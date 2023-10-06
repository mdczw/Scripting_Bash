#!/bin/bash

datetime=`date +"%D %T"`
whoami=`whoami`
intIP=`ipconfig getifaddr en0`
hostName=`hostname`
exIP=`curl -s ifconfig.me`
uname=`uname -rs`
uptime=`uptime`
space=`df -h`
#ram=`free -h`
cpu=`sysctl -n hw.ncpu`

echo "**********************************"
echo "current date and time"
echo "$datetime"
echo "**********************************"
echo "name of current user"
echo "$whoami"
echo "**********************************"
echo "internal IP address and hostname"
echo "$intIP"
echo "$hostName"
echo "**********************************"
echo "external IP address"
echo "$exIP"
echo "**********************************"
echo "name and version of Linux distribution"
echo "$uname"
echo "**********************************"
echo "system uptime"
echo "$uptime"
echo "**********************************"
echo "used and free space"
echo "$space"
#echo "**********************************"
#echo "total and free RAM"
#echo "$ram"
echo "**********************************"
echo "number of CPU cores"
echo "$cpu"
echo "**********************************"
