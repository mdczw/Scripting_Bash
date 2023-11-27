#!/bin/bash

#Caesar cipher script accepting three parameters <shift> <input file> <output file>
#Usage example: ./task_4.sh [shift] [input_file] [output_file]


parametersValueCheck() {
  if [[ ! "$shift" =~ [0-9] ]] || [[ ! -e "$input_file" ]]; then
    echo "You used the wrong parameters"
    echo "Usage: task_4.sh [shift] [input_file] [output_file]"
    exit 1
  fi
}

encryptCharacter() {
  for (( y = 0; y<26; y++)); do
    if [[ $1 == "${alfa[y]}" ]]; then
      encrypted_text+="${alfa[((y+$shift)%26)]}"
      break
    fi
  done
}

caesarCipherScript() {
  local original_text=$1
  local symbol
  encrypted_text=""
  
  for ((i = 0; i<${#original_text}; i++)); do
    symbol="${original_text:i:1}"

    if [[ "$symbol" =~ [A-Z] ]]; then
      alfa=({A..Z})
      encryptCharacter "$symbol"
      
    elif [[ "$symbol" =~ [a-z] ]]; then
      alfa=({a..z})
      encryptCharacter "$symbol"

    else
      encrypted_text+="$symbol"
    fi

  done  
}

main() {
  parametersValueCheck
  
  original_text=$(cat "$input_file")
  caesarCipherScript "$original_text"

  echo "********** Original text **********"
  echo "$original_text"
  echo "********** Encrypted text **********"
  echo "$encrypted_text"
  echo "$encrypted_text" > "$output_file"
}


#Check number of parameters

if [ "$#" != "3" ]; then
  echo "Enter parameters"
  echo "Usage: task_4.sh [shift] [input_file] [output_file]"
  exit 1
fi

shift=$1
input_file=$2
output_file=$3

main

