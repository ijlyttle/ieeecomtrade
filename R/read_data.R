#' Read data file using config information
#'
#' This is a wrapper for [`ct_read_data()`].
#'
#' @inheritParams ct_read_config
#' @param config list created using [`ct_read_config()`]
#'
#' @return tibble (data frame)
#' @examples
#'   config <- ct_example("keating_1999.CFG") %>% ct_read_config()
#'   ct_example("keating_1999.DAT") %>% ct_read_data_config(config)
#' @seealso [`ct_read_data()`]
#' @export
#'
#'
ct_read_data_config <- function(file, config){

  # TODO: validate config
  # TODO: find a way to check for the existance of config$sampling_rate$endsamp

  ct_read_data(
    file,
    n_analog = config[["##A"]],
    n_digital = config[["##D"]],
    n_max = max(config[["sampling_rate"]][["endsamp"]])
  )
}

#' Read data file
#'
#' In practice, it may be easier to use [`ct_read_data_config()`].
#'
#' @inheritParams ct_read_config
#' @param n_analog  integer, number of analog channels
#' @param n_digital integer, number of digital channels
#' @param n_max  integer, maximum number of records to read
#'
#' @return tibble (data frame)
#' @examples
#'   config <- ct_example("keating_1999.CFG") %>% ct_read_config()
#'   ct_example("keating_1999.DAT") %>%
#'     ct_read_data(
#'       n_analog = config[["##A"]],
#'       n_digital = config[["##D"]],
#'       n_max = max(config$sampling_rate$endsamp)
#'     )
#' @seealso [`ct_read_data_config()`]
#' @export
#'
ct_read_data <- function(file, n_analog, n_digital, n_max = Inf) {

  make_names <- function(root, n) {

    n <- as.integer(n)

    if (identical(n, 0L)) {
      return(NULL)
    }

    names <- sprintf(paste0(root, "%06d"), seq(n))

    names
  }

  col_names <-
    c("n", "timestamp", make_names("a", n_analog), make_names("d", n_digital))

  col_types <- paste(rep("i", 2 + n_analog + n_digital), collapse = "")

  readr::read_csv(
    file,
    col_names = col_names,
    col_types = col_types,
    n_max = n_max
  )
}
