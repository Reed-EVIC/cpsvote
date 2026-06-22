#' Download CPS technical documentation
#' 
#' @param path A file path (relative or absolute) where the downloads should go.
#' Defaults to [cps_docs_dir()], which returns `~/cps_docs` unless overridden
#' via `options(cpsvote.docsdir = "your/path")`.
#' @param years Which years of documentation to download. Defaults to all
#' even-numbered years from 1994 to 2024.
#' @param overwrite Logical, whether to write over existing files or not.
#' Defaults to FALSE.
#' @details
#' * File names will be written in the style "cps_nov2024.pdf", with the
#' appropriate years.
#' * The Voting and Registration Supplement is only conducted in even-numbered
#' years (since 1964), so any entry in `years` outside of this will be skipped.
#' * Currently the package only supports downloads from 1994 onwards, so any
#' entry in `years` before 1994 will be skipped.
#' @examples
#' \dontrun{
#' cps_download_docs(years = 2016, overwrite = TRUE)
#' }
#'
#' @export
cps_download_docs <- function(path = cps_docs_dir(),
                          years = seq(1994, 2024, 2),
                          overwrite = FALSE) {
  
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
  
  # years must be before 2024
  if (any(years > 2024)) {
    warning(paste0("The Census Bureau has not yet released CPS data for years after 2024. The remaining years listed (",
                   paste(years[years <= 2024], collapse = ", "),
                   ") will be downloaded."),
            immediate. = T)
    years <- years[years <= 2024]
  }
  
  # years must be in survey coverage zone
  if (!all(years %in% seq(1964, 2024, 2))) {
    warning(paste0("The VRS was not conducted in the following years: ",
                   paste(years[!(years %in% seq(1964, 2024, 2))], collapse = ", "),
                   ". The remaining years listed (",
                   paste(years[years %in% seq(1964, 2024, 2)], collapse = ", "),
                   ") will be downloaded."),
            immediate. = T)
    years <- years[years %in% seq(1964, 2024, 2)]
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
    message("No new documentation files downloaded")
    return()
  } 
  
  url_names <- dplyr::case_when(
    years < 2011 ~ paste0("data.nber.org/cps/cpsnov", stringr::str_sub(years, 3, 4), ".pdf"),
    years < 2017 ~ paste0("data.nber.org/cps/cpsnov", years, ".pdf"),
    years == 2024 ~ paste0("https://www2.census.gov/programs-surveys/cps/techdocs/cpsnov", stringr::str_sub(years, 3, 4), ".pdf"),
    years > 2017 ~ paste0("data.nber.org/cps/cpsnov", stringr::str_sub(years, 3, 4), ".pdf")
  )
  
  # lengthen timeout
  orig_timeout <- getOption("timeout")
  options(timeout = max(300, orig_timeout))
  
  # download file
  # libcurl is corrupting files on Windows
  if (Sys.info()['sysname'] == "Windows") {
    for (i in seq_along(url_names)) {
      utils::download.file(url_names[i], file_names[i], quiet = TRUE, method = "curl")
    }
  } else utils::download.file(url_names, file_names, quiet = TRUE, method = "libcurl")
  
  # reset timeout
  options(timeout = orig_timeout)
  
  message(paste0(length(file_names), " new file(s) downloaded to ", path, 
                 "; year(s) ", paste(years, collapse = ", ")))
  
}


#' Download CPS microdata
#' 
#' @param path A file path (relative or absolute) where the downloads should go.
#' Defaults to [cps_data_dir()], which returns `~/cps_data` unless overridden
#' via `options(cpsvote.datadir = "your/path")`.
#' @param years Which years of data to download. Defaults to all
#' even-numbered years from 1994 to 2024.
#' @param overwrite Logical, whether to write over existing files or not.
#' Defaults to FALSE.
#' @details
#' * File names will be written in the style "cps_nov2024.zip", with the
#' appropriate years.
#' * The Voting and Registration Supplement is only conducted in even-numbered
#' years (since 1964), so any entry in `years` outside of this will be skipped.
#' * Currently the package only supports downloads from 1994 onwards, so any
#' entry in `years` before 1994 will be skipped.
#' @examples
#' \dontrun{
#' cps_download_data(years = 2016, overwrite = TRUE)
#' }
#'
#' @export
cps_download_data <- function(path = cps_data_dir(),
                          years = seq(1994, 2024, 2), 
                          overwrite = FALSE) {
  
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
  
  # years must be before 2024
  if (any(years > 2024)) {
    warning(paste0("The Census Bureau has not yet released CPS data for years after 2024. The remaining years listed (",
                   paste(years[years <= 2024], collapse = ", "),
                   ") will be downloaded."),
            immediate. = T)
    years <- years[years <= 2024]
  }
  
  # years must be in survey coverage zone
  if (!all(years %in% seq(1964, 2024, 2))) {
    warning(paste0("The VRS was not conducted in the following years: ",
                   paste(years[!(years %in% seq(1964, 2024, 2))], collapse = ", "),
                   ". The remaining years listed (",
                   paste(years[years %in% seq(1964, 2024, 2)], collapse = ", "),
                   ") will be downloaded."),
            immediate. = T)
    years <- years[years %in% seq(1964, 2024, 2)]
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
                       paste0("cps_nov", years,".zip"))
  
  # remove years / file names that already exist, if overwrite is FALSE
  if (!overwrite) {
    years <- years[!file.exists(file_names)]
    file_names <- file_names[!file.exists(file_names)]
  }
  
  # if they're all gone, stop
  if (length(years) == 0) {
    message("No new data files downloaded")
    return()
  } 
  
  url_names <- dplyr::case_when(
    years < 2011 ~ paste0("data.nber.org/cps/cpsnov", stringr::str_sub(years, 3, 4), ".zip"),
    years < 2017 ~ paste0("data.nber.org/cps/cpsnov", years, ".zip"),
    years == 2024 ~ paste0("https://www2.census.gov/programs-surveys/cps/datasets/", years, "/supp/nov", stringr::str_sub(years, 3, 4), "pub.zip"),
    years > 2017 ~ paste0("data.nber.org/cps/nov", stringr::str_sub(years, 3, 4), "pub.zip")
  )
  
  # lengthen timeout
  orig_timeout <- getOption("timeout")
  options(timeout = max(300, orig_timeout))
  
  # download file
  utils::download.file(url_names, file_names, quiet = TRUE, method = "libcurl")
  
  # reset timeout
  options(timeout = orig_timeout)
  
  message(paste0(length(file_names), " new file(s) downloaded to ", path, 
                 "; year(s) ", paste(years, collapse = ", ")))
  
}
