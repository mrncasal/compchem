#ES1=$(grep "Total energy" ricc2.out | awk '{print $6}'| head -n 1) 
#ES2=$(grep "Total energy" ricc2.out | awk '{print $6}'| head -n 2 | tail -n 1 ) 

cp /home/mariana/mrtadf/doboa/t1/scs-cc2/dens_ana.in . 

theodore analyze_tden 
mv tden_summ.txt tden_s0 

for file in trans_char*a; do 
    mv $file "$file"_s0
done

theodore analyze_tden_es2es -r 1
mv tden_summ.txt tden_s1 
for file in trans_char*a ; do 
    mv $file "$file"_s1 
done

theodore analyze_tden_es2es -r 2
mv tden_summ.txt tden_t1 
for file in trans_char*a ; do 
    mv $file "$file"_t1 
done

descr_s0_s1=$(grep "1(1)a" tden_s0 | awk '{print $4 ";" $5 ";" $6}')
descr_s0_t1=$(grep "1(3)a" tden_s0 | awk '{print $4 ";" $5 ";" $6}')

descr_s1_t1=$(grep "1(3)a" tden_s1 | awk '{print $4 ";" $5 ";" $6}')
descr_t1_s1=$(grep "1(1)a" tden_t1 | awk '{print $5 ";" $6}')

echo "$ES1 ; $ES2 ; ; $descr_s0_s1 ; $descr_s0_t1 ; $descr_t1_s1 ;  $descr_s1_t1" 

