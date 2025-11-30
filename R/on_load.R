.onLoad <- function(libname, pkgname) {
  envs <- Sys.getenv()
  ckanr <- list(CKANR_DEFAULT_URL = "https://demo.ckan.org/")
  if (!(names(ckanr) %in% names(envs))) do.call(Sys.setenv, ckanr)
  invisible()
}
