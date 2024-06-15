#!/bin/bash

# # Install required tools
apt update 

export DEBIAN_FRONTEND=noninteractive 

apt install -yq --no-install-recommends python3 \
    make \
    python3-pip \
    python3-sphinx \
    python3-sphinx-autobuild 

pip3 install sphinx-rtd-theme --break-system-packages

# Get the documentation project directory from a environment variable
ROOT_DIR=$DOCUMENTATION_ROOT_DIR
SOURCE_DIR=$ROOT_DIR/source
BUILD_DIR=$ROOT_DIR/build

# Check if the Sphinx documentation is already built
if [ ! -d "$BUILD_DIR" ]; then
    echo "Building Sphinx documentation..."
    sphinx-build -b html $SOURCE_DIR $BUILD_DIR
else
    echo "Sphinx documentation already built."
fi

# Start the Sphinx web server using sphinx-autobuild
echo "Starting Sphinx web server on http://127.0.0.1:8000"
sphinx-autobuild -b html --host 0.0.0.0 --port 9000 $SOURCE_DIR $BUILD_DIR

# Echo starting python3 -m http.server 9091
# echo "Starting Python HTTP server on http://127.0.0.1:9000"
# python3 -m http.server 9000 --directory $BUILD_DIR 

# Keep the script running
echo "Press [CTRL+C] to stop the server."
