#!/bin/bash

rm -rf /tmp/Geo-Distance-XS-0.13
if [ $? != 0 ]; then
	echo "Error rm"
	exit 1
else
	echo "rm - ok"
fi


cp -r /media/sf_Share/Compare-C-vs-Perl/Geo-Distance-XS-0.13 /tmp
if [ $? != 0 ]; then
	echo "Error copy to tmp"
	exit 1
else
	echo "Copy to tmp - ok"
fi


cd /tmp/Geo-Distance-XS-0.13
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

perl /tmp/Geo-Distance-XS-0.13/ex/benchmark_math.pl