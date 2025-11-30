context("package_dataset_extras")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
oid <- get_test_oid()

create_dataset_with_resources <- function(n = 2) {
  pkg <- package_create(
    name = paste0("revise_pkg_", as.integer(Sys.time()), sample.int(1000, 1)),
    owner_org = oid,
    url = url,
    key = key
  )
  paths <- system.file("examples", c("actinidiaceae.csv", "iris.parquet"),
    package = "ckanr"
  )
  paths <- paths[file.exists(paths)]
  for (i in seq_len(min(n, length(paths)))) {
    resource_create(
      package_id = pkg$id,
      name = paste0("res_", i, "_", pkg$id),
      upload = paths[[i]],
      format = tools::file_ext(paths[[i]]),
      url = url,
      key = key
    )
  }
  pkg
}

test_that("package_revise updates metadata", {
  check_ckan(url)
  pkg <- create_dataset_with_resources(1)
  on.exit(package_delete(pkg$id, url = url, key = key), add = TRUE)

  res <- package_revise(
    match = list(id = pkg$id),
    update = list(notes = "Revised via test"),
    include = "package",
    url = url,
    key = key
  )
  expect_true(is.list(res))
  expect_equal(res$package$notes, "Revised via test")
})

test_that("package_resource_reorder rearranges resources", {
  check_ckan(url)
  pkg <- create_dataset_with_resources(2)
  on.exit(package_delete(pkg$id, url = url, key = key), add = TRUE)
  pkg_refreshed <- package_show(pkg$id, url = url, key = key)
  res_ids <- vapply(pkg_refreshed$resources, function(x) x$id, character(1))
  skip_if(length(res_ids) < 2, "Need at least two resources to reorder")

  package_resource_reorder(pkg, order = rev(res_ids), url = url, key = key)
  updated <- package_show(pkg$id, url = url, key = key)
  updated_ids <- vapply(updated$resources, function(x) x$id, character(1))
  expect_equal(updated_ids[seq_along(res_ids)], rev(res_ids))
})

test_that("package_owner_org_update moves dataset between orgs", {
  check_ckan(url)
  pkg <- package_create(
    name = paste0("owner_move_", as.integer(Sys.time()), sample.int(1000, 1)),
    owner_org = oid,
    url = url,
    key = key
  )
  on.exit(package_delete(pkg$id, url = url, key = key), add = TRUE)

  org_name <- paste0("temp_org_", as.integer(Sys.time()), sample.int(1000, 1))
  new_org <- organization_create(name = org_name, url = url, key = key)
  on.exit(suppressWarnings(organization_delete(new_org$id, url = url, key = key)), add = TRUE)

  expect_true(package_owner_org_update(pkg,
    organization_id = new_org,
    url = url, key = key
  ))
  moved <- package_show(pkg$id, url = url, key = key)
  expect_equal(moved$organization$id, new_org$id)

  # move back for cleanup
  package_owner_org_update(pkg, organization_id = oid, url = url, key = key)
  moved_back <- package_show(pkg$id, url = url, key = key)
  expect_equal(moved_back$organization$id, oid)
})

test_that("dataset_purge is gated behind opt-in", {
  check_ckan(url)
  skip_if(
    tolower(Sys.getenv("CKANR_ALLOW_PURGE_TESTS")) %in% c("", "false", "0"),
    "Set CKANR_ALLOW_PURGE_TESTS=true to exercise dataset_purge"
  )

  pkg <- package_create(
    name = paste0("purge_pkg_", as.integer(Sys.time()), sample.int(1000, 1)),
    owner_org = oid,
    url = url,
    key = key
  )
  package_delete(pkg$id, url = url, key = key)

  expect_true(dataset_purge(pkg$id, url = url, key = key))
})
