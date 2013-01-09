#include <string.h>
#include <stdio.h>

#define OCL_HEARTBEAT() printf("%s\n", "Alive");

/* Attempt to create the program object from a cached binary. */
cl_program oclCreateProgramFromBinary(cl_context context, cl_device_id device, const char* fileName)
{
   FILE *fp;
   cl_int errcode;
   cl_program program;
   cl_int binaryStatus;
   size_t binarySize;
   unsigned char *programBinary;

   fp = fopen(fileName, "rb");
   assert(fp); if(!fp) return NULL;

   /* Determine the size of the binary */
   fseek(fp, 0, SEEK_END);
   binarySize = ftell(fp);
   rewind(fp);

   programBinary = (unsigned char*) malloc(sizeof(unsigned char) * binarySize);
   fread(programBinary, 1, binarySize, fp);
   fclose(fp);

   program = clCreateProgramWithBinary(context, 1, &device, &binarySize, (const unsigned char**)&programBinary, &binaryStatus, &errcode);
   assert(errcode == CL_SUCCESS); assert(binaryStatus == CL_SUCCESS);

   errcode = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
   assert(errcode == CL_SUCCESS);

   free(programBinary);

   return program;
}

/* Allocates a matrix with random float entries. */
void oclRandomInit(float* data, int size)
{
   unsigned int i;

   for (i = 0; i < size; ++i) {
      data[i] = rand() / (float)RAND_MAX;
   }
}

/*
* Loads a Program file and prepends the cPreamble to the code.
*
* @return the source string if succeeded, 0 otherwise
* @param filename         program filename
* @param cPreamble        code that is prepended to the loaded file, typically a set of #defines or a header
* @param szFinalLength    returned length of the code string
*/
char* oclLoadProgSource(const char* fileName, const char* cPreamble, size_t* const szFinalLength)
{
   FILE* fp;
   size_t szSourceLength;

   fp = fopen(fileName, "rb");
   assert(fp); if(!fp) return NULL;

   size_t szPreambleLength = strlen(cPreamble);

   /* Get the length of the source code */
   fseek(fp, 0, SEEK_END);
   szSourceLength = ftell(fp);
   fseek(fp, 0, SEEK_SET);

   /* allocate a buffer for the source code string and read it in */
   char* cSourceString = (char *)malloc(szSourceLength + szPreambleLength + 1);
   memcpy(cSourceString, cPreamble, szPreambleLength);
   if (fread((cSourceString) + szPreambleLength, szSourceLength, 1, fp) != 1) {
      fclose(fp);
      free(cSourceString);
      return 0;
   }

   /* close the file and return the total length of the combined (preamble + source) string */
   fclose(fp);
   if(szFinalLength != 0) {
      *szFinalLength = szSourceLength + szPreambleLength;
   }
   cSourceString[szSourceLength + szPreambleLength] = '\0';

   return cSourceString;
}
