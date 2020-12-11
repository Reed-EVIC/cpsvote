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

#' Calculations to reweight properly for voter turnout
#' 
#' While the U.S. Census Bureau provides one weight with the CPS, a modified 
#' weight is needed to properly calculate voter turnout. This data set provides 
#' those calculations, according to Hur and Achen (2013). The comparison data 
#' comes from Dr. Michael McDonald's estimates of voter turnout among the 
#' voting-eligible population (VEP). It can be joined with CPS data to 
#' calculate the new weights needed for analysis, using the function 
#' `cps_reweight_turnout`.
#' @format A tibble with 1,326 rows and 6 columns:
#' \describe{
#' \item{YEAR}{year}
#' \item{STATE}{state}
#' \item{response}{indicator of turnout in recent election}
#' \item{vep_turnout}{proportion of turnout indicator, calculated by McDonald}
#' \item{cps_turnout}{proportion of turnout indicator, calculated by CPS}
#' \item{reweight}{the factor by which to scale original CPS weights}
#' }
#' @source Turnout data from \url{http://www.electproject.org/home/voter-turnout/voter-turnout-data}
"cps_reweight"

#' A sample of the full CPS dataset
#' 
#' This is a 10,000 row sample of the data that comes out of 
#' `cpsvote::cps_load_basic`.
#' @format A tibble with 10,000 rows and 25 columns:
#' \describe{
#' \item{FILE}{Which default file the case came from}
#' \item{YEAR}{Year of interview}
#' \item{STATE}{State postal abbreviation}
#' \item{AGE}{Person's age as of the end of survey week; 
#' topcoded at 90 until 2002, 80 in 2004, and 80/85 after}
#' \item{SEX}{Binary sex}
#' \item{EDUCATION}{Highest level of school completed or degree received}
#' \item{RACE}{Race}
#' \item{HISPANIC}{Hispanic status}
#' \item{WEIGHT}{Original CPS survey weight}
#' \item{VRS_VOTE}{Whether respondent voted in the election; self-reported}
#' \item{VRS_REG}{Whether respondent was registered to vote in the election; 
#' self-reported}
#' \item{VRS_VOTE_TIME}{What time of day respondent voted}
#' \item{VRS_RESIDENCE}{Duration of time living at current address}
#' \item{VRS_VOTE_WHYNOT}{Reason for not voting}
#' \item{VRS_VOTEMETHOD_1996to2002}{Method of voting, pre-2004}
#' \item{VRS_REG_SINCE95}{Whether respondent had registered to vote since 1995}
#' \item{VRS_REG_DMV}{Whether respondent registered at the DMV}
#' \item{VRS_REG_METHOD}{Method of registration}
#' \item{VRS_REG_WHYNOT}{Reason for not being registered to vote}
#' \item{VRS_VOTEMODE_2004toPRESENT}{Whether respondent voted by mail, 2004 on}
#' \item{VRS_VOTEWHEN_2004toPRESENT}{Whether respondent voted on election day or 
#' before, 2004 on}
#' \item{VRS_VOTEMETHOD_CON}{A consolidation of VRS_VOTEMETHOD_1996to2002, 
#' VRS_VOTEMODE_2004toPRESENT, and VRS_VOTEWHEN_2004toPRESENT}
#' \item{cps_turnout}{Recode of VRS_VOTE for CPS turnout calculation}
#' \item{hurachen_turnout}{Recode of VRS_VOTE for adjusted Hur & Achen turnout 
#' calculation}
#' \item{turnout_weight}{Adjusted weight for calculating voter turnout (per 
#' Hur & Achen)}
#' }
"cps_allyears_10k"

#' A sample of the raw 2016 CPS dataset
#' 
#' This is a 10,000 row sample of the data that comes out of 
#' `cps_read(years = 2016)`.
#' @format A tibble with 10,000 rows and 17 columns:
#' \describe{
#' \item{FILE}{Which default file the case came from}
#' \item{YEAR}{Year of interview}
#' \item{STATE}{State postal abbreviation}
#' \item{AGE}{Person's age as of the end of survey week; 
#' topcoded at 80 and 85}
#' \item{SEX}{Binary sex}
#' \item{EDUCATION}{Highest level of school completed or degree received}
#' \item{RACE}{Race}
#' \item{HISPANIC}{Hispanic status}
#' \item{WEIGHT}{Original CPS survey weight}
#' \item{VRS_VOTE}{Whether respondent voted in the election; self-reported}
#' \item{VRS_REG}{Whether respondent was registered to vote in the election; 
#' self-reported}
#' \item{VRS_REG_WHYNOT}{Reason for not being registered to vote}
#' \item{VRS_VOTE_WHYNOT}{Reason for not voting}
#' \item{VRS_VOTEMODE_2004toPRESENT}{Whether respondent voted by mail}
#' \item{VRS_VOTEWHEN_2004toPRESENT}{Whether respondent voted on election day or 
#' before}
#' \item{VRS_REG_METHOD}{Method of registration}
#' \item{VRS_RESIDENCE}{Duration of time living at current address}
#' }
"cps_2016_10k"
