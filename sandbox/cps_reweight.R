# this needs documentation
# also maybe it should go into the canonical cps data included
cps_reweight <- function(data) {
  thing <- dplyr::left_join(data, reweight,
                            by = c("CPS_YEAR", "CPS_STATE", "VRS_VOTE")) %>%
    dplyr::select(-cps_prop, -vep_prop) %>%
    dplyr::mutate(WEIGHT_TURNOUT = WEIGHT * REWEIGHT)
}