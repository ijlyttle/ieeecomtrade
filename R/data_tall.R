#' Make a Tall Data Frame
#'
#' The COMTRADE format for the data is a wide data frame, it could be handy
#' to have a tall format.
#'
#' Here are the variables:
#'
#' \describe{
#'   \item{`type`}{character, type of channel: analog or digital}
#'   \item{`channel_number`}{integer, number of channel within `type`}
#'   \item{`n`}{integer, number of observation within `type` and `channel_number`}
#'   \item{`timestamp`}{integer, non-scaled timestamp}
#'   \item{`value`}{integer, non-scaled value}
#' }
#'
#' @param ct comtrade object (see [comtrade()])
#'
#' @return data frame
#' @export
#'
ct_data_tall <- function(ct, ...) {
  UseMethod("ct_data_tall")
}

#' @rdname ct_data_tall
#' @keywords internal
#' @export
#'
ct_data_tall.default <- function(ct, ...){
  stop("Unknown class")
}

#' @rdname ct_data_tall
#' @keywords internal
#' @export
#'
ct_data_tall.comtrade <- function(ct, ...){

  channels <- colnames(ct[["data"]])

  matches <- stringr::str_detect(channels, "^[ad]\\d{6}$")

  extract <- function(x) {
    x %>%
    stringr::str_extract("\\d{6}$") %>%
    as.integer()
  }

  type <- function(x) {

    letter <- stringr::str_extract(x, "^[ad]")

    type <- c(a = "analog", d = "digital")

    unname(type[letter])
  }

  list_mutate <- list(
    channel_number = ~extract(channel),
    type = ~type(channel)
  )

  data_tall <-
    ct[["data"]] %>%
    tidyr::gather_("channel", "value", channels[matches]) %>%
    dplyr::mutate_(.dots = list_mutate) %>%
    dplyr::select_("type", "channel_number", "n", "timestamp", "value")

  data_tall
}
