library(cpsvote)
library(dplyr)

cps <- cpsvote::read_cps() %>%
  select(-file) %>%
  cps_reweight()

usethis::use_data(cps, overwrite = TRUE, compress = "xz")

devtools::document()
