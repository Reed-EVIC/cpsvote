library(here)
library(dplyr)

# get fips to join state names
fips <- tigris::fips_codes %>%
  select(starts_with('state')) %>%
  distinct() %>%
  filter(state_code < 57) # only states plus DC

year_scripts <- list.files(here('R', 'year_scripts'), full.names = TRUE)
lapply(year_scripts, source)

test_file(here('tests', 'testthat', 'test-year_scripts.R'))
