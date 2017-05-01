#!/bin/sh

KEY=Pages

for src in $@; do
    N=`pdfinfo $src | grep $KEY | awk '{print $2}'`
    name=${src%.pdf}
    echo "Divide $src ($N pages)"

    for i in `seq 1 $N`; do
        pdftk $src cat $i output ${name}-$i.pdf
    done
done
