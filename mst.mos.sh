#!/bin/bash

## Modificação no arquivo *spt gerado pelo Theodore

FILE = $1.mld
NTOs = $2


load FILE 
mo titleformat ""
color "[ 184,184,208 ]"		# cor cinza para as estruturas
rotate y -30			
select molecule = 1		# seleciona apenas um dos monômeros
translateSelected x 80 		# translada apenas um dos monômeros para melhor visualização
select

background white
mo fill
mo cutoff 0.02


for d in $(seq NTOs); do 
	mo color blue red
	mo $d
	write image pngt 'FILE+"_"$d+".png'
	mo color 


