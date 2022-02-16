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

gpg --default-key CF7F439E4E336DC2 -abs --output Release.gpg Release
gpg --default-key CF7F439E4E336DC2 -abs --clearsign --output InRelease Release
gpg --output CPOS.gpg --armor --export CF7F439E4E336DC2
