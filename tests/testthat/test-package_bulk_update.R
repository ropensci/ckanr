context("package_bulk_update")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()

skip_if(
  !nzchar(url) || !nzchar(key),
  "CKAN test settings not configured"
)

unique_name <- function(prefix) {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sample(10000, 1), sep = "-")
}

setup_bulk_org <- function() {
  org <- organization_create(name = unique_name("ckanr-bulk-org"), url = url, key = key)
  ds1 <- package_create(name = unique_name("ckanr-bulk-ds1"), owner_org = org$id, url = url, key = key)
  ds2 <- package_create(name = unique_name("ckanr-bulk-ds2"), owner_org = org$id, url = url, key = key)
  list(org = org, datasets = c(ds1$id, ds2$id))
}

cleanup_bulk_org <- function(fixture) {
  for (ds in fixture$datasets) {
    try(package_delete(ds, url = url, key = key), silent = TRUE)
    try(
      ckan_action("dataset_purge",
        body = list(id = ds), url = url, key = key
      ),
      silent = TRUE
    )
  }
  try(organization_delete(fixture$org$id, url = url, key = key), silent = TRUE)
  try(organization_purge(fixture$org$id, url = url, key = key), silent = TRUE)
}

test_that("bulk_update_private and bulk_update_public toggle visibility", {
  check_ckan(url)

  fixture <- setup_bulk_org()
  on.exit(cleanup_bulk_org(fixture), add = TRUE)

  expect_true(bulk_update_private(fixture$datasets, org_id = fixture$org$id, url = url, key = key))

  private <- package_show(fixture$datasets[1], url = url, key = key)
  expect_true(isTRUE(private$private))

  expect_true(bulk_update_public(fixture$datasets, org_id = fixture$org$id, url = url, key = key))

  public <- package_show(fixture$datasets[1], url = url, key = key)
  expect_false(isTRUE(public$private))
})

test_that("bulk_update_delete deletes datasets", {
  check_ckan(url)

  fixture <- setup_bulk_org()
  on.exit(cleanup_bulk_org(fixture), add = TRUE)

  expect_true(bulk_update_delete(fixture$datasets, org_id = fixture$org$id, url = url, key = key))

  deleted <- package_show(fixture$datasets[1], url = url, key = key)
  expect_equal(deleted$state, "deleted")
})

test_that("bulk_update_* accept ckan_package and ckan_organization objects", {
  check_ckan(url)

  fixture <- setup_bulk_org()
  on.exit(cleanup_bulk_org(fixture), add = TRUE)

  org_obj <- organization_show(fixture$org$id, url = url, key = key)
  pkg_objs <- lapply(fixture$datasets, function(ds) package_show(ds, url = url, key = key))

  expect_true(bulk_update_private(pkg_objs, org_id = org_obj, url = url, key = key))
  expect_true(bulk_update_public(pkg_objs, org_id = org_obj, url = url, key = key))
})

test_that("bulk_update_* fail well", {
  check_ckan(url)

  fixture <- setup_bulk_org()
  on.exit(cleanup_bulk_org(fixture), add = TRUE)

  expect_error(
    bulk_update_private(character(0), org_id = fixture$org$id, url = url, key = key),
    "at least one dataset id"
  )
  expect_error(
    bulk_update_public(fixture$datasets, org_id = "missing-org", url = url, key = key),
    "Not Found Error"
  )
  expect_error(
    bulk_update_delete(fixture$datasets, org_id = fixture$org$id, url = url, key = "invalid-key"),
    "Authorization Error"
  )
})
