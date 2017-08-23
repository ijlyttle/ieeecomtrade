#' Create data-frame for analog channels
#'
#' @param .data data frame
#' @param ch_id
#' @param ph
#' @param ccbm
#' @param uu
#' @param a
#' @param b
#' @param skew
#' @param min
#' @param max
#' @param primary
#' @param secondary
#' @param PS
#'
#' @importFrom rlang enquo
#' @importFrom rlang UQ
#' @importFrom rlang eval_tidy
#'
#' @return `tbl_df`
#' @export
#'
ct_config_analog_channel <- function(.data, ch_id = NULL, ph = NULL, ccbm = NULL, uu,
                                     a, b, skew = NULL,
                                     min = -99999L, max = 99999L,
                                     primary = 1, secondary = 1, PS = "P") {

  # could be a handy wee function
  # a bit like purrr::`%||%`, but to work with quosures
  #
  `%|q|%` <- function(x, y){

    x_eval <- eval_tidy(x, data = .data)
    if (is.null(x_eval)) {
      result <- y
    } else {
      x
    }
  }

  ch_id     <- enquo(ch_id) %|q|% quo(NA_character_)
  ph        <- enquo(ph)    %|q|% quo(NA_character_)
  ccbm      <- enquo(ccbm)  %|q|% quo(NA_character_)
  uu        <- enquo(uu)
  a         <- enquo(a)
  b         <- enquo(b)
  skew      <- enquo(skew)  %|q|% quo(NA_real_)
  min       <- enquo(min)
  max       <- enquo(max)
  primary   <- enquo(primary)
  secondary <- enquo(secondary)
  PS        <- enquo(PS)

  result <- .data %>%
    tibble::rowid_to_column("An") %>%
    dplyr::transmute(
      .data$An,
      ch_id = UQ(ch_id),
      ph = UQ(ph),
      ccbm = UQ(ccbm),
      uu = UQ(uu)
    )

  result
}
