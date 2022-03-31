#! /bin/bash

for ii in *.xyz; do
    i=${ii%.xyz}
    cat > ${i}.gjf << EOF
%chk=${i}.chk
%nproc=8
%mem=8GB
#B3LYP CBSB7 SP Stable

Wavefunction Stability Analysis

0 1
EOF
    tail -n +3 "${ii}" | tee "${i}.temp" >/dev/null
    while read -r LINE ; do
        echo "$LINE" >> "${i}.gjf"
    done < "./${i}.temp"
    rm "${i}.temp"
    echo -e "\n" >> "${i}.gjf"
    echo "Reading coordinates: ${i}.xyz"
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