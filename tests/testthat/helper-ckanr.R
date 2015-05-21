check_ckan <- function(url){
  if (!ping(url)) {
    skip(paste("CKAN is offline.",
               "Did you set CKAN test settings with ?setup_ckanr ?",
               "Does the test CKAN server run at", url, "?"))
  }
}

check_resource <- function(url, x){
  res <- resource_show(x, url = url)
  if (!is(res, "list") && res$id != x) {
    skip(paste("The CKAN test resource wasn't found.",
               "Did you set CKAN test settings with ?setup_ckanr ?",
               "Does a resource with ID", x, "exist on", url, "?"))
  }
}

check_dataset <- function(url, x){
  res <- package_show(x, url = url)
  if (!is(res, "list") && res$id != x) {
    skip(paste("The CKAN test dataset wasn't found.",
               "Did you set CKAN test settings with ?setup_ckanr ?",
               "Does a dataset with ID", did, "exist on", url, "?"))
  }
}
