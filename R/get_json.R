

get_json_time <- function(from = "2020-01-02",
                          to = as.character(Sys.Date())) {
  base <- "https://covidtrackerapi.bsg.ox.ac.uk/api/v2/stringency/date-range"
  x <- paste(base, from, to, sep = "/")
  return(x)
}


get_json_actions <- function(ccode, on = as.character(Sys.Date())) {
  base <- "https://covidtrackerapi.bsg.ox.ac.uk/api/v2/stringency/actions"
  x <- paste(base, ccode, on, sep = "/")
  return(x)
}


get_data_time <- function(json) {
  x <- jsonlite::fromJSON(txt = json, flatten = TRUE)

  y <- unlist(x[["data"]], recursive = FALSE)

  z <- lapply(X = y, FUN = unlist)

  df <- dplyr::bind_rows(z)

  return(df)
}


get_data_actions <- function(json) {
  x <- jsonlite::fromJSON(txt = json, flatten = TRUE)

  y <- unlist(x[["data"]], recursive = FALSE)

  z <- lapply(X = y, FUN = unlist)

  df <- dplyr::bind_rows(z)

  return(df)
}
