library(srvyr)
library(dplyr)
library(ggplot2)
devtools::load_all()

data(cps)
vep <- cpsvote::vep

states <- data.frame(name = c(state.name, "District of Columbia"),
                     abb = c(state.abb, "DC"))

cps_wgt <- as_survey_design(cps, weights = WEIGHT)

cps_side <- cps_wgt %>% 
  filter(VRS_VOTE %in% c("YES", "NO")) %>%
  mutate(VRS_VOTE = forcats::fct_drop(VRS_VOTE)) %>%
  group_by(CPS_YEAR, CPS_STATE, VRS_VOTE) %>%
  summarize(cps_prop = survey_mean()) %>%
  select(-ends_with("_se"))

vep_side <- vep %>%
  filter(year %in% unique(cps$CPS_YEAR),
         state_name != "United States") %>%
  mutate(state_name = forcats::fct_drop(state_name)) %>%
  select(year, state_name, pct_highestoffice_vep) %>%
  left_join(states, by = c("state_name" = "name")) %>%
  transmute(year,
            state = abb,
            YES = pct_highestoffice_vep,
            NO = 1 - YES) %>%
  tidyr::gather(key = "vote", value = "vep_prop", YES, NO)

weight_table <- full_join(cps_side, vep_side,
                         by = c("CPS_YEAR" = 'year',
                                "CPS_STATE" = 'state',
                                "VRS_VOTE" = "vote")) %>%
  mutate(weight_correction = vep_prop / cps_prop,
         CPS_STATE = factor(CPS_STATE,
                            levels = levels(cps$CPS_STATE)))

cps_edit <- left_join(cps, weight_table,
                      by = c("CPS_YEAR", "CPS_STATE", "VRS_VOTE")) %>%
  mutate(CPS_STATE = factor(CPS_STATE, levels = levels(cps$CPS_STATE)),
         VRS_VOTE = factor(VRS_VOTE, levels = levels(cps$VRS_VOTE)),
         WEIGHT_NEW = WEIGHT * weight_correction)


cps_wgt_edit <- cps_edit %>%
  filter(!is.na(WEIGHT_NEW)) %>%
  as_survey_design(weight = WEIGHT_NEW)

new_turnout <- cps_wgt_edit %>%
  filter(CPS_YEAR %in% c(2014, 2018)) %>%
  group_by(CPS_YEAR, CPS_STATE) %>%
  summarize(turnout = survey_mean(VRS_VOTE == "YES"))

new_turnout %>%
  ggplot(aes(x = forcats::fct_reorder(CPS_STATE, turnout, magrittr::extract, 2), y = turnout, col = factor(CPS_YEAR))) +
  geom_point() +
  ylim(0,1) +
  coord_flip()
# compare this to the VEP plot / numbers