
<!-- README.md is generated from README.Rmd. Please edit that file -->

# oxcgrt: An Interface to the Oxford COVID-19 Government Response Tracker API <img src="man/figures/logo.png" width="200" align="right" />

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
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
(OxCGRT)](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
tracks and compares worldwide government responses to the COVID-19
pandemic rigorously and consistently.
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
makes available systematic information in a consistent way, aiding those
who require information have access to it efficiently. This package
facilitates access to the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
data for [R](https://cran.r-project.org) users via version 2 of its API.
This package also includes functions to calculate the various
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
indices in [R](https://cran.r-project.org). This package is aimed at
[R](https://cran.r-project.org) users who use or plan to use the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
data for their research or for other academic purposes or who develop or
want to develop other metrics or indices that build on the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
approach.

## What does `oxcgrt` do?

The `oxcgrt` package has two main sets of functions that:

1.  Retrieve
    [OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
    data (`get_*` functions) via version 2 of its API; and,

2.  Calculate various
    [OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
    [indicators, sub-indices and
    indices](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/index_methodology.md)
    (`calculate_*` functions).

There are other [R](https://cran.r-project.org) packages that provide
access to data from the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker).
The [`COVID19` package](https://cran.r-project.org/package=COVID19) and
the [`oxcovid19` package](https://como-ph.github.io/oxcovid19/) are just
two examples of these. However, all these packages provide access to the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
data as *data dumps* and only for the time-series of the stringency
index per country. To our knowledge, the `oxcgrt` package is the only
[R](https://cran.r-project.org) package currently that provides an
interface to the available API for querying and retrieving data. Also,
the `oxcgrt` package provides functions to calculate the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
sub-indices and indices based on their methodology. None of the other
[R](https://cran.r-project.org) packages that we have seen and reviewed
have this functionality.

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
```

## Usage

### The `oxcgrt` data retrieval workflow via API

The *retrieve data* functions are based on the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)’s
JSON API described [here](https://covidtrackerapi.bsg.ox.ac.uk). Two API
endpoints are provided: 1) endpoint for JSON providing data for
stringency index by country over time; and, 2) endpoint for JSON
providing data on policy actions and stringency index for a specific
country on a specific day.

For each of these endpoints, the data retrieval workflow is composed of
two steps: first is the creation of the appropriate API URL query; and,
second is the retrieval of the appropriate data as per query into a
data.frame structure usable in [R](https://cran.r-project.org). This
workflow is show in code below:

``` r
## Load oxcgrt package
library(oxcgrt)

## Step 1: Create the appropriate API URL query for time series data from 
## 1 June 2020 up to current day
query <- get_json_time(from = "2020-06-01")

## Step 2: Retrieve the data
get_data_time(query)
```

This results in the following:

    #> # A tibble: 30,638 x 9
    #>    date_value country_code country_name confirmed deaths stringency_actu…
    #>    <date>     <chr>        <chr>            <int>  <int>            <dbl>
    #>  1 2020-06-01 ABW          Aruba              101      3             50  
    #>  2 2020-06-01 AFG          Afghanistan      15205    257             84.3
    #>  3 2020-06-01 AGO          Angola              86      4             77.8
    #>  4 2020-06-01 ALB          Albania           1137     33             71.3
    #>  5 2020-06-01 AND          Andorra            764     51             50  
    #>  6 2020-06-01 ARE          United Arab…     34557    264             72.2
    #>  7 2020-06-01 ARG          Argentina        16838    539             90.7
    #>  8 2020-06-01 AUS          Australia         7195    102             62.0
    #>  9 2020-06-01 AUT          Austria          16642    668             53.7
    #> 10 2020-06-01 AZE          Azerbaijan        5494     63             77.8
    #> # … with 30,628 more rows, and 3 more variables: stringency <dbl>,
    #> #   stringency_legacy <dbl>, stringency_legacy_disp <dbl>

The `oxcgrt` functions are designed to work with pipe operators via the
`magrittr` package. The steps shown above can be replicated using pipe
operators as follows:

``` r
## Load magrittr package
library(magrittr)

get_json_time(from = "2020-06-01") %>%    ## Step 1: Creat API URL query
  get_data_time()                         ## Step 2: Retrieve data
```

This results in the same output as the earlier workflow albeit sorted
alphabetically by country code:

    #> # A tibble: 30,638 x 9
    #>    date_value country_code country_name confirmed deaths stringency_actu…
    #>    <date>     <chr>        <chr>            <int>  <int>            <dbl>
    #>  1 2020-06-01 ABW          Aruba              101      3             50  
    #>  2 2020-06-01 AFG          Afghanistan      15205    257             84.3
    #>  3 2020-06-01 AGO          Angola              86      4             77.8
    #>  4 2020-06-01 ALB          Albania           1137     33             71.3
    #>  5 2020-06-01 AND          Andorra            764     51             50  
    #>  6 2020-06-01 ARE          United Arab…     34557    264             72.2
    #>  7 2020-06-01 ARG          Argentina        16838    539             90.7
    #>  8 2020-06-01 AUS          Australia         7195    102             62.0
    #>  9 2020-06-01 AUT          Austria          16642    668             53.7
    #> 10 2020-06-01 AZE          Azerbaijan        5494     63             77.8
    #> # … with 30,628 more rows, and 3 more variables: stringency <dbl>,
    #> #   stringency_legacy <dbl>, stringency_legacy_disp <dbl>

For more detailed examples of how to retrieve data via the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
API version 2, read [Retrieve data via OxCGRT
API](https://como-ph.github.io/oxcgrt/articles/retrieve.html).

### The `oxcgrt` calculate workflow

The `calculate_*` functions are based on the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)’s
methodology described
[here](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/index_methodology.md).
There are two sets of calculate functions included in `oxcgrt`. The
first calculates the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
**sub-indices** and the second calculates the four
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
**indices** which are composed of various combinations of the indicators
used by
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
sub-indices and indices.

For more detailed examples of how to calculate the various
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
sub-indices and indices, read [Calculate OxCGRT sub-indices and
indices](https://como-ph.github.io/oxcgrt/articles/calculate.html).

### Datasets

The `oxcgrt` package comes with helpful datasets which serve as guides
to facilitate in usage and interpretation of the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
data.

#### Codebook

The
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
provides an authoritative codebook found
[here](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/codebook.md).
The `oxcgrt` package has extracted the tables from this documentation
into a single codebook that can serve as a handy and convenient
reference for an [R](https://cran.r-project.org) user when working with
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
data in [R](https://cran.r-project.org). The
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
codebook can be accessed as follows:

``` r
codebook
```

which outputs the codebook as a singular table in `tbl` format as shown
below:

    #> # A tibble: 29 x 6
    #>    ID    Name     Description      Measurement   Coding         `Policy Group`  
    #>    <chr> <chr>    <chr>            <chr>         <chr>          <chr>           
    #>  1 C1    C1_Scho… "Record closing… Ordinal scale 0 - no measur… Containment and…
    #>  2 C1    C1_Flag  ""               Binary flag … 0 - targeted;… Containment and…
    #>  3 C2    C2_Work… "Record closing… Ordinal scale 0 - no measur… Containment and…
    #>  4 C2    C2_Flag  ""               Binary flag … 0 - targeted;… Containment and…
    #>  5 C3    C3_Canc… "Record cancell… Ordinal scale 0 - no measur… Containment and…
    #>  6 C3    C3_Flag  ""               Binary flag … 0 - targeted;… Containment and…
    #>  7 C4    C4_Rest… "Record limits … Ordinal scale 0 - no restri… Containment and…
    #>  8 C4    C4_Flag  ""               Binary flag … 0 - targeted;… Containment and…
    #>  9 C5    C5_Clos… "Record closing… Ordinal scale 0 - no measur… Containment and…
    #> 10 C5    C5_Flag  ""               Binary flag … 0 - targeted;… Containment and…
    #> # … with 19 more rows

The current `oxcgrt` package version includes the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
**codebook version 2.5** released on 4 November 2020.

#### Example OxCGRT indicators dataset

In the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
methodology
[document](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/index_methodology.md),
an example indicator dataset is used to demonstrate the calculation of
per indicator sub-indices and the four main indices that
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
provides. This example dataset has been made available in table format
in the `oxcgrt` package and can be accessed as follows:

``` r
indicatorData
```

which outputs the example data as a singular table in `tbl` format as
shown below:

    #> # A tibble: 14 x 6
    #>    indicator value flag_value max_value  flag score
    #>    <chr>     <int>      <int>     <int> <int> <dbl>
    #>  1 C1            2          1         3     1  66.7
    #>  2 C2           NA         NA         3     1   0  
    #>  3 C3            2          0         2     1  75  
    #>  4 C4            2          0         4     1  37.5
    #>  5 C5            0         NA         2     1   0  
    #>  6 C6            1          0         3     1  16.7
    #>  7 C7            1          1         2     1  50  
    #>  8 C8            3         NA         4     0  75  
    #>  9 E1            2          0         2     1  75  
    #> 10 E2            2         NA         2     0 100  
    #> 11 H1            2          0         2     1  75  
    #> 12 H2            3         NA         3     0 100  
    #> 13 H3            2         NA         2     0 100  
    #> 14 H6            2          0         4     1  37.5

This dataset is used by the `oxcgrt` package to test the `calculate_*`
functions and for demonstrating how these functions work. This dataset
can be useful for those trying to learn the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)’s
calculation methods and [R](https://cran.r-project.org) users who are
learning how to use the `oxcgrt` package `calculate_*` functions.

## Limitations

The current version of `oxcgrt` package is *experimental* in that its
stability and future development would depend on the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)‘s
current and future development. The
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
is in continuous evolution given that the COVID-19 pandemic is still
on-going and various governments’ responses to it are continuously
changed and/or updated. The
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
has also been developing other indices that capture other aspects of
governments’ responses not yet covered by current indices.

The `oxcgrt` package author and maintainer commit to ensuring that
current functions are maintained and/or updated in a manner that ensures
backwards compatibility should changes to the data structure and/or to
the indices calculation are implemented by the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
team. This would include maintaining the arguments used by the current
functions, maintaining the functionality of the current functions, and
maintaining the type of outputs of the current functions. Should changes
implemented by the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
team to the data structure and/or to the indices calculation require the
breaking of the syntax, functionality and/or outputs of the current
functions, a formal and proper deprecation process will be implemented
that include proper and detailed documentation of the changes and the
potential impact on current users.

## Disclaimer

The `oxcgrt` package is an independent development and is separate from
and not recognised and approved by the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
team. The author and maintainer of the package is not affiliated with
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
but is committed to ensure fidelity to the methods and usage specified
by
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
and accuracy of outputs described and required by
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker).

Any mistakes, problems and issues with the functionality and outputs of
the `oxcgrt` including mistakes in interpretation of the calculation of
the sub-indices and indices noted (if any) are that of the author and
maintainer and not of the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker).
Hence any problems and issues to the usage, functionality and outputs of
the `oxcgrt` package should be addressed directly to the author and
maintainer [here](https://github.com/como-ph/oxcgrt/issues).

## Citation

When using the `oxcgrt` package, please cite both the source of the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
data and `oxcgrt` package itself.

For the source of the
[OxCGRT](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
data, the following citation is recommended:

*Hale, Thomas, Noam Angrist, Emily Cameron-Blake, Laura Hallas, Beatriz
Kira, Saptarshi Majumdar, Anna Petherick, Toby Phillips, Helen Tatlow,
Samuel Webster (2020). Oxford COVID-19 Government Response Tracker,
Blavatnik School of Government.*

For the `oxcgrt` package, the suggested citation can be obtained using a
call to the `citation` function as follows:

``` r
citation("oxcgrt")
#> 
#> To cite oxcgrt in publications use:
#> 
#>   Ernest Guevarra (2020). oxcgrt: An Interface to the Oxford COVID-19
#>   Government Response Tracker API. R package version 0.1.0. URL
#>   https://como-ph.github.io/oxcgrt
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {oxcgrt: An Interface to the Oxford COVID-19 Government Response Tracker API},
#>     author = {Ernest Guevarra},
#>     year = {2020},
#>     note = {R package version 0.1.0},
#>     url = {https://como-ph.github.io/oxcgrt},
#>   }
```

## Community guidelines

Feedback, bug reports and feature requests are welcome; file issues or
seek support [here](https://github.com/como-ph/oxcgrt/issues). If you
would like to contribute to the package, please see our [contributing
guidelines](https://como-ph.github.io/oxcgrt/CONTRIBUTING.html).

This project is released with a [Contributor Code of
Conduct](https://como-ph.github.io/oxcgrt/CODE_OF_CONDUCT.html). By
participating in this project you agree to abide by its terms.
