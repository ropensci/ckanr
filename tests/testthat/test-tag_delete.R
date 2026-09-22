context("tag_delete")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()

skip_if(
  !nzchar(url) || !nzchar(key),
  "CKAN test settings not configured"
)

unique_tag_name <- function(prefix = "ckanr-tag-delete") {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sample(10000, 1), sep = "-")
}

unique_vocab_name <- function(prefix = "ckanr-vocab-delete") {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sample(10000, 1), sep = "-")
}

test_that("tag_delete deletes a vocabulary tag", {
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  vocab <- vocabulary_create(name = unique_vocab_name(), url = url, key = key)
  on.exit(
    try(vocabulary_delete(vocab$id, url = url, key = key), silent = TRUE),
    add = TRUE
  )

  tag <- tag_create(name = unique_tag_name(), vocabulary_id = vocab$id, url = url, key = key)

  expect_true(tag_delete(tag$id, vocabulary_id = vocab$id, url = url, key = key))

  expect_error(
    tag_show(tag$id, url = url, key = key),
    "Not Found Error"
  )
})

test_that("tag_delete accepts ckan_tag objects", {
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  vocab <- vocabulary_create(name = unique_vocab_name(), url = url, key = key)
  on.exit(
    try(vocabulary_delete(vocab$id, url = url, key = key), silent = TRUE),
    add = TRUE
  )

  tag <- tag_create(name = unique_tag_name(), vocabulary_id = vocab$id, url = url, key = key)
  tag_obj <- tag_show(tag$id, url = url, key = key)

  expect_true(tag_delete(tag_obj, vocabulary_id = vocab$id, url = url, key = key))
})

test_that("tag_delete fails well", {
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  expect_error(
    tag_delete("missing-tag-name", url = url, key = key),
    "Not Found Error"
  )

  vocab <- vocabulary_create(name = unique_vocab_name(), url = url, key = key)
  on.exit(
    try(vocabulary_delete(vocab$id, url = url, key = key), silent = TRUE),
    add = TRUE
  )
  tag <- tag_create(name = unique_tag_name(), vocabulary_id = vocab$id, url = url, key = key)
  on.exit(
    try(tag_delete(tag$id, vocabulary_id = vocab$id, url = url, key = key), silent = TRUE),
    add = TRUE
  )

  expect_error(
    tag_delete(tag$id, vocabulary_id = vocab$id, url = url, key = "invalid-key"),
    "Authorization Error"
  )
})
