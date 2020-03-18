#' combine factor levels across years
#' 
#' The response sets in certain CPS questions change between years. This function 
#' consolidates several of these response sets across years (and fixes typos 
#' from the CPS documentation), specifically race, Hispanic status, duration of 
#' residency, reason for not voting, and method of registration.
#' 
#' @details While consolidating response sets across multiple surveys can be 
#' fraught with peril, this function attempts to combine disparate levels for 
#' race and other CPS variable across multiple years. Some of these are 
#' relatively straightforward typos fixes ("NON-HIPSANIC" should clearly match 
#' "NON-HISPANIC"), but others have differing degrees of subjectivity applied.
#' Take this function with a grain of salt, as it depends on some exact variable 
#' names you may or may not be using, and recode variables as needed for your 
#' own uses. To explore exactly how these variables were recoded, you can run 
#' `table(data$RACE, combine_factors(data)$RACE)` in the console, substituting 
#' your column of interest in for `RACE`.
#' @param data A dataset containing already-labelled CPS data
#' @param move_levels Whether to move the levels "OTHER", "DON'T KNOW", and 
#' "REFUSED" to the end of each factor's level set
#' @export
combine_factors <- function(data, move_levels = TRUE) {
  RACE <- HISPANIC <- VRS_RESIDENCE <- VRS_VOTE_WHYNOT <- VRS_REG_METHOD <- NULL
  
  output <- data %>%
    dplyr::mutate(RACE = forcats::fct_collapse(RACE, # try to consolidate RACE
                                               "WHITE" = c("WHITE", 
                                                      "WHITE ONLY"),
                                          "BLACK" = c("BLACK", 
                                                      "BLACK ONLY"),
                                          "ASIAN, PACIFIC ISLANDER, OR NATIVE HAWAIIAN" = c("ASIAN OR PACIFIC ISLANDER",
                                                                                            "ASIAN ONLY",
                                                                                            "HAWAIIAN/PACIFIC ISLANDER ONLY"),
                                          "AMERICAN INDIAN OR ALASKA NATIVE" = c("AMERICAN INDIAN, ALEUT, ESKIMO",
                                                                                 "AMERICAN INDIAN, ALASKAN NATIVE ONLY"),
                                          other_level = "TWO OR MORE RACES"),
                  HISPANIC = forcats::fct_collapse(HISPANIC, "NON-HISPANIC" = "NON-HIPSANIC"), # fix typo
                  VRS_RESIDENCE = forcats::fct_collapse(VRS_RESIDENCE,
                    "LESS THAN 1 YEAR" = c("LESS THAN 1 MONTH", # consolidate old/new versions
                                                                 "1-6 MONTHS",
                                                                 "7-11 MONTHS")) %>%
                    forcats::fct_relevel("LESS THAN 1 YEAR"), # stick that one in front
                  VRS_VOTE_WHYNOT = forcats::fct_collapse(VRS_VOTE_WHYNOT,
                    "TRANSPORTATION PROBLEMS" = c("HAD NO WAY TO GET TO POLLS",
                                                                        "TRANSPORTATION PROBLEMS"),
                                          "SCHEDULE PROBLEMS" = c("COULD NOT TAKE TIME OFF FROM WORK/SCHOOL/TOO BUSY",
                                                                  "TOO BUSY, CONFLICTING WORK OR SCHOOL SCHEDULE"),
                                          "OUT OF TOWN" = c("OUT OF TOWN OR AWAY FROM HOME"),
                                          "SICK, DISABLED, OR FAMILY EMERGENCY" = c("SICK, DISABLED, OR FAMILY EMERGENCY",
                                                                                    "ILLNESS OR DISABILITY (OWN OR FAMILY'S)"),
                                          "DID NOT LIKE CANDIDATES OR ISSUES" = c("DID NOT PREFER ANY OF THE CANDIDATES",
                                                                                  "DIDN'T LIKE CANDIDATES OR CAMPAIGN ISSUES"),
                                          "NOT INTERESTED" = c("NOT INTERESTED, DON'T CARE, ETC.",
                                                               "NOT INTERESTED, FELT MY VOTE WOULDN'T MAKE A DIFFERENCE"),
                                          "FORGOT TO VOTE" = c("FORGOT TO VOTE",
                                                               "FORGOT TO VOTE (OR SEND IN ABSENTEE BALLOT)"),
                                          "INCONVENIENT POLLING PLACE OR HOURS OR LINES TOO LONG" = c("LINES TOO LONG AT POLLS", 
                                                                                                      "INCONVENIENT POLLING PLACE OR HOURS OR LINES TOO LONG",
                                                                                                      "INCONVENIENT HOURS, POLLING PLACE OR HOURS OR LINES TOO LONG"),
                                          "BAD WEATHER" = c("BAD WEATHER CONDITIONS"),
                                          "REGISTRATION PROBLEMS" = c("REGISTRATION PROBLEMS (I.E., DIDN'T RECEVIE ABSENTEE BALLOT, NOT REGISTERED IN CURRENT LOCATION)",
                                                                      "REGISTRATION PROBLEMS (I.E., DIDN'T RECEIVE ABSENTEE BALLOT, NOT REGISTERED IN CURRENT LOCATION)",
                                                                      "REGISTRATION PROBLEMS (I.E. DIDN'T RECEIVE ABSENTEE BALLOT, NOT REGISTERED IN CURRENT LOCATION)"),
                                          "OTHER" = c("OTHER REASONS"),
                                          "DON'T KNOW" = c("DON'T KNOW"),
                                          ),
                  VRS_REG_METHOD = forcats::fct_collapse(VRS_REG_METHOD,
                    "PUBLIC ASSISTANCE AGENCY" = c("AT A PUBLIC ASSISTANCE AGENCY (FOR EXAMPLE, MEDICAID, AFDC, OR FOOD STAMP UNEMPLOYMENT OFFICE, OFFICE SERVING DISABLED PERSONS)",
                                                                         "AT A PUBLIC ASSISTANCE AGENCY (FOR EXAMPLE, MEDICAID, AFDC, OR FOOD STAMPS OFFICE, AN OFFICE SERVING DISABLED PERSONS, OR AN UNEMPLOYMENT OFFICE)",
                                                                         "AT A PUBLIC ASSISTANCE AGENCY (FOR EXAMPLE, A MEDICAID, AFDC, OR FOOD STAMPS OFFICE, AN OFFICE SERVING DISABLED PERSONS, OR AN UNEMPLOYMENT OFFICE",
                                                                         "AT A PUBLIC ASSISTANCE AGENCY (FOR EXAMPLE, A MEDICAID, AFDC, OR FOOD STAMPS OFFICE, AN OFFICE SERVING DISABLED PERSONS, OR AN UNEMPLOYMENT OFFICE)"),
                                          "BY MAIL" = c("MAILED IN FORM TO ELECTIONS OFFICE",
                                                        "REGISTERED BY MAIL"),
                                          "SCHOOL OR HOSPITAL" = c("AT A SCHOOL, HOSPITAL, OR ON CAMPUS"),
                                          "COUNTY REGISTRATION OFFICE" = c("WENT TO A COUNTY OR GOVERNMENT VOTER REGISTRATION OFFICE",
                                                                           "WENT TO A TOWN HALL OR COUNTY/GOVERNMENT REGISTRATION OFFICE"),
                                          "REGISTRATION DRIVE" = c("FILLED OUT FORM AT A REGISTRATION DRIVE (FOR EXAMPLE, POLITICAL RALLY, SOMEONE CAME TO YOUR DOOR, REGISTRATION DRIVE AT MALL, MARKET, FAIR, POST OFFICE, LIBRARY, STORE, CHURCH, ETC.)",
                                                                   "FILLED OUT FORM AT A REGISTRATION DRIVE (LIBRARY, POST OFFICE, OR SOMEONE CAME TO YOUR DOOR)"),
                                          "SAME DAY AT POLLS" = c("REGISTERED AT THE POLLS ON ELECTION DAY",
                                                                  "REGISTERED AT POLLINGPLACE (ON ELECTION OR PRIMARY DAY)",
                                                                  "REGISTERED AT POLLING PLACE (ON ELECTION OR PRIMARY DAY)"),
                                          "DMV" = c("AT A DEPARTMENT OF MOTOR VEHICLES (FOR EXAMPLE, WHEN OBTAINING A DRIVER'S LICENSE OR OTHER IDENTIFICATION CARD)"),
                                          "ONLINE" = c("REGISTERED USING THE INTERNET OR ONLINE"),
                                          "OTHER" = c("OTHER PLACE/WAY")
                                          )
           )
  
  if (move_levels) output <- output %>%
    dplyr::mutate_if(is.factor, function(x) suppressWarnings(forcats::fct_relevel(x, 
                                                                                  "OTHER", 
                                                                                  "DON'T KNOW",
                                                                                  "REFUSED",
                                                                                  after = Inf)))
  
  output
}

# small visual tests
# check_levels <- function(var) {
#   table(data[[var]], output[[var]]) %>%
#     data.frame(stringsAsFactors = FALSE) %>%
#     tidyr::pivot_wider(names_from = "Var2", values_from = "Freq") %>%
#     dplyr::select(-Var1, Var1) %>%
#     dplyr::arrange_if(is.numeric, dplyr::desc)
# }
# 
# check_years <- function(var) {
#   table(data[[var]], data$YEAR)
# }
