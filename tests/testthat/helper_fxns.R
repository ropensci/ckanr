check_ckan <- function(){
  if (!ping(url)) {
    skip(paste("CKAN is offline.",
               "Did you set CKAN test settings with ?set_test_env ?",
               "Does the test CKAN server run at", url, "?"))
  }
}
