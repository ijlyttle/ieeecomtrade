context("sample_per_cycle")

test_that("sample_per_cycle_single works", {
  expect_identical(ct_sample_per_cycle_single(keating_1999), 512L)
})
