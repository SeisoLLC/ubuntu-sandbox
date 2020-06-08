#!/usr/bin/env bash

set -E
set -euo pipefail

vagrant up --provider vmware_desktop "$@"
vagrant ssh

