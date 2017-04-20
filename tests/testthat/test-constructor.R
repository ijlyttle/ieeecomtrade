context("constructor")

config <- ct_example("keating_1999.CFG") %>% ct_read_config()
data <- ct_example("keating_1999.DAT") %>% ct_read_data_config(config)

example <- comtrade(config = config, data = data)

test_that("inherits comtrade", {
  expect_is(example, "comtrade")
})
