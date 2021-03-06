% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cps_label.R
\name{cps_label}
\alias{cps_label}
\title{Apply factor levels to raw CPS data}
\usage{
cps_label(
  data,
  factors = cpsvote::cps_factors,
  names_col = "new_name",
  na_vals = c("-1", "BLANK", "NOT IN UNIVERSE"),
  expand_year = TRUE,
  rescale_weight = TRUE,
  toupper = TRUE
)
}
\arguments{
\item{data}{The raw CPS data that factors should be applied to}

\item{factors}{A data frame containing the label codes to be applied}

\item{names_col}{Which column of \code{factors} contains the column names of \code{data}}

\item{na_vals}{Which character values should be considered "missing" across
the dataset and be set to NA after labelling}

\item{expand_year}{Whether to change the two-digit year listed in earlier surveys
(94, 96) into a four-digit year (1994, 1996)}

\item{rescale_weight}{Whether to rescale the weight, dividing by 10,000. The
CPS describes the given weight as having "four implied decimals", so this
rescaling adjusts the weight to produce sensible population totals.}

\item{toupper}{Whether to convert all factor levels to uppercase}
}
\value{
CPS data with factor labels in place of the raw numeric data
}
\description{
The CPS publishes their data in a numeric format, with a separate
PDF codebook (not machine readable) describing factor values. This function
labels the raw numeric CPS data according to a supplied factor key. Codes
that appear in a given year and are not included in \code{factors} will be
recoded as \code{NA}.
}
\examples{
cps_label(cps_2016_10k)

}
