devtools::load_all()

set.seed(20200318)
cps_allyears_100k <- cps_load_basic() %>%
  dplyr::sample_n(100000) %>%
  dplyr::arrange(YEAR, STATE)

usethis::use_data(cps_allyears_100k, overwrite = TRUE)

devtools::document()
