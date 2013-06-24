#!/bin/bash

. batch_run_common.sh

TAG="LOCALITY"; SOP="--si-workgroup-scheduling-policy UserLocality"
prep
( bench "BitonicSort" "-x 4096" ) &
( bench "DCT" "-x 1024 -y 1024" ) &
#( bench "RecursiveGaussian" "" ) &
###( bench "FloydWarshall" "" ) &
###( bench "FastWalshTransform" "" ) &
( bench "MatrixTranspose" "-x 1024" ) &
##( bench "ScanLargeArrays" "" ) &
( bench "Reduction" "-x 1048576" ) &
##( bench "RadixSort" "" ) &
( bench "Histogram" "-x 8192 -y 8192" ) &
( bench "BinomialOption" "-x 1024" ) &
##( bench "DwtHaar1D" "" ) &
##( bench "BinarySearch" "" ) &
##( bench "PrefixSum" "" ) &
##( bench "EigenValue" "" ) &
##( bench "MatrixMultiplication" "" ) &
##( bench "SimpleConvolution" "-x 256 -y 256 -m 256" ) &
##( bench "SobelFilter" "" ) &
#( bench "URNG" "" ) &

TAG="BASELINE"; SOP="";
prep
( bench "BitonicSort" "" ) &
( bench "DCT" "-x 256 -y 256" ) &
( bench "RecursiveGaussian" "" ) &
( bench "FloydWarshall" "" ) &
( bench "FastWalshTransform" "-x 32768" ) &
( bench "MatrixTranspose" "-x 512" ) &
( bench "ScanLargeArrays" "-x 262144" ) &
( bench "Reduction" "-x 524288" ) &
( bench "RadixSort" "-x 524288" ) &
( bench "Histogram" "-x 2048 -y 2048" ) &
( bench "BinomialOption" "-x 512" ) &
#( bench "DwtHaar1D" "-x 1048576" ) &
#( bench "BinarySearch" "-s 32 -x 16384" ) &
#( bench "PrefixSum" "-x 16384" ) &

