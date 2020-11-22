################################################################################
#
#'
#' Calculate OxCGRT sub-index score for a single indicator
#'
#' @param indicator_code Two-character code for indicators of policy measures
#'   tracked by **Oxford COVID-19 Government Response Tracker**.
#' @param value An integer for recorded policy value on the ordinal scale for
#'   given policy type.
#' @param flag_value Either logical or binary value of 0 or 1 for recorded flag
#'   value. If NA, corresponds to policy type with no flag.
#'
#' @return A numeric value between 0 to 100.
#'
#' @author **Ernest Guevarra** based on calculation methods by *Hale, Thomas,*
#'   *Noam Angrist, Emily Cameron-Blake, Laura Hallas, Beatriz Kira,*
#'   *Saptarshi Majumdar, Anna Petherick, Toby Phillips, Helen Tatlow,*
#'   *Samuel Webster (2020). Oxford COVID-19 Government Response Tracker,*
#'   *Blavatnik School of Government.*
#'
#' @examples
#' calculate_subindex(indicator_code = indicatorData$indicator[1],
#'                    value = indicatorData$value[1],
#'                    flag_value = indicatorData$flag_value[1])
#'
#' @rdname calculate_subindex
#' @export
#'
#
################################################################################

calculate_subindex <- function(indicator_code,
                               value,
                               flag_value) {
  ## Re-code max_value
  max_value <- ifelse(indicator_code %in% c("C1", "C2", "C6", "H2"), 3,
                 ifelse(indicator_code %in% c("C4", "C8", "H6"), 4, 2))

  ## Re-code flag
  flag <- ifelse(indicator_code %in% c("C8", "E2", "H2", "H3"), 0, 1)

  ## Re-code flag_value
  xflag <- ifelse(flag_value, 1, 0)

  ## Calculate sub-index
  subindex <- 100 * ((value - (0.5 * (flag - xflag))) / max_value)

  ## Check for missing values
  if(is.na(value) | is.null(value) | is.na(flag_value) | is.null(flag_value)) {
    subindex <- 0
  }

  ## Check if indicator has a flag
  if(indicator_code %in% c("C8", "E2", "H2", "H3")) {
    subindex <- 100 * (value / max_value)
  }

  ## Return subindex
  return(subindex)
}


################################################################################
#
#'
#' Calculate OxCGRT sub-index scores for all indicators
#'
#' @param df A data.frame containing per indicator values required for
#'   calculating sub-index scores. This data.frame will be structured similarly
#'   as the policy actions data.frame produced by a call to
#'   [get_data_actions()].
#' @param indicator_code A character value specifying the name of the variable
#'   in `df` containing the policy type codes. By default, this is set to
#'   `policy_type_code` which is the variable name used by the **OxCGRT API**.
#' @param value A character value specifying the name of the column in `df`
#'   containing the values in ordinal scale assigned to each policy type. By
#'   default, this is set to `policyvalue_actual` which is the variable name
#'   used by the **OxCGRT API**.
#' @param flag_value A character value specifying the name of the column in `df`
#'   containing the flag values for each policy type. By default, this is set to
#'   `flagged` which is the variable name used by the **OxCGRT API**.
#' @param add Logical. Should sub-indices for each indicator be added to `df`?
#'   Default is TRUE.
#'
#' @return If `add` is TRUE (default), returns a tibble composed of the input
#'   data.frame `x` with an added column named score for the calculated
#'   sub-indices. If `add` is FALSE, returns a tibble of 4 columns with the
#'   first column for the policy codes named `policy_type_codes`, the second
#'   column for the policy values named `policy_value`, the third column for
#'   the flag values named `flag_value` and the fourth column named `score` for
#'   the calculated sub-indices.
#'
#' @author Ernest Guevarra
#'
#' @examples
#' x <- get_data(json = get_json_actions(ccode = "AFG",
#'                                       from = NULL,
#'                                       to = "2020-09-01"))
#' calculate_subindices(df = x$policyActions)
#'
#' @rdname calculate_subindex
#' @export
#'
#
################################################################################

calculate_subindices <- function(df,
                                 indicator_code = "policy_type_code",
                                 value = "policyvalue_actual",
                                 flag_value = "flagged",
                                 add = TRUE) {
  ## Create concatenating object
  score <- NULL

  ## Calculate indices
  for(i in seq_len(length.out = nrow(df))) {
    y <- calculate_subindex(indicator_code = df[[indicator_code]][i],
                            value = df[[value]][i],
                            flag_value = df[[flag_value]][i])
    score <- c(score, y)
  }

  ## Create scoreDF
  if(add) {
    scoreDF <- data.frame(df, score)
    if(indicator_code != "policy_type_code") {
      names(df)[names(df) == indicator_code] <- "policy_type_code"
    }
    names(df)[names(df) == value] <- "policy_value"
    names(df)[names(df) == flag_value] <- "flag_value"
  } else {
    scoreDF <- data.frame(df[[indicator_code]], df[[value]],
                          df[[flag_value]], score)
    names(scoreDF) <- c("policy_type_code", "policy_value",
                        "flag_value", "score")
  }

  ## Convert to tibble
  scoreDF <- tibble(scoreDF)

  ## Return scoreDF
  return(scoreDF)
}


