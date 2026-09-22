context("resource_patch")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
did <- get_test_did()
path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")

skip_if(
  !nzchar(url) || !nzchar(key) || !nzchar(did),
  "CKAN test settings not configured"
)

unique_resource_name <- function(prefix = "ckanr-patch") {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sample(1000, 1), sep = "-")
}

create_temp_resource <- function(name = unique_resource_name()) {
  resource_create(
    package_id = did,
    description = "resource patch test",
    name = name,
    upload = path,
    rcurl = "http://example.com",
    url = url,
    key = key
  )
}

test_that("resource_patch updates metadata for id string", {
  check_ckan(url)
  check_dataset(url, did)

  res <- create_temp_resource()
  on.exit(
    {
      try(resource_delete(res$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  patched <- resource_patch(
    list(description = "patched description"),
    id = res$id,
    url = url,
    key = key
  )

  expect_is(patched, "ckan_resource")
  expect_equal(patched$id, res$id)
  expect_equal(patched$description, "patched description")
})

test_that("resource_patch accepts ckan_resource objects", {
  check_ckan(url)
  check_dataset(url, did)

  res <- create_temp_resource()
  on.exit(
    {
      try(resource_delete(res$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  res_obj <- resource_show(res$id, url = url, key = key)
  new_title <- paste0("title-", sample(letters, 5, replace = TRUE), collapse = "")
  patched <- resource_patch(
    list(title = new_title),
    id = res_obj,
    url = url,
    key = key
  )

  expect_equal(patched$title, new_title)
})

test_that("resource_patch fails well", {
  check_ckan(url)
  check_dataset(url, did)

  res <- create_temp_resource()
  on.exit(
    {
      try(resource_delete(res$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  expect_error(
    resource_patch("not-a-list", id = res$id, url = url, key = key),
    "x must be of class list"
  )

  expect_error(
    resource_patch(
      list(description = "nope"),
      id = paste0(res$id, "-bogus"),
      url = url,
      key = key
    ),
    "Not Found Error"
  )
})

test_that("resource_patch changes the external URL through rcurl", {
  check_ckan(url)
  check_dataset(url, did)

  res <- create_temp_resource()
  on.exit(
    {
      try(resource_delete(res$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  new_url <- "https://example.com/arcgis/item.html?id=abc123"
  patched <- resource_patch(list(), id = res$id, rcurl = new_url,
    url = url, key = key)

  expect_is(patched, "ckan_resource")
  expect_equal(patched$url, new_url)
  expect_equal(patched$url_type, "link")

  shown <- resource_show(res$id, url = url, key = key)
  expect_equal(shown$url, new_url)

  # rcurl wins over a url item in x
  patched2 <- resource_patch(list(url = "https://example.com/body"),
    id = res$id, rcurl = "https://example.com/param",
    url = url, key = key)
  expect_equal(patched2$url, "https://example.com/param")

  # an explicit url_type item in x wins over the rcurl default
  patched3 <- resource_patch(
    list(url = "https://example.com/kept", url_type = "link"),
    id = res$id,
    url = url, key = key)
  expect_equal(patched3$url, "https://example.com/kept")
  expect_equal(patched3$url_type, "link")
})
