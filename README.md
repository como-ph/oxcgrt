
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
functions that calculate
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker)’s various indices.

### Retrieve data

The *retrieve data* functions are based on the
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker)’s JSON API described
[here](https://covidtracker.bsg.ox.ac.uk/about-api). Two API endpoints
are provided: 1) endpoint for JSON providing data for stringency index
by country over time; and, 2) endpoint for JSON providing data on policy
actions and stringency index for a specific country on a specific day.

#### Stringency index by country over time

The first API endpoint provides JSON for all countries included in the
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) over a specified period
of time:

`https://covidtrackerapi.bsg.ox.ac.uk/api/v2/stringency/date-range/{start-date}/{end-date}`

where `start-date` and `end-date` are the starting date and ending date
(both in `YYYY-MM-DD` format) respectively from which to retrieve data.

The `oxcgrt` package provides a function named `get_json_time` to
interface with the API and retrieve the specified JSON and a function
named `get_data_time` to extract the data from the specified JSON into
an [R](https://cran.r-project.org) `tibble` object. These two functions
have been designed such that they can be piped from one to the other.
Hence to retrieve stringency index data for all countries from 1 June
2020 to current date, the following code can be used:

``` r
library(oxcgrt)
library(magrittr)

get_json_time(from = "2020-06-01") %>% get_data_time()
```

This produces the following output:

    #> # A tibble: 27,810 x 8
    #>    date_value country_code confirmed deaths stringency_actu… stringency
    #>    <date>     <chr>            <int>  <int>            <dbl>      <dbl>
    #>  1 2020-06-01 SGP              34884     23             81.5       81.5
    #>  2 2020-06-01 SLB                 NA     NA             33.3       33.3
    #>  3 2020-06-01 SLE                861     46             73.2       73.2
    #>  4 2020-06-01 SLV               2517     46            100        100  
    #>  5 2020-06-01 SMR                671     42             57.4       57.4
    #>  6 2020-06-01 SOM               1976     78             48.2       48.2
    #>  7 2020-06-01 SRB              11412    243             43.5       43.5
    #>  8 2020-06-01 SSD                994     10             85.2       85.2
    #>  9 2020-06-01 SUR                 23      1             77.8       77.8
    #> 10 2020-06-01 SVK               1522     28             69.4       69.4
    #> # … with 27,800 more rows, and 2 more variables: stringency_legacy <dbl>,
    #> #   stringency_legacy_disp <dbl>

Important to note that in `get_json_time`, only the starting date (using
the `from` argument) is specified to the desired 1 June 2020 in
`YYYY-MM-DD` format. This is because by default the `to` argument (for
the ending date) is set to the current date using a call to the
`Sys.Date()` function. By default, the `from` argument is set to 2
January 2020 (2020-01-02) which is the earliest available data point for
the stringency index. Therefore, to retrieve data on stringency index
for all countries for all available time points up to current, the
following commands can be issued:

``` r
get_json_time() %>% get_data_time()
```

which produces the following output:

    #> # A tibble: 55,745 x 8
    #>    date_value country_code stringency_actu… stringency stringency_lega…
    #>    <date>     <chr>                   <dbl>      <dbl>            <dbl>
    #>  1 2020-01-02 ABW                         0          0                0
    #>  2 2020-01-02 AFG                         0          0                0
    #>  3 2020-01-02 AGO                         0          0                0
    #>  4 2020-01-02 ALB                         0          0                0
    #>  5 2020-01-02 AND                         0          0                0
    #>  6 2020-01-02 ARE                         0          0                0
    #>  7 2020-01-02 ARG                         0          0                0
    #>  8 2020-01-02 AUS                         0          0                0
    #>  9 2020-01-02 AUT                         0          0                0
    #> 10 2020-01-02 AZE                         0          0                0
    #> # … with 55,735 more rows, and 3 more variables: stringency_legacy_disp <dbl>,
    #> #   confirmed <int>, deaths <int>

#### Policy actions and stringency index for specific country on a specific day

The second API endpoint provides JSON for a specific country included in
the [OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) for a specified day:

`https://covidtrackerapi.bsg.ox.ac.uk/api/v2/stringency/actions/{country-code}/{date}`

where `country-code` is the ISO 3166-1 alpha-3 country code for the
required country to get data for and `date` is the date (in `YYYY-MM-DD`
format) on which to retrieve data.

The `oxcgrt` package provides a function named `get_json_actions` to
interface with the API and retrieve the specified JSON and a function
named `get_data` to extract the data from the specified JSON into a
named `list` [R](https://cran.r-project.org) object. These two functions
have been designed such that they can be piped from one to the other.
Hence to retrieve policy actions and stringency index data for
Afghanistan for 1 June 2020, the following code can be used:

``` r
get_json_actions(ccode = "AFG", from = NULL, to = "2020-06-01") %>% get_data()
```

which produces the following output:

    #> $policyActions
    #> # A tibble: 18 x 9
    #>    policy_type_code policy_type_dis… policyvalue policyvalue_act… flagged
    #>    <chr>            <chr>                  <int>            <int> <lgl>  
    #>  1 C1               School closing             3                3 TRUE   
    #>  2 C2               Workplace closi…           3                3 FALSE  
    #>  3 C3               Cancel public e…           2                2 TRUE   
    #>  4 C4               Restrictions on…           4                4 TRUE   
    #>  5 C5               Close public tr…           2                2 FALSE  
    #>  6 C6               Stay at home re…           2                2 FALSE  
    #>  7 C7               Restrictions on…           2                2 FALSE  
    #>  8 C8               International t…           3                3 NA     
    #>  9 E1               Income support             0                0 NA     
    #> 10 E2               Debt/contract r…           0                0 NA     
    #> 11 E3               Fiscal measures            0                0 NA     
    #> 12 E4               International s…           0                0 NA     
    #> 13 H1               Public informat…           2                2 TRUE   
    #> 14 H2               Testing policy             1                1 NA     
    #> 15 H3               Contact tracing            1                1 NA     
    #> 16 H4               Emergency inves…           0                0 NA     
    #> 17 H5               Investment in v…           0                0 NA     
    #> 18 H6               Facial Coverings           1                1 TRUE   
    #> # … with 4 more variables: is_general <lgl>, notes <chr>,
    #> #   flag_value_display_field <chr>, policy_value_display_field <chr>
    #> 
    #> $stringencyData
    #> # A tibble: 1 x 6
    #>   date_value country_code confirmed deaths stringency_actual stringency
    #>   <chr>      <chr>            <int>  <int>             <dbl>      <dbl>
    #> 1 2020-06-01 AFG              15205    257              84.3       84.3

Important to note that the output is a named `list` object containing a
`tibble` of **policy actions** data and a `tibble` of **stringency
index** data for the specified country and the specified date.
