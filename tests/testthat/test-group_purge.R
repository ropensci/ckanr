context("group_purge")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()

skip_if(
  !nzchar(url) || !nzchar(key),
  "CKAN test settings not configured"
)

unique_group_name <- function(prefix = "ckanr-group-purge") {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sample(10000, 1), sep = "-")
}

test_that("group_purge purges a deleted group", {
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  grp <- group_create(
    name = unique_group_name(),
    title = "temporary group for purge tests",
    url = url,
    key = key
  )

  expect_true(group_delete(grp$id, url = url, key = key))

  group_purge(grp$id, url = url, key = key)

  expect_error(
    group_show(grp$id, url = url, key = key),
    "Not Found Error"
  )
})

test_that("group_purge accepts ckan_group objects", {
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  grp <- group_create(name = unique_group_name(), url = url, key = key)
  group_delete(grp$id, url = url, key = key)

  grp_obj <- tryCatch(
    group_show(grp$id, url = url, key = key),
    error = function(e) e
  )
  if (inherits(grp_obj, "error")) {
    skip("deleted group is no longer retrievable on this CKAN instance")
  }

  group_purge(grp_obj, url = url, key = key)

  expect_error(
    group_show(grp$id, url = url, key = key),
    "Not Found Error"
  )
})

test_that("group_purge fails well", {
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  expect_error(
    group_purge("missing-group-name", url = url, key = key),
    "Not Found Error"
  )

  grp <- group_create(name = unique_group_name(), url = url, key = key)
  on.exit(
    {
      try(group_delete(grp$id, url = url, key = key), silent = TRUE)
      try(group_purge(grp$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  expect_error(
    group_purge(grp$id, url = url, key = "invalid-key"),
    "Authorization Error"
  )
})