################################################################################
#
#'
#' Calculate an OxCGRT index or indices
#'
#' @param df A data.frame produced by a call to [calculate_subindices()].
#' @param codes A vector of policy type codes to use for the index calculation.
#' @param tolerance An integer specifying the number of missing values above
#'   which index will not be calculated and reported.
#'
#' @return A numeric value for mean subindex scores of specified policy types.
#'   For [calculate_indices()], a tibble calculated OxCGRT indices
#'
#' @author Ernest Guevarra
#'
#' @examples
#' ## Get policy actions data for Afghanistan on 1 September 2020
#' x <- get_data(json = get_json_actions(ccode = "AFG",
#'                                       from = NULL,
#'                                       to = "2020-09-01"))
#'
#' ## Calculate OxCGRT subindices
#' y <- calculate_subindices(df = x$policyActions)
#'
#' ## Calculate OxCGRT index
#' calculate_index(df = y,
#'                 codes = c(paste("C", 1:8, sep = ""),
#'                           paste("E", 1:2, sep = ""),
#'                           paste("H", 1:3, sep = ""), "H6"),
#'                 tolerance = 1)
#'
#' ## Calculate OxCGRT government response index
#' calculate_gov_response(df = y)
#'
#' ## Calculate OxCGRT containment and health index
#' calculate_containment_health(df = y)
#'
#' ## Calculate OxCGRT stringency index
#' calculate_stringency(df = y)
#'
#' ## Calculate OxCGRT economic support index
#' calculate_economic_support(df = y)
#'
#' ## Calculate all OxCGRT indices
#' calculate_indices(df = y)
#'
#' @rdname calculate_index
#' @export
#'
#
################################################################################

calculate_index <- function(df, codes, tolerance) {
  ## Get scores for corresponding indicators
  x <- df$score[df[["policy_type_code"]] %in% codes]

  ## Get mean of scores
  z <- mean(x,
            na.rm = sum(is.na(df[["policy_value"]])) > tolerance)

  ## Return mean
  return(z)
}


################################################################################
#
#' @rdname calculate_index
#' @export
#
################################################################################

calculate_gov_response <- function(df) {
  ## Create vector of codes for government response indicators
  codes <- c(paste("C", 1:8, sep = ""), paste("E", 1:2, sep = ""),
             paste("H", 1:3, sep = ""), "H6")

  ## Calculate index
  z <- calculate_index(df = df, codes = codes, tolerance = 1)

  ## Return mean
  return(z)
}


################################################################################
#
#' @rdname calculate_index
#' @export
#
################################################################################

calculate_containment_health <- function(df) {
  ## Create vector of codes for containment and health indicators
  codes <- c(paste("C", 1:8, sep = ""), paste("H", 1:3, sep = ""), "H6")

  ## Calculate index
  z <- calculate_index(df = df, codes = codes, tolerance = 1)

  ## Return mean
  return(z)
}


################################################################################
#
#' @rdname calculate_index
#' @export
#
################################################################################

calculate_stringency <- function(df) {
  ## Create vector of codes for stringency indicators
  codes <- c(paste("C", 1:8, sep = ""), "H1")

  ## Calculate index
  z <- calculate_index(df = df, codes = codes, tolerance = 1)

  ## Return mean
  return(z)
}


################################################################################
#
#' @rdname calculate_index
#' @export
#
################################################################################

calculate_economic_support <- function(df) {
  ## Create vector of codes for economic support indicators
  codes <- paste("E", 1:2, sep = "")

  ## Calculate index
  z <- calculate_index(df = df, codes = codes, tolerance = 2)

  ## Return mean
  return(z)
}


################################################################################
#
#' @rdname calculate_index
#' @export
#
################################################################################

calculate_indices <- function(df) {
  ##
  index <- c("Government Response Index",
             "Containment and Health Index",
             "Stringency Index",
             "Economic Support Index")

  ##
  values <- c(calculate_gov_response(df = df),
              calculate_containment_health(df = df),
              calculate_stringency(df = df),
              calculate_economic_support(df = df))

  ##
  indexDF <- data.frame(index, values)

  ##
  indexDF <- tibble(indexDF)

  ##
  return(indexDF)
}

