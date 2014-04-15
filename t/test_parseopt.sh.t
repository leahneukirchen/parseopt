#!/bin/sh -e
if sh=$(command -v sh); then
  exec $sh t/test_parseopt.sh
else
  echo "Bail out! no sh"
fi

