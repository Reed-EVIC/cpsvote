#' load some basic/default CPS data into the environment
#' 
#' This function is a quick starter to working with the CPS, using all of the 
#' defaults that are baked into this package. Because the data is so large, it 
#' made more sense to ship a "basic" CPS data set as a function rather than as a 
#' package data object (which would have been over 10 MB). This function will 
#' take you from nothing to having some basic CPS data in your environment, with 
#' the option to save this data locally for future ease. A sample of the data
#' that comes out of this function is provided as `cpsvote::cps_sample_10k`.
#' 
#' @param datadir The location where the CPS zip files live (or should be 
#' downloaded to)
#' @param outdir The location where the final data file should be saved to
#' @export
cps_load_basic <- function(datadir = "cps_data",
                           outdir = NULL) {
  output <- cps_read(dir = datadir) %>%
    cps_label() %>%
    cps_refactor() %>%
    cps_recode_vote() %>%
    cps_reweight_turnout()
  
  if(!is.null(outdir)) {
    saveRDS(output, file = file.path(outdir, "cps_basic.RData"))
  }
  
  output
}
