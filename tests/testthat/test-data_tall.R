context("data_tall")

config <-
  ct_example("keating_1999.CFG") %>%
  ct_read_config()

data <-
  ct_example("keating_1999.DAT") %>%
  ct_read_data_config(config) %>%
  `[`(1:4, )

ct <- comtrade(config = config, data = data)

test_that("data_tall works", {
  expect_identical(data, ct_data_tall(ct))
})
