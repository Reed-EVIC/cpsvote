print("1994")
if (!file.exists(here('cps_data', 'cpsnov1994.zip'))) {
  download.file("data.nber.org/cps/cpsnov94.zip", destfile = here('cps_data', 'cpsnov1994.zip'))
}

if (!file.exists(here('cps_docs', 'cpsnov1994.pdf'))) {
  download.file("data.nber.org/cps/cpsnov94.pdf", destfile = here('cps_docs', 'cpsnov1994.pdf'))
}


cpsvrs1994_orig <- readr::read_fwf(here('cps_data', 'cpsnov1994.zip'),
                                  readr::fwf_cols(CPS_YEAR = c(67, 68),
                                                   CPS_STATE = c(93, 94),
                                                   CPS_AGE = c(122, 123),
                                                   CPS_SEX = c(129, 130),
                                                   CPS_EDU = c(137, 138),
                                                   CPS_RACE = c(139, 140),
                                                   CPS_HISP = c(157,158),
                                                   WEIGHT = c(613, 622),
                                                   VRS_VOTE = c(817, 818),
                                                   VRS_VOTEREG = c(819, 820),
                                                   VRS_VOTETIME = c(821, 822),
                                                   VRS_RESIDENCE = c(823, 824)))

# set the factors
cpsvrs1994_factored <- cpsvrs1994_orig %>%
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
    VRS_VOTE = factor(VRS_VOTE, levels = c(1,2,-2,-3),
                      labels = c("YES",
                                 "NO",
                                 "DON'T KNOW",
                                 "REFUSED")),
    VRS_VOTEREG = factor(VRS_VOTEREG, levels = c(1, 2, -2, -3, -9),
                         labels = c("YES",
                                    "NO",
                                    "DON'T KNOW",
                                    "REFUSED",
                                    "NO RESPONSE")),
    VRS_VOTETIME = factor(VRS_VOTETIME, levels = c(1:5, -2, -3, -9),
                          labels = c("BEFORE NOON",
                                     "NOON TO 4 P.M.",
                                     "4 P.M. TO 6 P.M.",
                                     "AFTER 6 P.M.",
                                     "VOTED ABSENTEE",
                                     "DON'T KNOW",
                                     "REFUSED",
                                     "NO RESPONSE"),
                          ordered = TRUE),
    VRS_RESIDENCE = factor(VRS_RESIDENCE, levels = c(1:6, -2, -3),
                           labels = c("LESS THAN 1 MONTH",
                                      "1-6 MONTHS",
                                      "7-11 MONTHS",
                                      "1-2 YEARS",
                                      "3-4 YEARS",
                                      "5 YEARS OR LONGER",
                                      "DON'T KNOW",
                                      "REFUSED"),
                           ordered = TRUE)
  )
