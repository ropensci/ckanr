context("ds_create_dataset")

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

unique_resource_name <- function(prefix = "ckanr-ds-create") {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sep = "-")
}

test_that("ds_create_dataset uploads a CSV resource", {
  check_ckan(url)
  check_dataset(url, did)

  res_name <- unique_resource_name()
  created <- NULL

  expect_warning(
    {
      created <- ds_create_dataset(
        package_id = did,
        name = res_name,
        path = path,
        url = url,
        key = key
      )
    },
    "deprecated"
  )

  expect_is(created, "list")
  expect_equal(created$name, res_name)
  expect_equal(tolower(created$format), "csv")

  on.exit(
    {
      if (!is.null(created$id)) {
        try(resource_delete(created$id, url = url, key = key), silent = TRUE)
      }
    },
    add = TRUE
  )

  fetched <- resource_show(created$id, url = url, key = key)
  expect_equal(fetched$id, created$id)
  expect_equal(fetched$name, res_name)
})

test_that("ds_create_dataset fails with bad inputs", {
  check_ckan(url)
  check_dataset(url, did)

  expect_error(suppressWarnings(ds_create_dataset()),
    "argument \"path\" is missing",
    fixed = FALSE
  )

  expect_error(
    suppressWarnings(ds_create_dataset(
      package_id = did,
      name = unique_resource_name(),
      path = path,
      url = url,
      key = "badkey"
    )),
    "Authorization Error|403",
    ignore.case = TRUE
  )

  missing_file <- tempfile(fileext = ".csv")
  expect_error(
    suppressWarnings(ds_create_dataset(
      package_id = did,
      name = unique_resource_name(),
      path = missing_file,
      url = url,
      key = key
    )),
    "cannot open|No such file|file\\.exists",
    ignore.case = TRUE
  )
})
