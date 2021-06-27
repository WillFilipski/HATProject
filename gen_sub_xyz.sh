#! /bin/bash

for ii in *.xyz; do
    #ITERATE FILES
    i=${ii%.xyz}

    cat > ${i}.gjf <<EOF
%chk=${i}.chk
%MEM=32GB
%nproc=8
#M062X 6-31G* OPT=ModRedundant

H3C...H...OH  TS calculation

0 2
EOF
    LINE_COUNT=1
    while read -r LINE ; do
            ((LINE_COUNT++))

            if [[ $LINE == "Bonds" ]] ; then
                break
            else
                echo "$LINE" >> "${i}.gjf"
            fi
    done < "./${i}.xyz"

    echo "READ: ${i}.xyz | WRITE: ${i}.gjf"
done
