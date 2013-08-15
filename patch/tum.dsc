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

3. Motivation
* Eliminate costly data copies
* More coherence
* Model for future platforms
* Exciting and new

4. Process 
This project is implemented as a series of modifications to Multi2Sim and benchmarks performed in a top-down manner. The highest level includes modifications to benchmarks while the lowest level includes modifications to the hardware model. Various other components of Multi2Sim are modified between these two levels which include but are not limited to the OpenCL Runtime and the OpenCL Kernel Driver.

Because the approach to solve this problem is evolving rapidly, the documentation for the individual phases has been moved to patch and series headers and is distributed with this report. This serves as a check to make sure that documentation is updated as patches change while still keeping the documentation easily readable. (See series-tum for details.)

5. Reference
[1] http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clGetDeviceInfo.html
[2] http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clCreateBuffer.html
[3] http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clEnqueueReadBuffer.html
[4] http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clEnqueueWriteBuffer.html
[5] http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clSetKernelArg.html

Argument functions comprise a class of OpenCL API that are responsible for
providing pointers to device memory and constant values for use in device
computation. These need to be modified to ensure that any pointers provided
represent a host memory space rather than a device space.

An example of a function in this class is clSetKernelArg[5].

It is possible to take advantage of Multi2Sim's implementation and avoid the
need to modify these functions by carefully handling pointers in the buffer
functions.
---
