############### EDIT ###########################################################
USER="letaylor" # for anaconda upload
PKG_NAME="bioutils" # for conda build .
ADD_DATE_VERSION="FALSE" # TRUE | FALSE
################################################################################

#export CONDA_BLD_PATH="${HOME}/conda-bld"
VERSION="0.1.1"
if [[ "${ADD_DATE_VERSION}" == "TRUE" ]]; then
    VERSION=${VERSION}"_"$(date +%Y.%m.%d)
fi
export VERSION

OS=$TRAVIS_OS_NAME-64 # for conda build .
#mkdir ${CONDA_BLD_PATH} # for conda build .

conda config --set anaconda_upload no # for conda build .
OUT_FILE=$(conda build . --output)
echo "CONDA BUILD OUT_FILE = ${OUT_FILE}"

anaconda --token ${CONDA_UPLOAD_TOKEN} upload \
    ${OUT_FILE} \
    --user ${USER} \
    --label "main" \
    --force
    #--all  # conda convert to generate packages for all platforms
