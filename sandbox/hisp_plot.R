cps_basic <- cps_load_basic(datadir = here::here('cps_data')) 
cps_basic_W <- as_survey_design(cps_basic, weights = turnout_weight)

age_data <- cps_basic_W %>%
  filter(!is.na(HISPANIC) & !is.na(AGE) & YEAR %in% c(2016, 2018)) %>%
  mutate(AGE = factor(AGE)) %>%
  group_by(HISPANIC, AGE) %>%
  summarize(value = survey_mean(na.rm = T)) %>%
  mutate(AGE= as.numeric(AGE)) 

cps_basic %>%
  filter(!is.na(HISPANIC) & !is.na(AGE) & YEAR %in% c(2016, 2018)) %>%
  group_by(AGE) %>%
  summarise(n())

age_data %>%
  ggplot(aes(x = AGE, y = value, fill = HISPANIC)) +
  geom_bar(stat = "identity") +
  theme_minimal() 
