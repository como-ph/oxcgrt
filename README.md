
<!-- README.md is generated from README.Rmd. Please edit that file -->

# oxcgrt: An R API to the Oxford COVID-19 Government Response Tracker

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/como-ph/oxcgrt/workflows/R-CMD-check/badge.svg)](https://github.com/como-ph/oxcgrt/actions)
[![Codecov test
coverage](https://codecov.io/gh/como-ph/oxcgrt/branch/master/graph/badge.svg)](https://codecov.io/gh/como-ph/oxcgrt?branch=master)
<!-- badges: end -->

The [Oxford COVID-19 Government Response Tracker
(OxCGRT)](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
tracks and compares worldwide government responses to the COVID-19
pandemic rigorously and consistently.
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
makes available systematic information in a consistent way, aiding those
who require information have access to it efficiently for their
purposes. This package facilitates access to the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
data via its API for R users.

## Installation

You can install the released version of oxcgrt from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("oxcgrt")
```

And the development version from [GitHub](https://github.com/) with:

``` r
if(!require(remotes)) install.packages("remotes")
remotes::install_github("como-ph/oxcgrt")
#> 
#>      checking for file ‘/private/var/folders/rx/nr32tl5n6f3d_86tn0tc7kc00000gp/T/Rtmp8OqZTR/remotes15b24a0ae19d/como-ph-oxcgrt-d4615de/DESCRIPTION’ ...  ✓  checking for file ‘/private/var/folders/rx/nr32tl5n6f3d_86tn0tc7kc00000gp/T/Rtmp8OqZTR/remotes15b24a0ae19d/como-ph-oxcgrt-d4615de/DESCRIPTION’
#>   ─  preparing ‘oxcgrt’:
#>      checking DESCRIPTION meta-information ...  ✓  checking DESCRIPTION meta-information
#>   ─  checking for LF line-endings in source and make files and shell scripts
#>   ─  checking for empty or unneeded directories
#>   ─  building ‘oxcgrt_0.1.0.tar.gz’
#>      
#> 
```
