if (!file.exists(here('raw_data', 'cpsnov1996.zip'))) {
  download.file("https://data.nber.org/cps/cpsnov96.zip", destfile = here('raw_data', 'cpsnov1996.zip'))
}

if (!file.exists(here('docs', 'cpsnov1996.pdf'))) {
  download.file("data.nber.org/cps/cpsnov96.pdf", destfile = here('docs', 'cpsnov1996.pdf'))
}


cpsvrs1996_orig <- readr::read_fwf(here('raw_data', 'cpsnov1996.zip'),
                                   readr::fwf_cols(CPS_YEAR = c(67, 68),
                                                   CPS_STATE = c(93, 94),
                                                   CPS_AGE = c(122, 123),
                                                   CPS_SEX = c(129, 130),
                                                   CPS_EDU = c(137, 138),
                                                   CPS_RACE = c(139, 140),
                                                   CPS_HISP = c(157,158),
                                                   WEIGHT = c(613, 622),
                                                   VRS_VOTE = c(815, 816),
                                                   VRS_VOTEREG = c(817, 818),
                                                   VRS_NOVOTEWHY = c(819, 820),
                                                   VRS_VOTEMETHOD = c(821, 822),
                                                   VRS_REGSINCE95 = c(823, 824),
                                                   VRS_REGDMV = c(825, 826),
                                                   VRS_REGHOW = c(827, 828),
                                                   VRS_RESIDENCE = c(829, 830)))

# set the factors
cpsvrs1996_factored <- cpsvrs1996_orig %>%
  dplyr::transmute(
    CPS_YEAR = CPS_YEAR + 1900,
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
    CPS_RACE = factor(CPS_RACE, levels = 1:5,
                      labels = c("WHITE",
                                 "BLACK",
                                 "AMERICAN INDIAN, ALEUT, ESKIMO",
                                 "ASIAN OR PACIFIC ISLANDER",
                                 "OTHER")),
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
    VRS_NOVOTEWHY = factor(VRS_NOVOTEWHY, levels = c(1:9, -2, -3, -9),
                           labels = c("HAD NO WAY TO GET TO POLLS", 
                                      "COULD NOT TAKE TIME OFF FROM WORK/SCHOOL/TOO BUSY", 
                                      "OUT OF TOWN OR AWAY FROM HOME", 
                                      "SICK, DISABLED, OR FAMILY EMERGENCY", 
                                      "DID NOT PREFER ANY OF THE CANDIDATES", 
                                      "NOT INTERESTED, DON'T CARE, ETC.", 
                                      "FORGOT TO VOTE", 
                                      "OTHER REASONS", 
                                      "LINES TOO LONG AT POLLS", 
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
                                   "MAILED IN FORM TO ELECTION OFFICE", 
                                   "AT A SCHOOL, HOSPITAL, OR ON CAMPUS", 
                                   "WENT TO A COUNTY OR GOVERNMENT VOTER REGISTRATION OFFICE", 
                                   "FILLED OUT FORM AT A REGISTRATION DRIVE (FOR EXAMPLE, POLITICAL RALLY, SOMEONE CAME TO YOUR DOOR, REGISTRATION DRIVE AT MALL, MARKET, FAIR, POST OFFICE, LIBRARY, STORE, CHURCH, ETC.)", 
                                   "OTHER PLACE/WAY", 
                                   "REGISTERED AT THE POLLS ON ELECTION DAY", 
                                   "DON'T KNOW", 
                                   "REFUSED", 
                                   "NO RESPONSE")),
    VRS_RESIDENCE = factor(VRS_RESIDENCE, levels = c(1:6, -2, -3, -9),
                           labels = c("LESS THAN 1 MONTH",
                                      "1-6 MONTHS",
                                      "7-11 MONTHS",
                                      "1-2 YEARS",
                                      "3-4 YEARS",
                                      "5 YEARS OR LONGER",
                                      "DON'T KNOW",
                                      "REFUSED",
                                      "NO RESPONSE"),
                           ordered = TRUE)
  )
