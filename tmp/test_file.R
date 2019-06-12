library(stringr)
library(dplyr)

# grab only the lines corresponding to column names
rows <- readLines('http://thedataweb.rm.census.gov/pub/cps/basic/201701-/January_2017_Record_Layout.txt') %>%
  str_replace_all("\\s+", " ") %>%
  trimws(which = "right") %>% # trim trailing WS because I want numbers at the end of lines
  str_subset("^[:upper:].*\\d[^[:alnum:]]*\\d$") # the colname rows start with a capital, end with two separated numbers

# grab names and ranges
names <- str_extract(rows, "^\\w*")
num <- str_extract(rows, "\\d{1,3}[^[:alnum:]]{1,3}\\d{1,4}$")

# tests
num_test <- str_extract_all(num, "\\d+") %>%
  lapply(as.numeric) %>%
  lapply(modelr::seq_range, by = 1) %>%
  unlist() # list the numbers in every range

all(1:1000 %in% num_test) # it catches everything
all(table(num_test) == 1) # everything only shows up once

# pull the starts and ends of columns
col_starts <- str_extract_all(num, "\\d+") %>%
  lapply(magrittr::extract2, 1) %>%
  unlist() %>%
  as.numeric()
col_ends <- str_extract_all(num, "\\d+") %>%
  lapply(magrittr::extract2, 2) %>%
  unlist() %>%
  as.numeric()

cps_0519 <- readr::read_fwf('http://thedataweb.rm.census.gov/pub/cps/basic/201701-/may19pub.dat.gz',
                  col_positions = readr::fwf_positions(col_starts, col_ends, names))




