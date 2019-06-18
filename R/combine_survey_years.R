library(here)
library(dplyr)
library(testthat)

# get fips to join state names
fips <- tigris::fips_codes %>%
  select(starts_with('state')) %>%
  distinct() %>%
  filter(state_code < 57) # only states plus DC

# run the yearly scripts
year_scripts <- list.files(here('R', 'year_scripts'), full.names = TRUE)
lapply(year_scripts, source)

# run the tests for the yearly datasets
test_file(here('tests', 'testthat', 'test-year_scripts.R'))

# bind everything together
# interesting note here that every single person with an NA education was not in universe for voting
# don't know what's up with that but I don't think it's a problem
# janitor::tabyl(cpsvrs, CPS_EDU, VRS_VOTE)
cpsvrs <- mget(ls(pattern = "_factored$")) %>%
  bind_rows() %>%
  filter(VRS_VOTE != "Not in Universe") %>% # people who are OOU for the vote Q are OOU for all VRS Qs, they also have zero weight
  mutate(VRS_RESIDENCE_COLLAPSE = factor(VRS_RESIDENCE,
                                levels = c("Less than 1 month",
                                           "1-6 months",
                                           "7-11 months",
                                           "Less than 1 year",
                                           "1-2 years",
                                           "3-4 years",
                                           "5 years or longer",
                                           "Not in Universe",
                                           "Don't know",
                                           "Refused",
                                           "No Response"),
                                labels = c("Less than 1 year",
                                           "Less than 1 year",
                                           "Less than 1 year",
                                           "Less than 1 year",
                                           "1-2 years",
                                           "3-4 years",
                                           "5 years or longer",
                                           "Not in Universe",
                                           "Don't know",
                                           "Refused",
                                           "No Response"),
                                ordered = TRUE), # collapse the sub-1yr categories together
         CPS_RACE_COLLAPSE = factor(CPS_RACE, levels = c("White Only", "Black Only", "Asian Only", "Black-AI", "White-Black",
                                                         "White-Asian", "White-AI", "American Indian, Alaskan Native Only",
                                                         "Hawaiian/Pacific Islander Only", "W-AI-A", "White-HP", "2 or 3 Races",
                                                         "Asian-HP", "W-B-AI", "W-A-HP", "Black-HP", "AI-Asian", "Black-Asian",
                                                         "W-B-A", "W-B-AI-A", "4 or 5 Races", "AI-HP", "W-B-HP", "W-AI-HP",
                                                         "Other 4 and 5 Race Combinations", "Other 3 Race Combinations",
                                                         "W-AI-A-HP", "B-AI-A", "White-Hawaiian"),
                           labels = c("White", "Black", "Asian", "Multiracial", "Multiracial",
                                      "Multiracial", "Multiracial", "American Indian, Alaskan Native",
                                      "Hawaiian/Pacific Islander", "Multiracial", "Multiracial", "Multiracial",
                                      "Multiracial", "Multiracial", "Multiracial", "Multiracial", "Multiracial", "Multiracial",
                                      "Multiracial", "Multiracial", "Multiracial", "Multiracial", "Multiracial", "Multiracial",
                                      "Multiracial", "Multiracial",
                                      "Multiracial", "Multiracial", "Multiracial")),
         VRS_REGHOW = factor(VRS_REGHOW, levels = c("At a department of motor vehicles (for example, when obtaining a driver's license or other identification card)",
                                                    "At a public assistance agency (for example, a Medicaid, AFDC, or Food Stamps office, an office serving disabled persons, or an unemployment office)",
                                                    "Registered by mail",
                                                    "Registered using the internet or online",
                                                    "At a school, hospital, or on campus",
                                                    "Went to a town hall or county/government registration office",
                                                    "Filled out form at a registration drive (library, post office, or someone came to your door)",
                                                    "Registered at polling place (on election or primary day)",
                                                    "Other",
                                                    "Not in Universe",
                                                    "Don't know",
                                                    "Refused",
                                                    "No Response"),
                             labels = c("At a department of motor vehicles (for example, when obtaining a driver's license or other identification card)",
                                        "At a public assistance agency (for example, a Medicaid, AFDC, or Food Stamps office, an office serving disabled persons, or an unemployment office)",
                                        "Registered by mail",
                                        "Registered using the internet or online",
                                        "At a school, hospital, or on campus",
                                        "Went to a town hall or county/government registration office",
                                        "Filled out form at a registration drive (library, post office, or someone came to your door)",
                                        "Registered at polling place (on election or primary day)",
                                        "Other",
                                        "Not in Universe",
                                        "Don't know",
                                        "Refused",
                                        "No Response"))) %>%
  mutate_if(is.factor, forcats::fct_recode,
            NULL = "Not in Universe",
            NULL = "Refused",
            NULL = "No Response") %>% # this is people who didn't have any answer recorded
  na_if("Not in Universe") %>%
  na_if("Refused") %>%
  na_if("No Response") %>%
  filter_at(vars(starts_with('VRS_')), any_vars(!is.na(.))) # drop anything with all NAs for the VRS questions

test_file(here('tests', 'testthat', 'test-joined_data.R'))
