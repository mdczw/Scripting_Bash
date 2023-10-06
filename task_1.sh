#!/bin/bash

#The Fibonacci numbers are the numbers in the following integer sequence. 
#0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144,.... In mathematical terms, t
#he sequence Fn of Fibonacci numbers is defined by the recurrence relation 
#Fn = Fn-1 + Fn-2 with seed values F0 = 0 and F1 = 1. Write a function fib 
#that returns Fn. For example:
#if n = 0, then fib should return 0
#if n = 1, then it should return 1
#if n > 1, it should return Fn-1 + Fn-2


echo "===== It looks like you want to get the nth number from the Fibonacci sequence ====="

a=0
b=1
F=0

while true; do
	read -p "Enter a positive number [0-89]: " n
	if [[ "$n" =~ ^[1-8]?[0-9]$ ]]; then
                if ((n == 0)); then
                        echo "The $n number from the Fibonacci sequence is $a"
                elif ((n == 1)); then
                        echo "The $n number from the Fibonacci sequence is $b"
                else
                        for ((i=1; i<n; i++)); do
                        F=$((a + b)); a=$b; b=$F
                        done
                        echo "The $n number from the Fibonacci sequence is $F"
		fi
		break
	else 
		echo "Please try again! Enter a positive number [0-89]:"
	fi
done		
