#! /bin/bash/

# Executa o tm2molden para o control original do cálculo turbomole
# e para o control sem o implicit core para o theodore


for d in $(seq 0 $1); do
    cd $d/tur_* ;
    cp control  control-turbomole ;
    for answer1 in "molden-turbomole.input" "Y" "Y"; do
        echo $answer1 ;
        done | $TURBO/tm2molden
    sed '/ implicit core=/d' control > control-molden
    cp control-molden control
    for answer2 in "molden-theodore.input" "Y" "Y"; do
        echo $answer2 ; 
        done | $TURBO/tm2molden
    
    cd -
    done
