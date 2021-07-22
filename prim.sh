#!/bin/bash

echo "Counting lines per file..."
for ii in *.log ; do
    i=${ii%.log}
    LCOUNT=0
    CITE=0
    while read -r LINE ; do
        ((LCOUNT++))
        if [[ "$LINE" =~ "Cite" ]] ; then
            ((CITE++))
            if [[ "$CITE" = 1 ]] ; then
                FIRST=${LCOUNT}
                echo "${i}.log : 1st: $FIRST    | CITE: $CITE | LCOUNT: $LCOUNT    | LINE: $LINE"
            fi
            if [[ "$CITE" = 2 ]] ; then
                SECOND=${LCOUNT}
                END=$((SECOND - 1))
                echo "${i}.log : 2nd: $SECOND | CITE: $CITE | LCOUNT: $LCOUNT | LINE: $LINE"
            fi
            if [[ "$CITE" = 3 ]] ; then
                THIRD=${LCOUNT}
                echo "${i}.log : 3rd: $THIRD | CITE: $CITE | LCOUNT: $LCOUNT | LINE: $LINE"
            fi
        fi
    done < "./${i}.log"
echo "${i}.log has $LCOUNT lines."
echo "${i}.log : Deleting lines $FIRST to $END"
sed -i "${FIRST},${END}d" ${i}.log
done
echo "Prim & proper!"