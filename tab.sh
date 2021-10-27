#! /bin/bash

ROW=0
for ii in *radical*.log ; do
    i=${ii%.log}
    echo "${i}" $(grep -i Done ${i}.log | tail -1) >> "process1.temp"
    while read -r LINE ; do
        ((ROW++))
        arr=($LINE)
        echo "${ROW},${arr[0]},${arr[5]}" >> "c1.csv"
    done < 'process1.temp'
    rm "process1.temp"
done

ROW=0
for ii in *parent*.log ; do
    i=${ii%.log}
    if [[ ${i} =~ "1_" || ${i} =~ "9_" || ${i} =~ "48_" || ${i} =~ "49_" ]] ; then
        cat > "process2.temp" << EOF
${i} $(grep -i Done ${i}.log | tail -1) >> "process2.temp
${i} $(grep -i Done ${i}.log | tail -1) >> "process2.temp
EOF
    else
        echo "${i}" $(grep -i Done ${i}.log | tail -1) >> "process2.temp"
    fi
    while read -r LINE ; do
        ((ROW++))
        arr=($LINE)
        echo "${ROW},${arr[0]},${arr[5]}" >> "c2.csv"
    done < 'process2.temp'
    rm "process2.temp"
done

join -t, -1 1 -2 1 c1.csv c2.csv > "tab.csv"
rm "c1.csv" "c2.csv"
echo "Done"