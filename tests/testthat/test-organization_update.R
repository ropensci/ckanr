context("organization_update")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()

skip_if(
  !nzchar(url) || !nzchar(key),
  "CKAN test settings not configured"
)

unique_org_name <- function(prefix = "ckanr-org-update") {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sample(10000, 1), sep = "-")
}

create_temp_org <- function(name = unique_org_name()) {
  organization_create(
    name = name,
    title = paste("ckanr org", name),
    description = "temporary organization for update tests",
    url = url,
    key = key
  )
}

cleanup_org <- function(id) {
  try(organization_delete(id, url = url, key = key), silent = TRUE)
  try(organization_purge(id, url = url, key = key), silent = TRUE)
}

test_that("organization_update updates metadata via id string", {
  check_ckan(url)

  org <- create_temp_org()
  on.exit(cleanup_org(org$id), add = TRUE)

  new_desc <- paste("updated description", sample(letters, 5, replace = TRUE), collapse = "")
  updated <- organization_update(
    list(description = new_desc),
    id = org$id,
    url = url,
    key = key
  )

  expect_is(updated, "ckan_organization")
  expect_equal(updated$description, new_desc)

  refreshed <- organization_show(org$id, url = url, key = key)
  expect_equal(refreshed$description, new_desc)
})

test_that("organization_update accepts ckan_organization objects", {
  check_ckan(url)

  org <- create_temp_org()
  on.exit(cleanup_org(org$id), add = TRUE)

  org_obj <- organization_show(org$id, url = url, key = key)
  new_title <- paste("ckanr title", sample(letters, 6, replace = TRUE), collapse = "")
  updated <- organization_update(
    list(title = new_title),
    id = org_obj,
    url = url,
    key = key
  )

  expect_equal(updated$title, new_title)
})

test_that("organization_patch patches metadata", {
  check_ckan(url)

  org <- create_temp_org()
  on.exit(cleanup_org(org$id), add = TRUE)

  new_title <- paste("ckanr patched", sample(letters, 6, replace = TRUE), collapse = "")
  patched <- organization_patch(
    list(title = new_title),
    id = org$id,
    url = url,
    key = key
  )

  expect_is(patched, "ckan_organization")
  expect_equal(patched$title, new_title)

  expect_ckan_formats(function(fmt) {
    organization_patch(
      list(title = new_title),
      id = org$id, url = url, key = key, as = fmt
    )
  })
})

test_that("organization_update and organization_patch fail well", {
  check_ckan(url)

  org <- create_temp_org()
  on.exit(cleanup_org(org$id), add = TRUE)

  expect_error(
    organization_update("not-a-list", id = org$id, url = url, key = key),
    "x must be of class list"
  )
  expect_error(
    organization_patch("not-a-list", id = org$id, url = url, key = key),
    "x must be of class list"
  )

  expect_error(
    organization_update(
      list(description = "nope"),
      id = paste0(org$id, "-missing"),
      url = url,
      key = key
    ),
    "Not Found Error"
  )
  expect_error(
    organization_patch(
      list(description = "nope"),
      id = paste0(org$id, "-missing"),
      url = url,
      key = key
    ),
    "Not Found Error"
  )

  expect_error(
    organization_update(
      list(description = "still nope"),
      id = org$id,
      url = url,
      key = "invalid-key"
    ),
    "Authorization Error"
  )
})
