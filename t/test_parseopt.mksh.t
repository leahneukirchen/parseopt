#!/bin/sh -e
if sh=$(command -v mksh); then
  exec $sh t/test_parseopt.sh
else
  echo "Bail out! no mksh"
fi

