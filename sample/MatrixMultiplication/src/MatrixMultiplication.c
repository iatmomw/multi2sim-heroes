#define NATIVE_EXECUTION
#define VERIFY
#define VERBOSE
/* #define NDEBUG */

/* Multiply two matrices A * B = C */
#include <time.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include <CL/cl.h>
#include <stdio.h>

#include "sdk.h"

#define WA 64
#define HA 64
#define WB 64
#define HB WA
#define WC WB
#define HC HA

int main(int argc, char** argv)
{
   cl_context context;
   cl_command_queue clCommandQue;
   cl_program clProgram;
   cl_kernel clKernel;
   cl_int errcode;
   cl_uint numPlatforms;
   cl_platform_id *platforms;
   cl_uint num_devices;
   cl_device_id *device_list;
   cl_mem d_A, d_B, d_C;

   unsigned int size_A, size_B, size_C;
   unsigned int mem_size_A, mem_size_B, mem_size_C;
   float *h_A, *h_B, *h_C;

   #ifdef NATIVE_EXECUTION
   size_t length;
   char *clProgramSource;
   #endif

   #ifdef VERBOSE
   char pbuf[100];
   #endif

   #if (defined VERBOSE || defined VERIFY)
   unsigned int i;
   #endif

   #ifdef VERIFY
   int realC;
   unsigned int j, k;
   #endif

   /* 0. Seed the RNG */
   srand(time(NULL));

   /* 1. Host memory */
   size_A = WA * HA;
   mem_size_A = sizeof(float) * size_A;
   h_A = (float*) malloc(mem_size_A);

   size_B = WB * HB;
   mem_size_B = sizeof(float) * size_B;
   h_B = (float*) malloc(mem_size_B);

   size_C = WC * HC;
   mem_size_C = sizeof(float) * size_C;
   h_C = (float*) malloc(mem_size_C);

   oclRandomInit(h_A, size_A);
   oclRandomInit(h_B, size_B);

   /* 2. Create OpenCL Context */
   /* 2a. Select a platform */
   errcode = clGetPlatformIDs(0, NULL, &numPlatforms);
   assert(errcode == CL_SUCCESS); assert(numPlatforms > 0);

   platforms = (cl_platform_id*) malloc(sizeof(cl_platform_id) * numPlatforms);
   assert(platforms);

   errcode = clGetPlatformIDs(numPlatforms, platforms, NULL);
   assert(errcode == CL_SUCCESS);

   /* 2b. Display available platforms */
   #ifdef VERBOSE
   for (i = 0; i < numPlatforms; ++i) {
      errcode = clGetPlatformInfo(platforms[i], CL_PLATFORM_VENDOR, sizeof(pbuf), pbuf, NULL);
      assert(errcode == CL_SUCCESS);

      printf("%d %s\n", i, pbuf);
   }
   #endif

   /* 2c. Set context properties */
   cl_context_properties cps[3] = {CL_CONTEXT_PLATFORM, (cl_context_properties) platforms[0], 0};

   context = clCreateContextFromType(cps, CL_DEVICE_TYPE_ALL, NULL, NULL, &errcode);
   assert(errcode == CL_SUCCESS);

   /* 2d. Get the list of GPU devices associated with context */
   errcode = clGetDeviceIDs(platforms[0], CL_DEVICE_TYPE_ALL, 0, NULL, &num_devices);
   assert(num_devices > 0); assert(errcode == CL_SUCCESS);

   device_list = (cl_device_id *) malloc(sizeof(cl_device_id) * num_devices);
   assert(device_list);

   errcode = clGetDeviceIDs(platforms[0], CL_DEVICE_TYPE_ALL, sizeof(cl_device_id) * num_devices, device_list, NULL);
   assert(errcode == CL_SUCCESS);

   /* 3. Create a command-queue */
   clCommandQue = clCreateCommandQueue(context, device_list[0], 0, &errcode);
   assert(errcode == CL_SUCCESS);

   /* 4. Device memory */
   d_C = clCreateBuffer(context, CL_MEM_READ_WRITE, mem_size_A, NULL, &errcode);
   assert(errcode == CL_SUCCESS);

   d_A = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR, mem_size_A, h_A, &errcode);
   assert(errcode == CL_SUCCESS);

   d_B = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR, mem_size_B, h_B, &errcode);
   assert(errcode == CL_SUCCESS);

   /* 5. Load and build OpenCL kernel */
   #ifdef NATIVE_EXECUTION
   clProgramSource = oclLoadProgSource("src/kernel.cl", "", &length);
   assert(clProgramSource);

   clProgram = clCreateProgramWithSource(context, 1, (const char **)&clProgramSource, &length, &errcode);
   assert(errcode == CL_SUCCESS);
   #else
   clProgram = oclCreateProgramFromBinary(context, device_list[0], "src/kernel.bin");
   #endif
   assert(clProgram);

   errcode = clBuildProgram(clProgram, 0, NULL, NULL, NULL, NULL);
   assert(errcode == CL_SUCCESS);

   clKernel = clCreateKernel(clProgram, "matrixMul", &errcode);
   assert(errcode == CL_SUCCESS);

   /* 6. Launch OpenCL kernel */
   size_t localWorkSize[2], globalWorkSize[2];

   int wA = WA;
   int wC = WC;
   errcode = clSetKernelArg(clKernel, 0, sizeof(cl_mem), (void *)&d_C);
   errcode |= clSetKernelArg(clKernel, 1, sizeof(cl_mem), (void *)&d_A);
   errcode |= clSetKernelArg(clKernel, 2, sizeof(cl_mem), (void *)&d_B);
   errcode |= clSetKernelArg(clKernel, 3, sizeof(int), (void *)&wA);
   errcode |= clSetKernelArg(clKernel, 4, sizeof(int), (void *)&wC);
   assert(errcode == CL_SUCCESS);

   localWorkSize[0] = 16;
   localWorkSize[1] = 16;
   globalWorkSize[0] = 1024;
   globalWorkSize[1] = 1024;

   /* 6a. Queue a kernel on the device */
   errcode = clEnqueueNDRangeKernel(clCommandQue, clKernel, 2, NULL, globalWorkSize, localWorkSize, 0, NULL, NULL);
   assert(errcode == CL_SUCCESS);

   /* 6b. Finish the command buffer
    * This means that the kernel is forced to begin executing on the device and control is only returned to the host
    * after the kernel completes
   */
   errcode = clFinish(clCommandQue);
   assert(errcode == CL_SUCCESS);

   /* 7. Retrieve result from device 
    * The third parameter set to CL_TRUE, makes this a blocking read. The CPU stalls until the data is fully copied
   */
   errcode = clEnqueueReadBuffer(clCommandQue, d_C, CL_TRUE, 0, mem_size_C, h_C, 0, NULL, NULL);
   assert(errcode == CL_SUCCESS);

   /* 8. Verify result */
   #ifdef VERIFY
   for(i = 0; i < HC; i++) {
      for(j = 0; j < WC; j++) {
         realC = 0;
         for(k = 0; k < WA; k++) {
            realC += h_A[ i* WA + k ] * h_B[ j + k * WB ];
         }

         assert(abs((realC - h_C[ i * WC + j ]) / realC) < 0.001);
      }
   }
   #ifdef VERBOSE
   printf("%s\n", "Verification successful");
   #endif
   #endif

   /* 9. Free resources */
   free(h_A);
   free(h_B);
   free(h_C);

   clReleaseMemObject(d_A);
   clReleaseMemObject(d_C);
   clReleaseMemObject(d_B);

   free(platforms);
   free(device_list);
   #ifdef NATIVE_EXECUTION
   free(clProgramSource);
   #endif
   clReleaseContext(context);
   clReleaseKernel(clKernel);
   clReleaseProgram(clProgram);
   clReleaseCommandQueue(clCommandQue);

   return 0;
}
