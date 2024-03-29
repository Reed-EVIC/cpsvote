print("1998")
if (!file.exists(here('cps_data', 'cpsnov1998.zip'))) {
  download.file("https://data.nber.org/cps/cpsnov98.zip", destfile = here('cps_data', 'cpsnov1998.zip'))
}

if (!file.exists(here('cps_docs', 'cpsnov1998.pdf'))) {
  download.file("data.nber.org/cps/cpsnov98.pdf", destfile = here('cps_docs', 'cpsnov1998.pdf'))
}


cpsvrs1998_orig <- readr::read_fwf(here('cps_data', 'cpsnov1998.zip'),
                                   readr::fwf_cols(CPS_YEAR = c(18, 21),
                                                   CPS_STATE = c(93, 94),
                                                   CPS_AGE = c(122, 123),
                                                   CPS_SEX = c(129, 130),
                                                   CPS_EDU = c(137, 138),
                                                   CPS_RACE = c(139, 140),
                                                   CPS_HISP = c(157,158),
                                                   WEIGHT = c(613, 622),
                                                   VRS_VOTE = c(857, 858),
                                                   VRS_VOTEREG = c(859, 860),
                                                   VRS_NOVOTEWHY = c(861, 862),
                                                   VRS_VOTEMETHOD = c(863, 864),
                                                   VRS_REGSINCE95 = c(865, 866),
                                                   VRS_REGDMV = c(867, 868),
                                                   VRS_REGHOW = c(869, 870),
                                                   VRS_RESIDENCE = c(871, 872)))

