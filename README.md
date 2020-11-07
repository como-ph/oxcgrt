
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
(OxCGRT)](https://www.bsg.ox.ac.uk/covidtracker) tracks and compares
worldwide government responses to the COVID-19 pandemic rigorously and
consistently. [OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) makes
available systematic information in a consistent way, aiding those who
require information have access to it efficiently for their purposes.
This package facilitates access to the
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) data for
[R](https://cran.r-project.org) users via version 2 of its
[API](https://covidtracker.bsg.ox.ac.uk/about-api). This package also
includes functions to calculate the various
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) indices in
[R](https://cran.r-project.org). This package is targeted at
[R](https://cran.r-project.org) users who use or plan to use the
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) data for their research
and other purposes.

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
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker)’s
[API](https://covidtracker.bsg.ox.ac.uk/about-api), and second are
functions that calculate
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker)’s various
[indices](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/index_methodology.md).

### Retrieve data

The *retrieve data* functions are based on the
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker)’s JSON
[API](https://covidtracker.bsg.ox.ac.uk/about-api) described
[here](https://covidtracker.bsg.ox.ac.uk/about-api). Two
[API](https://covidtracker.bsg.ox.ac.uk/about-api) endpoints are
provided: 1) endpoint for JSON providing data for stringency index by
country over time; and, 2) endpoint for JSON providing data on policy
actions and stringency index for a specific country on a specific day.

#### Stringency index by country over time

The first [API](https://covidtracker.bsg.ox.ac.uk/about-api) endpoint
provides JSON for all countries included in the
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) over a specified period
of time:

<br/>

`https://covidtrackerapi.bsg.ox.ac.uk/api/v2/stringency/date-range/{start-date}/{end-date}`

<br/>

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

    #> # A tibble: 28,709 x 8
    #>    date_value country_code confirmed deaths stringency_actu… stringency
    #>    <date>     <chr>            <int>  <int>            <dbl>      <dbl>
    #>  1 2020-06-01 ABW                101      3             38.9       38.9
    #>  2 2020-06-01 AFG              15205    257             84.3       84.3
    #>  3 2020-06-01 AGO                 86      4             77.8       77.8
    #>  4 2020-06-01 ALB               1137     33             67.6       67.6
    #>  5 2020-06-01 AND                764     51             50         50  
    #>  6 2020-06-01 ARE              34557    264             72.2       72.2
    #>  7 2020-06-01 ARG              16838    539             90.7       90.7
    #>  8 2020-06-01 AUS               7195    102             62.0       62.0
    #>  9 2020-06-01 AUT              16642    668             53.7       53.7
    #> 10 2020-06-01 AZE               5494     63             77.8       77.8
    #> # … with 28,699 more rows, and 2 more variables: stringency_legacy <dbl>,
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

    #> # A tibble: 56,644 x 8
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
    #> # … with 56,634 more rows, and 3 more variables: stringency_legacy_disp <dbl>,
    #> #   confirmed <int>, deaths <int>

#### Policy actions and stringency index for specific country on a specific day

The second [API](https://covidtracker.bsg.ox.ac.uk/about-api) endpoint
provides JSON for a specific country included in the
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) for a specified day:

<br/>

`https://covidtrackerapi.bsg.ox.ac.uk/api/v2/stringency/actions/{country-code}/{date}`

<br/>

where `country-code` is the ISO 3166-1 alpha-3 country code for the
required country to get data for and `date` is the date (in `YYYY-MM-DD`
format) on which to retrieve data.

The `oxcgrt` package provides a function named `get_json_actions` to
interface with the [API](https://covidtracker.bsg.ox.ac.uk/about-api)
and retrieve the specified JSON and a function named `get_data` to
extract the data from the specified JSON into a named `list`
[R](https://cran.r-project.org) object. These two functions have been
designed such that they can be piped from one to the other. Hence to
retrieve policy actions and stringency index data for Afghanistan for 1
June 2020, the following code can be used:

``` r
get_json_actions(ccode = "AFG", 
                 from = NULL, 
                 to = "2020-06-01") %>% 
  get_data()
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

#### Policy actions for specific country or countries on a specific day or days

It is also possible to retrieve just policy actions data for a specific
country or for multiple countries on a specific day or multiple days. To
retrieve policy actions data for Afghanistan for 1 June 2020, the
following code can be used:

``` r
get_json_actions(ccode = "AFG", 
                 from = NULL, 
                 to = "2020-06-01") %>% 
  get_data_action()
```

This results in:

    #> # A tibble: 18 x 11
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
    #> # … with 6 more variables: is_general <lgl>, notes <chr>,
    #> #   flag_value_display_field <chr>, policy_value_display_field <chr>,
    #> #   date_value <date>, country_code <chr>

Important to note here that the output is a tibble of just the policy
actions and two additional columns have been added to the dataset -
`date_value` and `country_code` - to identify the data as coming from a
specific date and for a specific country.

To retrieve policy actions data for multiple countries on multiple days,
the `get_data_actions` functions can be used as shown below:

``` r
get_json_actions(ccode = c("AFG", "Philippines"), 
                 from = "2020-10-25", 
                 to = "2020-10-31") %>% 
  get_data_actions()
```

This results in:

    #> # A tibble: 167 x 11
    #>    policy_type_code policy_type_dis… policyvalue policyvalue_act… flagged
    #>    <chr>            <chr>                  <int>            <int> <lgl>  
    #>  1 C1               School closing             1                1 TRUE   
    #>  2 C2               Workplace closi…           2                2 TRUE   
    #>  3 C3               Cancel public e…           0                0 NA     
    #>  4 C4               Restrictions on…           0                0 NA     
    #>  5 C5               Close public tr…           0                0 NA     
    #>  6 C6               Stay at home re…           0                0 NA     
    #>  7 C7               Restrictions on…           0                0 NA     
    #>  8 C8               International t…           0                0 NA     
    #>  9 E1               Income support             0                0 NA     
    #> 10 E2               Debt/contract r…           1                1 NA     
    #> # … with 157 more rows, and 6 more variables: is_general <lgl>, notes <chr>,
    #> #   flag_value_display_field <chr>, policy_value_display_field <chr>,
    #> #   date_value <date>, country_code <chr>

Important to note here that the output is a tibble of just the policy
actions and two additional columns have been added to the dataset -
`date_value` and `country_code` - to identify the data as coming from a
specific date and for a specific country.

### Calculate OxCGRT indices

The *calculate* functions are based on the
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker)’s methodology described
[here](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/index_methodology.md).
There are two sets of calculate functions included in `oxcgrt`. The
first calculates the [OxCGRT](https://www.bsg.ox.ac.uk/covidtracker)
**sub-indices** described in the table below:

| ID | Name                                  | Description                                                                                                                                                                                                                    | Measurement           | Coding                                                                                                                                                                                                                                                                                                                                                                                                                           | Policy Group                     |
| :- | :------------------------------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------- |
| C1 | School closing                        | Record closings of schools and universities                                                                                                                                                                                    | Ordinal scale         | 0 - no measures; 1 - recommend closing or all schools open with alterations resulting in significant differences compared to non-Covid-19 operations; 2 - require closing (only some levels or categories, eg just high school, or just public schools); 3 - require closing all levels; Blank - no data                                                                                                                         | Containment and closure policies |
| C2 | Workplace closing                     | Record closings of workplaces                                                                                                                                                                                                  | Ordinal scale         | 0 - no measures; 1 - recommend closing (or recommend work from home); 2 - require closing (or work from home) for some sectors or categories of workers; 3 - require closing (or work from home) for all-but-essential workplaces (eg grocery stores, doctors); Blank - no data                                                                                                                                                  | Containment and closure policies |
| C3 | Cancel public events                  | Record cancelling public events                                                                                                                                                                                                | Ordinal scale         | 0 - no measures; 1 - recommend cancelling; 2 - require cancelling; Blank - no data                                                                                                                                                                                                                                                                                                                                               | Containment and closure policies |
| C4 | Restrictions on gatherings            | Record limits on private gatherings                                                                                                                                                                                            | Ordinal scale         | 0 - no restrictions; 1 - restrictions on very large gatherings (the limit is above; 1000 people); 2 - restrictions on gatherings between; 101-1000 people; 3 - restrictions on gatherings between; 11-100 people; 4 - restrictions on gatherings of; 10 people or less; Blank - no data                                                                                                                                          | Containment and closure policies |
| C5 | Close public transport                | Record closing of public transport                                                                                                                                                                                             | Ordinal scale         | 0 - no measures; 1 - recommend closing (or significantly reduce volume/route/means of transport available); 2 - require closing (or prohibit most citizens from using it); Blank - no data                                                                                                                                                                                                                                       | Containment and closure policies |
| C6 | Stay at home requirements             | Record orders to “shelter-in-place” and otherwise confine to the home                                                                                                                                                          | Ordinal scale         | 0 - no measures; 1 - recommend not leaving house; 2 - require not leaving house with exceptions for daily exercise, grocery shopping, and ‘essential’ trips; 3 - require not leaving house with minimal exceptions (eg allowed to leave once a week, or only one person can leave at a time, etc); Blank - no data                                                                                                               | Containment and closure policies |
| C7 | Restrictions on internal movement     | Record restrictions on internal movement between cities/regions                                                                                                                                                                | Ordinal scale         | 0 - no measures; 1 - recommend not to travel between regions/cities; 2 - internal movement restrictions in place; Blank - no data                                                                                                                                                                                                                                                                                                | Containment and closure policies |
| C8 | International travel controls         | Record restrictions on international travel Note: this records policy for foreign travellers, not citizens                                                                                                                     | Ordinal scale         | 0 - no restrictions; 1 - screening arrivals; 2 - quarantine arrivals from some or all regions; 3 - ban arrivals from some regions; 4 - ban on all regions or total border closure; Blank - no data                                                                                                                                                                                                                               | Containment and closure policies |
| E1 | Income support (for households)       | Record if the government is providing direct cash payments to people who lose their jobs or cannot work. Note: only includes payments to firms if explicitly linked to payroll/salaries                                        | Ordinal scale         | 0 - no income support; 1 - government is replacing less than 50% of lost salary (or if a flat sum, it is less than 50% median salary); 2 - government is replacing 50% or more of lost salary (or if a flat sum, it is greater than 50% median salary); Blank - no data                                                                                                                                                          | Economic policies                |
| E2 | Debt/contract relief (for households) | Record if the government is freezing financial obligations for households (eg stopping loan repayments, preventing services like water from stopping, or banning evictions)                                                    | Ordinal scale         | 0 - no debt/contract relief; 1 - narrow relief, specific to one kind of contract; 2 - broad debt/contract relief                                                                                                                                                                                                                                                                                                                 | Economic policies                |
| E3 | Fiscal measures                       | Announced economic stimulus spending Note: only record amount additional to previously announced spending                                                                                                                      | USD                   | Record monetary value in USD of fiscal stimuli, includes any spending or tax cuts NOT included in E4, H4 or H5; 0 - no new spending that day; Blank - no data                                                                                                                                                                                                                                                                    | Economic policies                |
| E4 | International support                 | Announced offers of Covid-19 related aid spending to other countries Note: only record amount additional to previously announced spending                                                                                      | USD                   | Record monetary value in USD; 0 - no new spending that day; Blank - no data                                                                                                                                                                                                                                                                                                                                                      | Economic policies                |
| H1 | Public information campaigns          | Record presence of public info campaigns                                                                                                                                                                                       | Ordinal scale         | 0 - no Covid-19 public information campaign; 1 - public officials urging caution about Covid-19; 2- coordinated public information campaign (eg across traditional and social media); Blank - no data                                                                                                                                                                                                                            | Health system policies           |
| H2 | Testing policy                        | Record government policy on who has access to testing Note: this records policies about testing for current infection (PCR tests) not testing for immunity (antibody test)                                                     | Ordinal scale         | 0 - no testing policy; 1 - only those who both (a) have symptoms AND (b) meet specific criteria (eg key workers, admitted to hospital, came into contact with a known case, returned from overseas); 2 - testing of anyone showing Covid-19 symptoms; 3 - open public testing (eg “drive through” testing available to asymptomatic people); Blank - no data                                                                     | Health system policies           |
| H3 | Contact tracing                       | Record government policy on contact tracing after a positive diagnosis Note: we are looking for policies that would identify all people potentially exposed to Covid-19; voluntary bluetooth apps are unlikely to achieve this | Ordinal scale         | 0 - no contact tracing; 1 - limited contact tracing; not done for all cases; 2 - comprehensive contact tracing; done for all identified cases                                                                                                                                                                                                                                                                                    | Health system policies           |
| H4 | Emergency investment in healthcare    | Announced short term spending on healthcare system, eg hospitals, masks, etc Note: only record amount additional to previously announced spending                                                                              | USD                   | Record monetary value in USD; 0 - no new spending that day; Blank - no data                                                                                                                                                                                                                                                                                                                                                      | Health system policies           |
| H5 | Investment in vaccines                | Announced public spending on Covid-19 vaccine development Note: only record amount additional to previously announced spending                                                                                                 | USD                   | Record monetary value in USD; 0 - no new spending that day; Blank - no data                                                                                                                                                                                                                                                                                                                                                      | Health system policies           |
| H6 | Facial Coverings                      | Record policies on the use of facial coverings outside the home                                                                                                                                                                | Ordinal scale         | 0 - No policy; 1 - Recommended; 2 - Required in some specified shared/public spaces outside the home with other people present, or some situations when social distancing not possible; 3 - Required in all shared/public spaces outside the home with other people present or all situations when social distancing not possible; 4 - Required outside the home at all times regardless of location or presence of other people | Health system policies           |
| M1 | Wildcard                              | Record policy announcements that do not fit anywhere else                                                                                                                                                                      | Free text notes field | Note unusual or interesting interventions that are worth flagging                                                                                                                                                                                                                                                                                                                                                                | Miscellaneous policies           |

The second calculates the four
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) **indices** which are
composed of various combinations of the indicators described in the
table above. These combinations are described in the table below:

| ID | Name                                  | Government response index | Containment and health index | Stringency index | Economic support index |
| :- | :------------------------------------ | :------------------------ | :--------------------------- | :--------------- | :--------------------- |
| C1 | School closing                        | x                         | x                            | x                |                        |
| C2 | Workplace closing                     | x                         | x                            | x                |                        |
| C3 | Cancel public events                  | x                         | x                            | x                |                        |
| C4 | Restrictions on gatherings            | x                         | x                            | x                |                        |
| C5 | Close public transport                | x                         | x                            | x                |                        |
| C6 | Stay at home requirements             | x                         | x                            | x                |                        |
| C7 | Restrictions on internal movement     | x                         | x                            | x                |                        |
| C8 | International travel controls         | x                         | x                            | x                |                        |
| E1 | Income support (for households)       | x                         |                              |                  | x                      |
| E2 | Debt/contract relief (for households) | x                         |                              |                  | x                      |
| E3 | Fiscal measures                       | NA                        | NA                           | NA               | NA                     |
| E4 | International support                 | NA                        | NA                           | NA               | NA                     |
| H1 | Public information campaigns          | x                         | x                            | x                |                        |
| H2 | Testing policy                        | x                         | x                            |                  |                        |
| H3 | Contact tracing                       | x                         | x                            |                  |                        |
| H4 | Emergency investment in healthcare    | NA                        | NA                           | NA               | NA                     |
| H5 | Investment in vaccines                | NA                        | NA                           | NA               | NA                     |
| H6 | Facial Coverings                      | x                         | x                            |                  |                        |
| M1 | Wildcard                              | NA                        | NA                           | NA               | NA                     |

#### Calculating OxCGRT sub-indices

The [OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) subindices can be
calculated using the `calculate_subindex` and `calculate_subindices`
functions. To calculate a specific sub-index, the following code is
used:

``` r
## Given the C1 data in indicatorData, calculate C1 sub-index
calculate_subindex(indicator_code = indicatorData[1, "indicator"], 
                   value = indicatorData[1, "value"], 
                   flag_value = indicatorData[1, "flag_value"])
```

This gives a C1 index value of:

    #>      value
    #> 1 66.66667

To calculate all [OxCGRT](https://www.bsg.ox.ac.uk/covidtracker)
subindices, the following code is used:

``` r
## Given the indicatorData dataset, calculate all sub-indices
indicatorData %>%
  calculate_subindices(indicator_code = "indicator", 
                       value = "value", 
                       flag_value = "flag_value",
                       add = TRUE)
```

This results in the following output:

    #> # A tibble: 14 x 7
    #>    indicator value flag_value max_value  flag score score.1
    #>    <chr>     <int>      <int>     <int> <int> <dbl>   <dbl>
    #>  1 C1            2          1         3     1  66.7    66.7
    #>  2 C2           NA         NA         3     1   0       0  
    #>  3 C3            2          0         2     1  75      75  
    #>  4 C4            2          0         4     1  37.5    37.5
    #>  5 C5            0         NA         2     1   0       0  
    #>  6 C6            1          0         3     1  16.7    16.7
    #>  7 C7            1          1         2     1  50      50  
    #>  8 C8            3         NA         4     0  75      75  
    #>  9 E1            2          0         2     1  75      75  
    #> 10 E2            2         NA         2     0 100     100  
    #> 11 H1            2          0         2     1  75      75  
    #> 12 H2            3         NA         3     0 100     100  
    #> 13 H3            2         NA         2     0 100     100  
    #> 14 H6            2          0         4     1  37.5    37.5

It can be noted that the results of the calculations are added to the
input data.frame under the column name `score.1`. Comparing this with
the value in the column named `score` that is included in the
`indicatorData` dataset, the results are the same.

#### Calculating OxCGRT indices

The [OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) indices can be
calculated using the `calculate_index` and `calculate_indices`
functions. To calculate a specific sub-index, the following code can be
used:

``` r
indicatorData %>%
  calculate_subindices(indicator_code = "indicator",
                       value = "value",
                       flag_value = "flag_value",
                       add = FALSE) %>%
  calculate_index(codes = c(paste("C", 1:8, sep = ""),
                            paste("E", 1:2, sep = ""),
                            paste("H", 1:3, sep = ""),
                            "H6"), 
                  tolerance = 1)
```

This code calculates the `government response index` which is:

    #> [1] 57.7381

The same result can be reached by using the specialised function
`calculate_gov_response` as follows:

``` r
indicatorData %>% 
  calculate_subindices(indicator_code = "indicator",
                       value = "value",
                       flag_value = "flag_value",
                       add = FALSE) %>%
  calculate_gov_response()
```

which results in the same value as the previous code:

    #> [1] 57.7381

To calculate all four [OxCGRT](https://www.bsg.ox.ac.uk/covidtracker)
indices, the following code can be implemented:

``` r
indicatorData %>% 
  calculate_subindices(indicator_code = "indicator",
                       value = "value",
                       flag_value = "flag_value",
                       add = FALSE) %>%
  calculate_indices()
```

which outputs the following results:

    #> # A tibble: 4 x 2
    #>   index                        values
    #>   <chr>                         <dbl>
    #> 1 Government Response Index      57.7
    #> 2 Containment and Health Index   52.8
    #> 3 Stringency Index               44.0
    #> 4 Economic Support Index         87.5

### Datasets

The `oxcgrt` package comes with helpful datasets guides to facilitate in
usage and interpretation of the
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) data.

#### Codebook

The [OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) provides an
authoritative codebook found
[here](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/codebook.md).
The `oxcgrt` package has extracted the tables from this documentation
into a single codebook that can serve as a handy and convenient
reference for an [R](https://cran.r-project.org) user when working with
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) data in
[R](https://cran.r-project.org). The
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) codebook can be accessed
as follows:

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
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) **codebook version 2.5**
released on 4 November 2020.

#### Example OxCGRT indicators dataset

In the [OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) methodology
[document](https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/index_methodology.md),
an example indicator dataset is used to demonstrate the calculation of
per indicator sub-indices and the four main indices that
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) provides. This example
dataset has been made available in table format in the `oxcgrt` package
and can be accessed as follows:

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

This dataset is used by the `oxcgrt` package to test the `calculate_`
functions and for demonstrating how these functions work. This dataset
can be useful for those trying to learn the
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker)’s calculation methods
and [R](https://cran.r-project.org) users who are learning how to use
the `oxcgrt` package `calculate_` functions.

## Limitations

The current version of `oxcgrt` package is *experimental* in that its
stability and future development would depend on the
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker)‘s current and future
development. The [OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) is in
continuous evolution given that the COVID-19 pandemic is still on-going
and various governments’ responses to it are changed and/or updated. The
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) has also been developing
other indices that capture other aspects of governments’ responses not
yet covered by current indices.

The `oxcgrt` package author and maintainer commit to ensuring that
current functions are maintained and/or updated in a manner that ensures
backwards compatibility should changes to the data structure and/or to
the indices calculation are implemented by the
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) team. This would include
maintaining the arguments used by the current functions, maintaining the
functionality of the current functions, and maintaining the type of
outputs of the current functions. Should changes implemented by the
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) team to the data
structure and/or to the indices calculation require the breaking of the
syntax, functionality and/or outputs of the current functions, a formal
and proper deprecation process will be implemented that include proper
and detailed documentation of the changes and the potential impact on
current users.

## Disclaimer

The `oxcgrt` package is an independent development and is separate from
and not recognised and approved by the
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) team. The author and
maintainer of the package is not affiliated with
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) but is committed to
ensure fidelity to the methods and usage specified by
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) and accuracy of outputs
described and required by
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker).

Any mistakes, problems and issues with the functionality and outputs of
the `oxcgrt` including mistakes in interpretation of the calculation of
the sub-indices and indices noted (if any) are that of the author and
maintainer and not of the
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker). Hence any problems and
issues to the usage, functionality and outputs of the `oxcgrt` package
should be addressed directly to the author and maintainer
[here](https://github.com/como-ph/oxcgrt/issues).

## Citation

When using the `oxcgrt` package, please cite both the source of the
[OxCGRT](https://www.bsg.ox.ac.uk/covidtracker) data and `oxcgrt`
package itself.

For the source of the [OxCGRT](https://www.bsg.ox.ac.uk/covidtracker)
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
