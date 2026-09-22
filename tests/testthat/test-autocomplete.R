context("autocomplete")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
did <- get_test_did()
gid <- get_test_gid()
oid <- get_test_oid()

skip_if(
  !nzchar(url) || !nzchar(key),
  "CKAN test settings not configured"
)

test_that("package_autocomplete matches the test dataset", {
  check_ckan(url)
  check_dataset(url, did)

  ds <- package_show(did, url = url, key = key)
  q <- substr(ds$name, 1, 6)

  results <- package_autocomplete(q = q, url = url, key = key)
  expect_true(is.list(results))
  expect_true(any(vapply(results, function(x) x$name == ds$name, logical(1))))

  limited <- package_autocomplete(q = q, limit = 1, url = url, key = key)
  expect_lte(length(limited), 1)

  expect_ckan_formats(function(fmt) {
    package_autocomplete(q = q, url = url, key = key, as = fmt)
  })
})

test_that("package_autocomplete fails well", {
  check_ckan(url)

  expect_error(
    package_autocomplete(url = url, key = key),
    'argument "q" is missing'
  )
})

test_that("format_autocomplete returns format names", {
  check_ckan(url)

  formats <- format_autocomplete(q = "csv", url = url, key = key)
  expect_true(is.character(formats))
  expect_true(any(tolower(formats) == "csv"))

  expect_ckan_formats(function(fmt) {
    format_autocomplete(q = "csv", url = url, key = key, as = fmt)
  })
})

test_that("group_autocomplete matches the test group", {
  check_ckan(url)
  check_group(url, gid)

  grp <- group_show(gid, url = url, key = key)
  q <- substr(grp$name, 1, 6)

  results <- group_autocomplete(q = q, url = url, key = key)
  expect_true(is.list(results))
  expect_true(any(vapply(results, function(x) x$name == grp$name, logical(1))))

  expect_ckan_formats(function(fmt) {
    group_autocomplete(q = q, url = url, key = key, as = fmt)
  })
})

test_that("organization_autocomplete matches the test organization", {
  check_ckan(url)
  check_organization(url, oid)

  org <- organization_show(oid, url = url, key = key)
  q <- substr(org$name, 1, 6)

  results <- organization_autocomplete(q = q, url = url, key = key)
  expect_true(is.list(results))
  expect_true(any(vapply(results, function(x) x$name == org$name, logical(1))))

  expect_ckan_formats(function(fmt) {
    organization_autocomplete(q = q, url = url, key = key, as = fmt)
  })
})

test_that("user_autocomplete returns user dictionaries", {
  check_ckan(url)

  if (!ckanr:::ckan_action_available("user_autocomplete", url = url, key = key)) {
    skip("user_autocomplete action unavailable on this CKAN instance")
  }

  me <- tryCatch(current_test_user(url, key), error = function(e) e)
  if (inherits(me, "error")) {
    skip("Unable to determine current user")
  }
  q <- substr(me$name, 1, 3)

  results <- user_autocomplete(q = q, url = url, key = key)
  expect_true(is.list(results))
  expect_true(any(vapply(results, function(x) x$name == me$name, logical(1))))

  expect_ckan_formats(function(fmt) {
    user_autocomplete(q = q, url = url, key = key, as = fmt)
  })
})
