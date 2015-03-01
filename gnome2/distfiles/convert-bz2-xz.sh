#!/bin/bash

for i in *bz2; do
    name=$(basename $i .bz2)
    echo " Converting '$name' from .bz2 to .xz ...."
    bunzip2 -v "$i"
    xz -v "$name"
done
