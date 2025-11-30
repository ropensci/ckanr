test_that("task status helpers roundtrip", {
  skip_on_cran()
  url <- get_test_url()
  key <- get_test_key()
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  entity_id <- paste0(
    "ckanr-status-", as.integer(Sys.time()), "-",
    paste(sample(letters, 4), collapse = "")
  )

  created <- task_status_update(
    entity_id = entity_id,
    entity_type = "dataset",
    task_type = "ckanr_test",
    task_key = "ckanr",
    value = "queued",
    state = "running",
    url = url,
    key = key
  )
  expect_type(created, "list")
  expect_true(!is.null(created$id))

  entry <- task_status_show(id = created$id, url = url, key = key)
  expect_equal(entry$id, created$id)

  batch <- task_status_update_many(list(list(
    id = created$id,
    entity_id = entity_id,
    entity_type = "dataset",
    task_type = "ckanr_test",
    key = "ckanr",
    state = "finished",
    value = "complete"
  )), url = url, key = key)
  expect_type(batch, "list")

  deleted <- task_status_delete(id = created$id, url = url, key = key)
  expect_true(is.null(deleted) || is.list(deleted))
})

test_that("term translation helpers work", {
  skip_on_cran()
  url <- get_test_url()
  key <- get_test_key()
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  term <- paste0("ckanr_term_", as.integer(Sys.time()))
  lang <- "zz"

  res <- term_translation_update(
    term = term,
    term_translation = "ckanr term",
    lang_code = lang,
    url = url,
    key = key
  )
  expect_type(res, "list")

  fetched <- term_translation_show(term, lang_codes = lang, url = url, key = key)
  expect_type(fetched, "list")
  expect_true(any(vapply(fetched, function(x) identical(x$term, term), logical(1))))

  many <- term_translation_update_many(list(list(
    term = term,
    term_translation = "ckanr term updated",
    lang_code = lang
  )), url = url, key = key)
  expect_type(many, "list")
})

test_that("config option helpers read and write", {
  skip_on_cran()
  url <- get_test_url()
  key <- get_test_key()
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  listed <- config_option_list(url = url, key = key)
  expect_type(listed, "list")

  shown <- config_option_show("ckan.site_title", url = url, key = key)
  expect_type(shown, "character")
  expect_true(nzchar(shown))

  updated <- config_option_update(
    options = list("ckan.site_title" = shown),
    url = url,
    key = key
  )
  expect_type(updated, "list")
})

test_that("job helpers respond", {
  skip_on_cran()
  url <- get_test_url()
  key <- get_test_key()
  check_ckan(url)
  skip_if_not_sysadmin(url, key)

  listed <- job_list(url = url, key = key)
  expect_type(listed, "list")

  cleared <- job_clear(url = url, key = key)
  expect_type(cleared, "list")

  if (length(listed)) {
    job_obj <- listed[[1]]
    job_id <- job_obj$id
    if (is.null(job_id) && !is.null(job_obj$job_id)) {
      job_id <- job_obj$job_id
    }
    if (!is.null(job_id)) {
      details <- job_show(job_id, url = url, key = key)
      expect_type(details, "list")
      cancelled <- job_cancel(job_id, url = url, key = key)
      expect_type(cancelled, "list")
    }
  }
})

test_that("API token helpers roundtrip", {
  skip_on_cran()
  url <- get_test_url()
  key <- get_test_key()
  check_ckan(url)

  user <- tryCatch(current_test_user(url, key), error = function(e) e)
  if (inherits(user, "error")) {
    skip("Authenticated user required for API token tests")
  }

  tokens <- api_token_list(user_id = user$id, url = url, key = key)
  expect_type(tokens, "list")

  token_name <- paste0("ckanr-token-", as.integer(Sys.time()))
  created <- api_token_create(
    user = user$id,
    name = token_name,
    url = url,
    key = key
  )
  expect_true(!is.null(created$token))

  revoked <- api_token_revoke(token = created$token, url = url, key = key)
  expect_true(is.null(revoked) || is.list(revoked))
})

test_that("diagnostic helpers respond", {
  skip_on_cran()
  url <- get_test_url()
  check_ckan(url)

  status <- status_show(url = url)
  expect_type(status, "list")
  expect_true("ckan_version" %in% names(status))

  help <- help_show("package_search", url = url)
  expect_type(help, "character")
})