# set the factors
cpsvrs1998_factored <- cpsvrs1998_orig %>%
  dplyr::transmute(
    CPS_YEAR,
    CPS_STATE = factor(stringr::str_pad(CPS_STATE, width = 2, side = "left", pad = "0"),
                       levels = fips$state_code, labels = fips$state),
    CPS_AGE = ifelse(CPS_AGE < 0, NA, CPS_AGE),
    CPS_SEX = factor(CPS_SEX, levels = 1:2, labels = c("MALE", "FEMALE")),
    CPS_EDU = factor(CPS_EDU, levels = 31:46,
                     labels = c("LESS THAN 1ST GRADE",
                                "1ST, 2ND, 3RD OR 4TH GRADE",
                                "5TH OR 6TH GRADE",
                                "7TH OR 8TH GRADE",
                                "9TH GRADE",
                                "10TH GRADE",
                                "11TH GRADE",
                                "12TH GRADE NO DIPLOMA",
                                "HIGH SCHOOL GRAD-DIPLOMA OR EQUIV (GED)",
                                "SOME COLLEGE BUT NO DEGREE",
                                "ASSOCIATE DEGREE-OCCUPATIONAL/VOCATIONAL",
                                "ASSOCIATE DEGREE-ACADEMIC PROGRAM",
                                "BACHELOR'S DEGREE (EX: BA, AB, BS)",
                                "MASTER'S DEGREE (EX: MA, MS, MENG, MED, MSW)",
                                "PROFESSIONAL SCHOOL DEG (EX: MD, DDS, DVM)",
                                "DOCTORATE DEGREE (EX: PHD, EDD)"),
                     ordered = TRUE),
    CPS_RACE = factor(CPS_RACE, levels = 1:4,
                      labels = c("WHITE",
                                 "BLACK",
                                 "AMERICAN INDIAN, ALEUT, ESKIMO",
                                 "ASIAN OR PACIFIC ISLANDER")),
    CPS_HISP = factor(CPS_HISP, levels = 1:2,
                      labels = c("HISPANIC",
                                 "NON-HISPANIC")),
    WEIGHT,
    VRS_VOTE = factor(VRS_VOTE, levels = c(1,2,-2,-3, -9),
                      labels = c("YES",
                                 "NO",
                                 "DON'T KNOW",
                                 "REFUSED",
                                 "NO RESPONSE")),
    VRS_VOTEREG = factor(VRS_VOTEREG, levels = c(1, 2, -2, -3, -9),
                         labels = c("YES",
                                    "NO",
                                    "DON'T KNOW",
                                    "REFUSED",
                                    "NO RESPONSE")),
    VRS_NOVOTEWHY = factor(VRS_NOVOTEWHY, levels = c(1:11, -2, -3, -9),
                           labels = c("TOO BUSY, CONFLICTING WORK OR SCHOOL SCHEDULE", 
                                      "NOT INTERESTED, FELT MY VOTE WOULDN'T MAKE A DIFFERENCE", 
                                      "ILLNESS OR DISABILITY (OWN OR FAMILY'S)", 
                                      "DIDN'T LIKE CANDIDATES OR CAMPAIGN ISSUES", 
                                      "OUT OF TOWN OR AWAY FROM HOME", 
                                      "FORGOT TO VOTE (OR SEND IN ABSENTEE BALLOT)", 
                                      "TRANSPORTATION PROBLEMS", 
                                      "INCONVENIENT POLLING PLACE OR HOURS OR LINES TOO LONG", 
                                      "REGISTRATION PROBLEMS (I.E., DIDN'T RECEIVE ABSENTEE BALLOT, NOT REGISTERED IN CURRENT LOCATION)",
                                      "BAD WEATHER CONDITIONS",
                                      "OTHER", 
                                      "DON'T KNOW", 
                                      "REFUSED", 
                                      "NO RESPONSE")),
    VRS_VOTEMETHOD = factor(VRS_VOTEMETHOD, levels = c(1:3, -2, -3, -9),
                            labels = c("IN PERSON ON ELECTION DAY", 
                                       "IN PERSON BEFORE ELECTION DAY", 
                                       "VOTED BY MAIL (ABSENTEE)", 
                                       "DON'T KNOW", 
                                       "REFUSED", 
                                       "NO RESPONSE")),
    VRS_REGSINCE95 = factor(VRS_REGSINCE95, levels = c(1:2, -2, -3, -9),
                            labels = c("YES",
                                       "NO",
                                       "DON'T KNOW",
                                       "REFUSED",
                                       "NO RESPONSE")),
    VRS_REGDMV = factor(VRS_REGDMV, levels = c(1, 2, -2, -3),
                        labels = c("WHEN DRIVER'S LICENSE WAS OBTAINED/RENEWED", 
                                   "SOME OTHER WAY", 
                                   "DON'T KNOW", 
                                   "REFUSED")),
    # this is only asked of the people who said "some other way" to the DMV reg question
    VRS_REGHOW = factor(VRS_REGHOW, levels = c(1:7, -2, -3, -9),
                        labels = c("AT A PUBLIC ASSISTANCE AGENCY (FOR EXAMPLE, MEDICAID, AFDC, OR FOOD STAMPS OFFICE, AN OFFICE SERVING DISABLED PERSONS, OR AN UNEMPLOYMENT OFFICE)", 
                                   "REGISTERED BY MAIL", 
                                   "AT A SCHOOL, HOSPITAL, OR ON CAMPUS", 
                                   "WENT TO A TOWN HALL OR COUNTY/GOVERNMENT REGISTRATION OFFICE", 
                                   "FILLED OUT FORM AT A REGISTRATION DRIVE (LIBRARY, POST OFFICE, OR SOMEONE CAME TO YOUR DOOR)", 
                                   "REGISTERED AT POLLING PLACE (ON ELECTION OR PRIMARY DAY)", 
                                   "OTHER", 
                                   "DON'T KNOW", 
                                   "REFUSED", 
                                   "NO RESPONSE")),
    VRS_RESIDENCE = factor(VRS_RESIDENCE, levels = c(1:6, -2, -3, -9),
                           labels = c("LESS THAN 1 YEAR", "LESS THAN 1 YEAR", 
                                      "LESS THAN 1 YEAR", "1-2 YEARS", "3-4 YEARS", "5 YEARS OR LONGER", 
                                      "NA", "NA", "NA"),
                           ordered = TRUE) # collapse the sub-1yr categories together
  )
