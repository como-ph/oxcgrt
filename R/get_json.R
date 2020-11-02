################################################################################
#
#'
#' Get JSON for OxCGRT data
#'
#' @param ccode **ISO 3166-1 alpha-2** country code, **alpha-3** country code,
#'   or full **country name** string or vector of strings (mix of alpha-2 code
#'   or alpha-3 code or country names is valid).
#' @param from Start date for stringency index data to be collected. This can go
#'   as far back as **2020-01-02** (Default). Format `YYYY-MM-DD`. Accepts
#'   either character string or `date` class.
#' @param to End data for stringency index data to be collected. This defaults
#'   to current date. Format `YYYY-MM-DD`. Accepts either character string or
#'   `date` class.
#'
#' @return A character object for specified JSON time series endpoint, or a
#'   character string or a character vector for specified JSON policy actions
#'   endpoint or endpoints.
#'
#' @author Ernest Guevarra
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
#' ## Get JSON time series endpoint for all data available from OxCGRT
#' get_json_time()
#'
#' @rdname get_json
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
#' @rdname get_json
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



