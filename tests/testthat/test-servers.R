context("servers")

skip_on_cran()

test_that("servers returns known CKAN instance URLs", {
  srv <- servers()
  expect_type(srv, "character")
  expect_gt(length(srv), 50)
  expect_true(all(grepl("^https?://", srv)))
  expect_true("http://catalog.data.gov" %in% srv)
})

test_that("servers output has no trailing slash issues and no NAs", {
  srv <- servers()
  expect_false(any(is.na(srv)))
  expect_false(any(!nzchar(srv)))
})

test_that(".onLoad sets default URL when env is empty", {
  old <- Sys.getenv("CKANR_DEFAULT_URL", unset = NA)
  on.exit(
    {
      if (is.na(old)) {
        Sys.unsetenv("CKANR_DEFAULT_URL")
      } else {
        Sys.setenv(CKANR_DEFAULT_URL = old)
      }
    },
    add = TRUE
  )

  Sys.unsetenv("CKANR_DEFAULT_URL")
  ckanr:::.onLoad(NULL, NULL)
  expect_identical(
    Sys.getenv("CKANR_DEFAULT_URL"),
    "https://demo.ckan.org/"
  )

  # does not overwrite an existing value
  Sys.setenv(CKANR_DEFAULT_URL = "https://example.com/")
  ckanr:::.onLoad(NULL, NULL)
  expect_identical(
    Sys.getenv("CKANR_DEFAULT_URL"),
    "https://example.com/"
  )
})
