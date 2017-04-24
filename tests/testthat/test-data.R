context("data")

library("dplyr")

config <- ct_example("keating_1999.CFG") %>% ct_read_config()
config[["sampling_rate"]][["endsamp"]] <- 4

data <-
  ct_example("keating_1999.DAT") %>%
  ct_read_data(
    config[["##A"]],
    config[["##D"]],
    max(config$sampling_rate$endsamp)
  )
attr(data, "spec") <- NULL

data_config <- ct_example("keating_1999.DAT") %>% ct_read_data_config(config)
attr(data_config, "spec") <- NULL

data_sample <- tribble(
  ~n, ~timestamp, ~a000001, ~a000002, ~a000003, ~a000004, ~a000005, ~a000006, ~a000007, ~a000008,
  1L,NA_integer_,1571L,-7576L,10201L,-1735L,1905L,-4321L,2575L,14L,
  2L,NA_integer_,1651L,-7584L,10054L,-1734L,1966L,-4324L,2507L,14L,
  3L,NA_integer_,1777L,-7531L,9933L,-1731L,2023L,-4339L,2465L,15L,
  4L,NA_integer_,1892L,-7533L,9806L,-1736L,2064L,-4352L,2429L,12L
)

test_that("data works", {
  expect_identical(data, data_sample)
  expect_identical(data_config, data_sample)
})
