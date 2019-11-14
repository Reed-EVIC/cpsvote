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

reweight <- full_join(cps_side, vep_side,
                       by = c("CPS_YEAR" = 'year',
                              "CPS_STATE" = 'state',
                              "VRS_VOTE" = "vote")) %>%
  mutate(REWEIGHT = vep_prop / cps_prop,
         CPS_STATE = factor(CPS_STATE, levels = levels(cps$CPS_STATE),
                            ordered = TRUE),
         VRS_VOTE = factor(VRS_VOTE, levels = levels(cps$VRS_VOTE)))


usethis::use_data(reweight, overwrite = TRUE)

devtools::document()
