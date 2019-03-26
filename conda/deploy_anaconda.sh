#!/bin/bash
set -e

# NOTE: This script uses the CONDA_UPLOAD_TOKEN env var. Store this token
# securely in on Travis CI. See README.md
CONDA_USER_NAME="letaylor" # for anaconda upload
PKG_NAME="bioutils" # for conda build .

# echo "Converting conda package..."
# conda convert --platform all $HOME/miniconda2/conda-bld/linux-64/PACKAGENAME-*.tar.bz2 --output-dir conda-bld/

echo "Deploying to Anaconda.org..."
anaconda --token ${CONDA_UPLOAD_TOKEN} upload \
    "${HOME}/miniconda-foo/conda-bld/*/*${PKG_NAME}-*.tar.bz2" \
    --user ${CONDA_USER_NAME} \
    --label "main" \
    --force
    #--all

echo "Successfully deployed to Anaconda.org."
exit 0
