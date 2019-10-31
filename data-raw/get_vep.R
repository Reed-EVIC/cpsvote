# thank you jenny bryan
# https://github.com/mbannert/boar-2018/issues/1
# links manually collected via
# http://www.electproject.org/home/voter-turnout/voter-turnout-data

library(rvest)
library(googlesheets4)
library(dplyr)



# don't try to authenticate me, these are public sheets
drive_deauth()
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
  # there are no 0 entries for ballots, so there should be no 0 entries for percents
  mutate(pct_ballots_vep = na_if(pct_ballots_vep, 0),
         state_name = stringr::str_remove_all(state_name, " \\(Excl. Louisiana\\)")) %>%
  arrange(year, state_name) %>%
  mutate(state_name = factor(state_name) %>%
           forcats::fct_relevel("United States", after = 0))

usethis::use_data(vep, internal = TRUE, overwrite = TRUE)

devtools::document()

# vep %>%
#   filter(state_name == "United States") %>%
#   mutate(cycle = case_when(
#     year %% 4 == 0 ~ "Presidential",
#     year %% 4 == 2 ~ "Midterm"
#   )) %>%
#   ggplot(aes(x = year, y = pct_highestoffice_vep, col = cycle)) +
#   geom_point() +
#   geom_line(aes(group = cycle))
# 
# vep %>%
#   filter(year %in% c(2014, 2018)) %>%
#   mutate(pct_highestoffice_vap = highestoffice / vap) %>%
#   ggplot(aes(x = forcats::fct_reorder(state_name, pct_highestoffice_vap, magrittr::extract, 2), y = pct_highestoffice_vap, col = factor(year))) +
#   geom_point() +
#   ylim(0,1) +
#   coord_flip()
# 
# vep %>%
#   filter(state_name %in% c("United States", "Colorado", "Oregon", "Washington")) %>%
#   mutate(cycle = case_when(
#     year %% 4 == 0 ~ "Presidential",
#     year %% 4 == 2 ~ "Midterm"
#     )) %>%
#   group_by(year) %>%
#   mutate(turnout_diff = pct_highestoffice_vep - min(pct_highestoffice_vep)) %>%
#   ungroup() %>%
#   filter(state_name != "United States") %>%
#   ggplot(aes(x = year, y = turnout_diff, col = state_name)) +
#   geom_line(aes(group = state_name)) +
#   geom_vline(aes(xintercept = 1999, col = "Oregon")) +
#   geom_vline(aes(xintercept = 2011, col = "Washington")) +
#   geom_vline(aes(xintercept = 2013, col = "Colorado"))

