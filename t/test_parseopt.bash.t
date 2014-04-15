#!/bin/sh -e
if sh=$(command -v bash); then
  exec $sh t/test_parseopt.sh
else
  echo "Bail out! no bash"
fi

