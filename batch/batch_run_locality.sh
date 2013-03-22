#!/bin/bash
( ./s_run.sh multi2sim_locality nop BitonicSort LOCALITY ) &
( ./s_run.sh multi2sim_locality nop DCT LOCALITY -x 1024 -y 1024 ) &
( ./s_run.sh multi2sim_locality nop RecursiveGaussian LOCALITY ) &
( ./s_run.sh multi2sim_locality nop FloydWarshall LOCALITY ) &
( ./s_run.sh multi2sim_locality nop FastWalshTransform LOCALITY ) &
( ./s_run.sh multi2sim_locality nop MatrixTranspose LOCALITY ) &
( ./s_run.sh multi2sim_locality nop ScanLargeArrays LOCALITY ) &
( ./s_run.sh multi2sim_locality nop Reduction LOCALITY ) &
( ./s_run.sh multi2sim_locality nop RadixSort LOCALITY ) &
( ./s_run.sh multi2sim_locality nop Histogram LOCALITY ) &
( ./s_run.sh multi2sim_locality nop BinomialOption LOCALITY ) &
( ./s_run.sh multi2sim_locality nop DwtHaar1D LOCALITY ) &
( ./s_run.sh multi2sim_locality nop BinarySearch LOCALITY ) &
( ./s_run.sh multi2sim_locality nop PrefixSum LOCALITY ) &
( ./s_run.sh multi2sim_locality nop EigenValue LOCALITY ) &
( ./s_run.sh multi2sim_locality nop MatrixMultiplication LOCALITY ) &
( ./s_run.sh multi2sim_locality nop SimpleConvolution LOCALITY ) &
( ./s_run.sh multi2sim_locality nop SobelFilter LOCALITY ) &
( ./s_run.sh multi2sim_locality nop URNG LOCALITY ) &
