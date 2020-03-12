full_fips <- maps::state.fips %>%
  dplyr::mutate(name = tools::toTitleCase(stringr::str_remove(polyname, "\\:.*$"))) %>%
  dplyr::distinct(fips, abb, name) %>%
  dplyr::bind_rows(data.frame(fips = c(2,15),
                              abb = c("AK", "HI"),
                              name = c("Alaska", "Hawaii"),
                              stringsAsFactors = FALSE)) %>%
  dplyr::arrange(fips)

usethis::use_data(full_fips, overwrite = TRUE, internal = TRUE)

devtools::document()
