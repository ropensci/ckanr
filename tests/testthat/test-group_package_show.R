context("group_package_show")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
gid <- get_test_gid()

skip_if(
  !nzchar(url) || !nzchar(key),
  "CKAN test settings not configured"
)

test_that("group_package_show lists group datasets", {
  check_ckan(url)
  check_group(url, gid)

  pkgs <- group_package_show(gid, url = url, key = key)
  expect_true(is.list(pkgs))
  expect_true(all(vapply(pkgs, function(x) is(x, "ckan_package"), logical(1))))

  limited <- group_package_show(gid, limit = 1, url = url, key = key)
  expect_lte(length(limited), 1)

  expect_ckan_formats(function(fmt) {
    group_package_show(gid, url = url, key = key, as = fmt)
  })
})

test_that("group_package_show accepts ckan_group objects", {
  check_ckan(url)
  check_group(url, gid)

  grp <- group_show(gid, url = url, key = key)
  pkgs <- group_package_show(grp, url = url, key = key)
  expect_true(is.list(pkgs))
})

test_that("group_package_show fails well", {
  check_ckan(url)

  expect_error(
    group_package_show("missing-group-name", url = url, key = key),
    "Not Found Error"
  )
})
