#! /bin/bash

for ii in *.chk; do
    i=${ii%.chk}
    cat > ${i}.gjf << EOF
%chk=${i}.chk
%nproc=8
%mem=8GB
#UB3LYP guess=read geom=check

SCF Convergence Part 2 | UB3LYP ${i}

0 2
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