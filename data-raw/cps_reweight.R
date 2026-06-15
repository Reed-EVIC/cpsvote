# thank you jenny bryan
# https://github.com/mbannert/boar-2018/issues/1
# links manually collected via
# http://www.electproject.org/home/voter-turnout/voter-turnout-data
# NOTE: as of 2024, McDonald's VEP data moved from electproject.org to
# UF Election Lab (https://election.lab.ufl.edu/voter-turnout/)
# 2024+ data is a direct CSV download, not a Google Sheet

library(rvest)
library(googlesheets4)
library(dplyr)
library(readr)
library(srvyr)
devtools::load_all()

# state fips to make sure they can join #####

state_fips <- maps::state.fips %>%
  select(fips, state_abb = abb, state_name = polyname) %>%
  mutate(state_name = tools::toTitleCase(stringr::str_remove(state_name, "\\:.*$"))) %>%
  bind_rows(data.frame(
    fips = c(2,15,  NA),
    state_abb = c("AK", "HI", "US"),
    state_name = c("Alaska", "Hawaii", "United States"),
    stringsAsFactors = FALSE
  )) %>%
  arrange(fips) %>%
  distinct()

# get the VEP #####

# don't try to authenticate me, these are public sheets
# drive_deauth()
gs4_deauth()

gid_1980to2014 <- "1or-N33CpOZYQ1UfZo0h8yGPSyz0Db-xjmZOXg3VJi-Q"
gid_2016 <- "1VAcF0eJ06y_8T4o2gvIL4YcyQy8pxb1zYkgXF76Uu1s"
gid_2018 <- "1tal3fAaKnEj_7Yy_7ftrNg4dJy4UxGk3oKSd3uPb13Y"
gid_2020 <- "1h_2pR1pq8s_I5buZ5agXS9q1vLziECztN2uWeR6Czo0"
gid_2022 <- "17iSZIBPP6jj0C2wcqpym9wNuNCtTiqM_tMweMjmvces"
# NOTE: 2024 and later years use UF Election Lab CSV instead of Google Sheets — see below

vep_1980to2014 <- read_sheet(gid_1980to2014, range = "A3:Q",
                             col_names = c('year',
                                           'icpsr_state',
                                           'alpha_state',
                                           'state_name',
                                           'pct_ballots_vep',
                                           'pct_highestoffice_vep',
                                           'pct_highestoffice_vap',
                                           'ballots',
                                           'highestoffice',
                                           'vep',
                                           'vap',
                                           'pct_noncitizen',
                                           'prison',
                                           'probation',
                                           'parole',
                                           'total_ineligible_felon',
                                           'overseas_eligible'))
vep_2016 <- read_sheet(gid_2016, range = "A3:Q54",
                       col_names = c('state_name',
                                     'results_source',
                                     'status',
                                     'pct_ballots_vep',
                                     'pct_highestoffice_vep',
                                     'pct_highestoffice_vap',
                                     'ballots',
                                     'highestoffice',
                                     'vep',
                                     'vap',
                                     'pct_noncitizen',
                                     'prison',
                                     'probation',
                                     'parole',
                                     'total_ineligible_felon',
                                     'overseas_eligible',
                                     'state_abb')) %>%
  mutate(year = 2016)
vep_2018 <- read_sheet(gid_2018, range = "A3:P54",
                       col_names = c('state_name',
                                     'pct_ballots_vep',
                                     'pct_highestoffice_vep',
                                     'status',
                                     'results_source',
                                     'ballots',
                                     'highestoffice',
                                     'vep',
                                     'vap',
                                     'pct_noncitizen',
                                     'prison',
                                     'probation',
                                     'parole',
                                     'total_ineligible_felon',
                                     'overseas_eligible',
                                     'state_abb')) %>%
  mutate(year = 2018)
vep_2020 <- read_sheet(gid_2020, range = "A3:P54",
                       col_names = c('state_name',
                                     'results_source',
                                     'status',
                                     'ballots',
                                     'highestoffice',
                                     'pct_ballots_vep',
                                     'pct_highestoffice_vep',
                                     'vep',
                                     'vap',
                                     'pct_noncitizen',
                                     'prison',
                                     'probation',
                                     'parole',
                                     'total_ineligible_felon',
                                     'overseas_eligible',
                                     'state_abb')) %>%
  mutate(year = 2020)
