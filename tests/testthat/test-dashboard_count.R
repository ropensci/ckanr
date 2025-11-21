context("dashboard_count")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()

skip_if(!nzchar(url) || !nzchar(key),
  "CKAN test settings not configured"
)

test_that("dashboard_count matches dashboard_new_activities_count", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)

  count <- dashboard_new_activities_count(url = url, key = key)
  alias <- dashboard_count(url = url, key = key)

  expect_true(is.numeric(count))
  expect_equal(alias, count)
})

test_that("dashboard_mark_activities_old completes successfully", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)

  result <- dashboard_mark_activities_old(url = url, key = key)
  expect_null(result)

  refreshed <- dashboard_new_activities_count(url = url, key = key)
  expect_true(is.numeric(refreshed))
})
