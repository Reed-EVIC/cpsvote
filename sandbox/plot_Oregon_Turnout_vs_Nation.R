# Script to create yearly plots of voting turnout

library(srvyr)
library(ggplot2)
library(ggthemes)
library(scales)
library(tidyverse)
library(forcats)

# Data transformations prior to setting up the survey design

# Source for Census Region: https://www2.census.gov/geo/pdfs/maps-data/maps/reference/us_regdiv.pdf
#  The code below is designed for easy adapting to Censys Divisions 

cps <- cps %>% 
  mutate(
    census_region = case_when(
      CPS_STATE %in% c("ME", "NH", "VT", "MA", "CT", "RI", 
                     "NY", "PA", "NJ") ~ "Northeast",
      CPS_STATE %in% c("ME", "DE", "WV", "DC", "VA", "NC", "SC", "GA", "FL",
                     "KY", "TN", "MS", "AL", 
                     "OK", "AR", "LA", "TX") ~ "South",
      CPS_STATE %in% c("WI", "MI", "IL", "IN", "OH", 
                     "ND", "MN", "SD", "IA", "NE", "MO", "KS") ~ "Midwest",
      CPS_STATE %in% c("MT", "ID", "WY", "NV", "UT", "CO", "AZ", "NM", 
                     "WA", "OR", "CA", "AK", "HI") ~ "West"),
    census_division = case_when(
      CPS_STATE %in% c("ME", "NH", "VT", "MA", "CT", "RI") ~ "New England", 
      CPS_STATE %in% c("NY", "PA", "NJ") ~ "Middle Atlantic",
      CPS_STATE %in% c("ME", "DE", "WV", "DC", "VA", "NC", "SC", "GA", "FL") ~ "South Atlantic",
      CPS_STATE %in% c("KY", "TN", "MS", "AL") ~ "East South Central", 
      CPS_STATE %in% c("OK", "AR", "LA", "TX") ~ "West South Central",
      CPS_STATE %in% c("WI", "MI", "IL", "IN", "OH") ~ "East North Central", 
      CPS_STATE %in% c("ND", "MN", "SD", "IA", "NE", "MO", "KS") ~ "West North Central",
      CPS_STATE %in% c("MT", "ID", "WY", "NV", "UT", "CO", "AZ", "NM") ~ "Mountain", 
      CPS_STATE %in% c("WA", "OR", "CA", "AK", "HI") ~ "Pacific"),
    voted = case_when(
      VRS_VOTE == "YES" ~ 1,
      VRS_VOTE == "NO" ~ 0),
    racecat =  fct_collapse(cps$CPS_RACE_C, 
                            White = levels(cps$CPS_RACE_C)[5], 
                            Black = levels(cps$CPS_RACE_C)[4], 
                            Other = levels(cps$CPS_RACE_C)[1:3]),
    agecat = case_when(
      cps$CPS_AGE >= 18 & cps$CPS_AGE <= 25 ~ "18-25", 
      cps$CPS_AGE <= 26 & cps$CPS_AGE <= 50 ~ "26-50",
      cps$CPS_AGE <= 51 & cps$CPS_AGE <= 64 ~ "51-64",
      cps$CPS_AGE >= 65 ~ "65+")
    )

#
# Set up the survey design. Weights must be used for the CPS
#

cps_weight <- as_survey_design(cps, weights = WEIGHT)

# Graph 1: Rate of All Modes of Voting By Year
national_turnout <- cps_weight %>%
  filter(CPS_YEAR > 1994) %>%
  group_by(CPS_YEAR) %>%
  summarize(value = survey_mean(voted, na.rm = TRUE)) %>%
  mutate(category = "Nation")

oregon_turnout <- cps_weight %>%
  filter(CPS_YEAR > 1994 & CPS_STATE == "OR") %>%
  group_by(CPS_YEAR) %>%
  summarize(value = survey_mean(voted, na.rm = TRUE)) %>%
  mutate(category = "Oregon")

ggplot(rbind(national_turnout, oregon_turnout), 
       aes(x = CPS_YEAR, y = value, col = category)) +
  geom_line(size = 1.5) +
  geom_point(aes(x = CPS_YEAR, y = value, color = category), size = 2) +
  theme_minimal() +
  scale_x_continuous(breaks = seq(1996, 2018, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Voter Turnout, Oregon vs. the Nation, 1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       fill = "Mode of Voting") +
  theme(plot.title = element_text(size = 20, family = "Times", face = "bold.italic", colour = "red"),
        legend.background = element_rect(),
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) +
  ylab("") + xlab("") 

ggsave("sandbox/oregon_turnout_vs_national.png")

cps_weight %>%
  filter(CPS_YEAR > 1994 & CPS_STATE == "OR") %>%
  group_by(CPS_YEAR, racecat) %>%
  summarize(value = survey_mean(voted, na.rm = TRUE)) %>%
  ggplot(aes(x = CPS_YEAR, y = value, col = racecat)) +
  geom_line(size = 1.5) +
  geom_point(aes(x = CPS_YEAR, y = value, color = racecat), size = 2) +
  theme_minimal() +
  scale_x_continuous(breaks = seq(1996, 2018, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Oregon Voter Turnout by Race, 1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       color = "Race") +
  theme(plot.title = element_text(size = 20, family = "Times", face = "bold.italic", colour = "red"),
        legend.background = element_rect(),
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) +
  ylab("") + xlab("") 
ggsave("sandbox/oregon_turnout_by_race.png")

cps_weight %>%
  filter(CPS_YEAR > 1994 & CPS_STATE == "OR" & !is.na(agecat)) %>%
  group_by(CPS_YEAR, agecat) %>%
  summarize(value = survey_mean(voted, na.rm = TRUE)) %>%
  ggplot(aes(x = CPS_YEAR, y = value, col = agecat)) +
  geom_line(size = 1.5) +
  geom_point(aes(x = CPS_YEAR, y = value, color = agecat), size = 2) +
  theme_minimal() +
  scale_x_continuous(breaks = seq(1996, 2018, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Oregon Voter Turnout by Age Groups, 1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       color = "Age") +
  theme(plot.title = element_text(size = 20, family = "Times", face = "bold.italic", colour = "red"),
        legend.background = element_rect(),
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) +
  ylab("") + xlab("") 
ggsave("sandbox/oregon_turnout_by_age.png")
