#! /bin/bash

for ii in *.chk; do
    i=${ii%.chk}
    cat > ${i}.gjf << EOF
%chk=${i}.chk
%nproc=8
%mem=8GB
#B3LYP CBSB7 Stable

Wavefunction Stability Analysis guess=read geom=check

0 1
EOF
echo "Molecular coordinates will be read from checkpoint file."

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