bioutils
========

Useful functions for computational biology.

* GitHub repo: https://github.com/letaylor/bioutils
* Free software: MIT license

[![Build Status](https://travis-ci.com/letaylor/bioutils.svg?branch=master)](https://travis-ci.com/letaylor/bioutils)

Quick Start
-----------

Install the R package:

```r
# install the package in R
install.packages("devtools")
options(unzip = "internal") # sometimes this is needed, depending on the R install
devtools::install_github("letaylor/bioutils")
```


Usage
-----

See the [vignettes](vignettes/bioutils.md) for more usage examples.


Other
-----

This package uses [bumpversion](https://pypi.org/project/bumpversion) for automatic [semantic versioning](https://semver.org).

```bash
# bump the appropriate increment
bumpversion patch --verbose --dry-run
bumpversion minor --verbose --dry-run
bumpversion major --verbose --dry-run

# commit with tags
git push --tags
```
