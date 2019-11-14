library(here)
source(here('sandbox', 'cps_reweight.R'))
library(stringr)

cohort_turnout <- cps_edit %>%
  filter(CPS_YEAR %% 4 == 0,
         VRS_VOTE != "DON'T KNOW") %>%
  mutate(birth_yr = CPS_YEAR - CPS_AGE,
         cohort = cut(birth_yr, 
                      breaks = seq(1902, 1998, 4), 
                      include.lowest = TRUE),
         cohort = str_remove_all(cohort, "\\(|\\]|\\[")) %>%
  tidyr::separate(cohort, into = c("c1", "c2")) %>%
  mutate(c1 = as.numeric(c1) + 1,
         c2 = as.numeric(c2),
         cohort = paste(c1, c2, sep = "-")) %>%
  as_survey_design(weight = WEIGHT_NEW) %>%
  group_by(CPS_YEAR, cohort) %>%
  summarize(turnout = survey_mean(VRS_VOTE == "YES"))

ggplot(cohort_turnout, aes(x = CPS_YEAR, y = turnout, col = cohort, group = cohort)) +
  geom_line()
