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
PROMPT=""
if [[ "$(uname -m)" == "arm64" ]]; then
  OS="jeffnoxon/ubuntu-20.04-arm64"
else
  OS="bento/ubuntu-20.04"
fi
PROVIDER="parallels"

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

function help() {
  # Purposefully using tabs for the HEREDOC
  cat <<- HEREDOC
  Preferred Usage: ./${0##*/} [--provider=(parallels|virtualbox)]

	--provider=virtualbox     Use the virtualbox provider
	-h|--help                 Usage details
	HEREDOC

  exit 0
}

OPTSPEC=":h-:"
while getopts "${OPTSPEC}" optchar; do
  case "${optchar}" in
    -)
      case "${OPTARG}" in
        help)
          help ;;

        provider)
          PROVIDER="${!OPTIND}"; OPTIND=$(( OPTIND + 1 )) ;;

        provider=*)
          PROVIDER=${OPTARG#*=} ;;
      esac ;;
    h)
      help ;;
  esac
done

if [[ "${PROVIDER}" != "parallels" && "${PROVIDER}" != "virtualbox" ]]; then
  _feedback ERROR "Provider must be parallels or virtualbox; ${PROVIDER} was provided"
fi

vagrant box add "${OS}" --provider "${PROVIDER}" 2>/dev/null || true
vagrant box update --box "${OS}" --provider "${PROVIDER}"
OS="${OS}" vagrant up --provider "${PROVIDER}" "$@"
OS="${OS}" vagrant ssh || if [[ $? == "255" ]]; then echo "Caught exit code 255"; else echo "Unhandled exception during vagrant ssh"; exit 1 ; fi
while [ -z "${PROMPT}" ]; do
    read -rp "Do you want to destroy the VM (Y/n)? " PROMPT
    case "${PROMPT}" in
        ""|[yY]|[yY][eE][sS])
            _feedback INFO "Destroying the VM..."
            OS="${OS}" vagrant destroy -f
            break
            ;;
        [nN]|[nN][oO])
            _feedback WARNING "Keeping the VM running..."
            _feedback INFO "Run \`OS="${OS}" vagrant destroy -f\` when you are done"
            ;;
        *)
            _feedback WARNING "Unknown response"
            PROMPT=""
            ;;
    esac
done

_quit
