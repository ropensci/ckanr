.onLoad <- function(libname, pkgname) {
  ckanr <- list(CKANR_DEFAULT_URL = "https://demo.ckan.org/")
  current <- Sys.getenv("CKANR_DEFAULT_URL", unset = NA)
  if (is.na(current) || !nzchar(trimws(current))) do.call(Sys.setenv, ckanr)
  invisible()
}
