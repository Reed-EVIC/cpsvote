# Script to test out turnout estimates from the "add-2020" branch of cpsvote
#
# Paul Gronke October 6, 2025
#
# This script assumes you have already installed the "add-2020" branch of cpsvote
#
# If this is not the case, issue this comment 
#
#      remotes::install_github("Reed-EVIC/cpsvote", ref = "add-2020")   
#

library(tidyverse)
library(janitor)
library(cpsvote)
library(srvyr)

#
# Read in all years (1994 - 2020). If you have not downloaded the data files previously, these
# will be downloaded automatically and placed in the "cps_data" folder
#
# If you for any reason had extra files in that directory than one for each year, this can cause
# an error. 
#

cps <- cps_load_basic()  # Should load all years 1994 - 2020

# Look at the data - should be 150,000 or so cases per year 

table(cps$YEAR)

# Examine raw turnout for 2016 and 2020. Note that the Hur-Achen turnout
# coding changes how "NULL" values are treated.

# 2016

cps %>%
  filter(YEAR %in% c(2016)) %>%
  tabyl(cps_turnout, hurachen_turnout)

cps %>%
  filter(YEAR %in% c(2016) & hurachen_turnout != "NULL") %>%
  tabyl(hurachen_turnout)

cps %>%
  filter(YEAR %in% c(2016)) %>%
  tbl_cross(row = cps_turnout, 
            col = hurachen_turnout,
            percent = "cell")

cps %>%
  filter(YEAR %in% c(2016) & hurachen_turnout != "NULL") %>%
  tbl_cross(row = cps_turnout, 
            col = hurachen_turnout,
            percent = "cell")

# 2020
cps %>%
  filter(YEAR %in% c(2020)) %>%
  tabyl(cps_turnout, hurachen_turnout)

cps %>%
  filter(YEAR %in% c(2020) & hurachen_turnout != "NULL") %>%
  tabyl(hurachen_turnout)

cps %>%
  filter(YEAR %in% c(2020)) %>%
  tbl_cross(row = cps_turnout, 
            col = hurachen_turnout,
            percent = "cell")

cps %>%
  filter(YEAR %in% c(2020) & hurachen_turnout != "NULL") %>%
  tbl_cross(row = cps_turnout, 
            col = hurachen_turnout,
            percent = "cell") 


# Raw turnout by state 

cps %>%
  filter(YEAR %in% c(2020) & hurachen_turnout != "NULL") %>%
  droplevels() %>% 
  tbl_cross(col = hurachen_turnout, 
            row = STATE,
            percent = "row") 



# Survey weighted results 

cps %>% as_survey_design(weights = turnout_weight) %>%
  filter(YEAR %in% c(2016)) %>%
  tbl_svysummary(include = c(hurachen_turnout), 
            percent = "cell")

cps %>% as_survey_design(weights = turnout_weight) %>%
  filter(YEAR %in% c(2020) & hurachen_turnout != "NULL") %>%
  tbl_svysummary(include = hurachen_turnout,
            percent = "cell")

cps %>% filter(YEAR %in% c(2020) & hurachen_turnout != "NULL") %>%
  droplevels() %>% 
  as_survey_design(weights = turnout_weight) %>%
  tbl_svysummary(by = hurachen_turnout,
                 include = STATE,
                 percent = "row")

# Visual inspection shows these to be very close to the values reported at the UFL Elections Lab 
# site: https://electionlab.mit.edu/data

