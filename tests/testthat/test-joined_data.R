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

test_that("write a test that levels don't get deleted in the refactoring", {
  expect_true(FALSE)
})
