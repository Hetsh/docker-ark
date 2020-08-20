#!/usr/bin/env bash


# Abort on any error
set -e -u

# Simpler git usage, relative file paths
CWD=$(dirname "$0")
cd "$CWD"

# Load helpful functions
source libs/common.sh
source libs/docker.sh

# Check dependencies
assert_dependency "jq"
assert_dependency "curl"

# Debian Stable with SteamCMD
update_image "hetsh/steamcmd" "SteamCMD" "false" "(\d+\.)+\d+-\d+"

# ARK
ARK_PKG="MANIFEST_ID" # Steam depot id for identification
ARK_REGEX="\d{17,19}"
CURRENT_ARK_VERSION=$(cat Dockerfile | grep -P -o "$ARK_PKG=\K$ARK_REGEX")
NEW_ARK_VERSION=$(curl --silent --location "https://steamdb.info/depot/376031/" | grep -P -o "(?<=<td>)$ARK_REGEX(?=</td>)" | tail -n 1)
if [ "$CURRENT_ARK_VERSION" != "$NEW_ARK_VERSION" ]; then
	prepare_update "$ARK_PKG" "ARK" "$CURRENT_ARK_VERSION" "$NEW_ARK_VERSION"
	update_version "$NEW_ARK_VERSION"
fi

if ! updates_available; then
	#echo "No updates available."
	exit 0
fi

# Perform modifications
if [ "${1-}" = "--noconfirm" ] || confirm_action "Save changes?"; then
	save_changes

	if [ "${1-}" = "--noconfirm" ] || confirm_action "Commit changes?"; then
		commit_changes
	fi
fi