context("group_patch")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()

skip_if(
  !nzchar(url) || !nzchar(key),
  "CKAN test settings not configured"
)

unique_patch_group <- function(prefix = "ckanr-group-patch") {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sample(10000, 1), sep = "-")
}

create_patch_group <- function(name = unique_patch_group()) {
  group_create(
    name = name,
    title = paste("ckanr patch group", name),
    description = "temporary group for patch tests",
    url = url,
    key = key
  )
}

test_that("group_patch updates metadata via id string", {
  check_ckan(url)

  grp <- create_patch_group()
  on.exit(
    {
      try(group_delete(grp$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  new_title <- paste("patched title", sample(letters, 5, replace = TRUE), collapse = "")
  patched <- group_patch(
    list(title = new_title),
    id = grp$id,
    url = url,
    key = key
  )

  expect_is(patched, "ckan_group")
  expect_equal(patched$title, new_title)

  refreshed <- group_show(grp$id, url = url, key = key)
  expect_equal(refreshed$title, new_title)
})

test_that("group_patch accepts ckan_group objects", {
  check_ckan(url)

  grp <- create_patch_group()
  on.exit(
    {
      try(group_delete(grp$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  grp_obj <- group_show(grp$id, url = url, key = key)
  new_desc <- paste("patched description", sample(letters, 6, replace = TRUE), collapse = "")
  patched <- group_patch(
    list(description = new_desc),
    id = grp_obj,
    url = url,
    key = key
  )

  expect_equal(patched$description, new_desc)
})

test_that("group_patch fails well", {
  check_ckan(url)

  grp <- create_patch_group()
  on.exit(
    {
      try(group_delete(grp$id, url = url, key = key), silent = TRUE)
    },
    add = TRUE
  )

  expect_error(
    group_patch("nope", id = grp$id, url = url, key = key),
    "x must be of class list"
  )

  expect_error(
    group_patch(
      list(description = "still nope"),
      id = paste0(grp$id, "-missing"),
      url = url,
      key = key
    ),
    "Not Found Error"
  )

  expect_error(
    group_patch(
      list(description = "auth fail"),
      id = grp$id,
      url = url,
      key = "invalid-key"
    ),
    "Authorization Error"
  )
})
