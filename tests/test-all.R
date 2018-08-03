library("testthat")
library("ckanr")

source("testthat/helper-ckanr.R")
prepare_test_ckan()

# Test CKAN fallback
if(is.null(get_test_url())) ckanr_setup(test_url="http://demo.ckan.org")

test_check("ckanr")
