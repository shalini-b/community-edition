#!/bin/env bash

# Copyright 2021-2022 VMware Tanzu Community Edition contributors. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# set -o errexit
set -o nounset
set -o pipefail
set -o xtrace
set +x

debug="false"
if [[ $# -eq 1 ]] && [[ "$1" == "-d" ]]; then
    debug="true"
fi

echo_debug () {
    if [[ "${debug}" == "true" ]]; then
        echo "${1}"
    fi
}

error_exit() {
    echo "ERROR: ${1}"
    exit 1
}

echo "======================================"
echo " Uninstalling Tanzu Community Edition"
echo "======================================"
echo

BUILD_OS=$(uname 2>/dev/null || echo Unknown)

case "${BUILD_OS}" in
  Linux)
    XDG_DATA_HOME="${HOME}/.local/share"
    ;;
  Darwin)
    XDG_DATA_HOME="${HOME}/Library/Application Support"
    ;;
  *)
    error_exit "${BUILD_OS} is unsupported"
    ;;
esac

echo_debug "Data home: ${XDG_DATA_HOME}"

# check if the tanzu CLI already exists and remove it to avoid conflicts
TANZU_BIN_PATH=$(command -v tanzu)
if [[ -n "${TANZU_BIN_PATH}" ]]; then
  # best effort, so just ignore errors
  if [[ "${TANZU_BIN_PATH}" == *"/usr/local"* ]]; then
    sudo rm -f "${TANZU_BIN_PATH}" > /dev/null
  else
    rm -f "${TANZU_BIN_PATH}" > /dev/null
  fi
fi

echo_debug "Removing: ${HOME}/.tanzu"
rm -rf "${HOME}/.tanzu"
echo_debug "Removing: ${HOME}/.config/tanzu"
rm -rf "${HOME}/.config/tanzu"
echo_debug "Removing: ${HOME}/.config/tanzu-plugins"
rm -rf "${HOME}/.config/tanzu-plugins"
echo_debug "Removing: ${HOME}/.cache/tanzu"
rm -rf "${HOME}/.cache/tanzu"
echo_debug "Removing: ${XDG_DATA_HOME}/tanzu-cli"
rm -rf "${XDG_DATA_HOME}/tanzu-cli"
echo_debug "Removing: ${XDG_DATA_HOME}/tce"
rm -rf "${XDG_DATA_HOME}/tce"
echo_debug ""

echo "Uninstall complete!"
