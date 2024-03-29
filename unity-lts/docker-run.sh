#!/bin/sh -e

DISPLAY=:99.0
export DISPLAY
/etc/init.d/xvfb start
/etc/init.d/xvfb status

# Find any existing deb files and delete them.
for OLD_DEB in unity-lts*.deb*
do
  rm -f $OLD_DEB
done

# The root folder for the deb file.
BASE_DIR=$(dirname `realpath $0`)/unity-lts

# Install path for Unity.
UNITY_PATH=$BASE_DIR/opt/Unity-LTS

# Make install path if missing.
if [ ! -d "$UNITY_PATH" ]; then
	mkdir -p $UNITY_PATH
fi

# Clean up.
cleanup() {
  rm -rf $BASE_DIR
  rm -f lts-releases.xml*
}

# Get available versions.
wget -U "NoZilla/5.0" -q https://unity.com/releases/editor/lts-releases.xml

# Find latest LTS version.
LATEST_VERSION=$(xmllint --xpath '//channel/item[position() < last()]/title/text()' lts-releases.xml | sort | tail -n 1)
if [ -z "$LATEST_VERSION" ]; then
  echo "Failed to get the latest version of Unity!"
  echo "Terminating..."
  cleanup
  exit 1
fi

# Get current version.
apt-get update -y
CURRENT_VERSION=$(apt-cache show unity-lts 2> /dev/null | grep --max-count 1 "Version:" | cut -d' ' -f2)

echo "Latest version: $LATEST_VERSION"
echo "Current version: $CURRENT_VERSION"

# Check if we have the latest version.
UPDATE="false"
if [ -z "$CURRENT_VERSION" ]; then
  UPDATE="true"
elif [ "$LATEST_VERSION" != "$CURRENT_VERSION" ]; then
  UPDATE="true"
fi

if [ "$UPDATE" != "false" ]; then
  INSTALL_MODULES="webgl android documentation"

  unityhub --headless install-path \
      --no-sandbox \
      --set $UNITY_PATH
  unityhub --headless install \
      --no-sandbox \
      --version $LATEST_VERSION \
      --module $INSTALL_MODULES \
      --childModules

  # Make applications folder if missing.
  if [ ! -d "$BASE_DIR/usr/share/applications" ]; then
    mkdir -p $BASE_DIR/usr/share/applications
  fi

  # Insert Gnome desktop shortcut.
  cp -f Unity-LTS.desktop $BASE_DIR/usr/share/applications/Unity-LTS.desktop
  sed -i "s/VERSION/$LATEST_VERSION/g" $BASE_DIR/usr/share/applications/Unity-LTS.desktop

  # Make DEBIAN folder if missing.
  if [ ! -d "$BASE_DIR/DEBIAN" ]; then
  	mkdir -p $BASE_DIR/DEBIAN
  fi

  # Generate control file.
  cp -f control.tmpl $BASE_DIR/DEBIAN/control
  sed -i "s/VERSION/$LATEST_VERSION/g" $BASE_DIR/DEBIAN/control

  # Insert post install and remove scripts.
  cp -f postinst $BASE_DIR/DEBIAN/postinst
  cp -f postrm $BASE_DIR/DEBIAN/postrm

  DPKG_NAME=unity-lts_"$LATEST_VERSION"_amd64.deb

  # Build Debian package.
  dpkg-deb --root-owner-group --build $BASE_DIR $DPKG_NAME

  # Change owner of the new deb file.
  chown $USERID:$GROUPID $DPKG_NAME
else
  echo "Unity LTS is up to date: \"$CURRENT_VERSION\""
fi

# Clean up.
cleanup
