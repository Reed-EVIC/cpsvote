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
invisible(lapply(year_scripts, source))

# run the tests for the yearly datasets
test_file(here('tests', 'testthat', 'test-year_scripts.R'))

# bind everything together
# interesting note here that every single person with an NA education was not in universe for voting
# don't know what's up with that but I don't think it's a problem
# janitor::tabyl(cpsvrs, CPS_EDU, VRS_VOTE)
cpsvrs_bound <- mget(ls(pattern = "_factored$")) %>%
  bind_rows() %>%
  filter(VRS_VOTE != "Not in Universe") # people who are OOU for the vote Q are OOU for all VRS Qs, they also have zero weight

unique_race <- c("White", "Black", "Asian or Pacific Islander", "American Indian, Aleut, Eskimo",
                 "White Only", "Black Only", "Asian Only", "Black-AI", "White-Black",
                 "White-Asian", "White-AI", "American Indian, Alaskan Native Only",
                 "Hawaiian/Pacific Islander Only", "W-AI-A", "White-HP", "2 or 3 Races",
                 "Asian-HP", "W-B-AI", "W-A-HP", "Black-HP", "AI-Asian", "Black-Asian",
                 "W-B-A", "W-B-AI-A", "4 or 5 Races", "AI-HP", "W-B-HP", "W-AI-HP",
                 "Other 4 and 5 Race Combinations", "Other 3 Race Combinations",
                 "W-AI-A-HP", "B-AI-A", "White-Hawaiian")
unique_residence <- c("Less than 1 month",
                      "1-6 months",
                      "7-11 months",
                      "Less than 1 year",
                      "1-2 years",
                      "3-4 years",
                      "5 years or longer",
                      "Not in Universe",
                      "Don't know",
                      "Refused",
                      "No Response")

cpsvrs <- cpsvrs_bound %>%
  mutate(VRS_RESIDENCE_COLLAPSE = factor(VRS_RESIDENCE,
                                levels = unique_residence,
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
         CPS_RACE_COLLAPSE = factor(CPS_RACE, levels = unique_race,
                           labels = c("White", "Black", "Asian or Pacific Islander", "American Indian or Alaskan Native",
                                      "White", "Black", "Asian or Pacific Islander", "Multiracial or Other", "Multiracial or Other",
                                      "Multiracial or Other", "Multiracial or Other", "American Indian or Alaskan Native",
                                      "Asian or Pacific Islander", "Multiracial or Other", "Multiracial or Other", "Multiracial or Other",
                                      "Multiracial or Other", "Multiracial or Other", "Multiracial or Other", "Multiracial or Other", "Multiracial or Other", "Multiracial or Other",
                                      "Multiracial or Other", "Multiracial or Other", "Multiracial or Other", "Multiracial or Other", "Multiracial or Other", "Multiracial or Other",
                                      "Multiracial or Other", "Multiracial or Other",
                                      "Multiracial or Other", "Multiracial or Other", "Multiracial or Other")),
         # combine DMV question with voter reg
         VRS_REGHOW_COLLAPSE = case_when(
           VRS_REGDMV == "When driver's license was obtained/renewed" ~ "At a department of motor vehicles (for example, when obtaining a driver's license or other identification card)",
           VRS_REGDMV == "Don't know" ~ "Don't know",
           TRUE ~ VRS_REGHOW
         ) %>%
           factor(levels = c("At a department of motor vehicles (for example, when obtaining a driver's license or other identification card)",
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
                             "No Response")),
         VRS_VOTEMETHOD_COLLAPSE = case_when(
           VRS_VOTEMETHOD == "In person on election day" ~ "Election day",
           VRS_VOTEMETHOD == "Voted by mail (absentee)" ~ "Mail",
           VRS_VOTEMETHOD == "In person before election day" ~ "Early",
           VRS_VBM == "By mail" ~ "Mail",
           VRS_VBM == "In person" & VRS_ELEXDAY == "Before election day" ~ "Early",
           VRS_VBM == "In person" & VRS_ELEXDAY == "On election day" ~ "Election day"
         )) %>%
  mutate_if(is.factor, forcats::fct_recode,
            NULL = "Not in Universe",
            NULL = "Refused",
            NULL = "No Response") %>% # this is people who didn't have any answer recorded
  na_if("Not in Universe") %>%
  na_if("Refused") %>%
  na_if("No Response") %>%
  filter_at(vars(starts_with('VRS_')), any_vars(!is.na(.))) %>% # drop anything with all NAs for the VRS questions
  select(CPS_YEAR,
         CPS_STATE,
         CPS_AGE,
         CPS_SEX,
         CPS_EDU,
         CPS_RACE,
         CPS_RACE_COLLAPSE,
         CPS_HISP,
         WEIGHT,
         VRS_VOTE,
         VRS_NOVOTEWHY,
         VRS_VOTEREG,
         VRS_NOREGWHY,
         VRS_REGHOW,
         VRS_REGDMV,
         VRS_REGHOW_COLLAPSE,
         VRS_REGSINCE95,
         VRS_VOTEMETHOD,
         VRS_VBM,
         VRS_ELEXDAY,
         VRS_VOTEMETHOD_COLLAPSE,
         VRS_RESIDENCE,
         VRS_RESIDENCE_COLLAPSE,
         everything())

test_file(here('tests', 'testthat', 'test-joined_data.R'))

# to check the race refactoring manually
# race_table <- janitor::tabyl(cpsvrs, CPS_RACE, CPS_RACE_COLLAPSE)
# View(race_table)

# to check the residence refactoring manually
# residence_table <- janitor::tabyl(cpsvrs, VRS_RESIDENCE, VRS_RESIDENCE_COLLAPSE)
# View(residence_table)
