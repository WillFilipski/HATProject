#! /bin/bash

for ii in *.gjf ; do
    i=${ii%.gjf}

    cat > ${i}.sh <<EOF
#! /bin/bash

input=${i}

	module load gaussian/g16.a03
	export GAUSS_SCRDIR=$(pwd)/temporarydir_\${input}

cd $(pwd)

mkdir temporarydir_\${input}
mv    \${input}.* temporarydir_\${input}
cd    temporarydir_\${input}

g16 < \${input}.gjf >& \${input}.log

mv \${input}.* ..

cd ..

rm -r temporarydir_\${input}

EOF
done
