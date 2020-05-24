#!/bin/bash
#
# NOTE: In order to use this script, the user must have their aws credentials
# set.  Use `aws configure`.  Alternatively, an AWS host can be granted the permissions
# by adding it to the `s3-repo-administrators` group.  The JenkinsCI role is a member
# of this group so servers started under that role will automatically have access.
#
set -eu -o pipefail # quit if any of the commands exits with a non-zero status

if [ "$#" -ne 2 ]
then
    echo "Usage: $0 (unstable|stable) PATH_TO_DEB"
    exit 1
fi

# check the repo we should upload to
case $1 in
    unstable|stable)
        CODENAME="${1}"
    ;;
    *)
        echo "Specify either stable or unstable as the target repo"
        exit 1
    ;;
esac

DEB_FILE="${2}"

if [ ! -f "${DEB_FILE}" ]; then
	echo "Can't find deb file '${DEB_FILE}' to upload... quitting."
	exit 1
fi

BUILD_VERSION=$(dpkg-deb -f "${DEB_FILE}" Version)

echo "Uploading ${DEB_FILE} (version ${BUILD_VERSION}) to repo"

deb-s3 upload \
	--bucket='private-repo-8w' \
	--codename="${CODENAME}" \
	--s3-region="eu-west-1" \
	--sign='0F268252' \
	--gpg-options='--digest-algo SHA256' \
	--arch='all' \
	--preserve-versions \
	"${DEB_FILE}"

echo ""
echo "---------------------------------------------------------"
echo "-- Completed uploading ${BUILD_VERSION} to 8w repo"
echo "---------------------------------------------------------"
