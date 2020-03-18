#' Load a single CPS file
#' @description Read one year of data from the Current Population Survey
#' 
#' @param file Where the fixed-width or zip/gz file for this year's data lives
#' @param cols Which columns to read. This must be a data frame, with required 
#' columns `start_pos` and `end_pos`. The default value is `cps_cols`, which 
#' reads from the list `cpsvote::cps_cols`. See \url{vignettes/read_specs.html} for 
#' details about how to specify a different set of `cols`.
#' @param names_col The column in `cols` that contains column names for the 
#' specified columns. If none exists, use `names_col = NULL`
#' @param year Which year is being read; defaults to 4-digit year in file name
#' 
#' @return a data frame, with dimensions depending on the year and columns specified
#' @export
read_year <- function(file,
                      cols = cpsvote::cps_cols,
                      names_col = "new_name",
                      year = as.numeric(stringr::str_extract(file, "\\d{4}"))) {
  # error messages, sanitize data ----
  
  # enforce cols is a df, and contains start_pos and end_pos as needed
  if (!is.data.frame(cols)) stop("`cols` must be a data frame.")
  if (!is.numeric(cols$start_pos)) stop("`cols` must contain a integer column `start_pos`.")
  if (!is.numeric(cols$end_pos)) stop("`cols` must contain a integer column `end_pos`.")
  
  # if `year` column exists but no valid year was supplied, default to first value
  if ("year" %in% colnames(cols)) {
    if (is.null(year) | isTRUE(is.na(year)) | isFALSE(year %in% cols$year)) {
      warning("Supplied argument `year` was not found in `cols$year`. Defaulting to use the first value of `cols$year`.")
      year <- cols$year[1]
    }
  }
  
  # if the given names_col isn't in cols, break
  if (isFALSE(names_col %in% colnames(cols))) stop("Column `", names_col, "` not found in `cols`")
  
  # filter cols down to the given year
  cols <- cols[cols$year == year, ]
  
  # initialize an error collecting vector
  wrong_rows <- numeric()
  
  # if any of the column positions are negative, drop that row
  if(!all((cols$start_pos >= 1 & cols$end_pos >= 1) %in% TRUE)) {
    wrong_rows <- which(!((cols$start_pos >= 1 & cols$end_pos >= 1) %in% TRUE))
    warning("All positions must be at least 1.")
  }
  
  # if any of the column positions are NA or out of order, drop that row
  if(!all((cols$start_pos <= cols$end_pos) %in% TRUE)) {
    wrong_rows <- c(wrong_rows, which(!((cols$start_pos <= cols$end_pos) %in% TRUE)))
    warning("Entries for `cols$start_pos` must be less than or equal to `cols$end_pos`.")
  }
  
  # remove any rows that break the rules
  if (length(wrong_rows) > 0) {
    wrong_rows <- sort(unique(wrong_rows))
    warning(paste("The following rows of `cols` will not be read:",
                  paste(wrong_rows, collapse = ", ")))
    cols <- cols[-wrong_rows, ]
  }
  
  # read data ----
  
  # unzip bc 2018 breaks unless first unzipped
  # also this is loads faster than unzipping within read_fwf
  if(tools::file_ext(file) %in% c('gz', 'zip')) {
    old_file <- file
    temp <- tempfile()
    utils::unzip(file, exdir = temp)
    file <- list.files(temp, full.names = TRUE)
  }
  
  # read the data
  df <- suppressMessages(readr::read_fwf(
    file, 
    readr::fwf_positions(
      start = cols$start_pos,
      end = cols$end_pos,
      col_names = cols[[names_col]]
      ),
    col_types = paste0(rep("i", nrow(cols)), collapse = "") 
    # read everything as an integer - this will turn 01 FIPS into 1
    )
    )
  
  # if unzipped, drop the temp file
  if(exists("old_file")) {
    rm(temp)
  }
  
  # print status
  message(year, " file read")
  
  # return object
  return(df)
}



#' Read in CPS data
#' @description Load multiple years of data from the Current Population Survey
#' 
#' @param dir The folder where the CPS data files live. These files should  
#' follow a naming scheme that contains the 4-digit year of the results in 
#' question, and have a ".zip" or ".gz" extension.
#' @param years Which years to read in. Thie function will read data from files 
#' in `dir` whose names contain these 4-digit years.
#' @param cols Which columns to read. This must be a data frame, with required 
#' columns `start_pos`,`end_pos`, and `year`. The default value is `cps_cols`, 
#' which reads from the list `cpsvote::cps_cols`. See \url{vignettes/read_specs.html} 
#' for details about how to specify a different set of `cols`.
#' @param names_col The column in `cols` that contains column names for the 
#' specified columns. If none exists, use `names_col = NULL`
#' @param join_dfs Whether to combine all of the years into a single data frame, 
#' or leave them as a list of data frames. Defaults to `TRUE` with a warning.
#' 
#' @return a data frame, or list of data frames
#' @export
read_cps <- function(dir = "cps_data",
                     years = seq(1994, 2018, 2),
                     cols = cpsvote::cps_cols,
                     names_col = "new_name",
                     join_dfs = TRUE) {
  
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
  
  # download data, define files and factors #####
  
  download_data(path = dir, years = years, overwrite = FALSE)

  message("Reading ", length(years), " data file(s)...")
  
  # list all the files in the directory to read from
  file_list <- list.files(dir) %>%
    stringr::str_subset(paste(years, collapse = "|"))
  
  # read in the data #####
  all_years_list <- mapply(FUN = read_year, 
                      file = file.path(dir, file_list),
                      year = years, 
                      MoreArgs = list(cols = cols,
                                      names_col = names_col),
                      SIMPLIFY = FALSE
  )
  
  # name the list elements with their file name inside of the common dir
  names(all_years_list) <- file_list
  
  if (join_dfs == TRUE) {
    if (length(years) > 1) {
      warning("The column names provided by the CPS do not refer to the same question across all years. ",
              "Be cautious that you are joining columns which correspond across years.")
    }
    final_data <- suppressWarnings(dplyr::bind_rows(all_years_list, .id = "FILE"))
  } else {
    final_data <- all_years_list
  }
  
  return(final_data)
}
