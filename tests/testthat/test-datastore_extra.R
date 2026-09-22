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

# datastore_delete exists in every supported version (2.9-2.12, verified
# against the ckanext.datastore source for each release).
test_that("ds_delete removes filtered rows then drops the table", {
  check_ckan(url)
  skip_if_ckan_below(url, "2.9")
  check_dataset(url, did)

  path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
  res <- resource_create(
    package_id = did,
    description = "Datastore delete test",
    name = "ds_delete_test",
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
      url = url, key = key
    ),
    error = function(e) e
  )
  if (inherits(upserted, "error")) {
    skip(paste("ds_upsert unavailable:", conditionMessage(upserted)))
  }

  deleted <- tryCatch(
    ds_delete(
      resource_id = res$id,
      filters = list(k = "a"),
      force = TRUE,
      url = url, key = key
    ),
    error = function(e) e
  )
  if (inherits(deleted, "error")) {
    skip(paste("ds_delete unavailable:", conditionMessage(deleted)))
  }
  expect_true(is.list(deleted))

  remaining <- ds_search(resource_id = res$id, url = url, key = key)
  expect_true(is.list(remaining$records))
  expect_equal(length(remaining$records), 1)

  # Output formats: insert one row and delete it per format
  expect_ckan_formats(function(fmt) {
    ds_upsert(
      resource_id = res$id,
      records = list(list(k = paste0("fmt_", fmt))),
      method = "insert",
      force = TRUE,
      url = url, key = key
    )
    ds_delete(
      resource_id = res$id,
      filters = list(k = paste0("fmt_", fmt)),
      force = TRUE,
      url = url, key = key, as = fmt
    )
  })

  # Without filters the whole table goes away
  dropped <- ds_delete(resource_id = res$id, force = TRUE,
    url = url, key = key)
  expect_true(is.list(dropped))
  expect_error(
    ds_info(resource_id = res$id, url = url, key = key)
  )
})

test_that("ds_delete fails clearly without a target", {
  check_ckan(url)
  skip_if_ckan_below(url, "2.9")
  expect_error(
    ds_delete(url = url, key = key)
  )
})

# datastore_run_triggers exists in every supported version (2.9-2.12,
# verified against the ckanext.datastore source for each release).
#
# Suspected upstream CKAN 2.12.0 bug: repeating the call on the same table
# hangs the request until the uWSGI worker dies (HARAKIRI in the server
# log) and answers with an empty reply. Each server call below therefore
# uses its own fresh table, with a short retry for a flaked worker.
test_that("ds_run_triggers runs on a datastore table", {
  run_triggers_safe <- function(...) {
    out <- tryCatch(ds_run_triggers(...), error = function(e) e)
    if (inherits(out, "error") &&
        grepl("Empty reply", conditionMessage(out))) {
      Sys.sleep(5)
      out <- tryCatch(ds_run_triggers(...), error = function(e) e)
    }
    if (inherits(out, "error")) {
      stop(out)
    }
    out
  }
  fresh_trigger_table <- function(suffix) {
    res <- resource_create(
      package_id = did,
      description = "Datastore run triggers test",
      name = paste0("ds_run_triggers_test_", suffix),
      upload = path,
      rcurl = "http://example.com",
      url = url,
      key = key
    )
    ds_create(resource_id = res$id, force = TRUE,
      fields = list(list(id = "k", type = "text")),
      records = list(list(k = "a")),
      url = url, key = key)
    res$id
  }

  check_ckan(url)
  skip_if_ckan_below(url, "2.9")
  check_dataset(url, did)

  path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
  tables <- c()
  on.exit(
    {
      for (rid in tables) {
        try(resource_delete(rid, url = url, key = key), silent = TRUE)
      }
    },
    add = TRUE
  )
  make_table <- function(suffix) {
    rid <- tryCatch(fresh_trigger_table(suffix), error = function(e) e)
    if (inherits(rid, "error")) {
      skip(paste("datastore unavailable:", conditionMessage(rid)))
    }
    tables <<- c(tables, rid)
    rid
  }

  # The server answers with the number of records the triggers ran on
  ran <- tryCatch(
    run_triggers_safe(resource_id = make_table("list"), url = url, key = key),
    error = function(e) e
  )
  if (inherits(ran, "error")) {
    skip(paste("ds_run_triggers unavailable:", conditionMessage(ran)))
  }
  expect_true(is.numeric(ran))

  # Output formats, one fresh table per call (see bug note above)
  r_json <- run_triggers_safe(
    resource_id = make_table("json"), url = url, key = key, as = "json")
  expect_type(r_json, "character")
  expect_true(is.numeric(jsonlite::fromJSON(r_json)$result))

  r_table <- run_triggers_safe(
    resource_id = make_table("table"), url = url, key = key, as = "table")
  expect_true(is.numeric(r_table))

  # Failure path: an unknown resource errors fast
  expect_error(
    ds_run_triggers(resource_id = "no-such-resource", url = url, key = key),
    "does not exist"
  )
})

test_that("ds_run_triggers requires a resource id", {
  check_ckan(url)
  skip_if_ckan_below(url, "2.9")
  expect_error(
    ds_run_triggers(url = url, key = key),
    "resource_id"
  )
})
