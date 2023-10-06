#!/bin/bash

#Caesar cipher script accepting three parameters <shift> <input file> <output file>

#Check number of parameters

if [ "$#" != "3" ]; then
  echo "Enter parameters"
  echo "Usage: task_4.sh [shift] [input_file] [output_file]"
  exit 1
fi


#Check parameters value 

shift=$1
input_file=$2
output_file=$3

if [[ ! "$shift" =~ [0-9] ]] || [[ ! -e "$input_file" ]]; then
  echo "You used the wrong parameters"
  echo "Usage: task_4.sh [shift] [input_file] [output_file]"
  exit 1
fi


#Caesar cipher script

text=$(cat "$input_file")
new_text=""
ALFA=({A..Z})
alfa=({a..z})


for ((i = 0; i<${#text}; i++)); do
  symbol="${text:i:1}"

  if [[ "$symbol" =~ [A-Z] ]]; then
    for (( y = 0; y<26; y++)); do
      if [[ $symbol == "${ALFA[y]}" ]]; then
         new_text+="${ALFA[((y+shift)%26)]}"
         break
      fi
    done

  elif [[ "$symbol" =~ [a-z] ]]; then
    for (( y = 0; y<26; y++)); do
      if [[ $symbol == "${alfa[y]}" ]]; then
         new_text+="${alfa[((y+shift)%26)]}"
         break
      fi
    done

  else
    new_text+="$symbol"

  fi

done

echo "********** Original text **********"
echo "$text"
echo "********** Encrypted text **********"
echo "$new_text"
echo "$new_text" > "$output_file"
