#' Download CPS technical documentation
#' 
#' @param path A file path (relative or absolute) where the downloads should go.
#' @param years Which years of documentation to download. Defaults to all 
#' even-numbered years from 1994 to 2018.
#' @param overwrite Logical, whether to write over existing files or not. 
#' Defaults to FALSE.
#' @details 
#' * File names will be written in the style "cps_nov2018.pdf", with the 
#' appropriate years.
#' * The Voting and Registration Supplement is only conducted in even-numbered 
#' years (since 1964), so any entry in `years` outside of this will be skipped.
#' * Currently the package only supports downloads from 1994 onwards, so any 
#' entry in `years` before 1994 will be skipped.
#' @export
download_docs <- function(path, years = seq(1994, 2018, 2), overwrite = FALSE) {
  
  # sanitize inputs #####
  
  # years must be numeric
  if (!is.numeric(years)) stop('Argument "years" must be numeric')
  
  # and also not have NAs
  years <- years[!is.na(years)]
  
  # years must be from 1994 onwards
  if (any(years < 1994)) {
    warning(paste0("Currently, this package only supports years from 1994 onwards. The remaining years listed (",
                   paste(years[years >= 1994], collapse = ", "),
                   ") will be downloaded."),
            immediate. = T)
    years <- years[years >= 1994]
  }
  
  # years must be before 2020
  if (any(years > 2018)) {
    warning(paste0("The Census Bureau has not yet released CPS data for years after 2018. The remaining years listed (",
                   paste(years[years <= 2018], collapse = ", "),
                   ") will be downloaded."),
            immediate. = T)
    years <- years[years <= 2018]
  }
  
  # years must be in survey coverage zone
  if (!all(years %in% seq(1964, 2018, 2))) {
    warning(paste0("The VRS was not conducted in the following years: ",
                   paste(years[!(years %in% seq(1964, 2018, 2))], collapse = ", "),
                   ". The remaining years listed (",
                   paste(years[years %in% seq(1964, 2018, 2)], collapse = ", "),
                   ") will be downloaded."),
            immediate. = T)
    years <- years[years %in% seq(1964, 2018, 2)]
  }
  
  # overwrite must be T/F
  if (!(overwrite %in% c(T, F))) {
    warning("Argument 'overwrite' must be TRUE or FALSE; defaulting to FALSE",
            immediate. = T)
    overwrite <- FALSE
  }
  
  # actually download the relevant files #####
  # create file paths to save docs to
  # controls for if there's a slash at the end or not
  dir.create(path, showWarnings = FALSE)
  file_names <- paste0(path, 
                       ifelse(stringr::str_detect(path, "/$"), "", "/"), 
                       paste0("cps_nov", years, ".pdf"))
  
  # remove years / file names that already exist, if overwrite is FALSE
  if (!overwrite) {
    years <- years[!file.exists(file_names)]
    file_names <- file_names[!file.exists(file_names)]
  }
  
  # if they're all gone, stop
  if (length(years) == 0) {
    message("No documentation files downloaded")
    return()
  } 
  
  url_names <- dplyr::case_when(
    years < 2011 ~ paste0("data.nber.org/cps/cpsnov", stringr::str_sub(years, 3, 4), ".pdf"),
    years < 2017 ~ paste0("data.nber.org/cps/cpsnov", years, ".pdf"),
    years == 2018 ~ "https://www2.census.gov/programs-surveys/cps/techdocs/cpsnov18.pdf"
  )
  
  download.file(url_names, file_names, quiet = TRUE)
  
  message(paste0(length(file_names), " file(s) downloaded to ", path, 
                 ", years ", paste(years, collapse = ", ")))
  
}


#' Download CPS microdata
#' 
#' @param path A file path (relative or absolute) where the downloads should go.
#' @param years Which years of data to download. Defaults to all 
#' even-numbered years from 1994 to 2018.
#' @param overwrite Logical, whether to write over existing files or not. 
#' Defaults to FALSE.
#' @details 
#' * File names will be written in the style "cps_nov2018.zip", with the 
#' appropriate years.
#' * The Voting and Registration Supplement is only conducted in even-numbered 
#' years (since 1964), so any entry in `years` outside of this will be skipped.
#' * Currently the package only supports downloads from 1994 onwards, so any 
#' entry in `years` before 1994 will be skipped.
#' @export
download_data <- function(path, years = seq(1994, 2018, 2), overwrite = FALSE) {
  
  # sanitize inputs #####
  
  # years must be numeric
  if (!is.numeric(years)) stop('Argument "years" must be numeric')
  
  # and also not have NAs
  years <- years[!is.na(years)]
  
  # years must be from 1994 onwards
  if (any(years < 1994)) {
    warning(paste0("Currently, this package only supports years from 1994 onwards. The remaining years listed (",
                   paste(years[years >= 1994], collapse = ", "),
                   ") will be downloaded."),
            immediate. = T)
    years <- years[years >= 1994]
  }
  
  # years must be before 2020
  if (any(years > 2018)) {
    warning(paste0("The Census Bureau has not yet released CPS data for years after 2018. The remaining years listed (",
                   paste(years[years <= 2018], collapse = ", "),
                   ") will be downloaded."),
            immediate. = T)
    years <- years[years <= 2018]
  }
  
  # years must be in survey coverage zone
  if (!all(years %in% seq(1964, 2018, 2))) {
    warning(paste0("The VRS was not conducted in the following years: ",
                   paste(years[!(years %in% seq(1964, 2018, 2))], collapse = ", "),
                   ". The remaining years listed (",
                   paste(years[years %in% seq(1964, 2018, 2)], collapse = ", "),
                   ") will be downloaded."),
            immediate. = T)
    years <- years[years %in% seq(1964, 2018, 2)]
  }
  
  # overwrite must be T/F
  if (!(overwrite %in% c(T, F))) {
    warning("Argument 'overwrite' must be TRUE or FALSE; defaulting to FALSE",
            immediate. = T)
    overwrite <- FALSE
  }
  
  # actually download the relevant files #####
  
  # create file paths to save data to
  # controls for if there's a slash at the end or not
  dir.create(path, showWarnings = FALSE)
  file_names <- paste0(path, 
                       ifelse(stringr::str_detect(path, "/$"), "", "/"), 
                       paste0("cps_nov", years, ".zip"))
  
  # remove years / file names that already exist, if overwrite is FALSE
  if (!overwrite) {
    years <- years[!file.exists(file_names)]
    file_names <- file_names[!file.exists(file_names)]
  }
  
  # if they're all gone, stop
  if (length(years) == 0) {
    message("No data files downloaded")
    return()
  } 
  
  url_names <- dplyr::case_when(
    years < 2011 ~ paste0("data.nber.org/cps/cpsnov", stringr::str_sub(years, 3, 4), ".zip"),
    years < 2017 ~ paste0("data.nber.org/cps/cpsnov", years, ".zip"),
    years == 2018 ~ "thedataweb.rm.census.gov/pub/cps/supps/nov18pub.dat.gz"
  )
  
  download.file(url_names, file_names, quiet = TRUE)
  
  message(paste0(length(file_names), " file(s) downloaded to ", path, 
                 ", years ", paste(years, collapse = ", ")))
  
}
