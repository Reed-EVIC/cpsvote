## ----include = FALSE----------------------------------------------------------
options(rmarkdown.html_vignette.check_title = FALSE)
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  purl = NOT_CRAN,
  eval = NOT_CRAN
)
library(knitr)
library(cpsvote)
library(dplyr)

## ----setup, message=FALSE, eval = FALSE---------------------------------------
# library(cpsvote)
# library(dplyr)

## -----------------------------------------------------------------------------
income_cols <- data.frame(
  year = c(2006, 2008),
  cps_name = "HUFAMINC",
  new_name = "FAM_INCOME",
  start_pos = 39,
  end_pos = 40,
  stringsAsFactors = FALSE
)

## ----echo = FALSE-------------------------------------------------------------
kable(income_cols)

## -----------------------------------------------------------------------------
income_factors <- data.frame(
  year = c(rep(2006, 16), rep(2008, 16)),
  cps_name = "HUFAMINC",
  new_name = "FAM_INCOME",
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

## ----echo = FALSE-------------------------------------------------------------
kable(income_factors)

## -----------------------------------------------------------------------------
my_cols <- bind_rows(cps_cols, income_cols)
my_factors <- bind_rows(cps_factors, income_factors)

## ----message=F----------------------------------------------------------------
cps_income <- cps_read(years = c(2006, 2008),
                       dir = here::here("cps_data"),
                       cols = my_cols) %>%
  cps_label(factors = my_factors)

str(cps_income)

## ----eval = FALSE-------------------------------------------------------------
# table(cps_income$FAM_INCOME, cps_income$YEAR)

## ----echo = FALSE-------------------------------------------------------------
table(cps_income$FAM_INCOME, cps_income$YEAR) %>%
  kable()

