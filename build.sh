#!/bin/bash
# Build Script

# Loading configuration
source ./Makefile.conf

# Clear old file ...
rm -rf $BUILD_DIR
mkdir $BUILD_DIR
mkdir $ERROR_LOG_PATH

# This is Variable
progress=0
allProgress=0
# This is Function

function GetFileLine(){
    awk 'END {print NR}' $CSV_CONFIG_FILE
}

function addProgress(){

    printf "\r"
    printf "Progress: |"
    progress=$(expr  $progress + 1)
    for((tmp=1; $tmp < $progress; tmp++))
    do
        printf "="
    done
    printf ">"
    for((tmp=$progress; $tmp < $allProgress; tmp++))
    do
        printf " "
    done
    printf "| %d%%" $(expr $progress \* 100 / $allProgress)
}

# Check the verification file and startup parameters
echo "----------Build Start----------"

# This is to read the file configuration to get version and other information and the file that needs to be compiled

allProgress=$(GetFileLine $CSV_CONFIG_FILE) 

warningNum=0
warningList=( )

while read line
do

    path=$(cut -d ',' -f 1 <<< $line)
    targetname=$(cut -d ',' -f 2 <<< $line)
    buildpath=$(cut -d ',' -f 3 <<< $line)
    if [ ! -d  $BUILD_DIR/$buildpath ];then
        mkdir $BUILD_DIR/$buildpath
    fi
    $COMPILE -o $BUILD_DIR/$buildpath/$targetname$TYPE $path $OPTIONS &> $ERROR_LOG_PATH/$targetname.log
    if [ -s $ERROR_LOG_PATH/$targetname.log ];
    then
        warningNum=$(expr $warningNum + 1)
        warningList[$warningNum]=$path
    fi
    addProgress
done < $CSV_CONFIG_FILE 
printf "\nDone\nError: $warningNum\n"
if [ $warningNum -ne 0 ];
then 
    echo "----------Build Failed----------"
    exit 1
else
    echo "----------Build Success----------"
fi
echo "[Error List]" > $ERROR_LOG_PATH/error.log
for((tmp=1; $tmp <= $warningNum; tmp++))
do
    echo "Error: ${warningList[$tmp]}" >> $ERROR_LOG_PATH/error.log
done