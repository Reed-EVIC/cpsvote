for (year in seq(1972, 2018, 2)) {
  if(!file.exists(here('R', 'year_scripts', paste0('read', year, '.R')))) next

  # each file should have a unique "year of interview" field that corresponds to the survey year
  test_that(paste(year, "CPS_YEAR is unique and correct"), {
    expect_equal(unique(get(paste0('cpsvrs', year, '_orig'))$CPS_YEAR), year)
  })

  # if VRS_VOTE is out of universe on a respondent, all of the VRS questions should be OOU
  # unles they only put an answer for residence time because frankly that's not directly voting-related
  test_that(paste(year, "VRS_VOTE out of universe is always OOU"), {
    not_in_univ <- filter(get(paste0('cpsvrs', year, '_orig')), VRS_VOTE == -1) %>%
      select(starts_with("VRS_"), -VRS_RESIDENCE)
    expect_true(all(not_in_univ == -1 | not_in_univ == -9))
  })
}

