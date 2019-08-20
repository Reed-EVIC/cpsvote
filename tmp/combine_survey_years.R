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

# list all of the unique options for factoring disparate response sets (change over time) for testing
unique_race <- c("WHITE", "BLACK", "ASIAN OR PACIFIC ISLANDER", "AMERICAN INDIAN, ALEUT, ESKIMO", 
                 "WHITE ONLY", "BLACK ONLY", "ASIAN ONLY", "BLACK-AI", "WHITE-BLACK", 
                 "WHITE-ASIAN", "WHITE-AI", "AMERICAN INDIAN, ALASKAN NATIVE ONLY", 
                 "HAWAIIAN/PACIFIC ISLANDER ONLY", "W-AI-A", "WHITE-HP", "2 OR 3 RACES", 
                 "ASIAN-HP", "W-B-AI", "W-A-HP", "BLACK-HP", "AI-ASIAN", "BLACK-ASIAN", 
                 "W-B-A", "W-B-AI-A", "4 OR 5 RACES", "AI-HP", "W-B-HP", "W-AI-HP", 
                 "OTHER 4 AND 5 RACE COMBINATIONS", "OTHER 3 RACE COMBINATIONS", 
                 "W-AI-A-HP", "B-AI-A", "WHITE-HAWAIIAN")
unique_residence <- c("LESS THAN 1 MONTH", "1-6 MONTHS", "7-11 MONTHS", "LESS THAN 1 YEAR", 
                      "1-2 YEARS", "3-4 YEARS", "5 YEARS OR LONGER", "NOT IN UNIVERSE", 
                      "DON'T KNOW", "REFUSED", "NO RESPONSE")
unique_novote <- c("NOT IN UNIVERSE", "FORGOT TO VOTE", "DID NOT PREFER ANY OF THE CANDIDATES", 
                   "NOT INTERESTED, DON'T CARE, ETC.", "OTHER REASONS", "DON'T KNOW", 
                   "SICK, DISABLED, OR FAMILY EMERGENCY", "COULD NOT TAKE TIME OFF FROM WORK/SCHOOL/TOO BUSY", 
                   "HAD NO WAY TO GET TO POLLS", "OUT OF TOWN OR AWAY FROM HOME", 
                   "LINES TOO LONG AT POLLS", "REFUSED", "NO RESPONSE", "FORGOT TO VOTE (OR SEND IN ABSENTEE BALLOT)", 
                   "TOO BUSY, CONFLICTING WORK OR SCHOOL SCHEDULE", "OTHER", "ILLNESS OR DISABILITY (OWN OR FAMILY'S)", 
                   "NOT INTERESTED, FELT MY VOTE WOULDN'T MAKE A DIFFERENCE", "TRANSPORTATION PROBLEMS", 
                   "BAD WEATHER CONDITIONS", "REGISTRATION PROBLEMS (I.E. DIDN'T RECEIVE ABSENTEE BALLOT, NOT REGISTERED IN CURRENT LOCATION)", 
                   "DIDN'T LIKE CANDIDATES OR CAMPAIGN ISSUES", "INCONVENIENT HOURS, POLLING PLACE OR HOURS OR LINES TOO LONG"
)

