#' Attach proper weights to calculate voter turnout
#' 
#' @param data The data set, containing a column of original weights
#' 
#' @details This function is designed to reweight the CPS VRS data for properly 
#' calculated turnout values, according to Achen and Hur (2013). Without 
#' reweighting, any estimate of voter turnout will be inaccurate. For more 
#' information on this reweighting, see `vignette("cps")`.
#' 
#' Additionally, it is designed to join and weight according to the default 
#' column names as used in the included `cps` data set - so it will throw an 
#' error if the required column names are not present. For custom data sets, 
#' load the provided data set `reweight` and join the two on year, state, and 
#' reported voting. Then multiply the existing weight column by the reweighting 
#' factor to obtain a correct weight to calculate turnout.
cps_reweight <- function(data) {
  if (!all(c("CPS_YEAR", "CPS_STATE", "VRS_VOTE") %in% colnames(data))) {
    stop("The following vars must be included in `data` in order to join: ",
         "'CPS_YEAR', 'CPS_STATE', 'VRS_VOTE'")
  }
  
  if (!("WEIGHT" %in% colnames(data))) {
    stop("Column 'WEIGHT' must exist in order to reweight")
  }
  
  dplyr::left_join(data, reweight,
                            by = c("CPS_YEAR", "CPS_STATE", "VRS_VOTE")) %>%
    dplyr::select(-cps_prop, -vep_prop) %>%
    dplyr::mutate(WEIGHT_TURNOUT = WEIGHT * REWEIGHT)
}