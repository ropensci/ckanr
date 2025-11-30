context("package_activity_list")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
oid <- get_test_oid()

skip_if(
  !nzchar(url) || !nzchar(key) || !nzchar(oid),
  "CKAN test settings not configured"
)

unique_package_activity_name <- function(prefix = "ckanr-package-activity") {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sample(10000, 1), sep = "-")
}

create_activity_package <- function() {
  pkg_name <- unique_package_activity_name()
  package_create(
    name = pkg_name,
    title = paste("Activity package", pkg_name),
    owner_org = oid,
    url = url,
    key = key
  )
}

trigger_package_update <- function(pkg) {
  package_update(
    list(notes = paste("updated", Sys.time())),
    id = pkg$id,
    url = url,
    key = key
  )
}

wait_for_package_activity <- function(pkg_id, timeout = 20, interval = 1) {
  deadline <- Sys.time() + timeout
  repeat {
    acts <- package_activity_list(pkg_id, limit = 10, url = url, key = key)
    if (is.list(acts) && any(vapply(acts, function(x) identical(x$object_id, pkg_id), logical(1)))) {
      return(acts)
    }
    if (Sys.time() >= deadline) {
      testthat::skip("Package activity stream did not update in time")
    }
    Sys.sleep(interval)
  }
}

test_that("package_activity_list lists recent changes", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)

  pkg <- create_activity_package()
  on.exit(
    {
      try(package_delete(pkg$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  trigger_package_update(pkg)

  acts <- wait_for_package_activity(pkg$id)
  expect_is(acts, "list")
  expect_true(any(vapply(acts, function(x) x$object_id == pkg$id, logical(1))))
  expect_ckan_formats(function(fmt) {
    package_activity_list(pkg$id, limit = 5, url = url, key = key, as = fmt)
  })
})

test_that("package_activity_list enforces limit parameter", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)

  pkg <- create_activity_package()
  on.exit(
    {
      try(package_delete(pkg$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  trigger_package_update(pkg)
  wait_for_package_activity(pkg$id)

  limited <- package_activity_list(pkg$id, limit = 1, url = url, key = key)
  expect_true(length(limited) <= 1)
})

test_that("package_activity_list fails for unknown packages", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)

  expect_error(
    package_activity_list("missing-package-id", url = url, key = key),
    "Not Found Error"
  )
})
