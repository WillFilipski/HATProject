#! /bin/bash

for ii in *.log ; do
	i=${ii%.log}
	grep -i  Done ${i}.log | tail -1
done
