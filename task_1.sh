#!/bin/bash
#
#The Fibonacci numbers are the numbers in the following integer sequence. 
#0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144,.... In mathematical terms, t
#he sequence Fn of Fibonacci numbers is defined by the recurrence relation 
#Fn = Fn-1 + Fn-2 with seed values F0 = 0 and F1 = 1. Write a function fib 
#that returns Fn. For example:
#if n = 0, then fib should return 0
#if n = 1, then it should return 1
#if n > 1, it should return Fn-1 + Fn-2

getNumberFromInput() {
	local input_number
	while true; do
		read -rp "Enter a positive number [0-89]: " input_number
		if [[ "$input_number" =~ ^[1-8]?[0-9]$ ]]; then
			number=$input_number
			break
		else 
			echo "Please try again! Enter a positive number [0-89]:"
		fi
	done		
}

printResult() {
	echo "The $1 number from the Fibonacci sequence is $2"
}

getFibonacciNumber() {
	local a=0
	local b=1
	local F=0
	local input_number=$1
        if ((input_number == 0)); then
                printResult "$input_number" "$a"
        elif ((input_number == 1)); then
                printResult "$input_number" "$b"
	else
        	for ((i=1; i<input_number; i++)); do
                        F=$((a + b)); a=$b; b=$F
                done
	                printResult "$input_number" "$F"
	        fi	
}

main(){
	echo "===== Hi! It looks like you want to get the nth number from the Fibonacci sequence ====="
	getNumberFromInput
	getFibonacciNumber "$number"
}

main
