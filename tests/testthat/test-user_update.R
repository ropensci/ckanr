context("user_update")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()

skip_if(
  !nzchar(url) || !nzchar(key),
  "CKAN test settings not configured"
)

skip_if_not_sysadmin(url, key)

unique_user_name <- function(prefix = "ckanr-user-update") {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sprintf("%04d", sample(10000, 1)), sep = "-")
}

create_temp_user <- function(name = unique_user_name()) {
  user_create(
    name = name,
    email = sprintf("%s@example.com", name),
    password = sprintf("pass-%06d", sample(1e6, 1)),
    fullname = sprintf("CKANR Test %s", name),
    about = "temporary user for update tests",
    url = url,
    key = key
  )
}

cleanup_user <- function(id) {
  suppressWarnings(try(user_delete(id, url = url, key = key), silent = TRUE))
}

test_that("user_update updates metadata via id string", {
  check_ckan(url)

  usr <- create_temp_user()
  on.exit(cleanup_user(usr$id), add = TRUE)

  # user_update replaces the whole account: fetch the full object first
  full <- unclass(user_show(usr$id, url = url, key = key))
  new_about <- paste("updated about", sample(letters, 5, replace = TRUE), collapse = "")
  full$about <- new_about
  updated <- user_update(full, id = usr$id, url = url, key = key)

  expect_is(updated, "ckan_user")
  expect_equal(updated$about, new_about)

  refreshed <- user_show(usr$id, url = url, key = key)
  expect_equal(refreshed$about, new_about)
})

test_that("user_update accepts ckan_user objects", {
  check_ckan(url)

  usr <- create_temp_user()
  on.exit(cleanup_user(usr$id), add = TRUE)

  usr_obj <- user_show(usr$id, url = url, key = key)
  full <- unclass(usr_obj)
  new_fullname <- paste("ckanr user", sample(letters, 6, replace = TRUE), collapse = "")
  full$fullname <- new_fullname
  updated <- user_update(full, id = usr_obj, url = url, key = key)

  expect_equal(updated$fullname, new_fullname)
})

test_that("user_patch patches metadata", {
  check_ckan(url)

  usr <- create_temp_user()
  on.exit(cleanup_user(usr$id), add = TRUE)

  new_about <- paste("patched about", sample(letters, 5, replace = TRUE), collapse = "")
  patched <- user_patch(
    list(about = new_about),
    id = usr$id,
    url = url,
    key = key
  )

  expect_is(patched, "ckan_user")
  expect_equal(patched$about, new_about)

  expect_ckan_formats(function(fmt) {
    user_patch(
      list(about = new_about),
      id = usr$id, url = url, key = key, as = fmt
    )
  })
})

test_that("user_update and user_patch fail well", {
  check_ckan(url)

  usr <- create_temp_user()
  on.exit(cleanup_user(usr$id), add = TRUE)

  expect_error(
    user_update("not-a-list", id = usr$id, url = url, key = key),
    "x must be of class list"
  )
  expect_error(
    user_patch("not-a-list", id = usr$id, url = url, key = key),
    "x must be of class list"
  )

  expect_error(
    user_update(
      list(about = "nope"),
      id = "missing-user-name",
      url = url,
      key = key
    ),
    "Not Found Error"
  )
  expect_error(
    user_patch(
      list(about = "nope"),
      id = "missing-user-name",
      url = url,
      key = key
    ),
    "Not Found Error"
  )

  expect_error(
    user_update(
      list(about = "still nope"),
      id = usr$id,
      url = url,
      key = "invalid-key"
    ),
    "Authorization Error"
  )
})
