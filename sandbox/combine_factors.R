combine_factors <- function(data, na.vals = c("-1", "BLANK", "NOT IN UNIVERSE", "NO RESPONSE (N/A)", "NO RESPONSE")) {
  output <- data %>%
    dplyr::mutate(FILE = factor(FILE),
                  YEAR = YEAR %% 1900 + 1900,
                  STATE = factor(STATE, 
                                 levels = get_levels("STATE")),
                  AGE = na_ifin(AGE, na.vals),
                  SEX = factor(toupper(SEX), 
                               levels = sort(get_levels("SEX"))),
                  EDUCATION = factor(toupper(EDUCATION), 
                                     levels = get_levels("EDUCATION")),
                  RACE = factor(toupper(RACE), 
                                levels = get_levels("RACE")) %>%
                    forcats::fct_collapse("WHITE" = c("WHITE", 
                                                      "WHITE ONLY"),
                                          "BLACK" = c("BLACK", 
                                                      "BLACK ONLY"),
                                          "ASIAN, PACIFIC ISLANDER, OR NATIVE HAWAIIAN" = c("ASIAN OR PACIFIC ISLANDER",
                                                                                            "ASIAN ONLY",
                                                                                            "HAWAIIAN/PACIFIC ISLANDER ONLY"),
                                          "AMERICAN INDIAN OR ALASKA NATIVE" = c("AMERICAN INDIAN, ALEUT, ESKIMO",
                                                                                 "AMERICAN INDIAN, ALASKAN NATIVE ONLY"),
                                          other_level = "TWO OR MORE RACES"),
                  HISPANIC = factor(toupper(HISPANIC),
                                    levels = c("HISPANIC", "NON-HISPANIC", "NON-HIPSANIC"),
                                    labels = c("HISPANIC", "NON-HISPANIC", "NON-HISPANIC")),
                  WEIGHT = na_ifin(WEIGHT, na.vals) / 10000,
                  VRS_VOTE = factor(toupper(VRS_VOTE), 
                                    levels = get_levels("VRS_VOTE")),
                  VRS_REG = factor(toupper(VRS_REG), 
                                   levels = get_levels("VRS_REG")),
                  VRS_VOTE_TIME = factor(toupper(VRS_VOTE_TIME), 
                                         levels = get_levels("VRS_VOTE_TIME")),
                  VRS_RESIDENCE = factor(toupper(VRS_RESIDENCE), 
                                         levels = get_levels("VRS_RESIDENCE")) %>%
                    forcats::fct_collapse("LESS THAN 1 YEAR" = c("LESS THAN 1 MONTH", # consolidate old/new versions
                                                                 "1-6 MONTHS",
                                                                 "7-11 MONTHS")) %>%
                    forcats::fct_relevel("LESS THAN 1 YEAR"), # stick that one in front
                  VRS_VOTE_WHYNOT = factor(toupper(VRS_VOTE_WHYNOT), 
                                           levels = get_levels("VRS_VOTE_WHYNOT")) %>%
                    forcats::fct_collapse("TRANSPORTATION PROBLEMS" = c("HAD NO WAY TO GET TO POLLS",
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
                  VRS_VOTE_METHOD = factor(toupper(VRS_VOTE_METHOD), 
                                           levels = get_levels("VRS_VOTE_METHOD")),
                  VRS_REG_SINCE95 = factor(toupper(VRS_REG_SINCE95), 
                                           levels = get_levels("VRS_REG_SINCE95")),
                  VRS_REG_DMV = factor(toupper(VRS_REG_DMV), 
                                           levels = get_levels("VRS_REG_DMV")),
                  VRS_REG_METHOD = factor(toupper(VRS_REG_METHOD), 
                                           levels = get_levels("VRS_REG_METHOD")) %>%
                    forcats::fct_collapse("PUBLIC ASSISTANCE AGENCY" = c("AT A PUBLIC ASSISTANCE AGENCY (FOR EXAMPLE, MEDICAID, AFDC, OR FOOD STAMP UNEMPLOYMENT OFFICE, OFFICE SERVING DISABLED PERSONS)",
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
                                          ),
                  VRS_REG_WHYNOT = factor(toupper(VRS_REG_WHYNOT), 
                                           levels = get_levels("VRS_REG_WHYNOT")),
                  VRS_VOTE_MAIL = factor(toupper(VRS_VOTE_MAIL), 
                                           levels = get_levels("VRS_VOTE_MAIL")),
                  VRS_VOTE_DAY = factor(toupper(VRS_VOTE_DAY), 
                                           levels = get_levels("VRS_VOTE_DAY"))
           ) %>%
    dplyr::mutate_if(function(y) !is.numeric(y), function(x) forcats::fct_drop(na_ifin(x, toupper(na.vals))))
  
  output
}

# helpers for the above
na_ifin <- function(x, y) {
  x[x %in% y] <- NA
  x
}

get_levels <- function(x, dataset = cps_factors, col = "new_name") {
  unique(toupper(dataset$value[dataset[[col]] == x]))
}

# small visual tests
check_levels <- function(var) {
  table(data[[var]], output[[var]]) %>%
    data.frame(stringsAsFactors = FALSE) %>%
    tidyr::pivot_wider(names_from = "Var2", values_from = "Freq") %>%
    dplyr::select(-Var1, Var1) %>%
    dplyr::arrange_if(is.numeric, dplyr::desc)
}

check_years <- function(var) {
  table(data[[var]], data$YEAR)
}
