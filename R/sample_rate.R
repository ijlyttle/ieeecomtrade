#' Sample rates.
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
#'   ct_sample_rate_nominal(keating_1999)
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
ct_sample_rate_nominal <- function(ct) {

  sample_rate_nominal <-
    ct_sample_per_cycle(ct) *
    ct$config$lf

  sample_rate_nominal
}
