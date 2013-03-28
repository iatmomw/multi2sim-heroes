#!/bin/bash
function prep {
  if [ ! -d "multi2sim_${TAG}" ]; then
    mkdir multi2sim_${TAG}
  fi
}

function bench {
  FILE_PREFIX="./multi2sim_${TAG}/${1}_${TAG}_"

  echo "Launching ${1}_${TAG} with option \"${SOP}\" and kernel option \"${2}\""

  m2s --si-sim detailed \
  ${SOP} \
  --si-report ${FILE_PREFIX}si_report.txt \
  --mem-report ${FILE_PREFIX}mem_report.txt \
  /usr/local/bin/m2s-bench-amdapp-2.5-si/${1}/${1} --load ${1}_Kernels.bin -q ${2} #2> ${FILE_PREFIX}log

  FILTER_PREFIX="../filter"
  echo "${1}_${TAG}" >> ./multi2sim_${TAG}/report.txt &&  ${FILTER_PREFIX}/memreport-to-stat-chain.sh ${FILTER_PREFIX} ${FILE_PREFIX}mem_report.txt >> ./multi2sim_${TAG}/report.txt && echo "" >> ./multi2sim_${TAG}/report.txt
}

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

