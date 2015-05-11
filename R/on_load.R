.onLoad <- function(libname, pkgname) {
  op <- options()
  op.ckanr <- list(ckanr.default.url = "http://data.techno-science.ca")
  toset <- !(names(op.ckanr) %in% names(op))
  if (any(toset)) options(op.ckanr[toset])
  invisible()
}
