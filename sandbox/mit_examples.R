install.packages(c('srvyr', 'dplyr', 'ggplot2', 'remotes'))
remotes::install_github("Reed-EVIC/cpsvote", force = TRUE)

library(cpsvote)
library(srvyr)
library(dplyr)
library(ggplot2)

# reading in ALL of the data -----

# download raw data
cps_download_data()
cps_download_docs()

# load raw data into R
cps_vote <- cps_read()

str(cps_vote)

# apply factor labels to the numeric values, recode turnout, and reweight
cps_coded <- cps_vote %>%
  cps_label() %>%
  cps_recode_vote() %>%
  cps_reweight_turnout()

str(cps_coded)

# all of the above is equivalent to this
cps_basic <- cps_load_basic()

# turnout with a 10k sample -----

data(cps_sample_10k)

?cps_sample_10k

cps_10k_weighted <- as_survey_design(cps_sample_10k, weights = turnout_weight)

turnout <- cps_10k_weighted %>%
  group_by(YEAR) %>%
  summarize(turnout = survey_mean(achenhur_turnout == "YES", na.rm = TRUE)) %>%
  mutate(election = case_when(YEAR %% 4 == 0 ~ "Presidential",
                              TRUE ~ "Midterm"))

ggplot(turnout, aes(x = YEAR, y = turnout, col = election, group = election)) +
  geom_line() +
  geom_point()
  ylim(0,1)

# income in 06/08 -----

income_cols <- data.frame(
  year = c(2006, 2008),
  cps_name = "HUFAMINC",
  new_name = "INCOME",
  start_pos = 39,
  end_pos = 40,
  stringsAsFactors = FALSE
)

income_factors <- data.frame(
  year = c(rep(2006, 16), rep(2008, 16)),
  cps_name = "HUFAMINC",
  new_name = "INCOME",
  code = c(1:16, 1:16),
  value = rep(c("LESS THAN $5,000",
                "5,000 TO 7,499",
                "7,500 TO 9,999",
                "10,000 TO 12,499",
                "12,500 TO 14,999",
                "15,000 TO 19,999",
                "20,000 TO 24,999",
                "25,000 TO 29,999",
                "30,000 TO 34,999",
                "35,000 TO 39,999",
                "40,000 TO 49,999",
                "50,000 TO 59,999",
                "60,000 TO 74,999",
                "75,000 TO 99,999",
                "100,000 TO 149,999",
                "150,000 OR MORE"), 2),
  stringsAsFactors = FALSE
)

my_cols <- bind_rows(cps_cols, income_cols)
my_factors <- bind_rows(cps_factors, income_factors)

cps_income <- cps_read(years = c(2006, 2008),
                       cols = my_cols) %>%
  cps_label(factors = my_factors)

janitor::tabyl(cps_income, INCOME, YEAR)
