# thank you jenny bryan
# https://github.com/mbannert/boar-2018/issues/1
# links manually collected via
# http://www.electproject.org/home/voter-turnout/voter-turnout-data

library(rvest)
library(googlesheets4)
library(dplyr)
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
sheets_deauth()

gid_1980to2014 <- "1or-N33CpOZYQ1UfZo0h8yGPSyz0Db-xjmZOXg3VJi-Q"
gid_2016 <- "1VAcF0eJ06y_8T4o2gvIL4YcyQy8pxb1zYkgXF76Uu1s"
gid_2018 <- "1tal3fAaKnEj_7Yy_7ftrNg4dJy4UxGk3oKSd3uPb13Y"

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

vep <- bind_rows(vep_1980to2014,
                 vep_2016,
                 vep_2018) %>%
  select(-state_abb) %>% # this one only shows up in 2 years
  # there are no 0 entries for ballots, so there should be no 0 entries for percents
  mutate(pct_ballots_vep = na_if(pct_ballots_vep, 0),
         state_name = stringr::str_remove_all(state_name, " \\(Excl. Louisiana\\)")) %>%
  arrange(year, state_name) %>%
  left_join(state_fips, by = c('state_name')) %>%
  mutate(state_name = factor(state_name) %>%
           forcats::fct_relevel("United States", after = 0))

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
  mutate(reweight = coalesce(vep_turnout / cps_turnout, 1))

usethis::use_data(cps_reweight, overwrite = TRUE)

devtools::document()
