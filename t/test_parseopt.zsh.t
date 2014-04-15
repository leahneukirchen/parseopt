#!/bin/sh -e
if sh=$(command -v zsh); then
  exec $sh t/test_parseopt.sh
else
  echo "Bail out! no zsh"
fi

