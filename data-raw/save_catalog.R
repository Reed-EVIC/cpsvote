catalog <- readxl::read_excel(here::here('data-raw', 'catalog.xlsx'), sheet = 1)

years <- unique(catalog$year)

read_year_sheet <- function(year) {
  readxl::read_excel(here('docs', 'catalog.xlsx'), sheet = as.character(year))
}

factoring <- lapply(years, read_year_sheet)

fwf_key <- append(factoring, list(catalog), after = 0)
names(fwf_key) <- c("catalog", years)

usethis::use_data(fwf_key, internal = TRUE)
