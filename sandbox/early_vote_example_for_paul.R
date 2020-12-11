library(srvyr)
library(ggplot2)
library(ggthemes)
library(scales)
library(tidyverse)
library(cpsvote)

cps <- cps_load_basic()

cps <- cps %>% 
  mutate(
    census_region = case_when(
      STATE %in% c("ME", "NH", "VT", "MA", "CT", "RI", 
                       "NY", "PA", "NJ") ~ "Northeast",
      STATE %in% c("ME", "DE", "WV", "DC", "VA", "NC", "SC", "GA", "FL",
                       "KY", "TN", "MS", "AL", 
                       "OK", "AR", "LA", "TX") ~ "South",
      STATE %in% c("WI", "MI", "IL", "IN", "OH", 
                       "ND", "MN", "SD", "IA", "NE", "MO", "KS") ~ "Midwest",
      STATE %in% c("MT", "ID", "WY", "NV", "UT", "CO", "AZ", "NM", 
                       "WA", "OR", "CA", "AK", "HI") ~ "West")) %>%
  filter(YEAR > 1994)

cps %>%
  as_survey_design(weight = turnout_weight) %>%
  group_by(census_region, YEAR, VRS_VOTEMETHOD_CON) %>%
  summarise(pct = survey_mean(na.rm = T)) %>%
  na.omit() %>%
  filter(VRS_VOTEMETHOD_CON == "EARLY") %>%
  ggplot(aes(x = YEAR, y = pct, color = census_region)) +
  geom_point(size = 3.5) +
  geom_line(size = 1.25) +
  theme_minimal(base_size = 20) +
  scale_x_continuous(breaks = seq(1996, 2018, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Early voting usage by US Census Region, 1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       fill = "Mode of Voting") +
  theme(plot.title = element_text(size = 30, family = "Times", face = "bold.italic", colour = "red"),
        legend.background = element_rect(),
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) +
  labs(x = "Year", y = "") +
  scale_color_discrete(name = "Census Region: ")


cps %>%
  as_survey_design(weight = turnout_weight) %>%
  group_by(census_region, YEAR, VRS_VOTEMETHOD_CON) %>%
  summarise(pct = survey_mean(na.rm = T)) %>%
  na.omit() %>%
  filter(VRS_VOTEMETHOD_CON == "BY MAIL") %>%
  ggplot(aes(x = YEAR, y = pct, color = census_region)) +
  geom_point(size = 3.5) +
  geom_line(size = 1.25) +
  theme_minimal(base_size = 20) +
  scale_x_continuous(breaks = seq(1996, 2018, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Vote-by-mail usage by US Census Region, 1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       fill = "Mode of Voting") +
  theme(plot.title = element_text(size = 30, family = "Times", face = "bold.italic", colour = "red"),
        legend.background = element_rect(),
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) +
  labs(x = "Year", y = "") +
  scale_color_discrete(name = "Census Region: ")



cps %>%
  as_survey_design(weight = turnout_weight) %>%
  group_by(census_region, YEAR, VRS_VOTEMETHOD_CON) %>%
  summarise(pct = survey_mean(na.rm = T)) %>%
  na.omit() %>%
  filter(VRS_VOTEMETHOD_CON == "ELECTION DAY") %>%
  ggplot(aes(x = YEAR, y = pct, color = census_region)) +
  geom_point(size = 3.5) +
  geom_line(size = 1.25) +
  theme_minimal(base_size = 20) +
  scale_x_continuous(breaks = seq(1996, 2018, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Election day voting usage by US Census Region, 1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       fill = "Mode of Voting") +
  theme(plot.title = element_text(size = 30, family = "Times", face = "bold.italic", colour = "red"),
        legend.background = element_rect(),
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) +
  labs(x = "Year", y = "") +
  scale_color_discrete(name = "Census Region: ")


cps %>%
  as_survey_design(weight = turnout_weight) %>%
  group_by(YEAR, VRS_VOTEMETHOD_CON) %>%
  summarise(pct = survey_mean(na.rm = T)) %>%
  na.omit() %>%
  ggplot(aes(x = YEAR, y = pct, color = VRS_VOTEMETHOD_CON)) +
  geom_point(size = 3.5) +
  geom_line(size = 1.25) +
  theme_minimal(base_size = 20) +
  scale_x_continuous(breaks = seq(1996, 2018, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Voting method in the United States, 1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       fill = "Mode of Voting") +
  theme(plot.title = element_text(size = 30, family = "Times", face = "bold.italic", colour = "red"),
        legend.background = element_rect(),
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 10)) +
  labs(x = "Year", y = "") +
  scale_color_discrete(name = "Vote method: ")


cps %>%
  as_survey_design(weight = turnout_weight) %>%
  filter(YEAR == 2016 & !is.na(VRS_VOTEMETHOD_CON)) %>%
  group_by(STATE) %>%
  summarise(pct = survey_mean(VRS_VOTEMETHOD_CON %in% c("BY MAIL", "EARLY"), na.rm = T)) %>%
  mutate(state = STATE) %>%
  usmap::plot_usmap(data = ., values = "pct") +
  scale_fill_continuous(low = "sky blue", high = "navy", name = "") +
  theme(legend.position = "right") + 
  labs(title = "Non-election day voting in the United States, 1996 - 2018", 
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       fill = "Mode of Voting") +
  theme(plot.title = element_text(size = 20, family = "Times", face = "bold.italic", colour = "red")) +
  scale_fill_continuous(name = "Non-election day voting:", labels = scales::percent)






