#!/bin/sh
# main
./s_run.sh multi2sim_1323_comp mem-config-default-scalar-separate BitonicSort COMP_VS
./s_run.sh multi2sim_1323_comp mem-config-default-scalar-separate DCT  COMP_VS -x 256 -y 256
./s_run.sh multi2sim_1323_comp mem-config-default-scalar-separate RecursiveGaussian COMP_VS
./s_run.sh multi2sim_1323_comp mem-config-default-scalar-separate FloydWarshall  COMP_VS

# intermediate time
./s_run.sh multi2sim_1323_comp mem-config-default-scalar-separate FastWalshTransform COMP_VS -x 32768
./s_run.sh multi2sim_1323_comp mem-config-default-scalar-separate MatrixTranspose COMP_VS -x 512
./s_run.sh multi2sim_1323_comp mem-config-default-scalar-separate ScanLargeArrays COMP_VS -x 262144
./s_run.sh multi2sim_1323_comp mem-config-default-scalar-separate Reduction COMP_VS -x 524288

# long time
./s_run.sh multi2sim_1323_comp mem-config-default-scalar-separate RadixSort COMP_VS -x 524288
./s_run.sh multi2sim_1323_comp mem-config-default-scalar-separate Histogram COMP_VS -x 2048 -y 2048
./s_run.sh multi2sim_1323_comp mem-config-default-scalar-separate BlackScholes COMP_VS -x 1048576
./s_run.sh multi2sim_1323_comp mem-config-default-scalar-separate BinomialOption COMP_VS -x 512

#not yet
#./s_run.sh multi2sim_1323_comp mem-config-default-scalar-separate DwtHaar1D COMP_VS -x 1048576
#./s_run.sh multi2sim_1323_comp mem-config-default-scalar-separate BoxFilter COMP_VS -x 32
#./s_run.sh multi2sim_1323_comp mem-config-default-scalar-separate BinarySearch COMP_VS -s 32 -x 16384
#./s_run.sh multi2sim_1323_comp mem-config-default-scalar-separate PrefixSum COMP_VS -x 16384
