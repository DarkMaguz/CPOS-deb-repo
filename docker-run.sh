#!/bin/sh -e

# Cleanup
rm -f Packages Packages.gz
rm -f Release

# Build Packages file
apt-ftparchive packages amd64/ >Packages
# Compress Packages file
gzip -k -f Packages

# Build Release file
apt-ftparchive release . > Release
