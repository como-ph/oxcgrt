################################################################################
#
#'
#' Get time series stringency index data from JSON
#'
#' @param json A JSON string, URL or file created using [get_json_time()]
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
  ## Check if curl is available
  requireNamespace("curl", quietly = TRUE)

  ## Extract data from JSON
  x <- jsonlite::fromJSON(txt = json, flatten = TRUE)

  ## Convert list to data.frame
  y <- unlist(x[["data"]], recursive = FALSE)
  z <- lapply(X = y, FUN = unlist)
  df <- dplyr::bind_rows(z)

  ## Convert column classes to appropriate classes
  df <- df %>%
    dplyr::mutate(date_value = lubridate::ymd(date_value),
                  confirmed = as.integer(confirmed),
                  deaths = as.integer(deaths),
                  stringency_actual = as.numeric(stringency_actual),
                  stringency = as.numeric(stringency),
                  stringency_legacy = as.numeric(stringency_legacy),
                  stringency_legacy_disp = as.numeric(stringency_legacy_disp))

  ## Return data
  return(df)
}


################################################################################
#
#'
#' Get policy actions and stringency data from JSON
#'
#' @param json A JSON string, URL or file created using [get_json_actions()]
#'
#' @return A named list of two tibbles. The first tibble is named
#'   `policyActions`. The second tibble is named `stringencyData`
#'
#' @examples
#' ## Get relevant JSON
#' x <- get_json_actions(ccode = "AFG", on = "2020-07-16")
#'
#' ## Get data on policy actions
#' get_data_actions(x)
#'
#' @export
#'
#
################################################################################

get_data_actions <- function(json) {
  ## Check if curl is available
  requireNamespace("curl", quietly = TRUE)

  ## Extract data from JSON
  x <- jsonlite::fromJSON(txt = json, flatten = TRUE)

  ## Convert data.frames in list to tibble
  x$policyActions <- tibble::tibble(x$policyActions) %>%
    dplyr::mutate(policyvalue = as.integer(policyvalue),
                  notes = as.character(notes))
  x$stringencyData <- dplyr::bind_rows(x$stringencyData)

  ## Return data
  return(x)
}
