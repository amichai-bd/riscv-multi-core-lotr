#!/bin/bash

#split mif file to 2 temp files
(( lines = `cat $1.mif | wc -l` ))
(( lines = lines-9 ))
# cat $1.mif | tail -n $lines | head -n -2 | cut -c 7- > temp1.txt
# cat $1.mif | tail -n $lines | head -n -2 | cut -c 1-6 > temp2.txt
cat $1.mif | tail -n $lines | head -n -2 | cut -d ":" -f 2 > temp1.txt
cat $1.mif | tail -n $lines | head -n -2 | cut -d ":" -f 1 > temp2.txt

# cat led_blinky.mif | tail -n $c | head -n 9 | cut -d ":" -f 1
# read addresses to array
addresses=()
(( c = 0 ))
while read line; do
    addresses+=($line)
    (( c++ ))
done <"temp2.txt"

#create new temp file
touch temp3.txt

#revesing all words to Little Endian and appened to temp file
(( lineCount = 0))
while read line; do
    (( wcount=`echo $line | wc -w` ))
    (( counter = 1 ))
    echo -n ${addresses[lineCount]} >> temp3.txt
    echo -n ": " >>temp3.txt
    for word in $line; do
        v=`echo $word | cut -c 1-8`
        u=`echo ${v:6:2}${v:4:2}${v:2:2}${v:0:2}`
        # echo $v
        echo -n $u >> temp3.txt
        if [ "$counter" -ne "$wcount" ]; then
            echo -n " " >> temp3.txt;
        fi
        (( counter++ ))
    done
    (( lineCount++ ))
    echo ";" >> temp3.txt
done <"temp1.txt"

#create the new Little Endian mif file
cat $1.mif | head -n 9  > $1.miff
cat temp3.txt >> $1.miff
cat $1.mif | tail -n 2  >> $1.miff
echo -n " " >> $1.miff
mv $1.miff $1.mif

#remove temp files
rm temp1.txt temp2.txt temp3.txt
