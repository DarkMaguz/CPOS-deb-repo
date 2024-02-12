#!/bin/sh -e

# Update APT repository files.

cd repo

# Create temporary directory.
TMP_DIR=$(mktemp -d)

# Build Packages file
apt-ftparchive packages amd64/ > ${TMP_DIR}/Packages
# Compress Packages file
gzip -k -f ${TMP_DIR}/Packages

# Build Release file
apt-ftparchive release . > ${TMP_DIR}/Release

# Generate GPG signed files.
gpg --pinentry-mode loopback --passphrase $PASS --default-key $KEYID -abs --output ${TMP_DIR}/Release.gpg ${TMP_DIR}/Release
gpg --pinentry-mode loopback --passphrase $PASS --default-key $KEYID -abs --clearsign --output ${TMP_DIR}/InRelease ${TMP_DIR}/Release
gpg --output ${TMP_DIR}/CPOS.gpg --armor --export $KEYID

# Overwrite existing files in repo directory.
cp -fp ${TMP_DIR}/* .

# Clean up.
rm -rf ${TMP_DIR}
