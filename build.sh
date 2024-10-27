#!/bin/bash
# Build Script

# Warning: You cannot have a blank line in build.csv
# Clear Dirty data of configuration
sed -i '/^[[:space:]]*$/d' ./Makefile.conf
# Loading configuration
source ./Makefile.conf
echo >> $CSV_CONFIG_FILE

sed -i '/^[[:space:]]*$/d' $CSV_CONFIG_FILE
# Clear old file ...
rm -rf $BUILD_DIR
mkdir $BUILD_DIR
mkdir $ERROR_LOG_PATH
# Thread create 
mkfifo ${THREAD_NAME}
exec 6<> ${THREAD_NAME}
rm -rf ${TMP_FILE}
for ((j=1; j<=${THREAD_MAX}; j++)); do
echo >&6
done

# This is Variable
progress=0
allProgress=0
# This is Function
sed -n '1p' $CSV_CONFIG_FILE
echo "$test"
function GetFileLine(){
    awk 'END {print NR}' $CSV_CONFIG_FILE
}

function addProgress(){

    printf "\r"
    printf "Progress: ["
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
    printf "] %d%%" $(expr $progress \* 100 / $allProgress)
}

# Check the verification file and startup parameters
echo "----------Build Start----------"

# This is to read the file configuration to get version and other information and the file that needs to be compiled

allProgress=$(GetFileLine $CSV_CONFIG_FILE) 

warningNum=0
warningList=( )

for ((i=0; i<${THREAD_MAX}; i++))
do
    echo >&6
done

    # 读取文件行到数组中
    lines=($(cat "${CSV_CONFIG_FILE}"))
    for ((num=0; num<${allProgress}; num++))
    do
        read -u6
        {
            # 获取当前行
            line=${lines[$num]}
            # 输出当前行
                path=$(cut -d ',' -f 1 <<< $line)
                targetname=$(cut -d ',' -f 2 <<< $line)
                buildpath=$(cut -d ',' -f 3 <<< $line)
                if [ -z $targetname ];then
                    break
                fi
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
            # 释放文件描述符，允许下一个进程开始
            echo >&6
        } &
        # 如果达到并发数，则等待一个进程完成
        wait
    done &
wait
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
# exec 6>&-
# 
exec 6>&-
rm -rf $THREAD_NAME