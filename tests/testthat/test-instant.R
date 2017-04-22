context("instant")

config <-
  ct_example("keating_1999.CFG") %>%
  ct_read_config()

# limit the number of samples to 4
config[["sampling_rate"]][["endsamp"]] <- 4

data <-
  ct_example("keating_1999.DAT") %>%
  ct_read_data_config(config)

ct <- comtrade(config = config, data = data)

ct_instant(ct, channel_name = ct_channel_name(ct, "ph"))

# test_that("multiplication works", {
#   expect_identical(ct, ct_tidytime(ct))
# })

## get_instant

sampling_rate <- tribble(
  ~samp, ~endsamp,
  1,     2L,
  2,     4L
)

test_that("get_instant works", {
  expect_identical(get_instant(sampling_rate), c(0, 1, 1.5, 2))
})

## scale_channel

scale_channel_test <- function(x) {
  config$analog_channel$a[[1]] * x + config$analog_channel$b[[1]]
}

scale_channel <- fn_scale_channel(config, 1L)

test_that("fn_scale_channel works", {
  expect_identical(scale_channel_test(0), scale_channel(0))
  expect_identical(scale_channel_test(1), scale_channel(1))
})

# TODO: need a more-robust test for primary/secondary scales

scale_side <- fn_scale_side(config, 1L, "primary")

test_that("fn_scale_channel works", {
  expect_identical(scale_side(1), 1)
})

