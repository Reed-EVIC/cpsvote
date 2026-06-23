## ----include = FALSE----------------------------------------------------------
options(rmarkdown.html_vignette.check_title = FALSE)
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE, 
  message = FALSE,
  purl = NOT_CRAN,
  eval = NOT_CRAN
)

library(cpsvote)

## ----eval = FALSE-------------------------------------------------------------
# library(cpsvote)
# cps_survey <- survey::svydesign(ids = ~1, # simple weights, no clusters
#                                 data = cps_allyears_100k, # data set
#                                 weights = ~turnout_weight) # weight column

## ----eval = FALSE-------------------------------------------------------------
# cps_srvyr <- srvyr::as_survey_design(.data = cps_allyears_100k, # data set
#                                      weights = turnout_weight) # weight column

## ----turnout_table, message = FALSE-------------------------------------------
library(cpsvote)
library(srvyr)

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

turnout_estimates <- dplyr::bind_rows(cps20_unweighted, 
                                      cps20_censusweight, 
                                      cps20_hurachenweight) %>%
  dplyr::transmute('Method' = type,
                   'Turnout Estimate' = scales::percent(turnout, .1))

knitr::kable(turnout_estimates, align = c('l', 'c'))

