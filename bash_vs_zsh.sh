#!/usr/bin/env bash
clear
set -o xtrace
echo "bash runs the piped command in a subshell, thus two clones and var = 1"
strace -e clone bash -c 'var=1;echo 2 | read var; echo $var'
read
echo "zsh runs the piped command in the original shell, thus one clone and var = 2"
strace -e clone zsh -c 'var=1;echo 2 | read var; echo $var'
set +o xtrace
