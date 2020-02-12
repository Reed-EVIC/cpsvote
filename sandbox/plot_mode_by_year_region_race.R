# Script to create yearly plots of mode of voting

library(srvyr)
library(ggplot2)
library(ggthemes)
library(scales)
library(tidyverse)


# Data transformations prior to setting up the survey design

# Source for Census Region: https://www2.census.gov/geo/pdfs/maps-data/maps/reference/us_regdiv.pdf
#  The code below is designed for easy adapting to Censys Divisions 

cps <- cps %>% 
  mutate(census_region = case_when(
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
      VRS_VOTE == "NO" ~ 0)
        )

#
# Set up the survey design. Weights must be used for the CPS
#
cps_weight <- as_survey_design(cps, weights = WEIGHT)

# Graph 1: Rate of All Modes of Voting By Year
cps_weight %>%
  filter(CPS_YEAR > 1994 & !is.na(VRS_VOTE_HOW_C)) %>%
  group_by(CPS_YEAR, VRS_VOTE_HOW_C) %>%
  summarize(value = survey_mean(na.rm = TRUE)) %>%
  ggplot(aes(x = CPS_YEAR, y = value, fill = VRS_VOTE_HOW_C, group = VRS_VOTE_HOW_C)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  scale_x_continuous(breaks = seq(1996, 2018, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "The Growth of Early Voting, 1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       fill = "Mode of Voting") +
  theme(plot.title = element_text(size = 20, family = "Times", face = "bold.italic", colour = "red"),
        legend.background = element_rect(),
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) +
  ylab("") + xlab("") 

ggsave("vote_modes_by_year.png")
  
# Graph 2: Rate of Early In Person Voting By Year
cps_weight %>%
  filter(CPS_YEAR > 1994 & !is.na(census_region)) %>%
  group_by(CPS_YEAR, census_region, VRS_VOTE_HOW_C) %>%
  summarize(value = survey_mean(na.rm = TRUE)) %>%
  filter(VRS_VOTE_HOW_C == "EARLY") %>%
  ggplot(aes(x = CPS_YEAR, y = value, col = census_region, group = census_region)) +
  geom_line(size = 1.5) +
  geom_point(aes(x = CPS_YEAR, y = value, color = census_region), size = 2) +
  scale_x_continuous(breaks = seq(1996, 2018, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal() +
  labs(title = "Regional Use of Early In Person Voting, 1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       color = "Region") +
  ylab("") + xlab("") + 
  theme(plot.title = element_text(size = 20, family = "Times", face = "bold.italic", colour = "red"),
        legend.position = c(.1,.8), legend.background = element_rect(),  
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) 

ggsave("early_voting_by_year.png")

# Graph 3: Rate of Vote at Home By Year
cps_weight %>%
  filter(CPS_YEAR > 1994 & !is.na(census_region)) %>%
  group_by(CPS_YEAR, census_region, VRS_VOTE_HOW_C) %>%
  summarize(value = survey_mean(na.rm = TRUE)) %>%
  filter(VRS_VOTE_HOW_C == "MAIL") %>%
  ggplot(aes(x = CPS_YEAR, y = value, col = census_region, group = census_region)) +
  geom_line(size = 1.5) +
  geom_point(aes(x = CPS_YEAR, y = value, color = census_region), size = 2) +
  theme_minimal() +
  scale_x_continuous(breaks = seq(1996, 2018, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Regional Use of Vote At Home, 1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       color = "Region") +
  theme(plot.title = element_text(size = 20, family = "Times", face = "bold.italic", colour = "red"),
        legend.position = c(.1,.8), legend.background = element_rect(),  
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) +
  ylab("") + xlab("")  

ggsave("vote_at_home_by_year.png")

# Graph 4a: Focus on East North Central Census Division
cps_weight %>%
  filter(CPS_YEAR > 1994 & census_division == "East North Central") %>%
  group_by(CPS_YEAR, CPS_STATE, VRS_VOTE_HOW_C) %>%
  summarize(value = survey_mean(na.rm = TRUE)) %>%
  filter(VRS_VOTE_HOW_C == "MAIL") %>%
  ggplot(aes(x = CPS_YEAR, y = value, col = CPS_STATE, group = CPS_STATE)) +
  geom_line(size = 1.5) +
  geom_point(aes(x = CPS_YEAR, y = value, color = CPS_STATE), size = 2) +
  theme_minimal() +
  scale_x_continuous(breaks = seq(1996, 2018, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Use of Vote At Home in the East North Central States, 1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       color = "Region") +
  theme(plot.title = element_text(size = 20, family = "Times", face = "bold.italic", colour = "red"),
        legend.position = c(.1,.8), legend.background = element_rect(),  
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) +
  ylab("") + xlab("")  

ggsave("east_north_central_vah.png")

# Graph 4b: Focus on East North Central Census Division
cps_weight %>%
  filter(CPS_YEAR > 1994 & census_division == "East North Central") %>%
  group_by(CPS_YEAR, CPS_STATE, VRS_VOTE_HOW_C) %>%
  summarize(value = survey_mean(na.rm = TRUE)) %>%
  filter(VRS_VOTE_HOW_C == "EARLY") %>%
  ggplot(aes(x = CPS_YEAR, y = value, col = CPS_STATE, group = CPS_STATE)) +
  geom_line(size = 1.5) +
  geom_point(aes(x = CPS_YEAR, y = value, color = CPS_STATE), size = 2) +
  theme_minimal() +
  scale_x_continuous(breaks = seq(1996, 2018, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Use of Early In Person in the East North Central States, 1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       color = "Region") +
  theme(plot.title = element_text(size = 20, family = "Times", face = "bold.italic", colour = "red"),
        legend.position = c(.1,.8), legend.background = element_rect(),  
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) +
  ylab("") + xlab("")  

ggsave("east_north_central_early.png")
