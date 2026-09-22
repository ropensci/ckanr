context("files (CKAN 2.12)")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()

test_that("file helpers fail clearly on CKAN < 2.12", {
  check_ckan(url)
  if (ckanr:::ckan_action_available("file_create", url = url, key = key)) {
    skip("CKAN supports file_create; guard test only relevant on older CKAN")
  }
  expect_error(file_show("some-id", url = url, key = key), "unavailable")
  expect_error(
    file_create(upload = tempfile(), url = url, key = key),
    "unavailable"
  )
})

test_that("file_create validates upload input", {
  check_ckan(url)
  skip_if_not(
    ckanr:::ckan_action_available("file_create", url = url, key = key),
    "file_create unavailable on this CKAN instance"
  )
  expect_error(file_create(url = url, key = key), "`upload` must be")
  expect_error(
    file_create(upload = 123, url = url, key = key),
    "single file path"
  )
  expect_error(
    file_create(upload = tempfile(), url = url, key = key),
    "does not exist"
  )
  expect_error(
    file_register(url = url, key = key),
    "`location` must be"
  )
})

test_that("ckan_file S3 class behaves", {
  f <- as.ckan_file(list(id = "abc", name = "f.txt"))
  expect_true(is.ckan_file(f))
  expect_identical(f$id, "abc")
  expect_error(as.ckan_file(list(name = "no-id")), "`id`")
  expect_output(print(f), "<CKAN File> abc")
  # print tolerates missing fields
  expect_output(print(as.ckan_file(list(id = "abc"))), "<CKAN File> abc")
  # identity coercion
  expect_identical(as.ckan_file(f), f)
})

test_that("file lifecycle roundtrip", {
  check_ckan(url)
  skip_if_not(
    ckanr:::ckan_action_available("file_create", url = url, key = key),
    "file_create unavailable on this CKAN instance"
  )
  skip_if_not_sysadmin(url, key)

  path <- tempfile(fileext = ".txt")
  writeLines(c("ckanr file test", "second line"), path)
  on.exit(unlink(path), add = TRUE)

  created <- file_create(upload = path, url = url, key = key)
  expect_true(is.list(created))
  expect_true(!is.null(created$id))
  on.exit(
    try(file_delete(created$id, url = url, key = key), silent = TRUE),
    add = TRUE
  )

  shown <- file_show(created$id, url = url, key = key)
  expect_equal(shown$id, created$id)

  # S3 object acceptance
  shown2 <- file_show(as.ckan_file(created), url = url, key = key)
  expect_equal(shown2$id, created$id)

  renamed <- file_rename(created$id, name = "ckanr-renamed.txt",
    url = url, key = key)
  expect_equal(renamed$name, "ckanr-renamed.txt")

  pinned <- file_pin(created$id, url = url, key = key)
  expect_true(is.list(pinned))

  unpinned <- file_unpin(created$id, url = url, key = key)
  expect_true(is.list(unpinned))

  expect_ckan_formats(function(fmt) {
    file_show(created$id, url = url, key = key, as = fmt)
  })

  deleted <- file_delete(created$id, url = url, key = key)
  expect_true(is.list(deleted))
})

test_that("file_owner_scan and ownership transfer validate", {
  check_ckan(url)
  skip_if_not(
    ckanr:::ckan_action_available("file_owner_scan", url = url, key = key),
    "file_owner_scan unavailable on this CKAN instance"
  )
  res <- file_owner_scan(
    owner_id = get_test_oid(), owner_type = "organization",
    url = url, key = key
  )
  expect_true(is.list(res))

  expect_error(
    file_ownership_transfer(url = url, key = key),
    'argument "id" is missing|argument "owner_id" is missing'
  )
})
