#!/bin/bash

grep "^c clk=[0-9]*.*$\|^si\.new_inst id=[0-9]* cu=[0-9]*.*$\|^.*miss.*$" trace > data.log
