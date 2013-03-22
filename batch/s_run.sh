#!/bin/sh
if [ $# -eq 0 ]
then
	echo "ex) s_run.sh <m2s_exec> <mem_conf> <exec> <id> <exec_arg1> <exec_arg2> ..."
	exit
fi

# arg1 for m2s exe name
# arg2 for mem configuration file name
# arg3 for exe name
# arg4 for identification 
# arg5~ for program arguments

if [ -d "$1" ]
then
    echo "Directory $1 exists. Skipping creating directory."
else
	mkdir $1
fi

m2s --x86-sim detailed --si-sim detailed	\
--si-report      ./$1/$3_$4_si_report.txt				\
--mem-report     ./$1/$3_$4_mem_report.txt				\
--si-workgroup-scheduling-policy UserLocality	\
/usr/local/bin/m2s-bench-amdapp-2.5-si/$3/$3 --load $3_Kernels.bin -q $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} 2> ./$1/$3_$4_log
#--trace          ./$1/$3_$4_trace.gz					\
