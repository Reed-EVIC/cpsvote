#` Load a single CPS file
#' @param file Where the fwf or zip (or gz) file for this year's data lives
#' @param yr Which year is being read; defaults to 4-digit year in file name
#' #' @param factored Whether the data (in numeric form) should be converted to 
#' the equivalent factor values or not. This will also rename columns according 
#' to the `catalog` argument.
#' @param catalog Which columns to read, and how to assign factor labels. The 
#' default value is "default", which reads from the list `cpsvote:::fwf_key`.
#' @export
read_year <- function(file,
                      yr = as.numeric(stringr::str_extract(file, "\\d{4}")),
                      factored = TRUE,
                      catalog = "default") {
  # set the lookup table to use
  if (catalog == "default") {
    catalog <- cpsvote:::fwf_key
  } else if (!is.list(catalog)) {
    warning("Catalog must be 'default' or a list. Defaulting to `catalog = 'default'`...")
    catalog <- cpsvote:::fwf_key
  } else {
    names(catalog) <- c('columns', 'factoring')
  }
  
  # grab the relevant column positions for the given year
  columns <- catalog$columns %>%
    dplyr::filter(year == yr)
  
  # grab which columns are going to be factors, ordered or unordered
  col_names <- columns$orig_col
  factor_cols <- col_names[columns$type == "factor"]
  ordered_cols <- col_names[stringr::str_detect(columns$notes, "ordered")] %>%
    magrittr::extract(!is.na(.))
  unordered_cols <- setdiff(factor_cols, ordered_cols)
  
  # read the actual data in, according to the column positions
  df <- suppressMessages(readr::read_fwf(file, 
                                         readr::fwf_positions(start = columns$start,
                                                              end = columns$end,
                                                              col_names = col_names)))
  
  # get a match for all of the state codes bc I didn't want to put that in the sheet
  fips <- tigris::fips_codes %>%
    dplyr::select(dplyr::starts_with('state')) %>%
    dplyr::distinct() %>%
    dplyr::filter(state_code < 57) %>%
    dplyr::transmute(year = yr %>%
                       as.numeric(),
                     var = "GESTFIPS",
                     code = as.numeric(state_code),
                     value = state)
  
  # get this year's factoring labels, attach the state codes
  factoring <- dplyr::filter(catalog$factoring, year == yr) %>%
    dplyr::mutate(code = as.numeric(code),
                  year = as.numeric(year)) %>%
    dplyr::bind_rows(fips)
  
  # replace numbers with factor labels
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
                               year == yr,
                               var == name)
      # factor the column with the labels, ordered status
      df[[name]] <- factor(df[[name]], 
                           levels = factors$value, 
                           ordered = name %in% ordered_cols)
    }
    
    # identify which columns are VRS specific
    vrs_cols <- stringr::str_subset(col_names, "^P(E|R)S\\d$")
    
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
  
  message(yr, " file read")
  
  return(df)
}



#' Read in CPS data
#' @description Load data from the Current Population Survey
#' @param data_dir The folder where the CPS data files live. These files must 
#' follow a naming scheme that contains the 4-digit year of the results in 
#' question, and have a ".zip" extension.
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
#' @param clean_data
#' @export
read_cps <- function(data_dir, years = seq(1994, 2018, 2),  
                     factored = TRUE, 
                     catalog = "default",
                     join_dfs = factored, 
                     clean_data = TRUE) {
  
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
  
  download_data(path = data_dir, years = years, overwrite = FALSE)

  message("Reading ", length(years), " data file(s)...")
  
  # list all the files in the directory to read from
  file_list <- list.files(data_dir, full.names = TRUE) %>%
    stringr::str_subset(paste(years, collapse = "|")) %>%
    stringr::str_subset("\\.(zip|gz)$")

  
  
  # read in the data #####
  all_years <- mapply(FUN = read_year, 
                      file = file_list,
                      yr = years, 
                      MoreArgs = list(catalog = catalog, 
                                      factored = factored)
  )
  
  names(all_years) <- years
  
  return(all_years)
}
