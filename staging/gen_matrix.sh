#!/bin/bash

TRACE="net.trace";
MATRIX="cct-messages.txt"

function add_network {
  perl net-trace-to-matrix.pl "${1}" < "$TRACE" >> "$MATRIX";
}

rm $MATRIX;

add_network "si-net-l2-0-gm-0"; 
add_network "si-net-l2-1-gm-1";
add_network "si-net-l2-2-gm-2";
add_network "si-net-l2-3-gm-3";
add_network "si-net-l2-4-gm-4";
add_network "si-net-l2-5-gm-5";
add_network "si-net-l1-l2";
