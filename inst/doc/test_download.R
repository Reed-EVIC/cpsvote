## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(cpsvote)

## ----setup, eval = FALSE------------------------------------------------------
# library(cpsvote)

## -----------------------------------------------------------------------------
cps_download_data(path = here::here('cps_data'), years = 2020, overwrite = TRUE)

## -----------------------------------------------------------------------------
cps_download_docs(path = here::here('cps_docs'), years = 2020, overwrite = TRUE)

