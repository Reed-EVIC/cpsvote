## ----include = FALSE----------------------------------------------------------
options(rmarkdown.html_vignette.check_title = FALSE)
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>", 
  messages = FALSE, warnings = FALSE,
  purl = NOT_CRAN,
  eval = NOT_CRAN
)
library(knitr)
library(cpsvote)
set.seed(20201012)

## ----eval = FALSE-------------------------------------------------------------
# install.packages('cpsvote')
# library(cpsvote)

## ----eval = FALSE-------------------------------------------------------------
# remotes::install_github("Reed-EVIC/cpsvote")
# library(cpsvote)

## ----eval = FALSE-------------------------------------------------------------
# # Load All Years
# # May take some time to download and process files the first time!
# cps <- cps_load_basic()

## ----eval = FALSE-------------------------------------------------------------
# # Just load 2006 and 2008
# cps <- cps_load_basic(years = c(2006, 2008))

## ----eval = F, message = F----------------------------------------------------
# library(dplyr)
# data("cps_allyears_100k")
# 
# cps_allyears_100k %>%
#   select(1:3, VRS_VOTE:VRS_REG, VRS_VOTEMETHOD_CON, turnout_weight) %>%
#   sample_n(10)

## ----echo = F, message = F----------------------------------------------------
library(dplyr)
data("cps_allyears_100k")

cps_allyears_100k %>%
  select(1:3, VRS_VOTE:VRS_REG, VRS_VOTEMETHOD_CON, turnout_weight) %>%
  sample_n(10) %>%
  kable()

## ----message=F, warning = F, eval = F-----------------------------------------
# library(srvyr)
# 
# cps20_weighted <- cps_load_basic(years = 2020, datadir = here::here('cps_data')) %>%
#   as_survey_design(weights = turnout_weight)
# 
# turnout20 <- cps20_weighted %>%
#   group_by(STATE) %>%
#   summarize(turnout = survey_mean(hurachen_turnout == "YES", na.rm = TRUE))
# 
# head(turnout20, 10)

## ----message=F, warning = F, echo = F-----------------------------------------
library(srvyr)

cps20_weighted <- cps_load_basic(years = 2020, datadir = here::here('cps_data')) %>%
  as_survey_design(weights = turnout_weight)

turnout20 <- cps20_weighted %>%
  group_by(STATE) %>%
  summarize(turnout = survey_mean(hurachen_turnout == "YES", na.rm = TRUE))

head(turnout20, 10) %>%
  kable()

## ----eval=F-------------------------------------------------------------------
# cps_download_data(path = "cps_data",
#                   years = seq(1994, 2024, 2))
# cps_download_docs(path = "cps_data",
#                   years = seq(1994, 2024, 2))
# 
# cps_read(years = seq(1994, 2024, 2),
#          dir = "cps_data",
#          cols = cpsvote::cps_cols,
#          names_col = "new_name",
#          join_dfs = TRUE) %>%
#     cps_label(factors = cpsvote::cps_factors,
#               names_col = "new_name",
#               na_vals = c("-1", "BLANK", "NOT IN UNIVERSE"),
#               expand_year = TRUE,
#               rescale_weight = TRUE,
#               toupper = TRUE) %>%
#     cps_refactor(move_levels = TRUE) %>%
#     cps_recode_vote(vote_col = "VRS_VOTE",
#                     items = c("DON'T KNOW", "REFUSED", "NO RESPONSE")) %>%
#     cps_reweight_turnout()

## ----eval = FALSE-------------------------------------------------------------
# cps14 <- cps_read(2014, names_col = "cps_name")

## ----eval = FALSE-------------------------------------------------------------
# cps14_lab <- cps_label(cps14, names_col = "cps_name")

