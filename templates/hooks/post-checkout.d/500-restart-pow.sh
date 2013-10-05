#!/bin/sh

if [ ! -d ~/.pow/ ] || [ ! -d ./tmp/ ]; then
  exit 0
fi

ls ~/.pow/ | while read POW; do
  if [ ~/.pow/$POW -ef . ]; then
    echo "Restart pow for $POW"
    touch ./tmp/restart.txt
    break
  fi
done
