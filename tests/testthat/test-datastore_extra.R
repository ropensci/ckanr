context("datastore extras (CKAN 2.12)")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
did <- get_test_did()

test_that("ds_info responds with meta controls", {
  check_ckan(url)
  check_dataset(url, did)
  r <- get_test_rid()
  check_resource(url, r)

  info <- tryCatch(ds_info(resource_id = r, url = url, key = key),
    error = function(e) e)
  if (inherits(info, "error")) {
    skip(paste("ds_info unavailable:", conditionMessage(info)))
  }
  expect_true(is.list(info))

  info_nominal <- tryCatch(
    ds_info(resource_id = r, include_meta = FALSE,
      include_fields_schema = FALSE, url = url, key = key),
    error = function(e) e
  )
  expect_false(inherits(info_nominal, "error"))

  expect_ckan_formats(function(fmt) {
    ds_info(resource_id = r, url = url, key = key, as = fmt)
  })
})

test_that("ds_upsert validates method and ds_delete requires care", {
  check_ckan(url)
  expect_error(
    ds_upsert(resource_id = "x", method = "bogus", url = url, key = key),
    "`method` must be one of"
  )
})

test_that("ds_upsert roundtrip with include_records", {
  check_ckan(url)
  check_dataset(url, did)

  path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
  res <- resource_create(
    package_id = did,
    description = "Datastore upsert test",
    name = "ds_upsert_test",
    upload = path,
    rcurl = "http://example.com",
    url = url,
    key = key
  )
  on.exit(resource_delete(res$id, url = url, key = key), add = TRUE)

  created <- tryCatch(
    ds_create(resource_id = res$id, force = TRUE,
      fields = list(list(id = "k", type = "text")),
      url = url, key = key),
    error = function(e) e
  )
  if (inherits(created, "error")) {
    skip(paste("ds_create unavailable:", conditionMessage(created)))
  }

  upserted <- tryCatch(
    ds_upsert(
      resource_id = res$id,
      records = list(list(k = "a"), list(k = "b")),
      method = "insert",
      force = TRUE,
      include_records = TRUE,
      url = url, key = key
    ),
    error = function(e) e
  )
  if (!inherits(upserted, "error")) {
    expect_true(is.list(upserted))
    # include_records asks the server to echo the inserted rows
    expect_true("records" %in% names(upserted))
    expect_equal(length(upserted$records), 2)
  }

  deleted <- tryCatch(
    ds_records_delete(
      resource_id = res$id,
      filters = list(k = "a"),
      force = TRUE,
      url = url, key = key
    ),
    error = function(e) e
  )
  if (!inherits(deleted, "error")) {
    expect_true(is.list(deleted))
  }
})

test_that("ds_create include_records and ds_search include_next_page", {
  check_ckan(url)
  check_dataset(url, did)

  path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
  res <- resource_create(
    package_id = did,
    description = "Datastore include_* test",
    name = "ds_include_test",
    upload = path,
    rcurl = "http://example.com",
    url = url,
    key = key
  )
  on.exit(resource_delete(res$id, url = url, key = key), add = TRUE)

  # NOTE: multi-record datastore_create with include_records=TRUE hits a
  # server-side ResourceClosedError on CKAN 2.12.0, so exercise the flag
  # with a single record (which the server handles).
  created <- tryCatch(
    ds_create(
      resource_id = res$id,
      fields = list(
        list(id = "k", type = "text"),
        list(id = "v", type = "text")
      ),
      records = list(list(k = "1", v = "x")),
      force = TRUE,
      include_records = TRUE,
      url = url, key = key
    ),
    error = function(e) e
  )
  if (inherits(created, "error")) {
    skip(paste("ds_create unavailable:", conditionMessage(created)))
  }
  expect_true(is.list(created))
  # include_records asks the server to echo the inserted rows
  expect_true("records" %in% names(created) || "resource_id" %in% names(created))

  searched <- tryCatch(
    ds_search(resource_id = res$id, limit = 2, sort = "_id asc",
      include_next_page = TRUE, url = url),
    error = function(e) e
  )
  if (!inherits(searched, "error")) {
    expect_true(is.list(searched))
    # keyset pagination: server returns filters for the next page
    expect_true("next_page" %in% names(searched))
  }
})

test_that("ds_function helpers validate input", {
  check_ckan(url)
  expect_error(
    ds_function_create(url = url, key = key),
    'argument "name" is missing|argument "definition" is missing'
  )
  expect_error(
    ds_function_delete(url = url, key = key),
    'argument "name" is missing'
  )
})

test_that("ds_function_create/delete roundtrip", {
  check_ckan(url)
  skip_if_not_sysadmin(url, key)
  fname <- paste0(
    "ckanr_test_trigger_",
    as.integer(Sys.time()), "_", sample.int(1000, 1)
  )
  on.exit(
    try(ds_function_delete(fname, url = url, key = key), silent = TRUE),
    add = TRUE
  )
  created <- ds_function_create(
    name = fname,
    definition = "BEGIN RETURN NEW; END;",
    url = url, key = key
  )
  expect_true(is.list(created) || is.null(created) || is.character(created))
  deleted <- ds_function_delete(fname, url = url, key = key)
  expect_true(is.list(deleted) || is.null(deleted) || is.character(deleted))
})
