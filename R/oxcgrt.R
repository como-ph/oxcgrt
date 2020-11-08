################################################################################
#
#'
#' An Interface to the Oxford COVID-19 Government Response Tracker API
#'
#' The **Oxford COVID-19 Government Response Tracker (OxCGRT)** tracks and
#' compares worldwide government responses to the COVID-19 pandemic rigorously
#' and consistently. **OxCGRT** makes available systematic information in a
#' consistent way, aiding those who require information have access to it
#' efficiently for their purposes. This package facilitates access to the
#' **OxCGRT** data via its API for R users.
#'
#' @docType package
#' @keywords internal
#' @name oxcgrt
#' @importFrom tibble tibble
#' @importFrom dplyr bind_rows mutate relocate
#' @importFrom jsonlite fromJSON
#' @importFrom magrittr %>%
#' @importFrom tidyr crossing
#' @importFrom countrycode countrycode countryname
#' @importFrom stringr str_extract
#'
#
################################################################################
"_PACKAGE"

## quiets concerns of R CMD check
if(getRversion() >= "2.15.1") {
  utils::globalVariables(c("policyvalue", "notes", "date_value", "confirmed",
                           "deaths", "stringency_actual", "stringency",
                           "stringency_legacy", "stringency_legacy_disp",
                           "country_code", "country_name", "policy_type_code"))
}
