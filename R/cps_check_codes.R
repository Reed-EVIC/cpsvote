#' check that expected response codes actually appear in the data
#'
#' @description The Census Bureau occasionally changes how it codes
#' nonresponse between survey years without documenting the change. For
#' example, the `-9` ("No Response") code for `PES1`/`VRS_VOTE` appears in
#' every CPS VRS release from 1994-2020, but is entirely absent starting in
#' 2022 (the codebook still lists it, but no respondent is actually coded
#' that way -- see `vignette("voting")` for details). Because
#' [cps_label()] and [cps_recode_vote()] do not error when an expected
#' response is simply absent, this kind of change can silently shift what
#' population is excluded from `cps_turnout` and `hurachen_turnout` without
#' any warning. This function compares the responses documented in `factors`
#' for a given year against what is actually observed in `data`, and warns
#' when a documented response is completely unobserved for a year where it
#' should exist.
#' @param data labelled CPS data (i.e. the output of [cps_label()]),
#' containing `vote_col` and a `YEAR` column
#' @param vote_col which column to check
#' @param check_labels which labels (as they appear in `factors$value`,
#' case-insensitive) to check for. Defaults to the three categories the
#' Census treats as nonvoters: "Don't Know", "Refused", and "No Response"
#' @param factors A data frame containing the label codes to be applied,
#' as in [cps_label()]
#' @param names_col Which column of `factors` contains the column names of
#' `data`
#' @return `data`, invisibly. This function is called for its side effect of
#' issuing warnings.
#' @examples cps_check_codes(cps_label(cps_2024_10k))
#'
#' @export
cps_check_codes <- function(data,
                            vote_col = "VRS_VOTE",
                            check_labels = c("DON'T KNOW", "REFUSED", "NO RESPONSE"),
                            factors = cpsvote::cps_factors,
                            names_col = "new_name") {

  if (!(vote_col %in% colnames(data)) || !("YEAR" %in% colnames(data))) {
    return(invisible(data))
  }

  # numeric (pre-`cps_label()`) data isn't labelled yet, so there's nothing
  # to compare against `factors$value`
  if (is.numeric(data[[vote_col]])) {
    return(invisible(data))
  }

  check_labels <- toupper(check_labels)

  for (yr in sort(unique(data$YEAR))) {
    documented <- toupper(factors$value[factors[[names_col]] == vote_col & factors$year == yr])
    expected <- intersect(check_labels, documented)
    if (length(expected) == 0) next

    observed <- toupper(as.character(data[[vote_col]][data$YEAR == yr]))
    missing <- expected[!(expected %in% observed)]

    if (length(missing) > 0) {
      warning(
        "cps_check_codes: for YEAR = ", yr, ", column '", vote_col, "', the codebook ",
        "documents the response(s) ", paste(sQuote(missing), collapse = ", "),
        " but none of them appear in the data. This usually means the Census Bureau ",
        "changed its coding of nonresponse for this year (see vignette(\"voting\") for ",
        "the 2022+ `-9`/No Response discontinuity), and turnout estimates from ",
        "`cps_recode_vote()` / `cps_reweight_turnout()` may be biased as a result.",
        call. = FALSE
      )
    }
  }

  invisible(data)
}
