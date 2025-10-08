devtools::load_all()

set.seed(20210827)
cps_2020_10k <- cps_read(years = 2020) %>%
  dplyr::sample_n(10000) %>%
  dplyr::arrange(YEAR, STATE)

usethis::use_data(cps_2020_10k, overwrite = TRUE)

devtools::document()
