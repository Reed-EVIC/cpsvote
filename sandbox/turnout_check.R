devtools::load_all()

cps <- cps_load_basic() %>%
  as_survey_design(weights = turnout_weight)

turnout <- cps %>% 
  group_by(YEAR, STATE) %>%
  summarize(turnout = survey_mean(hurachen_turnout == "YES", na.rm = TRUE))
  