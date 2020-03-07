#' Load a single CPS file
#' @description Read a single year of data from the CPS
#' @param file Where the fwf or zip (or gz) file for this year's data lives
#' @param year Which year is being read; defaults to 4-digit year in file name
#' #' @param factored Whether the data (in numeric form) should be converted to 
#' the equivalent factor values or not. This will also rename columns according 
#' to the `catalog` argument.
#' @param catalog Which columns to read, and how to assign factor labels. The 
#' default value is "default", which reads from the list `cpsvote:::fwf_key`.
#' @export

##############################################################################################3
# READ_YEAR FUNCTION
# 
# Reads indivudla CPS Files in order to determine the columns to read, formatting, set
# up factoring and other recodes. This function provides internal information that is utillized
# later to create a "merged" CPS output data frams. 
#
# The function draws on fwf_key, which is a list that is created by "save_catalog.R". This script 
# which uses as input information entered on an Excel spreadsheet (CPS_catalog.xlsx). 
# The spreadsheet documents, for each year of the CPS/VRS
#
#     Year, CPS Variable Name, CPSVote Variable name, Starting Column, Ending Column, 
#     variable type, Extended description, Notes
#
# This information is contained in individual tabs labeled by year, and a master tab that merges
#  the information for all years. Long run maintainance of the package will require updating
#  the CPS_catalog spreadsheet as new CPS VRS are released. 
# 
# The user can specify a list of CPS Years, or take the default. 
#  The propoer column locations for data for each CPS Yeqr are in a data frame within "fwf_key", 
#  which will either be the default list of years / columns, or will be dynamically built 
#  from the user-entered list of years.
#
#   As of 3/2020, the default CPS/VRS to be read are 1994 - 2018
#
# The function uses the other infomraiton in catalog to determine the data type for each column,
# determine which columns should be convered to factors, and create informative labels for the
# factor levels. This information is a second data frame within "fwf_key"
#
##############################################################################################3


