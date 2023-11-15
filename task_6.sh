#!/bin/bash

currentDateTime() {
	date +"%D %T"	
}

currentUserName() {
	whoami
}
internalIP(){
	ipconfig getifaddr en0
}

hostName() {
	hostname
}

externalIP() {
	dig @resolver4.opendns.com myip.opendns.com +short
}

distributionVersion() {
	uname -rs
}

systemUptime() {
	uptime
}

usedAndFreeSpace() {
	df -h
}

totalAndFreeRAM() {
	free -h
}

cpuCoresNumber() {
	sysctl -n hw.ncpu
}

printStars() {
	echo "**********************************"
}

printAllInfo() {
	printStars
	echo "current date and time"
	currentDateTime
	printStars
	echo "name of current user"
	currentUserName
	printStars
	echo "internal IP address and hostname"
	internalIP
	hostName
	printStars
	echo "external IP address"
	externalIP
	printStars
	echo "name and version of Linux distribution"
	distributionVersion
	printStars
	echo "system uptime"
	systemUptime
	printStars
	echo "used and free space"
	usedAndFreeSpace
	#printStars
	#echo "total and free RAM"
	#totalAndFreeRAM
	printStars
	echo "number of CPU cores"
	cpuCoresNumber
	printStars
}

printAllInfo

