context("group_update")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()

skip_if(!nzchar(url) || !nzchar(key),
  "CKAN test settings not configured"
)

unique_group_name <- function(prefix = "ckanr-group-update") {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sample(10000, 1), sep = "-")
}

create_temp_group <- function(name = unique_group_name()) {
  group_create(
    name = name,
    title = paste("ckanr group", name),
    description = "temporary group for update tests",
    url = url,
    key = key
  )
}

test_that("group_update updates metadata via id string", {
  check_ckan(url)

  grp <- create_temp_group()
  on.exit({
    try(group_delete(grp$id, url = url, key = key), silent = TRUE)
  }, add = TRUE)

  new_desc <- paste("updated description", sample(letters, 5, replace = TRUE), collapse = "")
  updated <- group_update(
    list(description = new_desc),
    id = grp$id,
    url = url,
    key = key
  )

  expect_is(updated, "ckan_group")
  expect_equal(updated$description, new_desc)

  refreshed <- group_show(grp$id, url = url, key = key)
  expect_equal(refreshed$description, new_desc)
})

test_that("group_update accepts ckan_group objects", {
  check_ckan(url)

  grp <- create_temp_group()
  on.exit({
    try(group_delete(grp$id, url = url, key = key), silent = TRUE)
  }, add = TRUE)

  grp_obj <- group_show(grp$id, url = url, key = key)
  new_title <- paste("ckanr title", sample(letters, 6, replace = TRUE), collapse = "")
  updated <- group_update(
    list(title = new_title),
    id = grp_obj,
    url = url,
    key = key
  )

  expect_equal(updated$title, new_title)
})

test_that("group_update fails well", {
  check_ckan(url)

  grp <- create_temp_group()
  on.exit({
    try(group_delete(grp$id, url = url, key = key), silent = TRUE)
  }, add = TRUE)

  expect_error(
    group_update("not-a-list", id = grp$id, url = url, key = key),
    "x must be of class list"
  )

  expect_error(
    group_update(
      list(description = "nope"),
      id = paste0(grp$id, "-missing"),
      url = url,
      key = key
    ),
    "Not Found Error"
  )

  expect_error(
    group_update(
      list(description = "still nope"),
      id = grp$id,
      url = url,
      key = "invalid-key"
    ),
    "Authorization Error"
  )
})
