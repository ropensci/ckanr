context("membership")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
gid <- get_test_gid()
oid <- get_test_oid()

create_temp_user <- function() {
  suffix <- paste(sample(letters, 4, TRUE), collapse = "")
  username <- paste0("ckanr_member_", format(Sys.time(), "%Y%m%d%H%M%S"), suffix)
  usr <- tryCatch(
    user_create(
      name = username,
      email = sprintf("%s@example.com", username),
      password = "secret123",
      url = url,
      key = key
    ),
    error = function(e) e
  )
  if (inherits(usr, "error")) {
    skip(paste("user_create failed:", conditionMessage(usr)))
  }
  usr
}

cleanup_temp_user <- function(usr) {
  try(suppressWarnings(user_delete(usr$id, url = url, key = key)), silent = TRUE)
}

# configuration sanity
test_that("membership tests have config", {
  expect_is(url, "character")
  expect_is(key, "character")
})

test_that("member_list and member_roles_list return data", {
  check_ckan(url)
  check_group(url, gid)
  res <- member_list(gid, url = url, key = key)
  expect_type(res, "list")
  roles <- member_roles_list(url = url, key = key)
  expect_type(roles, "list")
})

test_that("member_create/member_delete round-trip for users", {
  check_ckan(url)
  check_group(url, gid)
  usr <- create_temp_user()
  on.exit(cleanup_temp_user(usr), add = TRUE)

  res <- member_create(gid, usr,
    object_type = "user", capacity = "member",
    url = url, key = key
  )
  expect_type(res, "list")
  expect_true(member_delete(gid, usr, object_type = "user", url = url, key = key))
})

test_that("group_member_create/delete manage membership", {
  check_ckan(url)
  check_group(url, gid)
  usr <- create_temp_user()
  on.exit(cleanup_temp_user(usr), add = TRUE)

  gm <- group_member_create(gid, usr, role = "member", url = url, key = key)
  expect_type(gm, "list")
  expect_true(group_member_delete(gid, usr, url = url, key = key))
})

test_that("organization_member_create/delete manage membership", {
  check_ckan(url)
  check_organization(url, oid)
  usr <- create_temp_user()
  on.exit(cleanup_temp_user(usr), add = TRUE)

  om <- organization_member_create(oid, usr, role = "member", url = url, key = key)
  expect_type(om, "list")
  expect_true(organization_member_delete(oid, usr, url = url, key = key))
})

test_that("group_list_authz returns ckan_group objects", {
  check_ckan(url)
  res <- group_list_authz(url = url, key = key, limit = 5)
  expect_type(res, "list")
  if (length(res)) {
    expect_true(all(vapply(res, inherits, logical(1), what = "ckan_group")))
  }
})

test_that("organization_list_for_user defaults to current user", {
  check_ckan(url)
  res <- organization_list_for_user(url = url, key = key)
  expect_type(res, "list")
  if (length(res)) {
    expect_true(all(vapply(res, inherits, logical(1), what = "ckan_organization")))
  }
})

test_that("user_invite surfaces errors for invalid groups", {
  check_ckan(url)
  expect_error(
    user_invite("nobody@example.com", "does-not-exist", url = url, key = key),
    "Error"
  )
})
