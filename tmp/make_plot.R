library(here)
library(dplyr)
library(srvyr)
library(ggplot2)
library(ggtern)
library(gganimate)

source(here('R', 'combine_survey_years.R'))

cpsvrs_weighted <- as_survey_design(cpsvrs, weights = WEIGHT)

threevote <- cpsvrs_weighted %>%
  mutate(CPS_YEAR = factor(CPS_YEAR, ordered = TRUE)) %>%
  mutate(vote_method = case_when(
    VRS_VBM == "By mail" ~ "Mail",
    VRS_VBM == "In person" & VRS_ELEXDAY == "Before election day" ~ "Early",
    VRS_VBM == "In person" & VRS_ELEXDAY == "On election day" ~ "Election day"
    )) %>%
  filter(!is.na(vote_method)) %>%
  group_by(CPS_YEAR, CPS_STATE) %>%
  summarize(`Election day` = survey_mean(vote_method == 'Election day'),
            Mail = survey_mean(vote_method == 'Mail'),
            Early = survey_mean(vote_method == 'Early')) %>%
  select(-ends_with('_se')) %>%
  mutate(check = `Election day` + Mail + Early)

ggplot() + coord_tern() +
  geom_text(data = threevote, aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) +
  facet_wrap(~CPS_YEAR)

# ggplot() + coord_tern() +
#   geom_text(data = threevote, aes(y = `Election day`, x = Mail, z = Early, label = CPS_STATE)) +
#   transition_states(
#     CPS_YEAR,
#     transition_length = 3,
#     state_length = 2
#   )

