devtools::load_all()

set.seed(20241105)
cps_2024_10k <- cps_read(years = 2024) %>%
  dplyr::sample_n(10000) %>%
  dplyr::arrange(YEAR, STATE)

usethis::use_data(cps_2024_10k, overwrite = TRUE)

devtools::document()
