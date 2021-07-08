#! /bin/bash

for ii in *.xyz; do
    i=${ii%.xyz}
    cat > ${i}.gjf <<EOF
%chk=${i}.chk
%MEM=32GB
%nproc=8
#M062X 6-31G* OPT=ModRedundant

Step 1 | TS calculation

0 2
EOF
    while read -r LINE ; do
       if [[ "$LINE" =~ "Bonds" ]] ; then
           break
       else
           echo "$LINE" >> "${i}.gjf"
       fi
    done < "./${i}.xyz"
    echo "Reading coordinates: ${i}.xyz"
done
echo "Successfully read molecular coordinates."
for ii in *.xyz; do
    i=${ii%.xyz}
    
    while read -r F C H O ; do
        if [[ "$F" =~ "${i}" ]] ; then
            echo "Reading bond data: ${i}"
            B1=${C:1}
            B2=${H:1}
            B3=$(echo ${O:1})
        fi
    done < "bonds.txt"
    echo -e "\nB $B1 $B2 F" >> "${i}.gjf"
    echo -e "B $B2 $B3 F\n" >> "${i}.gjf"
    cat >> ${i}.gjf <<EOF
--Link1--
%chk=${i}.chk
%MEM=32GB
%nproc=8
#M062x 6-31G* Geom=(checkpoint,modredundant) Guess=Read Freq

Step 2 | TS calculation

0 2

B $B1 $B2 A
B $B2 $B3 A

--Link1--
%chk=${i}.chk
%MEM=32GB
%nproc=8
#M062x 6-31G* Geom=CheckPoint Guess=Read OPT=(TS,ReadFC,NoEigenTest) Freq

Step 3 | TS calculation

0 2

EOF
done

echo "Successfully transposed bond information."
echo "Executing ./gen_cedar_g16.sh"
bash ./gen_cedar_g16.sh

echo "Submit jobs to queue? Y/N"
read ANS
case $ANS in
    [Yy] | [Yy][Ee][Ss])
    echo "Submitting jobs..."
    for i in *.sub ; do sbatch $i ; done
    ;;

    [Nn] | [Nn][Oo])
    echo "Quitting program..."
    ;;

    *)
    echo "Invalid input."
    ;;
esac

echo "Done"
