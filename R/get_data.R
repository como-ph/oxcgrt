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
    dplyr::mutate(date_value = as.Date(date_value, format = "%Y-%m-%d"),
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
#' @param json A JSON string, URL or file created using [get_json_actions()] or
#'   a vector of JSON strings or URLs.
#'
#' @return A named list of two tibbles. The first tibble is named
#'   `policyActions`. The second tibble is named `stringencyData`
#'
#' @examples
#' ## Get relevant JSON
#' x <- get_json_actions(ccode = "AFG", from = NULL, to = "2020-07-16")
#'
#' ## Get data on policy actions and stringency index
#' get_data(x)
#'
#' @export
#'
#
################################################################################

get_data <- function(json) {
  ## Check if curl is available
  requireNamespace("curl", quietly = TRUE)

  ## Check if json is a vector
  if(length(json) > 1) {
    json <- json[1]
    warning("json has more than one value. Using first value only.",
            call. = TRUE, immediate. = TRUE)
  }

  ## Extract data from JSON
  x <- jsonlite::fromJSON(txt = json, flatten = TRUE)

  ## Convert data.frames in list to tibble
  x[["policyActions"]] <- tibble::tibble(x[["policyActions"]]) %>%
    dplyr::mutate(policyvalue = as.integer(policyvalue),
                  notes = as.character(notes))
  x[["stringencyData"]] <- dplyr::bind_rows(x[["stringencyData"]])

  ## Return data
  return(x)
}


################################################################################
#
#'
#' Get policy actions from JSON
#'
#' @param json A JSON string, URL or file created using [get_json_actions()] or
#'   a vector of JSON strings or URLs.
#'
#' @return A tibble of policy actions with their respective policy values for
#'   specified country/countries and specified date/dates.
#'
#' @examples
#' ## Get relevant JSON for Afghanistan on 16 July 2020
#' x <- get_json_actions(ccode = "AFG", from = NULL, to = "2020-07-16")
#'
#' ## Get data on policy actions
#' get_data_action(x)
#'
#' ## Get relevant JSON for Afghanistan and Philippines for whole month of
#' ## October
#' x <- get_json_actions(ccode = c("AFG", "PH"),
#'                       from = "2020-10-01",
#'                       to = "2020-10-16")
#'
#' ## Get data on policy actions
#' get_data_actions(x)
#'
#' @rdname get_data_action
#' @export
#'
#
################################################################################

get_data_action <- function(json) {
  ## Check if curl is available
  requireNamespace("curl", quietly = TRUE)

  ## Check if json is a vector
  if(length(json) > 1) {
    json <- json[1]
    warning("json has more than one value. Using first value only.",
            call. = TRUE, immediate. = TRUE)
  }

  ## Extract data from JSON
  x <- jsonlite::fromJSON(txt = json, flatten = TRUE)[["policyActions"]]

  ## Convert data.frames in list to tibble
  x <- tibble::tibble(x) %>%
    dplyr::mutate(#policyvalue = ifelse(!policyvalue %in% c("0", "1", "2", "3", "4"),
                  #                     NA, policyvalue),
                  #policyvalue = as.integer(policyvalue),
                  notes = as.character(notes),
                  date_value = stringr::str_extract(json,
                                                    pattern = "[0-9]{4}\\-[0-9]{2}\\-[0-9]{2}"),
                  date_value = as.Date(date_value, format = "%Y-%m-%d"),
                  country_code = stringr::str_extract(json,
                                                      pattern = "[A-Z]{3}"))

  ## Return data
  return(x)
}


################################################################################
#
#'
#' @rdname get_data_action
#' @export
#'
#
################################################################################

get_data_actions <- function(json) {
  ## Check if curl is available
  requireNamespace("curl", quietly = TRUE)

  ## Extract data from JSON
  x <- lapply(X = json, FUN = get_data_action) %>%
    dplyr::bind_rows()

  ## Return data
  return(x)
}


