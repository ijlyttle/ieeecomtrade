#' path to example
#'
#' Currently there are three example-files that all come from the same waveform.
#' The two files, `"keating_1999.CFG"` and `"keating_1999.DAT"` are the contents of
#' `"keating_1999.zip"`.
#'
#' @param path character, name of file
#'
#' @return path to the file
#' @examples
#' \dontrun{
#'   ct_example("keating_1999.CFG")
#'   ct_example("keating_1999.DAT")
#'   ct_example("keating_1999.zip")
#' }
#'   ct_example("keating_1999.zip") %>%
#'   ct_read_zip() %>%
#'   ct_instant()
#' @export
#'
ct_example <- function(path) {
  system.file("extdata", path, package = "ieeecomtrade", mustWork = TRUE)
}
