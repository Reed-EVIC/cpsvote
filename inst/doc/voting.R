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

## ----packages, message = FALSE, warning = FALSE-------------------------------
library(dplyr)
library(ggplot2)
library(here)
library(usmap)

## ----setup2, echo = TRUE------------------------------------------------------
library(cpsvote)
library(srvyr)
library(dplyr)

cps20 <- cps_load_basic(years = 2020, datadir = here::here('cps_data'))

# unweighted, using the census turnout coding
cps20_unweighted <- cps20 %>%
  summarize(type = "Unweighted",
            turnout = mean(cps_turnout == "YES", na.rm = TRUE))

# weighted, using the original weights and census turnout coding
cps20_censusweight <- cps20 %>%
  as_survey_design(weights = WEIGHT) %>%
  summarize(turnout = survey_mean(cps_turnout == "YES", na.rm = TRUE)) %>%
  mutate(type = "Census")

# weighted, using the modified weights and hur-achen turnout coding
cps20_hurachenweight <- cps20 %>%
  as_survey_design(weights = turnout_weight) %>%
  summarize(turnout = survey_mean(hurachen_turnout == "YES", na.rm = TRUE)) %>%
  mutate(type = "Hur & Achen")

turnout_estimates <- bind_rows(cps20_unweighted, 
                               cps20_censusweight, 
                               cps20_hurachenweight) %>%
  transmute('Method' = type,
            'Turnout Estimate' = scales::percent(turnout, .1))

knitr::kable(turnout_estimates)

## ----turnout_race, echo = TRUE------------------------------------------------
cps20 %>%
  as_survey_design(weights = turnout_weight) %>%
  filter(RACE %in% c("WHITE", "BLACK", "AMERICAN INDIAN OR ALASKA NATIVE",
                     "ASIAN, PACIFIC ISLANDER, OR NATIVE HAWAIIAN")) %>%
  group_by(RACE) %>%
  summarize(turnout = survey_mean(hurachen_turnout == "YES", na.rm = TRUE)) %>%
  ggplot(aes(x = RACE, y = turnout)) +
  geom_col() + 
  scale_x_discrete(labels = c("WHITE"= "White",
                              "BLACK" = "Black",
                              "AMERICAN INDIAN OR ALASKA NATIVE" = "AI/AN",
                              "ASIAN, PACIFIC ISLANDER, OR NATIVE HAWAIIAN" = "A/PI")) +
  scale_y_continuous(labels = scales::percent) +
  labs(x = "", y = "Turnout", title = "Turnout among Eligible Voters by Race, 2020") +
  theme_bw()

## ----turnout_statemap, echo = TRUE--------------------------------------------
cps20 %>%
  as_survey_design(weights = turnout_weight) %>%
  mutate(state = STATE) %>% # necessary column name for plot_usmap
  group_by(state) %>%
  summarize(turnout = survey_mean(hurachen_turnout == "YES", na.rm = TRUE)) %>%
  plot_usmap(data = ., values = "turnout", color = "black", size = 0.1) +
  scale_fill_continuous(low = "white", high = "blue", name = "Turnout Rate", 
                        labels = scales::percent_format(accuracy = 1)) +
  theme(legend.position = "right") + labs(title = "Voter Turnout in the United States, 2020")

## ----earlyvoting_data_load, include = TRUE------------------------------------
cps_region <-  cps_allyears_10k %>% 
  # since this is only among voters, either weight can be used equivalently
  as_survey_design(weights = turnout_weight) %>%
  mutate(census_region = case_when(
    STATE %in% c("ME", "NH", "VT", "MA", "CT", 
                 "RI", "NY", "PA", "NJ") ~ "Northeast",
    STATE %in% c("ME", "DE", "WV", "DC", "VA", 
                 "NC", "SC", "GA", "FL", "KY", 
                 "TN", "MS", "AL", "OK", "AR", 
                 "LA", "TX") ~ "South",
    STATE %in% c("WI", "MI", "IL", "IN", "OH", 
                 "ND", "MN", "SD", "IA", "NE", 
                 "MO", "KS") ~ "Midwest",
    STATE %in% c("MT", "ID", "WY", "NV", "UT", 
                 "CO", "AZ", "NM", "WA", "OR", 
                 "CA", "AK", "HI") ~ "West"
    )
)

