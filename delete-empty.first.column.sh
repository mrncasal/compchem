#! /bin/bash

#converte um arquivo com uma coluna extra em um arquivo xyz normal.

FILE=$1

awk '{$5="" ; print}' $FILE > new_file  && mv new_file $1
