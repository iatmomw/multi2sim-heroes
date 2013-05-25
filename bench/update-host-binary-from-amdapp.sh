#!/bin/bash

function fetch_host_binary() {
  echo "Replacing $1 with APPSDK version"
  cp /opt/AMDAPP/samples/opencl/cl/app/$1/build/debug/x86_64/$1 ./$1/
}

for D in `find . -maxdepth 1 -type d`
do
  D="${D:2:${#D}}"
  if [ "${D:0:1}" = "." ]
  then
    continue
  fi
  if [ "${D:0:1}" = "" ]
  then
    continue
  fi
  fetch_host_binary $D
done


