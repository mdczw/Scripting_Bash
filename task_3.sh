#!/bin/bash
#
#Script that prints the numbers from 1 to 100 such that:
#If the number is a multiple of 3, you need to print "Fizz" instead of that number.
#If the number is a multiple of 5, you need to print "Buzz" instead of that number.
#If the number is a multiple of both 3 and 5, you need to print "FizzBuzz" instead of that number.


replaceNumber() {
if ((n % 3 == 0 && n % 5 == 0)); then 
			n="FizzBuzz"
		else
			if ((n % 3 ==0)); then
				n="Fizz"
			elif ((n % 5 == 0)); then 
				n="Buzz"	
			fi
		fi
}

printNumbers() {
	for n in {1..100}
	do
		replaceNumber
		echo "$n"
	done
}

printNumbers
