#!/bin/bash

. batch_run_common.sh

## uses mem-config-default-double-l1-size
## uses amdapp-sdk 2.5

TAG="BIGGERL1"; SOP="--mem-config mem-config-default-double-l1-size";
prep
( bench "BitonicSort" "" ) &
( bench "RecursiveGaussian" "" ) &
( bench "FloydWarshall" "" ) &
( bench "ScanLargeArrays" "-x 262144" ) &
( bench "RadixSort" "-x 524288" ) &
( bench "Histogram" "-x 2048 -y 2048" ) &
( bench "DwtHaar1D" "-x 1048576" ) &

TAG="BASELINE"; SOP="";
prep
( bench "BitonicSort" "" ) &
( bench "RecursiveGaussian" "" ) &
( bench "FloydWarshall" "" ) &
( bench "ScanLargeArrays" "-x 262144" ) &
( bench "RadixSort" "-x 524288" ) &
( bench "Histogram" "-x 2048 -y 2048" ) &
( bench "DwtHaar1D" "-x 1048576" ) &
