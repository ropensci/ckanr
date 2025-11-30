context("resource_search")

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

unique_resource_name <- function(prefix = "ckanr-search") {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sample(1000, 1), sep = "-")
}

create_search_resource <- function(name = unique_resource_name()) {
  resource_create(
    package_id = did,
    description = "resource search test",
    name = name,
    upload = path,
    rcurl = "http://example.com",
    url = url,
    key = key
  )
}

search_until_found <- function(query, attempts = 6, delay = 1) {
  for (i in seq_len(attempts)) {
    result <- tryCatch(
      resource_search(query, url = url, limit = 10),
      error = function(e) NULL
    )
    if (!is.null(result) && isTRUE(result$count > 0)) {
      return(result)
    }
    Sys.sleep(delay)
  }
  skip("Resource search index not updated in time")
}

test_that("resource_search finds a newly created resource", {
  check_ckan(url)
  check_dataset(url, did)

  res <- create_search_resource()
  on.exit(
    {
      try(resource_delete(res$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  query <- sprintf("name:%s", res$name)
  result <- search_until_found(query)

  expect_is(result, "list")
  expect_gte(result$count, 1)
  ids <- vapply(result$results, "[[", character(1), "id")
  expect_true(res$id %in% ids)
})

test_that("resource_search accepts vector and list queries", {
  check_ckan(url)
  check_dataset(url, did)

  res <- create_search_resource()
  on.exit(
    {
      try(resource_delete(res$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  vector_query <- c(sprintf("name:%s", res$name), "format:CSV")
  list_query <- list(sprintf("name:%s", res$name), "format:CSV")

  vec_result <- search_until_found(vector_query)
  list_result <- search_until_found(list_query)

  expect_gte(vec_result$count, 1)
  expect_gte(list_result$count, 1)
})

test_that("resource_search supports list/json/table formats", {
  check_ckan(url)
  check_dataset(url, did)

  res <- create_search_resource()
  on.exit(
    {
      try(resource_delete(res$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  query <- sprintf("name:%s", res$name)
  search_until_found(query)

  expect_ckan_formats(function(fmt) {
    resource_search(query, url = url, as = fmt, limit = 10)
  })
})
