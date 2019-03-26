#!/bin/bash
set -e

# NOTE:
# this script uses the CONDA_UPLOAD_TOKEN env var.
# to create a token:
# >>> anaconda login
# >>> anaconda auth -c -n travis --max-age 307584000 --url https://anaconda.org/USERNAME/PACKAGENAME --scopes "api:write api:read"

USER="letaylor" # for anaconda upload
PKG_NAME="bioutils" # for conda build .

# echo "Converting conda package..."
# conda convert --platform all $HOME/miniconda2/conda-bld/linux-64/PACKAGENAME-*.tar.bz2 --output-dir conda-bld/

echo "Deploying to Anaconda.org..."
anaconda --token ${CONDA_UPLOAD_TOKEN} upload \
    ${HOME}/miniconda/conda-bld/**/${PKG_NAME}-*.tar.bz2 \
    --user ${USER} \
    --label "main" \
    --force
    #--all

echo "Successfully deployed to Anaconda.org."
exit 0
