#' Apply factor levels to raw CPS data
#' 
#' @description The CPS publishes their data in a numeric format, with a separate 
#' PDF codebook (not machine readable) describing factor values. This function 
#' labels the raw numeric CPS data according to a supplied factor key. Codes 
#' that appear in a given year and are not included in `factors` will be 
#' recoded as `NA`.
#' 
#' @param data The raw CPS data that factors should be applied to
#' @param factors A data frame containing the label codes to be applied
#' @param names_col Which column of `factors` contains the column names of `data`
#' @param na_vals Which character values should be considered "missing" across 
#' the dataset and be set to NA after labelling
#' @param expand_year Whether to change the two-digit year listed in earlier surveys 
#' (94, 96) into a four-digit year (1994, 1996)
#' @param rescale_weight Whether to rescale the weight, dividing by 10,000. The 
#' CPS describes the given weight as having "four implied decimals", so this 
#' rescaling adjusts the weight to produce sensible population totals.
#' 
#' @return CPS data with factor labels in place of the raw numeric data
#' @export
cps_label <- function(data, 
                      factors = cpsvote::cps_factors, 
                      names_col = "new_name",
                      na_vals = c("-1", "BLANK", "NOT IN UNIVERSE"),
                      expand_year = TRUE,
                      rescale_weight = TRUE) {
  cps_turnout <- hurachen_turnout <- YEAR <- YEAR4 <- year <- index <- WEIGHT <- NULL
  
  data <- data %>%
    dplyr::mutate(index = dplyr::row_number(),
                  YEAR4 = YEAR %% 1900 + 1900) # fix the two-digit year problem
  
  factor_cols <- colnames(data)[colnames(data) %in% factors[[names_col]]]
  
  factored_data <- dplyr::filter(data, FALSE) %>%
    dplyr::mutate_at(factor_cols, as.factor)
  
  for (yr in unique(data$YEAR4)) {
    data_yr <- dplyr::filter(data, YEAR4 == yr)
    
    for (col in factor_cols) {
      small_factors <- dplyr::filter(factors, year == yr, factors[[names_col]] == col)
      
      data_yr[[col]] <- factor(data_yr[[col]], 
                               levels = small_factors$code,
                               labels = small_factors$value)
    }
    factored_data <- suppressWarnings(dplyr::bind_rows(factored_data, data_yr))
  }
  
  # sort like the original, remove index and extra year
  output <- factored_data %>%
    dplyr::arrange(index) %>%
    dplyr::select(-index, -YEAR4)
  
  for (i in colnames(output)) {
    # if it's not in the factor data, skip
    if(!(i %in% factors[[names_col]])) next
    # change to uppercase, factor with levels from `factors`
    output[[i]] <- factor(toupper(output[[i]]), 
                          levels = unique(toupper(factors$value[factors[[names_col]] == i])))
  }
  
  output <- output %>%
    dplyr::mutate_if(is.numeric, function(x) suppressWarnings(na_ifin(x, as.numeric(na_vals)))) %>% # drop -1
    dplyr::mutate_if(function(y) !is.numeric(y), function(x) na_ifin(x, toupper(na_vals))) %>% # drop other na values
    dplyr::mutate_if(is.factor, forcats::fct_drop) %>% # if it's a factor, remove tha NA factor values
    dplyr::mutate(YEAR = dplyr::case_when(expand_year ~ as.integer(YEAR %% 1900 + 1900), TRUE ~ YEAR), # fix the two-digit year if asked
                  WEIGHT = dplyr::case_when(is.na(WEIGHT) ~ 0,
                                            rescale_weight ~ WEIGHT / 10000, 
                                            TRUE ~ as.double(WEIGHT))) # fix the 4-decimal weight if asked
  
  # bonus columns in case this happens after the vote reweighting
  if("turnout_weight" %in% colnames(output)) {
    output <- dplyr::mutate(output, turnout_weight = dplyr::case_when(is.na(turnout_weight) ~ 0,
                                                       rescale_weight ~ turnout_weight / 10000, 
                                                       TRUE ~ as.double(turnout_weight)))
  }
  if("cps_turnout" %in% colnames(output)) {
    output <- dplyr::mutate(output, cps_turnout = factor(cps_turnout,
                                                  levels = 1:2,
                                                  labels = c("YES", "NO")))
  }
  if("hurachen_turnout" %in% colnames(output)) {
    output <- dplyr::mutate(output, hurachen_turnout = factor(hurachen_turnout,
                                                  levels = 1:2,
                                                  labels = c("YES", "NO")))
  }
  
  return(output)
}


# helper for the above

#' vectorized \code{na_if}
#' 
#' @param x the vector to be checked
#' @param y the values which should be replaced with NA
na_ifin <- function(x, y) {
  x[x %in% y] <- NA
  x
}