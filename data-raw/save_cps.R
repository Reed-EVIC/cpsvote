library(cpsvote)
library(dplyr)

cps <- cpsvote::read_cps() %>%
  select(-file)

usethis::use_data(cps, overwrite = TRUE)

devtools::document()
