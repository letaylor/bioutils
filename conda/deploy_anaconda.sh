#!/bin/bash
#===============================================================================
#title        :deploy_anaconda.sh
#description  :
#author       :Leland Taylor
#date         :26/03/2019
#version      :0.1
#usage        :sh deploy_anaconda.sh PKG_NAME
#input        :PKG_NAME (required)
#               - package name to deploy
#output       :NULL
#notes        :CONDA_USER_NAME is stored securely in on Travis CI.
#              CONDA_UPLOAD_TOKEN is stored securely in on Travis CI.
#              See README.md
#===============================================================================
set -e

CONDA_OUT_FILE=${1-"ERROR"} # for conda build .
echo "CONDA_OUT_FILE=${CONDA_OUT_FILE}"

# echo "Converting conda package..."
# conda convert --platform all $HOME/miniconda2/conda-bld/linux-64/PACKAGENAME-*.tar.bz2 --output-dir conda-bld/

# /home/travis/miniconda/conda-bld/linux-64/r-bioutils-0.1.1-r351_0.tar.bz2
echo "Deploying to Anaconda.org..."
anaconda --token ${CONDA_UPLOAD_TOKEN} upload \
    ${CONDA_OUT_FILE} \
    --user ${CONDA_USER_NAME} \
    --label "main" \
    --force
    #--all

echo "Successfully deployed to Anaconda.org."
exit 0
