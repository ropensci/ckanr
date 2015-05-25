library("testthat")
library("ckanr")

# Test CKAN fallback
if(is.null(get_test_url())) ckanr_setup(test_url="http://demo.ckan.org")

test_check("ckanr")
