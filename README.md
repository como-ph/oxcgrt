
<!-- README.md is generated from README.Rmd. Please edit that file -->

# oxcgrt: An Interface to the Oxford COVID-19 Government Response Tracker API

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/como-ph/oxcgrt/workflows/R-CMD-check/badge.svg)](https://github.com/como-ph/oxcgrt/actions)
![test-coverage](https://github.com/como-ph/oxcgrt/workflows/test-coverage/badge.svg)
[![Codecov test
coverage](https://codecov.io/gh/como-ph/oxcgrt/branch/master/graph/badge.svg)](https://codecov.io/gh/como-ph/oxcgrt?branch=master)
[![CodeFactor](https://www.codefactor.io/repository/github/como-ph/oxcgrt/badge)](https://www.codefactor.io/repository/github/como-ph/oxcgrt)
<!-- badges: end -->

The [Oxford COVID-19 Government Response Tracker
(OxCGRT)](https://www.bsg.ox.ac.uk/covidtracker) tracks and compares
worldwide government responses to the COVID-19 pandemic rigorously and
consistently. [OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) makes
available systematic information in a consistent way, aiding those who
require information have access to it efficiently for their purposes.
This package facilitates access to the
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) data via its API for R
users. This package also includes functions to calculate the various
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) indices.

## Installation

<!---
You can install the released version of oxcgrt from [CRAN](https://CRAN.R-project.org) with:


```r
install.packages("oxcgrt")
```

And the development version from [GitHub](https://github.com/) with:
--->

`oxcgrt` is not yet available on [CRAN](https://cran.r-project.org).

The development version of `oxcgrt` can be installed via
[GitHub](https://github.com/como-ph/oxcgrt):

``` r
if(!require(remotes)) install.packages("remotes")
remotes::install_github("como-ph/oxcgrt")
```

## Usage

The `oxcgrt` package includes two types of functions. First are
functions that retrieve data via
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker)’s API, and second are
function that calculate
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker)’s various indices.
