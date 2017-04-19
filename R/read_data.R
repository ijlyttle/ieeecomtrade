#' read data file
#'
#' @inheritParams ctread_config
#' @param n_analog  integer, number of analog channels
#' @param n_digital integer, number of digital channels
#' @param n_sample  integer, maximum number of records to read
#'
#' @return tibble, specified in `vignette("data")`
#' @export
#'
ctread_data <- function(file, n_analog, n_digital, n_max = Inf) {

  make_names <- function(root, n) {

    n <- as.integer(n)

    if (identical(n, 0L)) {
      return(NULL)
    }

    names <-
      n %>%
      seq() %>%
      sprintf(paste0(root, "%06d"), .)

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