unique_reghow <- c("NOT IN UNIVERSE", "FILLED OUT FORM AT A REGISTRATION DRIVE (FOR EXAMPLE, POLITICAL RALLY, SOMEONE CAME TO YOUR DOOR, REGISTRATION DRIVE AT MALL, MARKET, FAIR, POST OFFICE, LIBRARY, STORE, CHURCH, ETC.)", 
                   "DON'T KNOW", "AT A SCHOOL, HOSPITAL, OR ON CAMPUS", "WENT TO A COUNTY OR GOVERNMENT VOTER REGISTRATION OFFICE", 
                   "MAILED IN FORM TO ELECTION OFFICE", "AT A PUBLIC ASSISTANCE AGENCY (FOR EXAMPLE, A MEDICAID, AFDC, OR FOOD STAMPS OFFICE, AN OFFICE SERVING DISABLED PERSONS, OR AN UNEMPLOYMENT OFFICE)", 
                   "REGISTERED AT THE POLLS ON ELECTION DAY", "OTHER PLACE/WAY", 
                   "REFUSED", "NO RESPONSE", "WENT TO A TOWN HALL OR COUNTY/GOVERNMENT REGISTRATION OFFICE", 
                   "FILLED OUT FORM AT A REGISTRATION DRIVE (LIBRARY, POST OFFICE, OR SOMEONE CAME TO YOUR DOOR)", 
                   "REGISTERED BY MAIL", "REGISTERED AT POLLING PLACE (ON ELECTION OR PRIMARY DAY)", 
                   "OTHER", "AT A DEPARTMENT OF MOTOR VEHICLES (FOR EXAMPLE, WHEN OBTAINING A DRIVER'S LICENSE OR OTHER IDENTIFICATION CARD)", 
                   "REGISTERED USING THE INTERNET OR ONLINE")


