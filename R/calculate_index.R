################################################################################
#
#'
#' Calculate sub-index score for a single indicator
#'
#' @param indicator_code Two-character code for indicators of policy measures
#'   tracked by Oxford COVID-19 Government Response Tracker.
#' @param value An integer for recorded policy value on the ordinal scale for
#'   given indicator.
#' @param flag_value Either logical or binary value (0, 1) for recorded flag
#'   value. If NA, corresponds to indicator with no flag.
#'
#' @return A numeric value between 0 to 100.
#'
#' @author Ernest Guevarra based on calculation methods by Hale, Thomas,
#'   Noam Angrist, Emily Cameron-Blake, Laura Hallas, Beatriz Kira,
#'   Saptarshi Majumdar, Anna Petherick, Toby Phillips, Helen Tatlow,
#'   Samuel Webster (2020). Oxford COVID-19 Government Response Tracker,
#'   Blavatnik School of Government.
#'
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
#' Calculate sub-index scores for all indicators
#'
#' @param df A data.frame containing per indicator values required for
#'   calculating sub-index scores. This data.frame will be something like the
#'   policy actions data.frame produced by a call to [get_data_actions()].
#' @param indicator_code A character value specifying the name of the column
#'   in `df` containing the indicator codes.
#' @param value A character value specifying the name of the column in `df`
#'   containing the values assigned to each indicator
#' @param flag_value A character value specifying the name of the column in `df`
#'   containing the flag values for each indicator
#' @param add Logical. Should sub-indices for each indicator be added to `df`?
#'   Default is TRUE.
#'
#' @return If `add` is TRUE (default), returns a tibble composed of the input
#'   data.frame `x` with an added column named score for the calculated
#'   sub-indices. If `add` is FALSE, returns a tibble of 2 columns with the
#'   first column for the indicator codes and the second column named score for
#'   the calculated sub-indices.
#'
#' @author Ernest Guevarra
#'
#' @examples
#' x <- get_data_actions(json = get_json_actions(ccode = "AFG",
#'                                               on = "2020-09-01"))
#' calculate_subindices(df = x$policyActions)
#'
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
  } else {
    scoreDF <- data.frame(df[[indicator_code]], score)
    names(scoreDF) <- c("indicator_code", "score")
  }

  ## Convert to tibble
  scoreDF <- tibble(scoreDF)

  ## Return scoreDF
  return(scoreDF)
}


################################################################################
#
#'
#' Calculate government response index
#'
#' @param df A data.frame produced by a call to [calculate_subindices()].
#' @param indicator_code A character value specifying the name of the column
#'   in `df` containing the indicator codes.
#'
#' @return A numeric value for mean index scores for government response index.
#'
#' @author Ernest Guevarra
#'
#' @examples
#' x <- get_data_actions(json = get_json_actions(ccode = "AFG",
#'                                               on = "2020-09-01"))
#' y <- calculate_subindices(df = x$policyActions)
#'
#' calculate_gov_response(df = y)
#'
#' @export
#'
#
################################################################################

calculate_gov_response <- function(df,
                                   indicator_code = "policy_type_code") {
  ## Create vector of codes for government response indicators
  codes <- c(paste("C", 1:8, sep = ""), paste("E", 1:2, sep = ""),
             paste("H", 1:3, sep = ""), "H6")

  ## Get scores for corresponding indicators
  x <- df$score[df[[indicator_code]] %in% codes]

  ## Get mean of scores
  z <- mean(x, na.rm = TRUE)

  ## Return mean
  return(z)
}
