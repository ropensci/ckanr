library("testthat")
library("ckanr")

ckanr::ckanr_setup(
  test_url = Sys.getenv("CKANR_TEST_URL"),
  test_key = Sys.getenv("CKANR_TEST_KEY"),
  test_behaviour = "SKIP"
)
ckanr::ckanr_settings()
test_check("ckanr")
