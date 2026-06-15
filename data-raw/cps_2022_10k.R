devtools::load_all()

set.seed(20221108)
cps_2022_10k <- cps_read(years = 2022) %>%
  dplyr::sample_n(10000) %>%
  dplyr::arrange(YEAR, STATE)

usethis::use_data(cps_2022_10k, overwrite = TRUE)

devtools::document()
