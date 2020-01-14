#' Voting and Registration Supplement to the CPS
#' 
#' A dataset containing selected variables from the U.S. Census Bureau's 
#' Current Population Survey (CPS), particularly the biannual Voting and 
#' Registration Supplement (VRS). The VRS included questions about voting and 
#' voter registration, particularly about the most recent general election 
#' (November of the survey year). All VRS variables are included, and relevant 
#' CPS variables were chosen to complement this data. Survey years from 1996 
#' onwards are included. Two weights are provided - the original weight given 
#' by the CPS for each case, and an edited weight that is needed to properly 
#' calculate voter turnout, according to Achen and Hur (2013). For more 
#' about the variables chosen and this reweighting, see `vignette("cps")`.
#' @format A tibble with 1,132,756 rows and 28 columns:
#' \describe{
#'   \item{CPS_YEAR}{year respondent was surveyed}
#'   \item{CPS_STATE}{state of residence}
#'   \item{CPS_COUNTY}{FIPS code for county of residence}
#'   \item{CPS_AGE}{age at time of survey}
#'   \item{CPS_SEX}{respondent's sex}
#'   \item{CPS_EDU}{highest level of education completed}
#'   \item{CPS_RACE}{respondent's race}
#'   \item{CPS_RACE_C}{recoding of `CPS_RACE` to match levels across years}
#'   \item{CPS_HISP}{whether respondent is Hispanic or not}
#'   \item{WEIGHT}{the original weight provided by the CPS}
#'   \item{VRS_VOTE}{whether respondent voted in the election, self-reported}
#'   \item{VRS_VOTE_WHYNOT}{reason for not voting}
#'   \item{VRS_VOTE_WHYNOT_C}{recoding of `VRS_VOTE_WHYNOT` to match levels across years}
#'   \item{VRS_VOTE_HOW}{which method respondent used to vote}
#'   \item{VRS_VOTE_MAIL}{whether respondent voted by mail or not}
#'   \item{VRS_VOTE_DAY}{whether respondent voted on election day or early}
#'   \item{VRS_VOTE_HOW_C}{combination of overlapping questions across years: 
#'   `VRS_VOTE_HOW`, `VRS_VOTE_MAIL`, `VRS_VOTE_DAY`}
#'   \item{VRS_VOTE_TIME}{what time of day respondent voted}
#'   \item{VRS_REG}{whether respondent was registered to vote for the election}
#'   \item{VRS_REG_WHYNOT}{reason for not being registered}
#'   \item{VRS_REG_HOW}{method respondent used to register to vote}
#'   \item{VRS_REG_DMV}{whether respondent registered while getting driver's license}
#'   \item{VRS_REG_HOW_C}{combination of overlapping questions across years: 
#'   `VRS_REG_HOW`, `VRS_REG_DMV`}
#'   \item{VRS_REG_SINCE95}{whether respondent's more recent voter registration was after 1995}
#'   \item{VRS_RESIDENCE}{length of time respondent has lived at current address}
#'   \item{VRS_RESIDENCE_C}{recoding of `VRS_RESIDENCE` to match levels across years}
#'   \item{REWEIGHT}{reweighting factor, to multiply by `WEIGHT`}
#'   \item{WEIGHT_TURNOUT}{new weight to properly calculate voter turnout}
#' }
#' @source \url{http://data.nber.org/data/current-population-survey-data.html} for years before 2018, 
#' \url{https://thedataweb.rm.census.gov/ftp/cps_ftp.html} for 2018
"cps"

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