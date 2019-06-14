library(here)
library(dplyr)
library(ggplot2)
library(ggtern)

source(here('tmp', 'vrs_test.R'))

threevote <- mutate(cpsvrs,
                    vote_method = case_when(
                      VRS_VBM == "By mail" ~ "Mail",
                      VRS_VBM == "In person" & VRS_ELEXDAY == "Before election day" ~ "Early",
                      VRS_VBM == "In person" & VRS_ELEXDAY == "On election day" ~ "Election day"
                    )) %>%
  count(YEAR, STATE, vote_method) %>%
  filter(!is.na(vote_method)) %>%
  group_by(YEAR, STATE) %>%
  mutate(prop = n / sum(n)) %>%
  select(-n) %>%
  tidyr::spread(key = vote_method, value = prop)

ggplot() + coord_tern() +
  geom_text(data = threevote, aes(y = `Election day`, x = Mail, z = Early, label = STATE)) +
  facet_wrap(~YEAR)
