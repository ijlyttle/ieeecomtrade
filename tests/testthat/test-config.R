context("config")

library("tibble")
library("nanotime")
library("lubridate")

# consider a function to access
file <- ct_example("keating_1999.CFG")

spec <- list(
  station_name = "4_Victoria_Keating.main_7650",
  rec_dev_id = "4_Victoria_Keating.main_7650",
  rev_year = factor(1999L, levels = c(1991L, 1999L, 2013L)),
  TT = 8L,
  `##A` = 8L,
  `##D` = 0L,
  analog_channel = tribble(
    ~An, ~ch_id, ~ph, ~ccbm, ~uu, ~a, ~b, ~skew, ~min, ~max, ~primary, ~secondary, ~PS,
    1L,"I1","I1","4_Victoria_Keating.main_7650","ampere",-0.0197614394128323,25.3736882060767,NA_real_,-99999L,99999L,1,1,"p",
    2L,"I2","I2","4_Victoria_Keating.main_7650","ampere",-0.0197705887258053,25.8599300533533,NA_real_,-99999L,99999L,1,1,"p",
    3L,"I3","I3","4_Victoria_Keating.main_7650","ampere",-0.0197511073201895,24.4123686477542,NA_real_,-99999L,99999L,1,1,"p",
    4L,"I4","I4","4_Victoria_Keating.main_7650","ampere",-0.275151550769806,-476.287334382534,NA_real_,-99999L,99999L,1,1,"p",
    5L,"U1","V1","4_Victoria_Keating.main_7650","volt",-0.113816305994987,8.42240664362904,NA_real_,-99999L,99999L,1,1,"p",
    6L,"U2","V2","4_Victoria_Keating.main_7650","volt",-0.113884098827839,3.07487066835165,NA_real_,-99999L,99999L,1,1,"p",
    7L,"U3","V3","4_Victoria_Keating.main_7650","volt",-0.113433696329594,6.01198590546848,NA_real_,-99999L,99999L,1,1,"p",
    8L,"U4","V4","4_Victoria_Keating.main_7650","volt",-0.0380415394902229,0.494540013372898,NA_real_,-99999L,99999L,1,1,"p"
  ),
  lf = 60,
  nrates = 1L,
  sampling_rate = tribble(
    ~samp, ~endsamp,
    30707.244140625, 2048L
  ),
  dtm_first =
    nanotime(ymd_hms("2015-11-18T05:33:03Z")) +
    .765333000 * 1.e9,
  dtm_trigger =
  nanotime(ymd_hms("2015-11-18T05:33:03Z")) +
    .790289000 * 1.e9,
  ft = factor("ascii", levels = c("ascii", "binary")),
  timemult = 1
)

spec$analog_channel$PS <-
  spec$analog_channel$PS %>%
  factor(levels = c("p", "s"))

test_that("config works", {
  expect_identical(ct_read_config(file), spec)
})
