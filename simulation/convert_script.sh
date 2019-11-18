#!/bin/bash
baseName=${1%.*}
extension=${1##*.}
outFile="$baseName"_conv."$extension"
echo Converting "$1"...
convert $1 -negate $outFile
convert $outFile -fuzz 20% -fill "#000A52" -opaque "#CA10EC" $outFile
convert $outFile -fuzz 10% -fill "#000A52" -opaque "#571057" $outFile
convert $outFile -fill "#E2E2E2" -opaque "#808080" $outFile
echo Written output to "$outFile".

