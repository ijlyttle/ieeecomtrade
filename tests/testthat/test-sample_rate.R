context("sample_rate")

test_that("sample-rate functions work", {
  expect_identical(ct_sample_per_cycle(keating_1999), 512L)
  expect_identical(ct_sample_rate_nominal(keating_1999), 30720)
})
