test_that("states joined", {
  expect_setequal(cpsvrs$CPS_STATE, c(state.abb, "DC"))
})

test_that("nobody is NA for all VRS Qs", {
  expect_equal(nrow(dplyr::filter_at(cpsvrs, vars(starts_with('VRS_')), all_vars(is.na(.)))), 0)
})

test_that("missing codes are NA", {
  expect_equal(sum(unlist(cpsvrs) %in% c("No Response", "Refused", "Not in Universe")), 0)
})

test_that("no zero-weights", {
  expect_gt(min(cpsvrs$WEIGHT), 0)
})

test_that('race is refactored fully', {
  expect_setequal(unique(cpsvrs_bound$CPS_RACE), unique_race)
})

test_that('residence is refactored fully', {
  expect_setequal(unique(cpsvrs_bound$VRS_RESIDENCE), unique_residence)
})

test_that('select caught all of the columns', {
  expect_equal(colnames(cpsvrs)[ncol(cpsvrs)], "VRS_RESIDENCE_COLLAPSE")
})
