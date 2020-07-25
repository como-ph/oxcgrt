################################################################################
#
#'
#' Get data time series stringency index data from JSON
#'
#' @param json A JSON string, URL or file created using \link{get_json_time}
#'
#' @return A tibble of time series stringency index data
#'
#' @examples
#' x <- get_json_time(from = "2020-07-18", to = "2020-07-25")
#'
#' get_data_time(x)
#'
#' @export
#'
#
################################################################################

get_data_time <- function(json) {
  x <- jsonlite::fromJSON(txt = json, flatten = TRUE)
  y <- unlist(x[["data"]], recursive = FALSE)
  z <- lapply(X = y, FUN = unlist)
  df <- dplyr::bind_rows(z)
  return(df)
}

################################################################################
#
#'
#' Get policy actions and stringency data from JSON
#'
#' @param json A JSON string, URL or file created using \link{get_json_actions}
#'
#' @return A named list of two tibbles. The first tibble is named
#'   \code{policyActions}. The second tibble is named \code{stringencyData}
#'
#' @examples
#' x <- get_json_actions(ccode = "AFG", on = "2020-07-16")
#'
#' get_data_actions(x)
#'
#' @export
#'
#
################################################################################

get_data_actions <- function(json) {
  x <- jsonlite::fromJSON(txt = json, flatten = TRUE)

  x$policyActions <- tibble::tibble(x$policyActions)
  x$stringencyData <- dplyr::bind_rows(x$stringencyData)

  return(x)
}
