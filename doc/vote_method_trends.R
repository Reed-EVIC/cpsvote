## ----include = FALSE, echo = FALSE--------------------------------------------
options(rmarkdown.html_vignette.check_title = FALSE)
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>", 
  message = FALSE, warning = FALSE,
  fig.width = 6, fig.height = 3,
  purl = NOT_CRAN,
  eval = NOT_CRAN
)
library(knitr)
library(cpsvote)

## ----eval = FALSE-------------------------------------------------------------
# library(cpsvote)

## ----setup, message = FALSE, warning = FALSE----------------------------------
library(srvyr)
library(ggplot2)
library(ggthemes)
library(scales)
library(dplyr)
library(here)
knitr::opts_chunk$set(echo = FALSE, warning = FALSE, results='asis')
cps <- cps_load_basic(datadir = here::here('cps_data'))

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

## ----fig.width=8,fig.height = 5-----------------------------------------------
cps %>%
  as_survey_design(weight = turnout_weight) %>%
  filter(!is.na(VRS_VOTEMETHOD_CON)) %>%
  group_by(YEAR, VRS_VOTEMETHOD_CON) %>%
  summarise(pct = survey_mean(na.rm = T)) %>%
  ggplot(aes(x = YEAR, y = pct, color = VRS_VOTEMETHOD_CON)) +
  geom_point(size = 2) +
  geom_line(size = 1) +
  theme_minimal(base_size = 12) +
  scale_x_continuous(breaks = seq(1996, 2024, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Voting method in the United States, 1996 - 2024",
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       fill = "Mode of Voting") +
  theme(plot.title = element_text(size = 16, family = "serif", face = "bold.italic", colour = "red"),
        legend.background = element_rect(),
        legend.title = element_text(size = 10, face = "bold"),
        legend.text = element_text(size = 9),
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Year", y = "") +
  scale_color_discrete(name = "Vote method: ")


## ----fig.width=8,fig.height = 5-----------------------------------------------
cps_2020_10k %>%
  cps_label() %>%
  cps_refactor() %>%
  cps_recode_vote() %>%
  cps_reweight_turnout() %>%
  as_survey_design(weight = turnout_weight) %>%
  filter(YEAR == 2020 & !is.na(VRS_VOTEMETHOD_CON)) %>%
  group_by(STATE) %>%
  summarise(pct = survey_mean(VRS_VOTEMETHOD_CON %in% c("ELECTION DAY"), na.rm = T)) %>%
  mutate(state = STATE) %>%
  usmap::plot_usmap(data = ., values = "pct") +
  scale_fill_continuous(low = "sky blue",
                        high = "navy",
                        name = "Election day voting:",
                        labels = scales::percent,
                        guide = "colourbar") +
  labs(title = "Election day voting in the United States, 2020",
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       fill = "Mode of Voting") +
  theme(plot.title = element_text(size = 16, family = "serif", face = "bold.italic", colour = "red"),
        plot.subtitle = element_text(size = 10, family = "serif"),
        legend.position = "right",
        legend.background = element_rect(),
        legend.title = element_text(size = 10, family = "serif"),
        legend.text = element_text(size = 9)) +
  guides(fill = guide_colourbar(barheight = 5, barwidth = 1.5))

## ----fig.width=8,fig.height = 5-----------------------------------------------
cps %>%
  as_survey_design(weight = turnout_weight) %>%
  filter(!is.na(VRS_VOTEMETHOD_CON),
         !is.na(census_region)) %>%
  group_by(census_region, YEAR, VRS_VOTEMETHOD_CON) %>%
  summarise(pct = survey_mean(na.rm = T)) %>%
  filter(VRS_VOTEMETHOD_CON == "ELECTION DAY") %>%
  ggplot(aes(x = YEAR, y = pct, color = census_region)) +
  geom_point(size = 2) +
  geom_line(size = 1) +
  theme_minimal(base_size = 12) +
  scale_x_continuous(breaks = seq(1996, 2024, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Election day voting usage by US Census Region, 1996 - 2024",
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       fill = "Mode of Voting") +
  theme(plot.title = element_text(size = 16, family = "serif", face = "bold.italic", colour = "red"),
        legend.background = element_rect(),
        legend.title = element_text(size = 10, face = "bold"),
        legend.text = element_text(size = 9),
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Year", y = "") +
  scale_color_discrete(name = "Census Region: ")


## ----fig.width=8,fig.height = 5-----------------------------------------------
cps %>%
  as_survey_design(weight = turnout_weight) %>%
  filter(!is.na(VRS_VOTEMETHOD_CON),
         !is.na(census_region)) %>%
  group_by(census_region, YEAR, VRS_VOTEMETHOD_CON) %>%
  summarise(pct = survey_mean(na.rm = T)) %>%
  filter(VRS_VOTEMETHOD_CON == "EARLY") %>%
  ggplot(aes(x = YEAR, y = pct, color = census_region)) +
  geom_point(size = 2) +
  geom_line(size = 1) +
  theme_minimal(base_size = 12) +
  scale_x_continuous(breaks = seq(1996, 2024, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Early voting usage by US Census Region, 1996 - 2024",
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       fill = "Mode of Voting") +
  theme(plot.title = element_text(size = 16, family = "serif", face = "bold.italic", colour = "red"),
        legend.background = element_rect(),
        legend.title = element_text(size = 10, face = "bold"),
        legend.text = element_text(size = 9),
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Year", y = "") +
  scale_color_discrete(name = "Census Region: ")

## ----fig.width=8,fig.height = 5-----------------------------------------------
cps %>%
  as_survey_design(weight = turnout_weight) %>%
  filter(!is.na(VRS_VOTEMETHOD_CON),
         !is.na(census_region)) %>%
  group_by(census_region, YEAR, VRS_VOTEMETHOD_CON) %>%
  summarise(pct = survey_mean(na.rm = T)) %>%
  filter(VRS_VOTEMETHOD_CON == "BY MAIL") %>%
  ggplot(aes(x = YEAR, y = pct, color = census_region)) +
  geom_point(size = 2) +
  geom_line(size = 1) +
  theme_minimal(base_size = 12) +
  scale_x_continuous(breaks = seq(1996, 2024, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Vote-by-mail usage by US Census Region, 1996 - 2024",
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       fill = "Mode of Voting") +
  theme(plot.title = element_text(size = 16, family = "serif", face = "bold.italic", colour = "red"),
        legend.background = element_rect(),
        legend.title = element_text(size = 10, face = "bold"),
        legend.text = element_text(size = 9),
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Year", y = "") +
  scale_color_discrete(name = "Census Region: ")

