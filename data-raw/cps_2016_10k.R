devtools::load_all()

set.seed(20201026)
cps_2016_10k <- cps_read(years = 2016) %>%
  dplyr::sample_n(10000) %>%
  dplyr::arrange(YEAR, STATE)

usethis::use_data(cps_2016_10k, overwrite = TRUE)

devtools::document()
