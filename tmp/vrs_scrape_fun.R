read_cps <- function(file, vrs_start) {
  readr::read_fwf(file,
                  readr::fwf_cols(YEAR = c(18, 21),
                                  STATE = c(93, 94),
                                  AGE = c(122, 123),
                                  SEX = c(129, 130),
                                  EDU = c(137,138),
                                  RACE = c(139, 140),
                                  HISP = c(157,158),
                                  WEIGHT = c(613, 622),
                                  VOTE = c(vrs_start, vrs_start + 1),
                                  VOTEREG = c(vrs_start + 2, vrs_start + 3),
                                  NOREGWHY = c(vrs_start + 4, vrs_start + 5),
                                  NOVOTEWHY = c(vrs_start + 6, vrs_start + 7),
                                  VBM = c(vrs_start + 8, vrs_start + 9),
                                  ELEXDAY = c(vrs_start + 10, vrs_start + 11),
                                  REGHOW = c(vrs_start + 12, vrs_start + 13),
                                  RESIDENCE = c(vrs_start + 14, vrs_start + 15)))
}
