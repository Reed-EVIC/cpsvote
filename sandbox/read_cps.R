#' read in CPS data
#' @param directory
#' @param years
#' @param factored
#' @param factor_list
#' @param join_dfs
#' @export
read_cps <- function(directory, years = seq(1994, 2018, 2), factored = TRUE, 
                     catalog = "default", join_dfs = c("cleaned", "raw", "list")) {
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
  
}

# helper
fips <- tigris::fips_codes %>%
  dplyr::select(dplyr::starts_with('state')) %>%
  dplyr::distinct() %>%
  dplyr::filter(state_code < 57) %>%
  dplyr::transmute(year = years[stringr::str_detect(file, as.character(years))] %>%
                     as.character(),
                   var = "GESTFIPS",
                   code = as.numeric(state_code),
                   value = state)

# lapply helper for the helper
col_refactor <- function(fct_col) {
  # filter down the factoring lookup to only be what we need
  factors <- dplyr::filter(factoring,
                           year == yr,
                           var == fct_col)
  
  # make the factors do their thing
  df[[fct_col]] <<- factor(df[[fct_col]], 
                           levels = factors$value, 
                           ordered = fct_col %in% ordered_cols)
}

# helper
read_year <- function(file) {
  yr <- years[stringr::str_detect(file, as.character(years))]
  columns <- catalog$columns %>%
    dplyr::filter(year == yr)
  
  col_names <- columns$orig_col
  factor_cols <- col_names[columns$type == "factor"]
  ordered_cols <- col_names[stringr::str_detect(columns$notes, "ordered")] %>%
    magrittr::extract(!is.na(.))
  unordered_cols <- setdiff(factor_cols, ordered_cols)
  
  df <- readr::read_fwf(file, readr::fwf_positions(start = columns$start,
                                                   end = columns$end,
                                                   col_names = col_names))
  
  factoring <- dplyr::filter(catalog$factoring, year == yr) %>%
    dplyr::mutate(code = as.numeric(code)) %>%
    dplyr::bind_rows(fips)
  
  if (factored) {
    
    df <- df %>%
      dplyr::mutate(index = dplyr::row_number()) %>%
      tidyr::gather(key = "column", value = "answer", -index) %>%
      dplyr::left_join(factoring, by = c("column" = "var", "answer" = "code")) %>%
      dplyr::transmute(index,
                       column,
                       answer = ifelse(!is.na(value), value, answer)) %>%
      tidyr::spread(key = "column", value = "answer") %>%
      dplyr::select(col_names)
    
    invisible(lapply(factor_cols, col_refactor))
    
    vrs_cols <- stringr::str_subset(col_names, "^P(E|R)S\\d$")
    
    df <- df %>%
      dplyr::mutate(PWSSWGT = trimws(PWSSWGT),
                    HRYEAR = as.numeric(HRYEAR)) %>%
      dplyr::mutate_if(is.factor, forcats::fct_collapse,
                       NULL = c(
                         "Refused",
                         "No response (N/A)"
                       )) %>%
      dplyr::na_if(-1) %>%
      dplyr::mutate(HRYEAR = ifelse(HRYEAR < 1900, HRYEAR + 1900, as.numeric(HRYEAR)),
                    PEAGE = as.numeric(PEAGE) %>% replace(. < 0, NA),
                    PWSSWGT = as.numeric(PWSSWGT) / 10000) %>%
      dplyr::filter_at(dplyr::vars(vrs_cols), dplyr::any_vars(!is.na(.)))
    
    colnames(df) <- columns$new_col
  }
  
  return(df)
}
