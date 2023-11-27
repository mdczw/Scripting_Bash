#!/bin/bash

#script with following functionality:
#If -v tag is passed, replaces lowercase characters with uppercase and vise versa
#If -s is passed, script substitutes <A_WORD> with <B_WORD> in text (case sensitive)
#If -r is passed, script reverses text lines
#If -l is passed, script converts all the text to lower case
#If -u is passed, script converts all the text to upper case
#Script should work with -i <input file> -o <output file> tags
#Usage example: ./task_5.sh -vruls -i <input_file> -o <output_file

inputFileCheck() {
  if [[ "$i" != "true" ]] || [[ ! -e $input_file ]]; then
    echo "Input file not found"
    echo "Usage example: $0 -vruls -i <input_file> -o <output_file>"
    exit 1
  fi
}

outputFileCheck(){
  if [[ "$o" != "true" ]]; then
    echo "Enter the output file name"
    echo "Usage example: $0 -vruls -i <input_file> -o <output_file>"
    exit 1
  fi
}

registerChange() {
  < "$1" tr '[:upper:][:lower:]' '[:lower:][:upper:]'
}

replaceWords() {
  sed "s/$1/$2/g" "$3"
}

reverseTextLines() {
  nl "$1" | sort -nr | cut -f 2- 
}

convertToUpperCase() {
  < "$1" tr '[:lower:]' '[:upper:]'
}

convertToLowerCase() {
  < "$1" tr '[:upper:]' '[:lower:]'
}

main() {

  inputFileCheck
  outputFileCheck
  
  : > "$output_file"

  if [[ "$v" == "true" ]]; then
    echo "*** Replaced lowercase characters with uppercase and vise versa ***" >> "$output_file"
    registerChange "$input_file" >> "$output_file"
    echo "Lowercase characters have been replaced with uppercase and vise versa from $input_file and saved to $output_file"
    echo $'\n' >> "$output_file"
  fi

  if [[ "$s" == "true" ]]; then
    read -rp "Enter the word to be replaced: " A_WORD
    read -rp "Enter a replacement word: " B_WORD
    echo "*** Replaced <$A_WORD> with <$B_WORD> ***" >> "$output_file"
    replaceWords "$A_WORD" "$B_WORD" "$input_file" >> "$output_file"
    echo "<$A_WORD> have been replaced with <$B_WORD> in $input_file and saved to $output_file"
    echo $'\n' >> "$output_file"
  fi

  if [[ "$r" == "true" ]]; then
    echo "*** Reversed text lines ***" >> "$output_file"
    reverseTextLines "$input_file" >> "$output_file"
    echo "Text lines from $input_file has been reversed and saved to $output_file"
    echo "" >> "$output_file"
  fi

  if [[ "$u" == "true" ]]; then
    echo "*** Converted all the text to upper case ***" >> "$output_file"
    convertToUpperCase "$input_file" >> "$output_file"
    echo "All the text from $input_file has been converted to upper case and saved to $output_file"
    echo $'\n' >> "$output_file"
  fi

  if [[ "$l" == "true" ]]; then
    echo "*** Converted all the text to lower case  ***" >> "$output_file"
    convertToLowerCase "$input_file" >> "$output_file"
    echo "All the text from $input_file has been converted to lower case and saved to $output_file"
    echo $'\n' >> "$output_file"
  fi

}

#Check number of parameters

if [ "$#" -lt "1" ]; then
  echo "Enter parameters"
  echo "Usage example: $0 -vruls -i <input_file> -o <output_file>"
  exit 1
fi


#Catch parameters

while getopts "vsrlui:o:" flag; do
  case $flag in
    i)
      i=true
      input_file=$OPTARG
     ;;
    o)
      o=true
      output_file=$OPTARG
      ;;
    v)
      v=true
      ;;
    s)
      s=true
      ;;
    r)
      r=true
      ;;
    u)
      u=true
      ;;
    l)
      l=true
      ;;
    *)
      echo ""
      echo "Please use the correct syntax! Usage example:"
      echo "$0 -vruls -i <input_file> -o <output_file>"
      echo ""
      exit 1
      ;;
  esac
done

main
