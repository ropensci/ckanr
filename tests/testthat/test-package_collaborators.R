context("package_collaborators")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
did <- get_test_did()

check_ckan(url)

# Skip for CKAN < 2.10
# See https://github.com/ropensci/ckanr/issues/220
ver <- floor(ckan_version(url)$version_num)

# basic sanity checks ensure configuration exists
test_that("collaborator tests have config", {
  expect_is(url, "character")
  expect_is(key, "character")
})

test_that("package collaborator listing works when enabled", {
  check_ckan(url)
  check_dataset(url, did)
  skip_if(ver < 210, "Dataset collaborators were introduced in CKAN 2.9, tested in CKAN 2.10+")
  # skip_if_collaborators_disabled(url, key)

  res <- package_collaborator_list(did, url = url, key = key)
  expect_type(res, "list")

  users <- user_list(url = url, key = key)
  skip_if(length(users) == 0, "No users available for collaborator listing test")
  res_user <- package_collaborator_list_for_user(users[[1]], url = url, key = key)
  expect_type(res_user, "list")
})

test_that("package collaborator mutation surfaces API errors", {
  check_ckan(url)
  check_dataset(url, did)
  skip_if(ver < 210, "Dataset collaborators were introduced in CKAN 2.9, tested in CKAN 2.10+")
  # skip_if_collaborators_disabled(url, key)

  bogus_user <- paste0("nonexistent-", as.integer(Sys.time()))
  expect_error(
    package_collaborator_create(did, bogus_user, capacity = "member", url = url, key = key),
    "Error"
  )
  expect_error(
    package_collaborator_delete(did, bogus_user, url = url, key = key),
    "Error"
  )
})
