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
      VRS_VOTE == "Yes" ~ 1,
      VRS_VOTE == "No" ~ 0),
    voted_eip = case_when(
      VRS_VOTE == "Yes" & VRS_VOTE_DAY == "Before election day" &
        VRS_VOTE_MAIL == "In person" ~ 1,
      VRS_VOTE == "Yes" ~ 0),
    income_cats =case_when(
      as.numeric(CPS_INCOME) <=6 ~ "Bottom 20%",
      as.numeric(CPS_INCOME) > 6 & 
        as.numeric(CPS_INCOME) <= 11 ~ "From 20% to median",
      as.numeric(CPS_INCOME) > 11 &
        as.numeric(CPS_INCOME) <=15 ~ "Median to top 15%",
      TRUE ~ "Top 15%")
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
  scale_x_continuous(breaks = seq(1996, 2018, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "The Growth of Early Voting, 1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       fill = "Mode of Voting",
       y = "",
       x = "") +
  theme_minimal() +
  theme(plot.title = element_text(size = 20, family = "Times", face = "bold.italic", colour = "red"),
        legend.position = c(.1,.8), 
        legend.background = element_rect(), 
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) 
  
ggsave("sandbox/vote_modes_by_year_barchart.png")

# Graph 1a: Rate of All Modes of Voting By Year (line graph)

cps_weight %>%
  filter(CPS_YEAR > 1994 & !is.na(VRS_VOTE_HOW_C)) %>%
  group_by(CPS_YEAR, VRS_VOTE_HOW_C) %>%
  summarize(value = survey_mean(na.rm = TRUE)) %>%
  ggplot(aes(x = CPS_YEAR, y = value, col = VRS_VOTE_HOW_C, group = VRS_VOTE_HOW_C)) +
  geom_line(size = 1.5) +
  geom_point(aes(x = CPS_YEAR, y = value, color = VRS_VOTE_HOW_C), size = 2) +
  scale_x_continuous(breaks = seq(1996, 2018, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "The Growth of Early Voting, 1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       color = "Mode of Voting",
       y = "",
       x = "") +
  theme_minimal() +
  theme(plot.title = element_text(size = 20, family = "Times", face = "bold.italic", colour = "red"),
        legend.position = c(.15,.8), 
        legend.background = element_rect(), 
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) 

ggsave("sandbox/vote_modes_by_year_linegraph.png")

# Graph 1a: Rate of All Modes of Voting By Year in NC (line graph)

cps_weight %>%
  filter(CPS_YEAR > 1994 & !is.na(VRS_VOTE_HOW_C) & CPS_STATE == "NC") %>%
  group_by(CPS_YEAR, VRS_VOTE_HOW_C) %>%
  summarize(value = survey_mean(na.rm = TRUE)) %>%
  ggplot(aes(x = CPS_YEAR, y = value, col = VRS_VOTE_HOW_C, group = VRS_VOTE_HOW_C)) +
  geom_line(size = 1.5) +
  geom_point(aes(x = CPS_YEAR, y = value, color = VRS_VOTE_HOW_C), size = 2) +
  scale_x_continuous(breaks = seq(1996, 2018, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "The Growth of Early Voting in NC,\n1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       color = "Mode of Voting",
       y = "",
       x = "") +
  theme_minimal() +
  theme(plot.title = element_text(size = 20, family = "Times", face = "bold.italic", colour = "red"),
        legend.position = c(.15,.75), 
        legend.background = element_rect(), 
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) 
  
ggsave("sandbox/vote_modes_by_year_NClinegraph.png")

cps_weight %>% 
  filter(VRS_VOTE_DAY != "Don't know" & CPS_STATE == "NC" & CPS_RACE %in% c("White Only", "Black Only")) %>%
  group_by(CPS_YEAR, CPS_RACE) %>%
  summarize(value = survey_mean(voted_eip, na.rm = TRUE)) %>% 
  ggplot(., aes(x = CPS_YEAR, y = value,  col = CPS_RACE, fill = CPS_RACE)) +
  geom_bar(stat = "identity", position = "dodge")+
  scale_x_continuous(breaks = seq(1996, 2018, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Early Voting in NC by Race,\n1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       color = "Race", fill = "Race",
       y = "",
       x = "") +
  theme_minimal() +
  theme(plot.title = element_text(size = 20, family = "Times", face = "bold.italic", colour = "red"),
        legend.position = c(.15,.75), 
        legend.background = element_rect(), 
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) 
ggsave("sandbox/EIP_by_race_NC.png")


cps_weight %>% 
  filter(VRS_VOTE_DAY != "Don't know" & CPS_STATE == "NC") %>%
  group_by(CPS_YEAR, income_cats) %>%
  summarize(value = survey_mean(voted_eip, na.rm = TRUE)) %>% 
  ggplot(., aes(x = CPS_YEAR, y = value,  col = income_cats, fill = income_cats)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_x_continuous(breaks = seq(2014, 2018, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Early Voting in NC by Income Category,\n1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       color = "Income Category", fill = "Income Category",
       y = "",
       x = "") +
  theme_minimal() +
  theme(plot.title = element_text(size = 20, family = "Times", face = "bold.italic", colour = "red"),
        legend.position = c(.15,.85), 
        legend.background = element_rect(), 
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) 
ggsave("sandbox/EIP_by_income_NC.png")


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
        legend.position = c(.15,.8), legend.background = element_rect(),  
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) 

ggsave("sandbox/early_voting_by_year_by_region.png")

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

ggsave("sandbox/vote_at_home_by_year.png")
