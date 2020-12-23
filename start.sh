#!/usr/bin/env bash

set -E
set -euo pipefail

#shellcheck disable=SC2155
declare -r start=$(date +%s)
# shellcheck disable=SC2034
{
    declare -r ERROR='\033[0;31m'
    declare -r WARNING='\033[0;33m'
    declare -r INFO='\033[0m'
    declare -r DEFAULT='\033[0m'
}
prompt=""

function _quit() {
    exitCode="${1:-0}"
    duration=$(( $(date +%s) - start ))
    _feedback INFO "Completed after running for $(python3 -c "print('%um:%02us' % ((${duration}) / 60, (${duration}) % 60))")"
    exit "${exitCode}"
}

function _feedback() {
    color="${1:-DEFAULT}"
    case "${1}" in
        ERROR)
            >&2 echo -e "${!color}${1}:  ${2}${DEFAULT}"
            _quit 1
            ;;
        WARNING)
            >&2 echo -e "${!color}${1}:  ${2}${DEFAULT}"
            ;;
        *)
            echo -e "${!color}${1}:  ${2}${DEFAULT}"
            ;;
    esac
}

vagrant box update --box "bento/ubuntu-20.04"
vagrant up --provider virtualbox "$@"
vagrant ssh || if [[ $? == "255" ]]; then echo "Caught exit code 255"; else echo "Unhandled exception during vagrant ssh"; exit 1 ; fi
while [ -z "${prompt}" ]; do
    read -rp "Do you want to destroy the VM (Y/n)? " prompt
    case "${prompt}" in
        ""|[yY]|[yY][eE][sS])
            _feedback INFO "Destroying the VM..."
            vagrant destroy -f
            break
            ;;
        [nN]|[nN][oO])
            _feedback WARNING "Keeping the VM running..."
            _feedback INFO "Run \`vagrant destroy -f\` when you are done"
            ;;
        *)
            _feedback WARNING "Unknown response"
            prompt=""
            ;;
    esac
done

_quit

