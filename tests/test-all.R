library("testthat")
library("ckanr")

# Test CKAN fallback
ckanr_setup(test_url="http://106.187.93.114",
            test_did = "hp03-olderman-dentual",
            test_gid = "wush",
            test_oid = "tainan")

test_check("ckanr")
