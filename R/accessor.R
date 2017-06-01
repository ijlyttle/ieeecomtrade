#' Accessor functions
#'
#' This is a convenience function for those cases where the comtrade file has
#' **exactly one** sampling frequency.
#'
#' This function uses some simple heuristics to estimate the sampling frequency,
#' assuming that it will be close to the line-frequency multiplied by some
#' positive-integer power of two.
#'
#' @inheritParams ct_instant
#'
#' @return An `integer`, estimate of number of samples per cycle.
#' @examples
#'   library("ieeecomtrade")
#'
#'   ct_sample_per_cycle(keating_1999)
#'   ct_sampling_frequency_nominal(keating_1999)
#' @export
#'
ct_sample_per_cycle <- function(ct) {

  assertthat::assert_that(
    inherits(ct, "comtrade"),
    identical(ct$config$nrates, 1L)
  )

  samp_freq <-
    ct$config$sampling_rate$samp

  exponent <- log2(samp_freq) - log2(ct$config$lf)

  # pendantic way to calculate 2^exponent, keep as integer
  sample_per_cycle <- bitwShiftL(1L, as.integer(round(exponent)))

  sample_per_cycle
}

#' @rdname ct_sample_per_cycle
#' @export
#' @return A `numeric`, estimate of nominal sampling-rate (Hz.).
#'
ct_sampling_frequency_nominal <- function(ct) {

  assertthat::assert_that(
    inherits(ct, "comtrade")
  )

  sampling_frequency_nominal <-
    ct_sample_per_cycle(ct) *
    ct$config$lf

  sampling_frequency_nominal
}

#' @rdname ct_sample_per_cycle
#' @export
#' @return A `numeric`, electrical frequency (Hz.)
#'
ct_electrical_frequency_nominal <- function(ct) {

  assertthat::assert_that(
    inherits(ct, "comtrade")
  )

    # may have to make sure this rounds to 60 or 50

  ct$config$lf
}

#' @rdname ct_sample_per_cycle
#' @export
#' @return A `numeric`, electrical frequency (Hz.)
#'
ct_sampling_frequency <- function(ct) {

  assertthat::assert_that(
    inherits(ct, "comtrade"),
    identical(ct$config$nrates, 1L)
  )

  ct$config$sampling_rate$samp
}

