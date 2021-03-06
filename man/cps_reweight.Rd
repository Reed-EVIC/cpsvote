% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_doc.R
\docType{data}
\name{cps_reweight}
\alias{cps_reweight}
\title{Calculations to reweight properly for voter turnout}
\format{
A tibble with 1,326 rows and 6 columns:
\describe{
\item{YEAR}{year}
\item{STATE}{state}
\item{response}{indicator of turnout in recent election}
\item{vep_turnout}{proportion of turnout indicator, calculated by McDonald}
\item{cps_turnout}{proportion of turnout indicator, calculated by CPS}
\item{reweight}{the factor by which to scale original CPS weights}
}
}
\source{
Turnout data from \url{http://www.electproject.org/home/voter-turnout/voter-turnout-data}
}
\usage{
cps_reweight
}
\description{
While the U.S. Census Bureau provides one weight with the CPS, a modified
weight is needed to properly calculate voter turnout. This data set provides
those calculations, according to Hur and Achen (2013). The comparison data
comes from Dr. Michael McDonald's estimates of voter turnout among the
voting-eligible population (VEP). It can be joined with CPS data to
calculate the new weights needed for analysis, using the function
\code{cps_reweight_turnout}.
}
\keyword{datasets}
