#!/bin/bash

rm -rf /tmp/Benchmark_of_XS
if [ $? != 0 ]; then
	echo "Error rm"
	exit 1
else
	echo "rm - ok"
fi


cp -r /media/sf_Share/Compare-C-vs-Perl/Benchmark_of_XS /tmp
if [ $? != 0 ]; then
	echo "Error copy to tmp"
	exit 1
else
	echo "Copy to tmp - ok"
fi


cd /tmp/Benchmark_of_XS
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

perl /tmp/Benchmark_of_XS/ex/benchmark_math.pl