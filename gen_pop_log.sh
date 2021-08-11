#1 /bin/bash

for ii in *.log ; do
    i=${ii%.log}
    cat > ${i}.gjf << EOF
%chk=input.chk
%MEM=32GB
%nproc=8
#M062X 6-311+G** POP=NBO

Population analysis

0 1
EOF
    awk '
    /Input/ { rec=""; f=1 }
    f { rec=rec $0 ORS; if (/Distance/) {last=rec; f=0} }
    END { printf "%s", last >> "'${i}.txt'" }
    ' ${i}.log 
    echo "Imported optimized geometry from ${i}.log"
done

for ii in *.txt ; do
    i=${ii%.txt}
    sed -i -e '/--/d ;
    /Input/d ;
    /Center/d ;
    /Number/d ;
    /Distance/d' ${i}.txt

    sed -i -r 's/^.{7}//' ${i}.txt
    sed -i -e 's/^[ \t]*//' ${i}.txt
    cat "${i}.txt" >> "${i}.gjf"
    echo "Formatted coordinates from ${i}.txt"
    rm ${i}.txt
    echo "Now deleted."
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