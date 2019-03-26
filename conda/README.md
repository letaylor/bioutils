# Automatic Uploads to Anaconda from Travis CI

This workflow is derived from [here](https://gist.github.com/zshaheen/fe76d1507839ed6fbfbccef6b9c13ed9) and [here](https://gist.github.com/yoavram/05a3c04ddcf317a517d5).

## 1. Edit config files

Edit the following files:
* conda_upload.sh : alter the section marked EDIT
* meta.yaml : alter the package::name, source::git_url, requirements::host, requirements::run, test::commands, and the about sections

## 2. Give Travis CI access to upload to Anaconda

The token `conda_upload.sh::$CONDA_UPLOAD_TOKEN` is used to authenticate the `anaconda upload` command. Store this token securely in on Travis CI.

1. Login to the account you want Travis to use to upload on [anaconda.org](https://anaconda.org).
2. Click on your username on the top left and go to 'My Settings'.
3. On the left hand panel, go to 'Access' and enter your password as requested.
4. Now we'll create an API token. Give it a name, and **check at least both 'Allow read access to the API site' and 'Allow write access to the API site'**.
5. Create the token and copy it.
6. Login to your account on [travis-ci.org](https://travis-ci.org) and go to the repository that you want to add this automatic functionality to.
7. On the right next to 'More options' go to 'Settings' in the hamburger menu.
8. Add an environment variable with the name `CONDA_UPLOAD_TOKEN` and give it the value of the API token that you copied from [anaconda.org](https://anaconda.org).

Or from the command line:

```bash
anaconda login
anaconda auth -c -n travis --max-age 307584000 --url https://anaconda.org/${CONDA_USER_NAME}/${PKG_NAME} --scopes "api:write api:read"
```
