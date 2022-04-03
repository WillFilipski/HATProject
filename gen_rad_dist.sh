#! /bin/bash

for ii in *.xyz; do
    i=${ii%.xyz}

    while read -r LINE ; do
        echo "$LINE" >> "${i}.temp"
    done < "./${i}.xyz"

    END=$(sed -n "$=" ${i}.temp)
    EX=$((END - 1))

    sed -i "1,${EX} s/        /    -1    /" ${i}.temp
    sed -i "1,${EX} s/       -/    -1   -/" ${i}.temp

    cat > ${i}.gjf <<EOF
%chk=${i}.chk
%nproc=16
%mem=5gb
#B3LYP CBSB7 OPT

${i} radical distorted

0 1
EOF
    while read -r LINE ; do
       if [[ "$LINE" =~ "Bonds" ]] ; then
           break
       else
           echo "$LINE" >> "${i}.gjf"
       fi   
    done < "./${i}.temp"
    echo -e "" >> "${i}".gjf"
    echo "Reading coordinates: ${i}.temp"
    rm ${i}.temp
done
echo "Successfully read molecular coordinates."

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
