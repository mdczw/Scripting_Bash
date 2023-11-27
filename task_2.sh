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
#Usage example: ./task_2.sh -o '*' -n 5 3 -d

operationCheck() {
  if ! [[ "$operation" =~ ^[-+*%]$ ]]; then
    echo "Please write the right operation ('-', '+', '*', '%') and/or use quotation marks"
  fi
}

arethmeticСalculations() {
  local temp=( "$@" )
  local local_operation=${temp[0]}
  local local_numbers=( ${temp[@]:1} )
  if (( ${#local_numbers[@]} < 2 )); then
    echo "Please write at least 2 numbers"
    exit 1
  else
    result=${local_numbers[0]}
    for (( i=1; i < ${#local_numbers[@]}; i++ )); do
      result=$((result $local_operation local_numbers[i]))
    done
    echo "Result of the operation: $result"
  fi  
}

debugFlag() {
  echo "User: $USER"
  echo "Script: $(basename "$0")"
  echo "Operation: $operation"
  echo "Numbers: ${numbers[*]}"
}

while [ $# -gt 0 ]; do
  case "$1" in

    -o)
      shift
      operation="$1"
      operationCheck 
      shift
      ;;

    -n)
      shift
      while [[ "$1" =~ [[:digit:]] ]]; do
        numbers+=("$1")
        shift
      done
      arethmeticСalculations "$operation" "${numbers[*]}"
      ;;

    -d)
      debugFlag
      shift
      ;;
    *)
      echo "Error: Unknown parameter $1"
      echo "Usage example: $0 -o '*' -n 5 3 -d"
      exit 1
      ;;

    esac 
done

