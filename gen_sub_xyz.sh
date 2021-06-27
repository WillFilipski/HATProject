#! /bin/bash

for ii in *.xyz; do
    i=${ii%.xyz}
    cat > ${i}.gjf <<EOF
%chk=${i}.chk
%MEM=32GB
%nproc=8
#M062X 6-31G* OPT=ModRedundant

H3C...H...OH  TS calculation

0 2
EOF
    while read -r LINE ; do
            if [[ "$LINE" =~ "Bonds" ]] ; then
                break
            else
                echo "$LINE" >> "${i}.gjf"
            fi
    done < "./${i}.xyz"
    echo "READ: ${i}.xyz"
done
    
for ii in *.xyz; do
    i=${ii%.xyz}
    read -p "WRITE ${i}.gjf | Bonds to freeze: " B1 B2 B3
    echo -e "\nB $B1 $B2 F" >> "${i}.gjf"
    echo -e "B $B2 $B3 F\n" >> "${i}.gjf"
    cat >> ${i}.gjf <<EOF
--Link1--
%chk=${i}.chk
%MEM=32GB
%nproc=8
#M062x 6-31G* Geom=(checkpoint,modredundant) Guess=Read Freq

H3C...H...OH  TS calculation

0 2

B $B1 $B2 A
B $B2 $B3 A

--Link1--
%chk=${i}.chk
%MEM=32GB
%nproc=8
#M062x 6-31G* Geom=CheckPoint Guess=Read OPT=(TS,ReadFC,NoEigenTest) Freq

H3C...H...OH  TS calculation

0 2

EOF
done

bash ./gen_cedar_g16.sh

echo "Done"
