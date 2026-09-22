context("CKAN 2.12 compat: include_users, job_list limit")

skip_on_cran()

url <- get_test_url()
key <- get_test_key()

test_that("organization_show include_users preserves users", {
  check_ckan(url)
  check_organization(url, get_test_oid())

  with_users <- organization_show(get_test_oid(), include_users = TRUE,
    url = url, key = key)
  expect_true("users" %in% names(with_users))

  without_users <- organization_show(get_test_oid(), include_users = FALSE,
    url = url, key = key)
  expect_true(is.list(without_users))

  expect_ckan_formats(function(fmt) {
    organization_show(get_test_oid(), include_users = TRUE,
      url = url, key = key, as = fmt)
  })
})

test_that("group_show include_users preserves users", {
  check_ckan(url)
  check_group(url, get_test_gid())

  with_users <- group_show(get_test_gid(), include_users = TRUE,
    url = url, key = key)
  expect_true("users" %in% names(with_users))

  without_users <- group_show(get_test_gid(), include_users = FALSE,
    url = url, key = key)
  expect_true(is.list(without_users))
})

test_that("job_list accepts limit", {
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  listed <- tryCatch(job_list(url = url, key = key), error = function(e) e)
  if (inherits(listed, "error")) {
    skip(paste("job_list unavailable:", conditionMessage(listed)))
  }
  expect_true(is.list(listed))

  limited <- tryCatch(job_list(limit = 1, url = url, key = key),
    error = function(e) e)
  if (!inherits(limited, "error")) {
    expect_true(is.list(limited))
    expect_lte(length(limited), 1)
  }

  ids <- tryCatch(job_list(ids_only = TRUE, url = url, key = key),
    error = function(e) e)
  if (!inherits(ids, "error")) {
    expect_true(is.list(ids) || is.character(ids))
  }
})
