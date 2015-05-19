check_ckan <- function(url){
  if (!ping(url)) {
    skip(paste("CKAN is offline.",
               "Did you set CKAN test settings with ?set_test_env ?",
               "Does the test CKAN server run at", url, "?"))
  }
}

check_gen <- function(url, x){
  res <- package_show(did, url = url)
  if (!is(res, "list") && res$id != x) {
    skip(paste("The CKAN test dataset wasn't found.",
               "Did you set CKAN test settings with ?set_test_env ?",
               "Does a dataset with ID", x, "exist on", url, "?"))
  }
}
