William Panlener

1. Project Goals
Goal 1: Lose the notion of separate host and device memory spaces. All spaces should be shared and equally accessible by host and device.
Goal 2: Minimize the number of copies of data
Goal 3: Implement a model of hardware components necessary to accomplish previous goals

2. Definitions
User-mode vs kernel-mode (runtime vs kernel driver): These terms are used to describe the level of abstraction that a code interface works at. The difference can best be illustrated with an analogy. Assume we have a hard-disk and a byte that we would like to write to this disk. There are also many other bytes that need to be written to the disk. Unfortunately, the disk is only able to write to one location at any given time because of its physical limitations.

User-mode or runtime code does not care that these limitations exist and writing a byte is as simple as saying "write byte" and the byte will be written at some point. The kernel-mode or kernel driver code very much cares about these physical limitations, however. It accepts all the incoming "write byte" statements from user-mode and inserts them into a queue. It then takes into account details such as the spin-rate of the disk, the current position of the write arm, etc and works to process the queue in an efficient manner.

From this analogy, it is clear that user-mode/runtime code is not hardware-aware while kernel-mode/kernel driver code is very much hardware aware.

Unified-memory (UM) vs truly unified memory (TUM): In TUM, memory address space is completely shared between host and device. This is in contrast to UM which may be the same physical memory unit but the space addressable by the CPU and the space addressable by the GPU are mutually exclusive. To access data in the other space, a copy must be performed to bring the data into the appropriate memory space. TUM offers the benefit of avoiding this potentially expensive copy.

3. Current vs desired state of Multi2Sim Implementation
Without special configuration, Multi2Sim uses entirely disjoint memory spaces for host and device that each have their own unique address space. This model is representative of existing discrete GPU / CPU heterogeneous systems. Big limitations that such a model experience are extremely expensive memory transfers between host and device and missed opportunities for the device to utilize memory cached in the host memory hierarchy and opportunities for the host to utilize memory cached in the device memory hierarchy.

A partial implentation of a scheme called "fused memory" exists in Multi2Sim that allows the host and device to share a global memory module and addressing scheme but accesses are still kept entirely disjoint by restricting the device to the lower half of the address space and restricting the host to the upper half of the address space. This model is representative of AMD's current line of APUs such as Trinity. On real hardware, this model offers improvement for workloads characterized by large numbers of memory transfers between host and device over the default model since they are now point-to-point transfers within the same memory module rather than expensive PCI-e transfers. This could be "faked" in Multi2Sim by lowering the cost of host-device memory transfers to be equivalent to that of intra-module memory transfers, but modeling the common address space offers the benefit of paving the way for a truly unified memory between host and device. This model still exhibits limitations in that the memory transfers aren't necessary at all and could be eliminated since the host always holds a copy of any data that the device receives. Also, the memory hierarchies of host and device are still disjoint and cause the same missed opportunities for utilizing cache as in the default model.

-------------------------------------------------------------------------------
        Host                  Device
        Space  Range          Space  Range
Default 0      0x0-0x0+4G     1      0x0-0x0+4G
Fused   0      0x0+2G-0x0+4G  0      0x0-0x0+2G
TUM     0      0x0-0x0+4G     0      0x0+0x0+4G

	Table 1: Differences in Multi2Sim main memory schemes
-------------------------------------------------------------------------------

The desired state of the Multi2Sim memory model is to have only one memory space fully accessible by both host and device. This model is representative of AMDs Kaveri APU scheduled to be available at the end of 2013. This model holds promised to completely eliminate memory transfers between host and device memory spaces since they are in fact the same space, and allow for unified caching between host and device. Implementing this model in Multi2Sim serves as a seque into a tentatively planned thesis paper "The Impact of Zero-Copy, Unified Memory Heterogenous Systems on High Crosstalk Applications".

4. Process 
This project is implemented as a series of modifications to Multi2Sim and benchmarks performed in a top-down manner. The highest level includes modifications to benchmarks while the lowest level includes modifications to the hardware model. Various other components of Multi2Sim are modified between these two levels which include but are not limited to the OpenCL Runtime and the OpenCL Kernel Driver.

Because the approach to solve this problem is evolving rapidly, the documentation for the individual phases has been moved to patch and series headers and is distributed with this report. This serves as a check to make sure that documentation is updated as patches change while still keeping the documentation easily readable. (See series-tum for details.). A general overview, however, is that modifications to the OpenCL driver are mostly to force all memory requests to use the x86 paged memory interface instead of the existing scheme of allocating all memory in a linear fashion to the top of the address space. The modifications to the OpenCL runtime are mostly to eliminate all driver ABI calls to copy or allocate memory into a device memory address space, replace all device pointers with host pointers, and add an extension to the OpenCL API to allow a benchmark to specify that it should use this memory scheme and that the device is even capable of using it. Modifications to the hardware model mostly involve setting a flag to identify the device as "fused" and then writing a conditional on that flag that reuses an existing memory hierarchy configuration in Multi2Sim.

Many obscure issues were encountered in the process of integrating the required to changes to Multi2Sim. Debugging patterns for these issues were developed. The first pattern involves using the --x86-debug-opencl flag when invoking Multi2Sim. This dumps a trace of all calls to OpenCL driver ABI and is useful for identifying the order of OpenCL driver ABI calls and highlighting when an attempt to allocate memory inappropriately is made. Another pattern involves using the --si-debug-isa flag when invoking Multi2Sim. This helps identify bugs in the existing Multi2Sim implementation of the functional simulator for the Southern Islands architecture that have not been previously exposed via the default memory model. A comparison between the logs generated by the previously mentioned debugging patterns from an unmodified Multi2Sim instance and a patched Multi2Sim instance is also extremely useful.

5. Remaining issues

6. Future Work

7. Reference
[1] http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clGetDeviceInfo.html
[2] http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clCreateBuffer.html
[3] http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clEnqueueReadBuffer.html
[4] http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clEnqueueWriteBuffer.html
[5] http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clSetKernelArg.html
---
