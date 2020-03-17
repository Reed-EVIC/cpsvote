#' Calculations to reweight properly for voter turnout
#' 
#' While the U.S. Census Bureau provides one weight with the CPS, a modified 
#' weight is needed to properly calculate voter turnout. This data set provides 
#' those calculations, according to Achen and Hur (2013). The comparison data 
#' comes from Dr. Michael McDonald's estimates of voter turnout among the 
#' voting-eligible population (VEP). It can be joined with CPS data to 
#' calculate the new weights needed for analysis.
#' @format A tibble with 1,326 rows and 6 columns:
#' \describe{
#' \item{CPS_YEAR}{year}
#' \item{CPS_STATE}{state}
#' \item{VRS_VOTE}{indicator of turnout in recent election}
#' \item{cps_prop}{proportion of turnout indicator, calculated with CPS}
#' \item{vep_prop}{proportion of turnout indicator, calculated by McDonald}
#' \item{REWEIGHT}{the factor by which to scale original CPS weights}
#' }
#' @source Turnout data from \url{http://www.electproject.org/home/voter-turnout/voter-turnout-data}
"reweight"