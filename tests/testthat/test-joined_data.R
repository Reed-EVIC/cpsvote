test_that("years are in range", {
  expect_true(all(cpsvrs$CPS_YEAR %in% 1994:2018))
})

test_that("states joined", {
  expect_setequal(cpsvrs$CPS_STATE, c(state.abb, "DC"))
})

test_that("nobody is NA for all VRS Qs", {
  expect_equal(nrow(dplyr::filter_at(cpsvrs, vars(starts_with('VRS_')), all_vars(is.na(.)))), 0)
})

test_that("missing codes are NA", {
  expect_equal(sum(unlist(cpsvrs) %in% c("NO RESPONSE", "REFUSED", "NOT IN UNIVERSE")), 0)
})

test_that("no zero-weights", {
  expect_gt(min(cpsvrs$WEIGHT), 0)
})

test_that('factors were refactored fully', {
  expect_false(any(cpsvrs == "Other", na.rm = TRUE))
})

test_that('select caught all of the columns', {
  expect_equal(colnames(cpsvrs)[ncol(cpsvrs)], "RESIDENCE_COLLAPSE")
})
