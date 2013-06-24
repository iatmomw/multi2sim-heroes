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
  /usr/local/bin/m2s-bench-amdapp-2.5-si/${1}/${1} --load ${1}_Kernels.bin -q -e ${2} #2> ${FILE_PREFIX}log

  FILTER_PREFIX="../filter"
  echo "${1}_${TAG}" >> ./multi2sim_${TAG}/report.txt &&  ${FILTER_PREFIX}/memreport-to-stat-chain.sh \
        ${FILTER_PREFIX} ${FILE_PREFIX}mem_report.txt >> ./multi2sim_${TAG}/report.txt && echo "" >> ./multi2sim_${TAG}/report.txt
}

