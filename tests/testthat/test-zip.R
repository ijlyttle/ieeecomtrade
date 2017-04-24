context("zip")

config <- ct_example("keating_1999.CFG") %>% ct_read_config()
data <- ct_example("keating_1999.DAT") %>% ct_read_data_config(config)

ct <- ct_example("keating_1999.zip") %>% ct_read_zip()

test_that("multiplication works", {
  expect_identical(ct, comtrade(config, data))
})
