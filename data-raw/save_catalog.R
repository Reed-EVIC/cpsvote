catalog <- readxl::read_excel(here::here('data-raw', 'CPS_catalog.xlsx'), sheet = 1)

years <- unique(catalog$year)

read_year_sheet <- function(year) {
  readxl::read_excel(here::here('data-raw', 'CPS_catalog.xlsx'), 
                     sheet = as.character(year), 
                     col_types = "text")
}

factoring <- dplyr::bind_rows(lapply(years, read_year_sheet))

fwf_key <- append(list(factoring), list(catalog), after = 0)
names(fwf_key) <- c("columns", "factoring")

usethis::use_data(fwf_key, internal = TRUE, overwrite = TRUE)

devtools::document()
