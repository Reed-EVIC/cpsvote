library(here)
library(dplyr)
library(testthat)

# get fips to join state names
fips <- tigris::fips_codes %>%
  select(starts_with('state')) %>%
  distinct() %>%
  filter(state_code < 57) # only states plus DC

# run the yearly scripts
year_scripts <- list.files(here('tmp', 'year_scripts'), full.names = TRUE)
invisible(lapply(year_scripts, source))

# run the tests for the yearly datasets
test_file(here('tests', 'testthat', 'test-year_scripts.R'))

# bind everything together
# interesting note here that every single person with an NA education was not in universe for voting
# don't know what's up with that but I don't think it's a problem
# janitor::tabyl(cpsvrs, CPS_EDU, VRS_VOTE)
cpsvrs_bound <- mget(ls(pattern = "_factored$")) %>%
  bind_rows() %>%
  filter(VRS_VOTE != "NOT IN UNIVERSE") # people who are OOU for the vote Q are OOU for all VRS Qs, they also have zero weight

# list all of the unique options for factoring disparate response sets (change over time) for testing
cpsvrs <- cpsvrs_bound %>%
  mutate(RESIDENCE_COLLAPSE = forcats::fct_collapse(VRS_RESIDENCE,
                                                    "LESS THAN 1 YEAR" = c("LESS THAN 1 MONTH",
                                                                           "1-6 MONTHS",
                                                                           "7-11 MONTHS",
                                                                           "LESS THAN 1 YEAR"),
                                                    group_other = TRUE),
         RACE_COLLAPSE = forcats::fct_collapse(CPS_RACE,
                                               "WHITE" = c("WHITE",
                                                           "WHITE ONLY"),
                                               "BLACK" = c("BLACK",
                                                           "BLACK ONLY"),
                                               "ASIAN OR PACIFIC ISLANDER" = c("ASIAN OR PACIFIC ISLANDER",
                                                                               "HAWAIIAN/PACIFIC ISLANDER ONLY",
                                                                               "ASIAN ONLY"),
                                               "AMERICAN INDIAN OR ALASKA NATIVE" = c("AMERICAN INDIAN, ALEUT, ESKIMO",
                                                                                      "AMERICAN INDIAN, ALASKAN NATIVE ONLY"),
                                               "MULTIRACIAL OR OTHER" = c("OTHER",
                                                                          "WHITE-AI",
                                                                          "WHITE-ASIAN",
                                                                          "WHITE-BLACK",
                                                                          "W-B-AI",
                                                                          'BLACK-ASIAN',
                                                                          'BLACK-AI',
                                                                          'WHITE-HAWAIIAN',
                                                                          'ASIAN-HP',
                                                                          'W-A-HP',
                                                                          '2 OR 3 RACES',
                                                                          'AI-ASIAN',
                                                                          'W-AI-A',
                                                                          '4 OR 5 RACES',
                                                                          'BLACK-HP',
                                                                          'W-B-A',
                                                                          'W-B-AI-A'),
                                               group_other = TRUE),
         NOVOTE_COLLAPSE = forcats::fct_collapse(VRS_NOVOTEWHY,
                                                 "FORGOT TO VOTE" = c("FORGOT TO VOTE",
                                                                      "FORGOT TO VOTE (OR SEND IN ABSENTEE BALLOT)"),
                                                 "DIDN'T LIKE CANDIDATES OR CAMPAIGN ISSUES" = c("DID NOT PREFER ANY OF THE CANDIDATES",
                                                                                                 "DIDN'T LIKE CANDIDATES OR CAMPAIGN ISSUES"),
                                                 "NOT INTERESTED" = c("NOT INTERESTED, DON'T CARE, ETC.",
                                                                      "NOT INTERESTED, FELT MY VOTE WOULDN'T MAKE A DIFFERENCE"),
                                                 "SICK, DISABLED, OR FAMILY EMERGENCY" = c("SICK, DISABLED, OR FAMILY EMERGENCY",
                                                                                           "ILLNESS OR DISABILITY (OWN OR FAMILY'S)"),
                                                 "OUT OF TOWN OR AWAY FROM HOME" = c("OUT OF TOWN OR AWAY FROM HOME"),
                                                 "SCHEDULE PROBLEMS" = c("COULD NOT TAKE TIME OFF FROM WORK/SCHOOL/TOO BUSY",
                                                                         "TOO BUSY, CONFLICTING WORK OR SCHOOL SCHEDULE"),
                                                 "TRANSPORTATION PROBLEMS" = c("HAD NO WAY TO GET TO POLLS",
                                                                               "TRANSPORTATION PROBLEMS"),
                                                 "BAD WEATHER CONDITIONS" = c("BAD WEATHER CONDITIONS"),
                                                 "REGISTRATION PROBLEMS" = c("REGISTRATION PROBLEMS (I.E., DIDN'T RECEIVE ABSENTEE BALLOT, NOT REGISTERED IN CURRENT LOCATION)",
                                                                             "REGISTRATION PROBLEMS (I.E. DIDN'T RECEIVE ABSENTEE BALLOT, NOT REGISTERED IN CURRENT LOCATION)"),
                                                 "INCONVENIENT LOCATION/HOURS OR LONG LINES" = c("LINES TOO LONG AT POLLS",
                                                                                                 "INCONVENIENT POLLING PLACE OR HOURS OR LINES TOO LONG",
                                                                                                 "INCONVENIENT HOURS, POLLING PLACE OR HOURS OR LINES TOO LONG"),
                                                 "OTHER" = c("OTHER REASONS",
                                                             "OTHER"),
                                                 "DON'T KNOW" = c("DON'T KNOW"),
                                                 "REFUSED" = c("REFUSED"),
                                                 "NOT IN UNIVERSE" = c(),
                                                 "NO RESPONSE" = c("NO RESPONSE"),
                                                 group_other = TRUE),
         # combine DMV question with voter reg
         REGHOW_COLLAPSE = case_when(
           VRS_REGDMV == "WHEN DRIVER'S LICENSE WAS OBTAINED/RENEWED" ~ "AT A DEPARTMENT OF MOTOR VEHICLES (FOR EXAMPLE, WHEN OBTAINING A DRIVER'S LICENSE OR OTHER IDENTIFICATION CARD)",
           VRS_REGDMV == "DON'T KNOW" ~ "DON'T KNOW",
           TRUE ~ VRS_REGHOW
         ) %>%
           forcats::fct_collapse("REGISTRATION DRIVE" = c("FILLED OUT FORM AT A REGISTRATION DRIVE (FOR EXAMPLE, POLITICAL RALLY, SOMEONE CAME TO YOUR DOOR, REGISTRATION DRIVE AT MALL, MARKET, FAIR, POST OFFICE, LIBRARY, STORE, CHURCH, ETC.)",
                                                          "FILLED OUT FORM AT A REGISTRATION DRIVE (LIBRARY, POST OFFICE, OR SOMEONE CAME TO YOUR DOOR)"),
                                 "AT A SCHOOL, HOSPITAL, OR ON CAMPUS" = c("AT A SCHOOL, HOSPITAL, OR ON CAMPUS"),
                                 "REGISTRATION OFFICE" = c("WENT TO A COUNTY OR GOVERNMENT VOTER REGISTRATION OFFICE",
                                                           "WENT TO A TOWN HALL OR COUNTY/GOVERNMENT REGISTRATION OFFICE"),
                                 "BY MAIL" = c("MAILED IN FORM TO ELECTION OFFICE",
                                               "REGISTERED BY MAIL"),
                                 "PUBLIC ASSISTANCE AGENCY" = c("AT A PUBLIC ASSISTANCE AGENCY (FOR EXAMPLE, MEDICAID, AFDC, OR FOOD STAMPS OFFICE, AN OFFICE SERVING DISABLED PERSONS, OR AN UNEMPLOYMENT OFFICE)"),
                                 "AT DMV" = c("AT A DEPARTMENT OF MOTOR VEHICLES (FOR EXAMPLE, WHEN OBTAINING A DRIVER'S LICENSE OR OTHER IDENTIFICATION CARD)"),
                                 "AT THE POLLS, SAME DAY" = c("REGISTERED AT THE POLLS ON ELECTION DAY",
                                                              "REGISTERED AT POLLING PLACE (ON ELECTION OR PRIMARY DAY)"),
                                 "ONLINE" = c("REGISTERED USING THE INTERNET OR ONLINE"),
                                 "DON'T KNOW" = c("DON'T KNOW"),
                                 "OTHER" = c("OTHER PLACE/WAY",
                                             "OTHER"),
                                 "REFUSED" = c("REFUSED"),
                                 "NO RESPONSE" = c("NO RESPONSE"),
                                 group_other = FALSE),
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