#####  READ_YEAR Function statts here 
#####
read_year <- function(file,
                      year = as.numeric(stringr::str_extract(file, "\\d{4}")),
                      factored = TRUE,
                      catalog = "default") {
  if (!(year %in% seq(1994, 2018, 2))) {
    stop("Currently, this package only supports even-numbered years from 1994 to 2018.")
    }
  
  #
  # Set the lookup table (i.e. CPS years) to import, either the default or the list
  # provided by the user
  #
  
  if (catalog == "default") {
    catalog <- fwf_key
  } else if (!is.list(catalog)) {
    warning("Catalog must be 'default' or a list. Defaulting to `catalog = 'default'`...")
    catalog <- fwf_key
  } else {
    names(catalog) <- c('columns', 'factoring')
  }
  
  # set this so that it doesn't read all columns
  yr <- year
  
  # grab the relevant column positions for the given year
  columns <- catalog$columns %>%
    dplyr::filter(year == yr)
  
  # COLUMN FORMATS
  #
  # grab which columns are going to be factors, ordered or unordered
  col_names <- columns$orig_col
  factor_cols <- col_names[columns$type == "factor"]
  ordered_cols <- col_names[stringr::str_detect(columns$notes, "ordered")] %>%
    magrittr::extract(!is.na(.))
  unordered_cols <- setdiff(factor_cols, ordered_cols)
  
  ########################################
  # FILE IMPORT
  ######################################
  
  # read the actual data in, according to the column positions
  df <- suppressMessages(readr::read_fwf(file, 
                                         readr::fwf_positions(start = columns$start,
                                                              end = columns$end,
                                                              col_names = col_names)))
 
  ########################################
  # COLUMN RECODES
  ######################################  
  
  # QUICK CODE TO GRAB A LIST OF STATE FIPS CODES
  #
  # get a match for all of the state codes bc I didn't want to put that in the sheet
  fips <- tigris::fips_codes %>%
    dplyr::select(dplyr::starts_with('state')) %>%
    dplyr::distinct() %>%
    dplyr::filter(state_code < 57) %>%
    dplyr::transmute(year = year %>%
                       as.numeric(),
                     var = "GESTFIPS",
                     code = as.numeric(state_code),
                     value = state)
  
  # VALUE LABELS TAKEN FROM CATALOG --> OUTPUT DATA FACTOR LABELS
  #
  # get this year's factoring labels, attach the state codes
  factoring <- dplyr::filter(catalog$factoring, year == yr) %>%
    dplyr::mutate(code = as.numeric(code),
                  year = as.numeric(year)) %>%
    dplyr::bind_rows(fips)
  
  # replace numbers with factor labels
  # Retain some unrecoded columns
  if (factored) {
    # gather numbers, left join labels, spread with the new labels
    df <- df %>%
      dplyr::mutate(index = dplyr::row_number()) %>%
      tidyr::gather(key = "column", value = "answer", -index) %>%
      dplyr::mutate(answer = as.numeric(answer)) %>%
      dplyr::left_join(factoring, by = c("column" = "var", "answer" = "code")) %>%
      dplyr::transmute(index,
                       column,
                       answer = ifelse(!is.na(value), value, answer)) %>%
      tidyr::spread(key = "column", value = "answer") %>%
      dplyr::select(col_names)
    
    # skip FIPS county in factoring because I haven't set that up yet
    if (!any(stringr::str_detect(factoring$var, "^G(E|T)CO$"))) {
      df <- df %>%
        dplyr::mutate_at(stringr::str_subset(factor_cols, "^G(E|T)CO$"), 
                         stringr::str_pad,
                         width = 3, side = "left", pad = "0")
      factor_cols <- factor_cols[!stringr::str_detect(factor_cols, "^G(E|T)CO$")]
    }
    
    # turn the character columns into a factor
    for(name in factor_cols) {
      # get the set of factor labels for that column
      factors <- dplyr::filter(factoring,
                               year == year,
                               var == name)
      # factor the column with the labels, ordered status
      df[[name]] <- factor(df[[name]], 
                           levels = factors$value, 
                           ordered = name %in% ordered_cols)
    }
    
    # identify which columns are VRS specific
    vrs_cols <- stringr::str_subset(col_names, "^P(E|R)S\\d$")
    
    # RECODE ALL MISSING RESPONSES AND
    # REMOVE ALL CASES THAT ARE NOT IN CPS/VRS UNIVERSE
    
            # VOTE TURNOUT CODING BELOW
    
    # pull all of the non-response factor levels and -1s into NA
    # then remove all the rows that are NA for all of the VRS columns
    
    df <- df %>%
      dplyr::mutate_if(is.factor, forcats::fct_collapse,
                       NULL = c(
                         "Refused",
                         "No response (N/A)",
                         "Not in Universe",
                         "No Response",
                         "blank",
                         "No response"
                       )) %>%
      dplyr::na_if(-1) %>%
      dplyr::filter_at(dplyr::vars(vrs_cols), dplyr::any_vars(!is.na(.))) %>%
      dplyr::mutate(PWSSWGT = PWSSWGT %>%
                      trimws() %>%
                      as.numeric() %>%
                      magrittr::divide_by(10000)) %>%
      dplyr::mutate_at(dplyr::vars(dplyr::matches("HRYEAR")),
                       ~ifelse(as.numeric(.) < 1900, as.numeric(.) + 1900, as.numeric(.)))
    
    # rename df cols with the new names from the catalog
    colnames(df) <- columns$new_col
  }
  
  message(year, " file read")
  
  return(df)
}

#####################################
#####  READ_YEAR FUNCTION ENDS HERE #
#####################################


