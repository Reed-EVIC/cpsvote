#' Apply factor levels to raw CPS data
#' 
#' @description The CPS publishes their data in a numeric format, with a separate 
#' PDF codebook (not machine readable) describing factor values. This function 
#' labels the raw numeric CPS data according to a supplied factor key. Codes 
#' that appear in a given yer and are not included in `factors` will be 
#' supplanted with `NA`.
#' 
#' @param data The raw CPS data that factors should be applied to
#' @param factors A data frame containing the label codes to be applied
#' @param names_col Which column of `factors` contains the column names of `data`
#' 
#' @return CPS data with factor labels in place of the raw numeric data
#' @export
label_cps <- function(data, 
                      factors = cps_factors, 
                      names_col = "new_name") {
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
  
  output <- factored_data %>%
    dplyr::arrange(index) %>%
    dplyr::select(-index, -YEAR4)
  
  return(output)
}
