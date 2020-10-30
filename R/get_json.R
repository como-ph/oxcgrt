################################################################################
#
#'
#' Get JSON for stringency index data over time
#'
#' @param from Start date for stringency index data to be collected. This can go
#'   as far back as 2020-01-02 (Default). Format `YYYY-MM-DD`.
#' @param to End data for stringency index data to be collected. This defaults
#'   to current date. Format `YYYY-MM-DD`.
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
                          to = as.character(Sys.Date())) {
  ## Create object for base URL of OxCGRT API
  base <- "https://covidtrackerapi.bsg.ox.ac.uk/api/v2/stringency/date-range"

  ## Construct API query to retrieve JSON
  x <- paste(base, from, to, sep = "/")

  ## Return JSON
  return(x)
}


################################################################################
#
#'
#' Get JSON for policy actions data for a specific country for a specific date
#'
#' @param ccode ISO 3166-1 alpha-3 country code
#' @param on Date on which policy actions data is required. This defaults
#'   to current date. Format `YYYY-MM-DD`.
#'
#' @return A character object for specified JSON endpoint
#'
#' @examples
#' get_json_actions(ccode = "AFG", on = as.character(Sys.Date() - 7))
#'
#' @export
#'
#
################################################################################

get_json_actions <- function(ccode,
                             on = as.character(Sys.Date())) {
  ## Create object for base URL of OxCGRT API
  base <- "https://covidtrackerapi.bsg.ox.ac.uk/api/v2/stringency/actions"

  ## Construct API query to retrieve JSON
  x <- paste(base, ccode, on, sep = "/")

  ## Return JSON
  return(x)
}



