.onLoad <- function(libname, pkgname) {
  envs <- Sys.getenv()
  ckanr <- list(CKANR_DEFAULT_URL = "https://data.ontario.ca/")
  if (!(names(ckanr) %in% names(envs))) do.call(Sys.setenv, ckanr)
  invisible()
}
