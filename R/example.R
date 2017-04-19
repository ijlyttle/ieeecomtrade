#' path to example
#'
#' @param path character, name of file
#'
#' @return path to the file
#' @export
#'
ctread_example <- function(path) {
  system.file("extdata", path, package = "ieeecomtrade", mustWork = TRUE)
}
