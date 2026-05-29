# Creates a plot of Turnout by Hispanic and Non Hispanic across age groups

library(tidyverse)
library(survey)
library(srvyr)

cps_basic_W <- as_survey_design(cps, weights = turnout_weight)

age_data <- cps_basic_W %>%
  filter(!is.na(HISPANIC) & !is.na(AGE) & YEAR %in% c(2016, 2022)) %>%
  mutate(AGE = factor(AGE)) %>%
  group_by(HISPANIC, AGE) %>%
  summarize(value = survey_mean(na.rm = T)) %>%
  mutate(AGE= as.numeric(AGE)) 

cps %>%
  filter(!is.na(HISPANIC) & !is.na(AGE) & YEAR %in% c(2016, 2022)) %>%
  group_by(AGE) %>%
  summarise(n())

age_data %>%
  ggplot(aes(x = AGE, y = value, fill = HISPANIC)) +
  geom_bar(stat = "identity") +
  theme_minimal() 
