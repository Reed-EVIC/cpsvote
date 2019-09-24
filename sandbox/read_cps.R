#' read in CPS data
#' @param directory The folder where the CPS data files live. These files must 
#' follow a naming scheme that contains the 4-digit year of the results in 
#' question, and have a ".zip" extension.
#' @param years Which years to read in.
#' @param factored Whether the data (in numeric form) should be converted to 
#' the equivalent factor values or not. This will also rename columns according 
#' to the `catalog` argument.
#' @param catalog Which columns to read, and how to assign factor labels. The 
#' default value is "default", which reads from the list `cpsvote:::fwf_key`.
#' @param join_dfs
#' @param clean_data
#' @export
read_cps <- function(directory, years = seq(1994, 2018, 2), 
                     factored = TRUE, 
                     catalog = "default", 
                     join_dfs = TRUE, 
                     clean_data = TRUE) {
  # create encompassing environment to store variables across functions
  big_env <- new.env()
  
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
  
  download_data(path = directory, years = years, overwrite = FALSE)
  
  file_list <- list.files(directory, full.names = TRUE) %>%
    stringr::str_subset(paste(years, collapse = "|")) %>%
    stringr::str_subset("\\.zip$")
  
  
  
  if (catalog == "default") {
    catalog <- cpsvote:::fwf_key
  } else if (!is.list(catalog)) {
    warning("Catalog must be 'default' or a list. Defaulting to `catalog = 'default'`...")
    catalog <- cpsvote:::fwf_key
  } else {
    names(catalog) <- c('columns', 'factoring')
  }
  
  
  # read in the data #####
  all_years <- lapply(file_list, read_year)
}

# lapply helper for the helper
col_refactor <- function(fct_col) {
  # filter down the factoring lookup to only be what we need
  factors <- dplyr::filter(big_env$factoring,
                           year == big_env$yr,
                           var == fct_col)
  
  # make the factors do their thing
  big_env$df[[fct_col]] <<- factor(big_env$df[[fct_col]], 
                           levels = factors$value, 
                           ordered = fct_col %in% big_env$ordered_cols)
}

pad_county <- function(vec) {
  stringr::str_pad(vec, width = 3, side = "left", pad = "0")
}


# helper
read_year <- function(file) {
  big_env$yr <- years[stringr::str_detect(file, as.character(years))]
  columns <- catalog$columns %>%
    dplyr::filter(year == big_env$yr)
  
  col_names <- columns$orig_col
  factor_cols <- col_names[columns$type == "factor"]
  big_env$ordered_cols <- col_names[stringr::str_detect(columns$notes, "ordered")] %>%
    magrittr::extract(!is.na(.))
  unordered_cols <- setdiff(factor_cols, big_env$ordered_cols)
  
  big_env$df <- suppressMessages(readr::read_fwf(file, 
                                                 readr::fwf_positions(start = columns$start,
                                                                      end = columns$end,
                                                                      col_names = col_names)))
  
  fips <- tigris::fips_codes %>%
    dplyr::select(dplyr::starts_with('state')) %>%
    dplyr::distinct() %>%
    dplyr::filter(state_code < 57) %>%
    dplyr::transmute(year = years[stringr::str_detect(file, as.character(years))] %>%
                       as.numeric(),
                     var = "GESTFIPS",
                     code = as.numeric(state_code),
                     value = state)
  
  big_env$factoring <- dplyr::filter(catalog$factoring, year == big_env$yr) %>%
    dplyr::mutate(code = as.numeric(code),
                  year = as.numeric(year)) %>%
    dplyr::bind_rows(fips)
  
  if (factored) {
    
    big_env$df <- big_env$df %>%
      dplyr::mutate(index = dplyr::row_number()) %>%
      tidyr::gather(key = "column", value = "answer", -index) %>%
      dplyr::mutate(answer = as.numeric(answer)) %>%
      dplyr::left_join(big_env$factoring, by = c("column" = "var", "answer" = "code")) %>%
      dplyr::transmute(index,
                       column,
                       answer = ifelse(!is.na(value), value, answer)) %>%
      tidyr::spread(key = "column", value = "answer") %>%
      dplyr::select(col_names)
    
    if (!any(stringr::str_detect(big_env$factoring$var, "^G(E|T)CO$"))) {
      big_env$df <- big_env$df %>%
        dplyr::mutate_at(stringr::str_subset(factor_cols, "^G(E|T)CO$"), pad_county)
      factor_cols <- factor_cols[!stringr::str_detect(factor_cols, "^G(E|T)CO$")]
    }
    
    invisible(lapply(factor_cols, col_refactor))
    
    vrs_cols <- stringr::str_subset(col_names, "^P(E|R)S\\d$")
    
    big_env$df <- big_env$df %>%
      # dplyr::mutate(PWSSWGT = trimws(PWSSWGT),
      #               HRYEAR = as.numeric(HRYEAR)) %>%
      dplyr::mutate_if(is.factor, forcats::fct_collapse,
                       NULL = c(
                         "Refused",
                         "No response (N/A)"
                       )) %>%
      dplyr::na_if(-1) %>%
      # dplyr::mutate(HRYEAR = ifelse(HRYEAR < 1900, HRYEAR + 1900, as.numeric(HRYEAR)),
      #               PEAGE = as.numeric(PEAGE) %>% replace(. < 0, NA),
      #               PWSSWGT = as.numeric(PWSSWGT) / 10000) %>%
      dplyr::filter_at(dplyr::vars(vrs_cols), dplyr::any_vars(!is.na(.)))
    
    colnames(big_env$df) <- columns$new_col
  } else {
    colnames(big_env$df) <- columns$orig_col
  }
  
  message(big_env$yr, " file read")
  
  return(big_env$df)
}
