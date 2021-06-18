#! /bin/bash

for ii in *.gjf ; do
    i=${ii%.gjf}

    cat > ${i}.sub <<EOF
#! /bin/bash
#SBATCH -t 1-00:00
#SBATCH -J ${i}
#SBATCH -o ${i}.out
#SBATCH -e ${i}.err
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --mem-per-cpu=4000M
#SBATCH --account=def-dilabiog-ac

module load gaussian

g16 < \${input}.gjf >& \${input}.log

EOF
done
