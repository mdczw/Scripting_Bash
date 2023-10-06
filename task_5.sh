#!/bin/bash

#script with following functionality:
#If -v tag is passed, replaces lowercase characters with uppercase and vise versa
#If -s is passed, script substitutes <A_WORD> with <B_WORD> in text (case sensitive)
#If -r is passed, script reverses text lines
#If -l is passed, script converts all the text to lower case
#If -u is passed, script converts all the text to upper case
#Script should work with -i <input file> -o <output file> tags


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
      exit
      ;;
  esac
done

if [[ "$i" != "true" ]] || [[ ! -e $input_file ]]; then
  echo "Input file not found"
  echo "Usage example: $0 -vruls -i <input_file> -o <output_file>"
  exit 1
fi

if [[ "$o" != "true" ]]; then
  echo "Enter the output file name"
  echo "Usage example: $0 -vruls -i <input_file> -o <output_file>"
  exit 1
fi

> $output_file

if [[ "$v" == "true" ]]; then
  echo "*** Replaced lowercase characters with uppercase and vise versa ***" >> $output_file
  out_u=`cat $input_file | tr "[:upper:][:lower:]" "[:lower:][:upper:]" >> $output_file`
  echo "I've replaced lowercase characters with uppercase and vise versa from $input_file and saved it to $output_file"
  echo $'\n' >> $output_file
fi

if [[ "$s" == "true" ]]; then
  read -p "Enter the word to be replaced: " A_WORD
  read -p "Enter a replacement word: " B_WORD
  echo "*** Replaced <$A_WORD> with <$B_WORD> ***" >> $output_file
  `sed "s/$A_WORD/$B_WORD/g" $input_file >> $output_file`
  echo "I've replaced <$A_WORD> with <$B_WORD> in $input_file and saved it to $output_file"
  echo $'\n' >> $output_file
fi

if [[ "$r" == "true" ]]; then
  echo "*** Reversed text lines  ***" >> $output_file
  out_u=`nl $input_file | sort -nr | cut -f 2- >> $output_file`
  echo "I've converted all the text from $input_file to upper case and saved it to $output_file"
    echo "" >> $output_file
fi

if [[ "$u" == "true" ]]; then
  echo "*** Converted all the text to upper case  ***" >> $output_file
  out_u=`cat $input_file | tr [:lower:] [:upper:] >> $output_file`
  echo "I've converted all the text from $input_file to upper case and saved it to $output_file"
  echo $'\n' >> $output_file
fi

if [[ "$l" == "true" ]]; then
  echo "*** Converted all the text to lower case  ***" >> $output_file
  out_l=`cat $input_file | tr [:upper:] [:lower:]  >> $output_file `
  echo "I've converted all the text from $input_file to lower case and saved it to $output_file"
  echo $'\n' >> $output_file
fi

