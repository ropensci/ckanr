context("related")

skip_on_cran()

url <- get_test_url()

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
