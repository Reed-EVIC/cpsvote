#' apply weight correction for voter turnout
#' 
#' This function applies the turnout correction recommended by Achen & Hur 
#' (2013). The data set containing the scaling factor is `cpsvote::cps_reweight`.
#' @param data the input data set, containing columns `YEAR`, `STATE`, and 
#' `achenhur_turnout`
#' 
#' @export
cps_reweight_turnout <- function(data) {
  YEAR <- STATE <- WEIGHT <- response <- NULL
  
  reweight <- cpsvote::cps_reweight %>%
    dplyr::select(YEAR, STATE, response, reweight) %>%
    dplyr::mutate(YEAR = as.integer(YEAR))
  
  if(is.numeric(data$achenhur_turnout)) {
    reweight <- reweight %>%
      dplyr::rowwise() %>%
      dplyr::mutate(response = as.numeric(response),
                    STATE = unique(cpsvote::cps_factors$code[cpsvote::cps_factors$value == STATE]),
                    YEAR = dplyr::case_when(YEAR < 1998 ~ as.integer(YEAR %% 1900),
                                     TRUE ~ YEAR))
  }
  
  output <- data %>%
    dplyr::left_join(reweight, by = c("YEAR", "STATE", "achenhur_turnout" = "response")) %>%
    dplyr::mutate(reweight = dplyr::coalesce(reweight, 1), # if it's missing, just return the original
                  turnout_weight = WEIGHT * reweight) %>%
    dplyr::select(-reweight)
  
  output
}

# out <- output %>%
#   srvyr::as_survey_design(weights = turnout_weight)
# 
# turnout_check <- out %>%
#   dplyr::group_by(YEAR, STATE) %>%
#   dplyr::summarize(turnout = srvyr::survey_mean(achenhur_turnout == "YES", na.rm = TRUE))
