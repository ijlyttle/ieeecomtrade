#' path to example
#'
#' @param path character, name of file
#'
#' @return path to the file
#' @export
#'
ct_example <- function(path) {
  system.file("extdata", path, package = "ieeecomtrade", mustWork = TRUE)
}