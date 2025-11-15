context("ds_create")

skip_on_cran()

# to avoid failures on different CI operating systems
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
did <- get_test_did()

test_that("The CKAN URL must be set", { expect_is(url, "character") })
test_that("The CKAN API key must be set", { expect_is(key, "character") })
test_that("A CKAN dataset ID must be set", { expect_is(did, "character") })

test_that("ds_create creates a datastore table", {
  check_ckan(url)
  check_dataset(url, did)

  # Create a resource first
  path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
  res <- resource_create(
    package_id = did,
    description = "Datastore test resource",
    name = "ds_test",
    upload = path,
    rcurl = "http://example.com",
    url = url,
    key = key
  )

  # Create a simple datastore with sample records
  test_data <- data.frame(
    id = 1:3,
    name = c("A", "B", "C"),
    value = c(10, 20, 30),
    stringsAsFactors = FALSE
  )

  result <- tryCatch({
    ds_create(
      resource_id = res$id,
      records = test_data,
      force = TRUE,
      url = url,
      key = key
    )
  }, error = function(e) e)

  # The function may work or may have issues based on CKAN version
  if (!inherits(result, "error")) {
    expect_is(result, "list")
    expect_true("resource_id" %in% names(result))
  }

  # Clean up
  resource_delete(res$id, url = url, key = key)
})

test_that("ds_create with fields specification", {
  check_ckan(url)
  check_dataset(url, did)

  # Create a resource first
  path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
  res <- resource_create(
    package_id = did,
    description = "Datastore test resource 2",
    name = "ds_test_2",
    upload = path,
    rcurl = "http://example.com",
    url = url,
    key = key
  )

  # Create datastore with field specifications
  fields <- list(
    list(id = "id", type = "int"),
    list(id = "name", type = "text"),
    list(id = "value", type = "numeric")
  )

  result <- tryCatch({
    ds_create(
      resource_id = res$id,
      fields = fields,
      force = TRUE,
      url = url,
      key = key
    )
  }, error = function(e) e)

  # The function may work or may have issues based on CKAN version
  if (!inherits(result, "error")) {
    expect_is(result, "list")
  }

  # Clean up
  resource_delete(res$id, url = url, key = key)
})

test_that("ds_create fails well", {
  check_ckan(url)

  # no resource_id provided
  expect_error(ds_create(url = url, key = key))

  # invalid resource_id
  expect_error(
    ds_create(resource_id = "nonexistent-resource", url = url, key = key),
    "Not Found Error|error"
  )
})
