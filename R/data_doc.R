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

#' Sample column specifications for reading CPS data
#' 
#' Because the CPS is a fixed-width file that changes data locations (and variable 
#' names) across years, to correctly read the data you have to specify which 
#' start/end positions correspond to which column names in each year. This is one 
#' such specification. To add extra data or change column names, see the Vignette.
#' @format A data frame with 204 rows and 8 columns:
#' \describe{
#' \item{year}{year}
#' \item{cps_name}{original column name as given by the CPS}
#' \item{new_name}{a new name, which tries to describe the variable and join 
#' sensibly across multiple years}
#' \item{start_pos}{which character of a line the variable starts with}
#' \item{end_pos}{which character of a line the variable ends with}
#' \item{col_type}{whether the column is character, numeric, or a factor}
#' \item{description}{the question text/description from the CPS}
#' \item{notes}{any notes for question administration or analysis}
#' }
"cps_cols"

#' Sample factor specifications for reading CPS data
#' 
#' Because the CPS changes factor levels across years, to correctly read the data 
#' you have to specify which numeric codes correspond to which character values 
#' in each year. This is one such specification. To add extra data, see the Vignette.
#' @format A data frame with 204 rows and 8 columns:
#' \describe{
#' \item{year}{year}
#' \item{cps_name}{original column name as given by the CPS}
#' \item{new_name}{a new name, which tries to describe the variable and join 
#' sensibly across multiple years}
#' \item{code}{the numeric code contained in the raw CPS data}
#' \item{value}{the character value corresponding to each numeric code}
#' }
#' @details These match the exact specifications from the CPS, including NA codes 
#' and any typos that occur (e.g., "Hipsanic" is common in older years).
"cps_factors"