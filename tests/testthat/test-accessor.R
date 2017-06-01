context("sample_rate")

test_that("sample-rate functions work", {
  expect_identical(ct_sample_per_cycle(keating_1999), 512L)
  expect_identical(ct_sampling_frequency_nominal(keating_1999), 30720)
  expect_identical(ct_electrical_frequency_nominal(keating_1999), 60)
  expect_identical(ct_sampling_frequency(keating_1999), 30707.244140625)
})
