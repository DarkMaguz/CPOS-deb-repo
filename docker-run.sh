#!/bin/sh -e

cd repo

# Cleanup
rm -f Packages Packages.gz
rm -f Release InRelease Release.gpg CPOS.gpg

# Build Packages file
apt-ftparchive packages amd64/ >Packages
# Compress Packages file
gzip -k -f Packages

# Build Release file
apt-ftparchive release . > Release

gpg --pinentry-mode loopback --passphrase $PASS --default-key $KEYID -abs --output Release.gpg Release
gpg --pinentry-mode loopback --passphrase $PASS --default-key $KEYID -abs --clearsign --output InRelease Release
gpg --output CPOS.gpg --armor --export $KEYID
