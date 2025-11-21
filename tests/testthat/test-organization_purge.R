context("organization_purge")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()

skip_if(!nzchar(url) || !nzchar(key),
  "CKAN test settings not configured"
)

unique_org_name <- function(prefix = "ckanr-org-purge") {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sample(10000, 1), sep = "-")
}

create_temp_org <- function(name = unique_org_name()) {
  organization_create(
    name = name,
    title = paste("ckanr org", name),
    url = url,
    key = key
  )
}

test_that("organization_purge removes a deleted organization", {
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  org <- create_temp_org()
  on.exit({
    try(organization_purge(org$id, url = url, key = key), silent = TRUE)
  }, add = TRUE)

  expect_true(organization_delete(org$id, url = url, key = key))
  purged <- organization_purge(org$id, url = url, key = key)

  expect_true(is.list(purged))
  expect_true(all(vapply(purged, inherits, logical(1), "ckan_organization")))
  expect_error(organization_show(org$id, url = url, key = key), "Not Found Error")
})

test_that("organization_purge fails well", {
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  expect_error(organization_purge(url = url, key = key),
    'argument "id" is missing, with no default'
  )

  expect_error(
    organization_purge("nonexistent-org-id", url = url, key = key),
    "Not Found Error"
  )

  org <- create_temp_org()
  on.exit({
    try(organization_purge(org$id, url = url, key = key), silent = TRUE)
  }, add = TRUE)
  organization_delete(org$id, url = url, key = key)

  expect_error(
    organization_purge(org$id, url = url, key = "invalid-key"),
    "Authorization Error"
  )
})
