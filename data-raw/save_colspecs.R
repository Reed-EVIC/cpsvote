cps_cols <- read.csv(here::here('data-raw', 'cps_cols.csv'),
                     na.strings = c("NA", ""))

cps_factors <- read.csv(here::here('data-raw', 'cps_factors.csv'),
                        na.strings = c("NA", ""))

usethis::use_data(cps_cols, overwrite = TRUE)

usethis::use_data(cps_factors, overwrite = TRUE)

devtools::document()
