context("organization_follow")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
oid <- get_test_oid()

skip_if(
  !nzchar(url) || !nzchar(key),
  "CKAN test settings not configured"
)

test_that("organization follower count and list return data", {
  check_ckan(url)
  check_organization(url, oid)

  expect_true(is.numeric(organization_follower_count(oid, url = url, key = key)))
  expect_type(organization_follower_list(oid, url = url, key = key), "list")

  # counts come back as bare numbers in every parsed format
  expect_type(
    organization_follower_count(oid, url = url, key = key, as = "json"),
    "character"
  )
  expect_true(is.numeric(
    organization_follower_count(oid, url = url, key = key, as = "table")
  ))

  expect_ckan_formats(function(fmt) {
    organization_follower_list(oid, url = url, key = key, as = fmt)
  })
})

test_that("organization follower helpers accept ckan_organization objects", {
  check_ckan(url)
  check_organization(url, oid)

  org <- organization_show(oid, url = url, key = key)
  expect_true(is.numeric(organization_follower_count(org, url = url, key = key)))
  expect_type(organization_follower_list(org, url = url, key = key), "list")
})

test_that("organization followee count and list return data", {
  check_ckan(url)

  me <- tryCatch(current_test_user(url, key), error = function(e) e)
  if (inherits(me, "error")) {
    skip("Unable to determine current user")
  }

  expect_true(is.numeric(organization_followee_count(me$name, url = url, key = key)))
  expect_type(organization_followee_list(me$name, url = url, key = key), "list")
})

test_that("organization follower helpers fail well", {
  check_ckan(url)

  expect_error(
    organization_follower_count("missing-org-name", url = url, key = key),
    "Not Found Error"
  )
  expect_error(
    organization_follower_list("missing-org-name", url = url, key = key),
    "Not Found Error"
  )
})
