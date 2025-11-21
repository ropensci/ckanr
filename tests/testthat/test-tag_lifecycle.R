context("tag_lifecycle")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()

skip_if(!nzchar(url) || !nzchar(key),
  "CKAN test settings not configured"
)

unique_vocab_name <- function(prefix = "ckanr-vocab") {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sample(10000, 1), sep = "-")
}

unique_tag_name <- function(prefix = "ckanr-tag") {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sample(10000, 1), sep = "-")
}

create_temp_vocabulary <- function() {
  vocabulary_create(name = unique_vocab_name(), url = url, key = key)
}

cleanup_vocabulary <- function(id) {
  try(vocabulary_delete(id, url = url, key = key), silent = TRUE)
}

create_temp_tag <- function(vocab_id) {
  tag_create(name = unique_tag_name(), vocabulary_id = vocab_id, url = url, key = key)
}

test_that("tag_create and tag_show round-trip", {
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  vocab <- create_temp_vocabulary()
  on.exit(cleanup_vocabulary(vocab$id), add = TRUE)

  tag <- create_temp_tag(vocab$id)
  expect_s3_class(tag, "ckan_tag")
  expect_equal(tag$vocabulary_id, vocab$id)

  shown <- tag_show(tag, include_datasets = FALSE, url = url, key = key)
  expect_equal(shown$id, tag$id)

  json_txt <- tag_show(tag$id, url = url, key = key, as = "json")
  parsed <- jsonlite::fromJSON(json_txt)
  expect_equal(parsed$result$id, tag$id)
})

test_that("tag_list filters by vocabulary", {
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  vocab <- create_temp_vocabulary()
  on.exit(cleanup_vocabulary(vocab$id), add = TRUE)

  tag <- create_temp_tag(vocab$id)

  tags <- tag_list(vocabulary_id = vocab$id, all_fields = TRUE, url = url, key = key)
  expect_true(any(vapply(tags, function(x) x$id == tag$id, logical(1))))

  json_txt <- tag_list(vocabulary_id = vocab$id, url = url, key = key, as = "json")
  parsed <- jsonlite::fromJSON(json_txt)
  expect_true(tag$name %in% parsed$result)
})

test_that("tag_search locates newly created tags", {
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  vocab <- create_temp_vocabulary()
  on.exit(cleanup_vocabulary(vocab$id), add = TRUE)

  tag <- create_temp_tag(vocab$id)

  query_prefix <- substr(tag$name, 1, 3)
  results <- tag_search(query = query_prefix, vocabulary_id = vocab$id, url = url, key = key)
  expect_true(any(vapply(results, function(x) x$id == tag$id, logical(1))))

  json_txt <- tag_search(query = query_prefix, vocabulary_id = vocab$id, url = url, key = key, as = "json")
  parsed <- jsonlite::fromJSON(json_txt)
  expect_true(any(parsed$result$results$name == tag$name))
})

test_that("tag_create fails for missing vocabulary", {
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  expect_error(
    tag_create(name = unique_tag_name(), vocabulary_id = "missing-vocab", url = url, key = key),
    "Validation Error"
  )
})
