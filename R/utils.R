#' Get the cpsvote data directory
#'
#' Returns the path where downloaded CPS data files are stored. The default is
#' `~/cps_data`, which expands to your home directory on any platform.
#'
#' To use a different location persistently, add this to your `.Rprofile`:
#' ```r
#' options(cpsvote.datadir = "~/my/path/to/cps_data")
#' ```
#' Any path set this way will be used automatically by [cps_load_basic()],
#' [cps_read()], and [cps_download_data()] without needing to pass `datadir`
#' each time.
#'
#' @return A character string giving the expanded data directory path.
#' @seealso [cps_load_basic()], [cps_read()], [cps_download_data()]
#' @export
cps_data_dir <- function() {
  path <- getOption("cpsvote.datadir", default = "~/cps_data")
  path.expand(path)
}
