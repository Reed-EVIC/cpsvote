devtools::load_all()

set.seed(20200318)
cps_sample_10k <- cps_load_basic() %>%
  dplyr::sample_n(10000) %>%
  dplyr::arrange(YEAR, STATE)

usethis::use_data(cps_sample_10k, overwrite = TRUE)

devtools::document()