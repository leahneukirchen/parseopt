#!/bin/sh -e
if sh=$(command -v dash); then
  exec $sh t/test_parseopt.sh
else
  echo "Bail out! no dash"
fi

