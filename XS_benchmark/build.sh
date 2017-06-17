#!/bin/bash

rm -rf /tmp/XS_benchmark
if [ $? != 0 ]; then
	echo "Error rm"
	exit 1
else
	echo "rm - ok"
fi


cp -r /media/sf_Share/Compare-C-vs-Perl/XS_benchmark /tmp
if [ $? != 0 ]; then
	echo "Error copy to tmp"
	exit 1
else
	echo "Copy to tmp - ok"
fi


cd /tmp/XS_benchmark
if [ $? != 0 ]; then
	echo "Error cd"
	exit 1
else
	echo "cd - ok"
fi


perl ./Makefile.PL
if [ $? != 0 ]; then
	echo "Error Makefile.PL"
	exit 1
else
	echo "Makefile.PL - ok"
fi


make 
make test
echo
echo

perl /tmp/XS_benchmark/ex/benchmark_math.pl