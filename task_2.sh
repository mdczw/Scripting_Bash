#!/bin/bash

#Bash script accepts operation parameter (“-”, “+”, “*”, “%”), sequence of numbers and debug flag. 
#For example:
#./your_script.sh -o % -n 5 3 -d > Result: 2
#./your_script.sh -o + -n 3 5 7 -d > Result: 15
#If -d flag is passed, script must print additional information:
#User: <username of the user running the script>
#Script: <script name>        
#Operation: <operation>
#Numbers: <all space-separated numbers>


while [ $# -gt 0 ]; do
  case "$1" in

    -o)
      shift
      operation="$1"
      if ! [[ "$operation" =~ ^[-+*%]$ ]]; then
        echo "Please write the right operation ('-', '+', '*', '%') and/or use quotation marks"
      fi
      shift
      ;;

    -n)
      shift

      while [[ "$1" =~ [[:digit:]] ]]; do
        numbers+=("$1")
        shift
      done

      if (( ${#numbers[@]} < 2 )); then
        echo "Please write at least 2 numbers"
       
      else
        result=${numbers[0]}
        for (( i=1; i < ${#numbers[@]}; i++ )); do
          result=$((result $operation numbers[i]))
        done
        echo "Result of the operation: $result"
      fi
      ;;

    -d)
      echo "User: $USER"
      echo "Script: $(basename "$0")"
      echo "Operation: $operation"
      echo "Numbers: ${numbers[*]}"
      shift
      ;;
    *)
      echo "Error: Unknown parameter $1"
      echo "Usage example: $0 -o '*' -n 5 3 -d"
      exit 1
      ;;

    esac 
done

