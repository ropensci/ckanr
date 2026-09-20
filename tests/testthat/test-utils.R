context("ckanr utils")

skip_on_cran()

test_that("handle_many", {
  x <- c("stuff", "things")
  y <- list("stuff:foo", "things:bar")

  xa <- handle_many(x)
  expect_is(xa, "list")
  expect_named(xa, c("query", "query"))

  ya <- handle_many(y)
  expect_is(ya, "list")
  expect_named(ya, c("query", "query"))

  expect_error(handle_many(NA))
  expect_error(handle_many(5))
})

test_that("parse_version_number handles edge cases without warning", {
  expect_identical(parse_version_number("2.9"), 29)
  expect_identical(parse_version_number("2.3.5"), 23.5)
  expect_identical(parse_version_number("2.6.1"), 26.1)
  expect_identical(parse_version_number("2.11.2"), 211.2)
  expect_identical(parse_version_number("2.10.4"), 210.4)
  expect_identical(parse_version_number("3.0.0"), 30)
  expect_true(is.na(suppressWarnings(parse_version_number("2"))))
  expect_true(is.na(parse_version_number(NA_character_)))
  expect_true(is.na(parse_version_number(NULL)))
  expect_warning(parse_version_number("2"), NA)
})

test_that("identifier resolvers handle strings, id lists, and name-only lists", {
  expect_identical(ckanr:::resolve_group_or_org_id("my-group"), "my-group")
  expect_identical(
    ckanr:::resolve_group_or_org_id(list(id = "gid", name = "my-group")),
    "gid"
  )
  expect_identical(
    ckanr:::resolve_group_or_org_id(list(name = "my-group")),
    "my-group"
  )
  expect_identical(
    ckanr:::resolve_object_identifier(list(name = "my-dataset")),
    "my-dataset"
  )
  expect_identical(
    ckanr:::resolve_user_identifier(list(name = "some-user")),
    "some-user"
  )
  expect_identical(
    ckanr:::resolve_username(list(name = "some-user")),
    "some-user"
  )
})
