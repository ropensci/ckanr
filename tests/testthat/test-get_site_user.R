context("get_site_user")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()

skip_if(
  !nzchar(url) || !nzchar(key),
  "CKAN test settings not configured"
)

test_that("get_site_user returns the site user", {
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  if (!ckanr:::ckan_action_available("get_site_user", url = url, key = key)) {
    skip("get_site_user action unavailable on this CKAN instance")
  }

  usr <- get_site_user(url = url, key = key)
  expect_is(usr, "ckan_user")
  # the site user dict carries a name and apikey, but no id
  expect_true(nzchar(usr$name))

  expect_ckan_formats(function(fmt) {
    get_site_user(url = url, key = key, as = fmt)
  })
})

test_that("get_site_user fails well", {
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  if (!ckanr:::ckan_action_available("get_site_user", url = url, key = key)) {
    skip("get_site_user action unavailable on this CKAN instance")
  }

  expect_error(
    get_site_user(url = url, key = "invalid-key"),
    "Authorization Error"
  )
})
