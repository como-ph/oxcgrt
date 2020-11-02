################################################################################
#
#'
#' Get JSON for stringency index data over time
#'
#' @param from Start date for stringency index data to be collected. This can go
#'   as far back as **2020-01-02** (Default). Format `YYYY-MM-DD`. Accepts
#'   either character string or `date` class.
#' @param to End data for stringency index data to be collected. This defaults
#'   to current date. Format `YYYY-MM-DD`. Accepts either character string or
#'   `date` class.
#'
#' @return A character object for specified JSON endpoint
#'
#' @author Ernest Guevarra
#'
#' @examples
#' get_json_time()
#'
#' @export
#'
#
################################################################################

get_json_time <- function(from = "2020-01-02",
                          to = Sys.Date()) {
  ## Create object for base URL of OxCGRT API
  base <- "https://covidtrackerapi.bsg.ox.ac.uk/api/v2/stringency/date-range"

  ## Check class of from
  if(class(from) == "Date") {
    from <- as.character(from)
  }

  ## Check class of to
  if(class(to) == "Date") {
    to <- as.character(to)
  }

  ## Construct API query to retrieve JSON
  x <- paste(base, from, to, sep = "/")

  ## Return JSON
  return(x)
}


################################################################################
#
#'
#' Get JSON for policy actions and stringency index data
#'
#' @param ccode **ISO 3166-1 alpha-2** country code, **alpha-3** country code,
#'   or full **country name** string or vector of strings (mix of alpha-2 code
#'   or alpha-3 code or country names is valid).
#' @param from Start date for policy actions and stringency index data to be
#'   collected. This can go as far back as **2020-01-02** (Default). Format
#'   `YYYY-MM-DD`. Accepts either character string or `date` class. Set to NULL
#'   if only single day data is needed.
#' @param to End data for policy actions and stringency index data to be
#'   collected. This defaults to current date. Format `YYYY-MM-DD`. Accepts
#'   either character string or `date` class. If `from` is NULL, JSON for date
#'   specified in `to` will be retrieved
#'
#' @return A character string or vector for specified JSON endpoint/s
#'
#' @examples
#' ## Get JSON for Afghanistan at 7 days previous to current date
#' get_json_actions(ccode = "AFG",
#'                  from = NULL,
#'                  to = as.character(Sys.Date() - 7))
#'
#' ## Get JSON for Afghanistan and Philippines from 1 October to 31 October 2020
#' get_json_actions(ccode = c("Afghanistan", "PH"),
#'                  from = "2020-10-01", to = "2020-10-31")
#'
#' @export
#'
#
################################################################################

get_json_actions <- function(ccode,
                             from = "2020-01-02",
                             to = Sys.Date()) {
  ## Create object for base URL of OxCGRT API
  base <- "https://covidtrackerapi.bsg.ox.ac.uk/api/v2/stringency/actions"

  ## Convert ccode iso2c to iso3c
  c1 <- countrycode::countrycode(sourcevar = ccode,
                                 origin = "iso2c",
                                 destination = "iso3c",
                                 warn = FALSE)
  country <- ifelse(is.na(c1), ccode, c1)

  ## Convert country name to iso3c
  c2 <- countrycode::countryname(sourcevar = country,
                                 destination = "iso3c",
                                 warn = FALSE)
  country <- ifelse(is.na(c2), country, c2)

  ## Determine dates
  if(is.null(from)) {
    on <- to
  } else {
    on <- seq(from = as.Date(from), to = as.Date(to), by = "days")
  }

  ## Convert on to character
  on <- as.character(on)

  ## Create query
  query <- tidyr::crossing(country, on) %>%
    apply(MARGIN = 1, FUN = paste, collapse = "/")

  ## Construct API query to retrieve JSON
  x <- paste(base, query, sep = "/")

  ## Return JSON
  return(x)
}



