context("vocabulary")

skip_on_cran()

skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()

random_vocab_name <- function() {
  paste0("ckanr_vocab_", paste(sample(c(letters, 0:9), 10, TRUE), collapse = ""))
}

cleanup_vocabulary <- function(id) {
  try(vocabulary_delete(id, url = url, key = key), silent = TRUE)
}

test_that("vocabulary CRUD helpers work", {
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  vocab_name <- random_vocab_name()
  vocab <- vocabulary_create(name = vocab_name, url = url, key = key)
  cleanup_id <- vocab$id
  on.exit(cleanup_vocabulary(cleanup_id), add = TRUE)

  expect_s3_class(vocab, "ckan_vocabulary")
  expect_equal(vocab$name, vocab_name)

  shown <- vocabulary_show(vocab, url = url, key = key)
  expect_equal(shown$id, vocab$id)

  new_name <- paste0(vocab_name, "_updated")
  updated <- vocabulary_update(vocab, name = new_name, url = url, key = key)
  cleanup_id <- updated$id
  expect_equal(updated$name, new_name)

  listed <- vocabulary_list(url = url, key = key)
  listed_ids <- vapply(listed, `[[`, character(1), "id")
  expect_true(updated$id %in% listed_ids)

  deleted <- vocabulary_delete(updated, url = url, key = key)
  cleanup_id <- NULL
  expect_null(deleted)
})

test_that("tag_autocomplete returns suggestions", {
  check_ckan(url)
  res <- tag_autocomplete(q = "ckan", url = url)

  expect_true(is.character(res))
  expect_true(length(res) >= 1)
  expect_true(any(grepl("ckan", res)))
})