## ----modesbyyear_line, include = TRUE-----------------------------------------
cps_region %>%
  filter(YEAR > 1994 & !is.na(VRS_VOTEMETHOD_CON)) %>%
  group_by(YEAR, VRS_VOTEMETHOD_CON) %>%
  summarize(value = survey_mean(na.rm = TRUE)) %>%
  ggplot(aes(x = YEAR, y = value, col = VRS_VOTEMETHOD_CON, group = VRS_VOTEMETHOD_CON)) +
  geom_line(size = 1.5) +
  geom_point(aes(x = YEAR, y = value, color = VRS_VOTEMETHOD_CON), size = 2) +
  scale_x_continuous(breaks = seq(1996, 2024, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "The Growth of Early Voting, 1996 - 2024",
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       color = "Mode of Voting",
       y = "",
       x = "") +
  theme_minimal() +
  theme(plot.title = element_text(size = 20, family = "serif", 
                                  face = "bold.italic", colour = "red"),
        legend.background = element_rect(), 
        legend.title = element_text(size = 8, face = "bold"),
        legend.text = element_text(size = 6)) 

## ----voteathome---------------------------------------------------------------
cps_region %>%
  filter(YEAR > 1994 &  !is.na(VRS_VOTEMETHOD_CON) & !is.na(census_region)) %>%
  group_by(YEAR, census_region) %>%
  summarize(value = survey_mean(VRS_VOTEMETHOD_CON == "BY MAIL", na.rm = TRUE)) %>%
  ggplot(aes(x = YEAR, y = value, col = census_region, group = census_region)) +
  geom_line(size = 1.5) +
  geom_point(aes(x = YEAR, y = value, color = census_region), size = 2) +
  theme_minimal() +
  scale_x_continuous(breaks = seq(1996, 2024, by = 2)) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Regional Use of Vote At Home, 1996 - 2024",
       subtitle = "Source: Current Population Survey, Voting and Registration Supplement",
       color = "Region") +
  theme(plot.title = element_text(size = 20, family = "serif", 
                                  face = "bold.italic", colour = "red"),
        legend.background = element_rect(),  
        legend.title = element_text(size = 8, face = "bold"),
        legend.text = element_text(size = 6)) +
  ylab("") + xlab("")  

## ----votemethod-maps----------------------------------------------------------
map_data <- cps20 %>%
  as_survey_design(weights = turnout_weight) %>%
  filter(!is.na(STATE), !is.na(VRS_VOTEMETHOD_CON)) %>%
  mutate(state = STATE) %>% # this is a necessary column name for plot_usmap
  group_by(state, VRS_VOTEMETHOD_CON) %>%
  summarize(value = survey_mean(na.rm = TRUE))
  
map_data %>% 
  filter(VRS_VOTEMETHOD_CON == "ELECTION DAY") %>%
  plot_usmap(data = ., values = "value", color = "black", size = 0.1) +
  theme(legend.position = "top") +
  scale_fill_gradient(low = "lavender", high = "purple", na.value = NA, 
                      name = "Election Day Voting Usage (2020)", 
                      labels = scales::percent)

map_data %>% 
  filter(VRS_VOTEMETHOD_CON == "EARLY") %>%
  plot_usmap(data = ., values = "value", color = "black", size = 0.1) +
  theme(legend.position = "top") +
  scale_fill_gradient(low = "yellow", high = "red", na.value = NA, 
                      name = "Early In Person Voting Usage (2020)", 
                      labels = scales::percent)

map_data %>% 
  filter(VRS_VOTEMETHOD_CON == "BY MAIL") %>%
  plot_usmap(data = ., values = "value", color = "white", size = 0.1) +
  theme(legend.position = "top") + 
  scale_fill_gradient(low = "sky blue", high = "navy", na.value = NA, 
                      name = "Mail Voting Usage (2020)", 
                      labels = scales::percent)