vep_2022 <- read_sheet(gid_2022, range = "A3:N54",
                       col_names = c('state_name',
                                     'highestoffice',
                                     'status',
                                     'results_source',
                                     'pct_highestoffice_vep',
                                     'vep',
                                     'vap',
                                     'pct_noncitizen',
                                     'prison',
                                     'probation',
                                     'parole',
                                     'total_ineligible_felon',
                                     'overseas_eligible',
                                     'state_abb')) %>%
  mutate(year = 2022)

# 2024: data now from UF Election Lab CSV (not Google Sheets)
# URL may need updating if a newer version (v0.5 etc.) is released
url_2024 <- "https://election.lab.ufl.edu/data-downloads/turnoutdata/Turnout_2024G_v0.4.csv"
vep_2024 <- read_csv(url_2024, show_col_types = FALSE) %>%
  transmute(state_name = STATE,
            state_abb = STATE_ABV,
            pct_highestoffice_vep = parse_number(as.character(VEP_TURNOUT_RATE)) / 100,
            vep = parse_number(as.character(VEP)),
            vap = parse_number(as.character(VAP)),
            pct_noncitizen = parse_number(as.character(NONCITIZEN_PCT)) / 100,
            prison = parse_number(as.character(INELIGIBLE_PRISON)),
            probation = parse_number(as.character(INELIGIBLE_PROBATION)),
            parole = parse_number(as.character(INELIGIBLE_PAROLE)),
            total_ineligible_felon = parse_number(as.character(INELIGIBLE_FELONS_TOTAL)),
            overseas_eligible = parse_number(as.character(ELIGIBLE_OVERSEAS)),
            year = 2024)

vep <- bind_rows(vep_1980to2014,
                 vep_2016,
                 vep_2018,
                 vep_2020,
                 vep_2022,
                 vep_2024) %>%
  select(-state_abb) %>% # this one only shows up in 2 years
  # there are no 0 entries for ballots, so there should be no 0 entries for percents
  mutate(pct_ballots_vep = na_if(pct_ballots_vep, 0),
         state_name = stringr::str_remove_all(state_name, " \\(Excl. Louisiana\\)") %>%
           stringr::str_remove_all("\\*$")) %>%
  arrange(year, state_name) %>%
  left_join(state_fips, by = c('state_name')) %>%
  mutate(state_name = forcats::fct_relevel(state_name, "United States", after = 0))

vep_turnout <- vep %>%
  transmute(YEAR = year, STATE = state_abb, 
            YES = pct_highestoffice_vep, NO = 1 - YES) %>%
  filter(STATE != "US",
         YEAR >= 1994) %>%
  tidyr::pivot_longer(c("YES", "NO"), 
                      names_to = "response",
                      values_to = "vep_turnout") %>%
  mutate(response = factor(response, levels = unique(.$response)),
         STATE = factor(STATE, levels = unique(.$STATE)))
# this does NOT match the Iowa 2008 number in Hur/Achen, but it DOES match McDonald's site

# and now get the corresponding CPS amounts... #####

cps <- cps_load_basic() %>%
  as_survey_design(weights = WEIGHT)

cps_turnout <- cps %>%
  filter(!is.na(hurachen_turnout)) %>%
  group_by(YEAR, STATE, hurachen_turnout) %>%
  summarize(cps_turnout = survey_mean(na.rm = TRUE)) %>%
  ungroup() %>%
  select(YEAR, STATE,
         response = hurachen_turnout,
         cps_turnout)

# stick them together, get coefficients, and save #####

cps_reweight <- full_join(vep_turnout, cps_turnout,
                      by = c("YEAR", "STATE", "response")) %>%
  mutate(reweight = vep_turnout / cps_turnout)

usethis::use_data(cps_reweight, overwrite = TRUE)

devtools::document()