#' Read in CPS data
#' @description Load data from the Current Population Survey
#' @param data_dir The folder where the CPS data files live. These files should  
#' follow a naming scheme that contains the 4-digit year of the results in 
#' question, and have a ".zip" or ".gz" extension.
#' @param years Which years to read in.
#' @param factored Whether the data (in numeric form) should be converted to 
#' the equivalent factor values or not. This will also rename columns according 
#' to the `catalog` argument.
#' #' @param catalog Which columns to read, and how to assign factor labels. The 
#' default value is "default", which reads from the list `cpsvote:::fwf_key`.
#' @param join_dfs Whether to combine all of the years into a single data frame, 
#' or leave them as a list of data frames. This will default to the value of 
#' `factored`, because the raw column names represent different questions in 
#' different years and should not be naively joined otherwise.
#' @param combine_factors Whether to merge the changing factor levels over time 
#' into one consistent set of factors. This will default to the value of 
#' `join_dfs`, and is only set up for the default data on the complete set of 
#' years (even-numbered years from 1994-2018).
#' @export
read_cps <- function(data_dir = "cps_data", 
                     years = seq(1994, 2018, 2),  
                     factored = TRUE, 
                     catalog = "default",
                     join_dfs = factored, 
                     combine_factors = join_dfs) {
  
  # sanitize inputs #####
  
  # years must be numeric
  if (!is.numeric(years)) stop('Argument "years" must be numeric')
  
  # and also not have NAs
  years <- years[!is.na(years)]
  
  # years must be from 1994 onwards
  if (any(years < 1994)) {
    warning(paste0("Currently, this package only supports years from 1994 onwards. The remaining years listed (",
                   paste(years[years >= 1994], collapse = ", "),
                   ") will be loaded."),
            immediate. = T)
    years <- years[years >= 1994]
  }
  
  # years must be before 2020
  if (any(years > 2018)) {
    warning(paste0("The Census Bureau has not yet released CPS data for years after 2018. The remaining years listed (",
                   paste(years[years <= 2018], collapse = ", "),
                   ") will be loaded."),
            immediate. = T)
    years <- years[years <= 2018]
  }
  
  # years must be in survey coverage zone
  if (!all(years %in% seq(1964, 2018, 2))) {
    warning(paste0("The VRS was not conducted in the following years: ",
                   paste(years[!(years %in% seq(1964, 2018, 2))], collapse = ", "),
                   ". The remaining years listed (",
                   paste(years[years %in% seq(1964, 2018, 2)], collapse = ", "),
                   ") will be loaded."),
            immediate. = T)
    years <- years[years %in% seq(1964, 2018, 2)]
  }
  
  # if they're all gone, stop
  if (length(years) == 0) {
    message("No years loaded")
    return()
  }
  
  if (factored == F & join_dfs == TRUE) {
    warning("Column meanings change across years, so joining without factoring is inadvisable. ",
            "Setting `join_dfs = FALSE`...",
            immediate. = T)
    join_dfs <- FALSE
  }
  
  if (length(years) == 1 & join_dfs == TRUE) {
    warning("Cannot join only one data frame. ",
            "Setting `join_dfs = FALSE`...",
            immediate. = T)
    join_dfs <- FALSE
  }
  
  if ((factored == F | join_dfs == F) & combine_factors == T) {
    warning("Factor levels must be present (`factored = TRUE`) ", 
            "and in the same data set (`join_dfs = TRUE`) to combine. ", 
            "Setting `combine_factors = FALSE`...",
            immediate. = T)
    combine_factors <- FALSE
  }
  
  if ((!setequal(years, seq(1994, 2018, 2)) | catalog != "default") & combine_factors == TRUE) {
    warning("`combine_factors` is only set up when all years are present and the default catalog is used. ", 
            "Setting `combine_factors = FALSE`...",
            immediate. = T)
    combine_factors <- FALSE
  }
  
  # download data, define files and factors #####
  
  download_data(path = data_dir, years = years, overwrite = FALSE)

  message("Reading ", length(years), " data file(s)...")
  
  # list all the files in the directory to read from
  file_list <- list.files(data_dir, full.names = TRUE) %>%
    stringr::str_subset(paste(years, collapse = "|")) %>%
    stringr::str_subset("\\.(zip|gz)$")
  
  
  
  # read in the data #####
  all_years_list <- mapply(FUN = read_year, 
                      file = file_list,
                      year = years, 
                      MoreArgs = list(catalog = catalog, 
                                      factored = factored),
                      SIMPLIFY = FALSE
  )
  # single-year calls spit out a list, but we want a df
  if(length(all_years_list) == 1) all_years_list <- all_years_list[[1]]
  # name the list elements with the year they represent
  if (!is.data.frame(all_years_list)) names(all_years_list) <- years
  
  if(join_dfs == TRUE) {
    all_years <- suppressWarnings(dplyr::bind_rows(all_years_list, .id = "file"))
    if(combine_factors == TRUE) {
      # combine all the factors, pretty manually
      all_years <- dplyr::transmute(all_years,
                               # file name
                               file,
                               # year of survey
                               CPS_YEAR,
                               # state
                               CPS_STATE,
                               # county
                               CPS_COUNTY,
                               # age
                               CPS_AGE = as.numeric(CPS_AGE),
                               # sex
                               CPS_SEX = toupper(CPS_SEX) %>% factor(),
                               # education
                               CPS_EDU = toupper(CPS_EDU) %>% 
                                 factor(levels = c("LESS THAN 1ST GRADE",
                                                   "1ST, 2ND, 3RD OR 4TH GRADE",
                                                   "5TH OR 6TH GRADE",
                                                   "7TH OR 8TH GRADE",
                                                   "9TH GRADE",
                                                   "10TH GRADE",
                                                   "11TH GRADE",
                                                   "12TH GRADE NO DIPLOMA",
                                                   "HIGH SCHOOL GRAD-DIPLOMA OR EQUIV (GED)",
                                                   "SOME COLLEGE BUT NO DEGREE",
                                                   "ASSOCIATE DEGREE-OCCUPATIONAL/VOCATIONAL",
                                                   "ASSOCIATE DEGREE-ACADEMIC PROGRAM",
                                                   "BACHELOR'S DEGREE (EX: BA, AB, BS)",
                                                   "MASTER'S DEGREE (EX: MA, MS, MENG, MED, MSW)",
                                                   "PROFESSIONAL SCHOOL DEG (EX: MD, DDS, DVM)",
                                                   "DOCTORATE DEGREE (EX: PHD, EDD)"),
                                        ordered = TRUE),
                               # race
                               CPS_RACE = toupper(CPS_RACE),
                               CPS_RACE_C = CPS_RACE %>%
                                 factor() %>%
                                 forcats::fct_collapse(
                                   "WHITE" = c("WHITE",
                                               "WHITE ONLY"),
                                   "BLACK" = c("BLACK",
                                               "BLACK ONLY"),
                                   "ASIAN OR PACIFIC ISLANDER" = c("ASIAN OR PACIFIC ISLANDER",
                                                                   "HAWAIIAN/PACIFIC ISLANDER ONLY",
                                                                   "ASIAN ONLY", 
                                                                   "ASIAN-HP"),
                                   "AMERICAN INDIAN OR ALASKAN NATIVE" = c("AMERICAN INDIAN, ALEUT, ESKIMO",
                                                                           "AMERICAN INDIAN, ALASKAN NATIVE ONLY"),
                                   "MULTIRACIAL OR OTHER" = c("OTHER - SPECIFY", "WHITE-AI", "WHITE-ASIAN", "WHITE-BLACK", "W-B-AI", "BLACK-ASIAN", "BLACK-AI", 
                                                              "WHITE-HAWAIIAN", "W-A-HP", "2 OR 3 RACES", "AI-ASIAN", 
                                                              "W-AI-A", "4 OR 5 RACES", "BLACK-HP", "W-B-A", "W-B-AI-A", "WHITE-HP", 
                                                              "AI-HP", "OTHER 4 AND 5 RACE COMBINATIONS", "W-B-HP", "W-AI-HP", 
                                                              "OTHER 3 RACE COMBINATIONS", "W-AI-A-HP", "B-AI-A")
                                 ),
                               # hispanic status - correct typo
                               CPS_HISP = toupper(CPS_HISP) %>%
                                 factor(levels = c("NON-HIPSANIC", "HISPANIC", "NON-HISPANIC"),
                                        labels = c("NON-HISPANIC", "HISPANIC", "NON-HISPANIC")),
                               # weight
                               WEIGHT,
                               
                               # voted in recent general election
                               VRS_VOTE = forcats::fct_relabel(VRS_VOTE, toupper),
                               # if not, why?
                               VRS_VOTE_WHYNOT = toupper(VRS_VOTE_WHYNOT),
                               VRS_VOTE_WHYNOT_C = factor(VRS_VOTE_WHYNOT) %>%
                                 forcats::fct_collapse("SICK, DISABLED, OR FAMILY EMERGENCY" = c("ILLNESS OR DISABILITY (OWN OR FAMILY'S)",
                                                                                                 "SICK, DISABLED, OR FAMILY EMERGENCY"),
                                                       "OUT OF TOWN OR AWAY FROM HOME" = c("OUT OF TOWN OR AWAY FROM HOME"),
                                                       "FORGOT TO VOTE" = c("FORGOT TO VOTE",
                                                                            "FORGOT TO VOTE (OR SEND IN ABSENTEE BALLOT)"),
                                                       "NOT INTERESTED" = c("NOT INTERESTED, DON'T CARE, ETC.",
                                                                            "NOT INTERESTED, FELT MY VOTE WOULDN'T MAKE A DIFFERENCE"),
                                                       "SCHEDULE PROBLEMS" = c("COULD NOT TAKE TIME OFF FROM WORK/SCHOOL/TOO BUSY",
                                                                               "TOO BUSY, CONFLICTING WORK OR SCHOOL SCHEDULE"),
                                                       "TRANSPORTATION PROBLEMS" = c("HAD NO WAY TO GET TO POLLS",
                                                                                     "TRANSPORTATION PROBLEMS"),
                                                       "DIDN'T LIKE CANDIDATES OR CAMPAIGN ISSUES" = c("DID NOT PREFER ANY OF THE CANDIDATES",
                                                                                                       "DIDN'T LIKE CANDIDATES OR CAMPAIGN ISSUES"),
                                                       "REGISTRATION PROBLEMS" = c("REGISTRATION PROBLEMS (I.E., DIDN'T RECEVIE ABSENTEE BALLOT, NOT REGISTERED IN CURRENT LOCATION)",
                                                                                   "REGISTRATION PROBLEMS (I.E., DIDN'T RECEIVE ABSENTEE BALLOT, NOT REGISTERED IN CURRENT LOCATION)",
                                                                                   "REGISTRATION PROBLEMS (I.E. DIDN'T RECEIVE ABSENTEE BALLOT, NOT REGISTERED IN CURRENT LOCATION)"),
                                                       "BAD WEATHER CONDITIONS" = c("BAD WEATHER CONDITIONS"),
                                                       "INCONVENIENT HOURS OR LONG LINES" = c("LINES TOO LONG AT POLLS",
                                                                                              "INCONVENIENT POLLING PLACE OR HOURS OR LINES TOO LONG",
                                                                                              "INCONVENIENT HOURS, POLLING PLACE OR HOURS OR LINES TOO LONG"),
                                                       "OTHER" = c("OTHER REASONS",
                                                                   "OTHER")
                                 ),
                               # how did you vote? in person, early, absentee
                               VRS_VOTE_HOW = forcats::fct_relabel(VRS_VOTE_HOW, toupper),
                               # did you vote by mail or in person?
                               VRS_VOTE_MAIL = forcats::fct_relabel(VRS_VOTE_MAIL, toupper),
                               # did you vote day of or early?
                               VRS_VOTE_DAY = forcats::fct_relabel(VRS_VOTE_DAY, toupper),
                               # collapse these
                               VRS_VOTE_HOW_C = dplyr::case_when(
                                 VRS_VOTE_HOW == "IN PERSON ON ELECTION DAY" ~ "ELECTION DAY",
                                 VRS_VOTE_HOW == "VOTED BY MAIL (ABSENTEE)" ~ "MAIL",
                                 VRS_VOTE_HOW == "IN PERSON BEFORE ELECTION DAY" ~ "EARLY",
                                 VRS_VOTE_MAIL == "BY MAIL" ~ "MAIL",
                                 VRS_VOTE_MAIL == "IN PERSON" & VRS_VOTE_DAY == "BEFORE ELECTION DAY" ~ "EARLY",
                                 VRS_VOTE_MAIL == "IN PERSON" & VRS_VOTE_DAY == "ON ELECTION DAY" ~ "ELECTION DAY"
                               ) %>% factor(),
                               # when in the day did you vote?
                               VRS_VOTE_TIME,
                               
                               # registered to vote
                               VRS_REG = forcats::fct_relabel(VRS_REG, toupper),
                               # if not, why?
                               VRS_REG_WHYNOT = forcats::fct_relabel(VRS_REG_WHYNOT, toupper),
                               # how did you register?
                               VRS_REG_HOW = toupper(VRS_REG_HOW),
                               VRS_REG_DMV = forcats::fct_relabel(VRS_REG_DMV, toupper),
                               VRS_REG_HOW_C = dplyr::case_when(
                                 VRS_REG_DMV == "WHEN DRIVER'S LICENSE WAS OBTAINED/RENEWED" ~ "AT A DEPARTMENT OF MOTOR VEHICLES (FOR EXAMPLE, WHEN OBTAINING A DRIVER'S LICENSE OR OTHER IDENTIFICATION CARD)",
                                 VRS_REG_DMV == "DON'T KNOW" ~ "DON'T KNOW",
                                 TRUE ~ VRS_REG_HOW
                               ) %>% factor() %>%
                                 forcats::fct_collapse("AT DMV" = c("AT A DEPARTMENT OF MOTOR VEHICLES (FOR EXAMPLE, WHEN OBTAINING A DRIVER'S LICENSE OR OTHER IDENTIFICATION CARD)"),
                                                       "AT A PUBLIC ASSISTANCE AGENCY" = c("AT A PUBLIC ASSISTANCE AGENCY (FOR EXAMPLE, MEDICAID, AFDC, OR FOOD STAMP UNEMPLOYMENT OFFICE, OFFICE SERVING DISABLED PERSONS)",
                                                                                           "AT A PUBLIC ASSISTANCE AGENCY (FOR EXAMPLE, MEDICAID, AFDC, OR FOOD STAMPS OFFICE, AN OFFICE SERVING DISABLED PERSONS, OR AN UNEMPLOYMENT OFFICE)",
                                                                                           "AT A PUBLIC ASSISTANCE AGENCY (FOR EXAMPLE, A MEDICAID, AFDC, OR FOOD STAMPS OFFICE, AN OFFICE SERVING DISABLED PERSONS, OR AN UNEMPLOYMENT OFFICE",
                                                                                           "AT A PUBLIC ASSISTANCE AGENCY (FOR EXAMPLE, A MEDICAID, AFDC, OR FOOD STAMPS OFFICE, AN OFFICE SERVING DISABLED PERSONS, OR AN UNEMPLOYMENT OFFICE)"),
                                                       "BY MAIL" = c("MAILED IN FORM TO ELECTIONS OFFICE",
                                                                     "REGISTERED BY MAIL"),
                                                       "ONLINE" = c("REGISTERED USING THE INTERNET OR ONLINE"),
                                                       "AT A SCHOOL, HOSPITAL, OR ON CAMPUS" = c("AT A SCHOOL, HOSPITAL, OR ON CAMPUS"),
                                                       "REGISTRATION OFFICE" = c("WENT TO A COUNTY OR GOVERNMENT VOTER REGISTRATION OFFICE",
                                                                                 "WENT TO A TOWN HALL OR COUNTY/GOVERNMENT REGISTRATION OFFICE"),
                                                       "REGISTRATION DRIVE" = c("FILLED OUT FORM AT A REGISTRATION DRIVE (FOR EXAMPLE, POLITICAL RALLY, SOMEONE CAME TO YOUR DOOR, REGISTRATION DRIVE AT MALL, MARKET, FAIR, POST OFFICE, LIBRARY, STORE, CHURCH, ETC.)",
                                                                                "FILLED OUT FORM AT A REGISTRATION DRIVE (LIBRARY, POST OFFICE, OR SOMEONE CAME TO YOUR DOOR)"),
                                                       "AT THE POLLS, SAME DAY" = c("REGISTERED AT THE POLLS ON ELECTION DAY",
                                                                                    "REGISTERED AT POLLINGPLACE (ON ELECTION OR PRIMARY DAY)",
                                                                                    "REGISTERED AT POLLING PLACE (ON ELECTION OR PRIMARY DAY)"),
                                                       "OTHER" = c("OTHER PLACE/WAY",
                                                                   "OTHER"),
                                                       "DON'T KNOW" = c("DON'T KNOW")
                                 ),
                               VRS_REG_SINCE95,
                               
                               # how long lived in current home
                               VRS_RESIDENCE = toupper(VRS_RESIDENCE),
                               VRS_RESIDENCE_C = factor(VRS_RESIDENCE,
                                                        levels = c("LESS THAN 1 MONTH",
                                                                   "1-6 MONTHS",
                                                                   "7-11 MONTHS",
                                                                   "LESS THAN 1 YEAR",
                                                                   "1-2 YEARS",
                                                                   "3-4 YEARS",
                                                                   "5 YEARS OR LONGER",
                                                                   "DON'T KNOW"),
                                                        labels = c("LESS THAN 1 YEAR",
                                                                   "LESS THAN 1 YEAR",
                                                                   "LESS THAN 1 YEAR",
                                                                   "LESS THAN 1 YEAR",
                                                                   "1-2 YEARS",
                                                                   "3-4 YEARS",
                                                                   "5 YEARS OR LONGER",
                                                                   "DON'T KNOW"),
                                                        ordered = TRUE)
      )
    }
    final_data <- all_years
  } else {
    final_data <- all_years_list
  }
  
  return(final_data)
}
