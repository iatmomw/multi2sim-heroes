/* Matrix multiplication - Global Memory version */

__kernel void
matrixMul(__global float* C, 
          __global float* A, 
          __global float* B, 
          int wA, int wB)
{
   int tx = get_global_id(0); 
   int ty = get_global_id(1);
 
   float value = 0;

   for(int k = 0; k < wA; ++k) {
      value += A[ty * wA + k] * B[k * wB + tx];
   }
 
   C[ty * wA + tx] = value;
}