cpsvrs <- cpsvrs_bound %>%
  mutate(RESIDENCE_COLLAPSE = factor(VRS_RESIDENCE,
                                levels = unique_residence,
                                labels = c("LESS THAN 1 YEAR", "LESS THAN 1 YEAR", "LESS THAN 1 YEAR", 
                                           "LESS THAN 1 YEAR", "1-2 YEARS", "3-4 YEARS", "5 YEARS OR LONGER", 
                                           "NOT IN UNIVERSE", "DON'T KNOW", "REFUSED", "NO RESPONSE"),
                                ordered = TRUE), # collapse the sub-1yr categories together
         RACE_COLLAPSE = factor(CPS_RACE, levels = unique_race,
                           labels = c("WHITE", "BLACK", "ASIAN OR PACIFIC ISLANDER", "AMERICAN INDIAN OR ALASKAN NATIVE", 
                                      "WHITE", "BLACK", "ASIAN OR PACIFIC ISLANDER", "MULTIRACIAL OR OTHER", 
                                      "MULTIRACIAL OR OTHER", "MULTIRACIAL OR OTHER", "MULTIRACIAL OR OTHER", 
                                      "AMERICAN INDIAN OR ALASKAN NATIVE", "ASIAN OR PACIFIC ISLANDER", 
                                      "MULTIRACIAL OR OTHER", "MULTIRACIAL OR OTHER", "MULTIRACIAL OR OTHER", 
                                      "MULTIRACIAL OR OTHER", "MULTIRACIAL OR OTHER", "MULTIRACIAL OR OTHER", 
                                      "MULTIRACIAL OR OTHER", "MULTIRACIAL OR OTHER", "MULTIRACIAL OR OTHER", 
                                      "MULTIRACIAL OR OTHER", "MULTIRACIAL OR OTHER", "MULTIRACIAL OR OTHER", 
                                      "MULTIRACIAL OR OTHER", "MULTIRACIAL OR OTHER", "MULTIRACIAL OR OTHER", 
                                      "MULTIRACIAL OR OTHER", "MULTIRACIAL OR OTHER", "MULTIRACIAL OR OTHER", 
                                      "MULTIRACIAL OR OTHER", "MULTIRACIAL OR OTHER")),
         NOVOTE_COLLAPSE = factor(VRS_NOVOTEWHY, levels = unique_novote,
                                  labels = c("NOT IN UNIVERSE", "FORGOT TO VOTE", "DIDN'T LIKE CANDIDATES OR CAMPAIGN ISSUES", 
                                             "NOT INTERESTED", "OTHER", "DON'T KNOW", "SICK, DISABLED, OR FAMILY EMERGENCY", 
                                             "SCHEDULE PROBLEMS", "TRANSPORTATION PROBLEMS", "OUT OF TOWN OR AWAY FROM HOME", 
                                             "INCONVENIENT HOURS OR LONG LINES", "REFUSED", "NO RESPONSE", 
                                             "FORGOT TO VOTE", "SCHEDULE PROBLEMS", "OTHER", "SICK, DISABLED, OR FAMILY EMERGENCY", 
                                             "NOT INTERESTED", "TRANSPORTATION PROBLEMS", "BAD WEATHER CONDITIONS", 
                                             "REGISTRATION PROBLEMS", "DIDN'T LIKE CANDIDATES OR CAMPAIGN ISSUES", 
                                             "INCONVENIENT HOURS OR LONG LINES")),
         # combine DMV question with voter reg
         REGHOW_COLLAPSE = case_when(
           VRS_REGDMV == "WHEN DRIVER'S LICENSE WAS OBTAINED/RENEWED" ~ "AT A DEPARTMENT OF MOTOR VEHICLES (FOR EXAMPLE, WHEN OBTAINING A DRIVER'S LICENSE OR OTHER IDENTIFICATION CARD)",
           VRS_REGDMV == "DON'T KNOW" ~ "DON'T KNOW",
           TRUE ~ VRS_REGHOW
         ) %>%
           factor(levels = unique_reghow,
                  labels = c("NOT IN UNIVERSE", "REGISTRATION DRIVE", "DON'T KNOW", "AT A SCHOOL, HOSPITAL, OR ON CAMPUS", 
                             "REGISTRATION OFFICE", "BY MAIL", "PUBLIC ASSISTANCE AGENCY", 
                             "AT THE POLLS, SAME DAY", "OTHER", "REFUSED", "NO RESPONSE", 
                             "REGISTRATION OFFICE", "REGISTRATION DRIVE", "BY MAIL", "AT THE POLLS, SAME DAY", 
                             "OTHER", "AT DMV", "ONLINE")),
         VOTEMETHOD_COLLAPSE = case_when(
           VRS_VOTEMETHOD == "IN PERSON ON ELECTION DAY" ~ "ELECTION DAY",
           VRS_VOTEMETHOD == "VOTED BY MAIL (ABSENTEE)" ~ "MAIL",
           VRS_VOTEMETHOD == "IN PERSON BEFORE ELECTION DAY" ~ "EARLY",
           VRS_VBM == "BY MAIL" ~ "MAIL",
           VRS_VBM == "IN PERSON" & VRS_ELEXDAY == "BEFORE ELECTION DAY" ~ "EARLY",
           VRS_VBM == "IN PERSON" & VRS_ELEXDAY == "ON ELECTION DAY" ~ "ELECTION DAY"
         )) %>%
  mutate_if(is.factor, forcats::fct_recode,
            NULL = "NOT IN UNIVERSE",
            NULL = "REFUSED",
            NULL = "NO RESPONSE") %>% # this is people who didn't have any answer recorded
  na_if("NOT IN UNIVERSE") %>%
  na_if("REFUSED") %>%
  na_if("NO RESPONSE") %>%
  filter_at(vars(starts_with('VRS_')), any_vars(!is.na(.))) %>% # drop anything with all NAs for the VRS questions
  select(CPS_YEAR,
         CPS_STATE,
         CPS_AGE,
         CPS_SEX,
         CPS_EDU,
         CPS_RACE,
         RACE_COLLAPSE,
         CPS_HISP,
         WEIGHT,
         VRS_VOTE,
         VRS_NOVOTEWHY,
         NOVOTE_COLLAPSE,
         VRS_VOTEREG,
         VRS_NOREGWHY,
         VRS_REGHOW,
         REGHOW_COLLAPSE,
         VRS_REGDMV,
         VRS_REGSINCE95,
         VRS_VOTETIME,
         VRS_VOTEMETHOD,
         VRS_VBM,
         VRS_ELEXDAY,
         VOTEMETHOD_COLLAPSE,
         VRS_RESIDENCE,
         RESIDENCE_COLLAPSE,
         everything())

test_file(here('tests', 'testthat', 'test-joined_data.R'))

# to check the race refactoring manually
# race_table <- janitor::tabyl(cpsvrs, CPS_RACE, RACE_COLLAPSE)
# View(race_table)

# to check the residence refactoring manually
# residence_table <- janitor::tabyl(cpsvrs, VRS_RESIDENCE, RESIDENCE_COLLAPSE)
# View(residence_table)

save(cpsvrs, file = 'tmp/cpsvrs.RData')
