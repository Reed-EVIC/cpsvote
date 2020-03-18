cps_load_basic <- function(datadir = "cps_data",
                           outdir = NULL) {
  output <- cps_read(dir = datadir) %>%
    cps_label() %>%
    cps_refactor()
  
  if(!is.null(outdir)) {
    saveRDS(output, file = file.path(outdir, "cps_basic.RData"))
  }
  
  output
}
