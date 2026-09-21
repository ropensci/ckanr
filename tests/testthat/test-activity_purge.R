context("activity purge (CKAN 2.12)")

skip_on_cran()

url <- get_test_url()
key <- get_test_key()

test_that("activity_delete_counts responds", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)
  skip_if_not_sysadmin(url, key)
  if (!ckanr:::ckan_action_available("activity_delete_counts", url = url, key = key)) {
    skip("activity_delete_counts unavailable (requires CKAN 2.12+)")
  }
  res <- activity_delete_counts(url = url, key = key)
  expect_true(is.list(res))

  expect_ckan_formats(function(fmt) {
    activity_delete_counts(url = url, key = key, as = fmt)
  })
})

test_that("activity_delete validates input", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)
  skip_if_not_sysadmin(url, key)
  if (!ckanr:::ckan_action_available("activity_delete", url = url, key = key)) {
    skip("activity_delete unavailable (requires CKAN 2.12+)")
  }
  expect_error(
    activity_delete(url = url, key = key),
    "Provide `id`, `offset_days`"
  )
})

test_that("activity_delete fails clearly on CKAN < 2.12", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)
  if (ckanr:::ckan_action_available("activity_delete_counts", url = url, key = key)) {
    skip("CKAN supports activity purge; guard test only for older CKAN")
  }
  expect_error(
    activity_delete_counts(url = url, key = key),
    "unavailable"
  )
  expect_error(
    activity_delete(offset_days = 365, url = url, key = key),
    "unavailable"
  )
  expect_error(
    activity_delete_all(url = url, key = key),
    "unavailable"
  )
})
