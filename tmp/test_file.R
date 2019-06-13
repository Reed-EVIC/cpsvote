library(stringr)
library(dplyr)

# grab only the lines corresponding to column names
dict <- readLines('http://thedataweb.rm.census.gov/pub/cps/basic/201701-/January_2017_Record_Layout.txt') %>%
  str_replace_all("\\s+", " ") %>%
  trimws(which = "right")

rownums <- dict %>%
  str_which("^[:upper:].*\\d[^[:alnum:]]*\\d$") # the colname rows start with a capital, end with two separated numbers

rows <- dict[rownums]

# grab names, reported widths, and ranges
varnames <- str_extract(rows, "^\\w*")
num_width <- str_extract(rows, " \\d+") %>% as.numeric() # need the space bc some vars have numbers in them
num_range <- str_extract(rows, "\\d{1,3}[^[:alnum:]]{1,3}\\d{1,4}$")
# one of these widths is wrong in the data file, it's listed as 2 but the range is 114-117
num_width[45] <- 4

# test that the ranges do what we want them to
range_test <- str_extract_all(num_range, "\\d+") %>%
  lapply(as.numeric) %>%
  lapply(modelr::seq_range, by = 1) %>%
  unlist() # list the numbers in every range

all(1:1000 %in% range_test) # it catches everything
all(table(range_test) == 1) # everything only shows up once

width_test <- str_extract_all(num_range, "\\d+") %>%
  lapply(as.numeric) %>%
  lapply(modelr::seq_range, by = 1) %>%
  lapply(length) %>%
  unlist()

all(width_test == num_width)

# pull the starts and ends of columns
col_starts <- str_extract_all(num_range, "\\d+") %>%
  lapply(magrittr::extract2, 1) %>%
  unlist() %>%
  as.numeric()
col_ends <- str_extract_all(num_range, "\\d+") %>%
  lapply(magrittr::extract2, 2) %>%
  unlist() %>%
  as.numeric()

# everything up until the above works for all files from 2017 to present (May 2019)
cps_0519 <- readr::read_fwf('http://thedataweb.rm.census.gov/pub/cps/basic/201701-/may19pub.dat.gz',
                  col_positions = readr::fwf_positions(col_starts, col_ends, varnames))




