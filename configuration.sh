#!/bin/bash
# configuration
# Ready
source ./Makefile.conf # import config file 
if [ $# == 0 ]
then 
    echo "Not have arg"
fi
value=$((0))
keys="NONE"
for i in "$@"; do
    value=$((($value+1)%2))
    if [ $value == 1 ];then
            keys=$i
    else
            echo >> ./Makefile.conf
            printf "$keys=$i" >> ./Makefile.conf # write config
    fi

    echo $i
done