context("related")

skip_on_cran()

url <- get_test_url()
key <- get_test_key()
did <- get_test_did()

test_that("related_list works when available, else fails clearly", {
  check_ckan(url)
  if (ckanr:::ckan_action_available("related_list", url = url)) {
    res <- related_list(url = url)
    expect_true(is.list(res))
  } else {
    expect_error(related_list(url = url), "unavailable on this CKAN instance")
  }
})

test_that("related_show fails clearly when the action is unavailable", {
  check_ckan(url)
  skip_if(
    ckanr:::ckan_action_available("related_show", url = url),
    "related_show is available on this CKAN instance"
  )
  expect_error(
    related_show("dummy-id", url = url),
    "unavailable on this CKAN instance"
  )
})

# The related_* actions were removed from CKAN core before 2.9 and appear
# in none of the official API references for 2.9-2.12, so on all supported
# versions the wrappers must fail clearly. The roundtrip below only runs
# where a server still exposes the actions.
test_that("related_create fails clearly when the action is unavailable", {
  check_ckan(url)
  check_dataset(url, did)
  skip_if(
    ckanr:::ckan_action_available("related_create", url = url, key = key),
    "related_create is available on this CKAN instance"
  )
  expect_error(
    related_create(did,
      title = "ckanr test related", type = "idea",
      url = url, key = key
    ),
    "unavailable on this CKAN instance"
  )
})

test_that("related_delete fails clearly when the action is unavailable", {
  check_ckan(url)
  skip_if(
    ckanr:::ckan_action_available("related_delete", url = url, key = key),
    "related_delete is available on this CKAN instance"
  )
  expect_error(
    related_delete("dummy-id", url = url, key = key),
    "unavailable on this CKAN instance"
  )
})

test_that("related_create/delete roundtrip where the actions exist", {
  check_ckan(url)
  skip_on_os("windows")
  skip_on_os("mac")
  check_dataset(url, did)
  if (!ckanr:::ckan_action_available("related_create", url = url, key = key)) {
    skip("related_create unavailable (absent from CKAN 2.9-2.12 core)")
  }
  if (!ckanr:::ckan_action_available("related_delete", url = url, key = key)) {
    skip("related_delete unavailable (absent from CKAN 2.9-2.12 core)")
  }

  rel <- related_create(did,
    title = "ckanr test related", type = "idea",
    url = url, key = key
  )
  expect_is(rel, "ckan_related")

  # S3 input: a ckan_package object works like an ID string
  pkg <- package_show(did, url = url)
  rel2 <- related_create(pkg,
    title = "ckanr test related 2", type = "idea",
    url = url, key = key
  )
  expect_is(rel2, "ckan_related")

  # Output formats
  for (fmt in c("json", "table")) {
    r <- related_create(did,
      title = paste0("ckanr test related ", fmt), type = "idea",
      url = url, key = key, as = fmt
    )
    if (fmt == "json") {
      expect_type(r, "character")
      rid <- jsonlite::fromJSON(r)$result$id
    } else {
      expect_true(is.list(r) || inherits(r, "data.frame"))
      rid <- r$id
    }
    expect_true(related_delete(rid, url = url, key = key))
  }

  # Failure path: the server rejects an unknown related type
  expect_error(
    related_create(did,
      title = "ckanr test related", type = "bogus-type",
      url = url, key = key
    )
  )

  # S3 input: a ckan_related object works like an ID string
  expect_true(related_delete(rel2, url = url, key = key))
  expect_true(related_delete(rel$id, url = url, key = key))

  # Failure path: deleting an unknown item errors
  expect_error(related_delete("does-not-exist", url = url, key = key))
})
