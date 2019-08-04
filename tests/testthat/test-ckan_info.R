context("test-ckan_info")

test_that("parse_version_number parses correctly.", {
  expect_equal(parse_version_number("2.1"), 21)
  expect_equal(parse_version_number("2.1b"), 21)
  expect_equal(parse_version_number("2.1.0"), 21)
  expect_equal(parse_version_number("2.1.1b"), 21.1)
  expect_equal(parse_version_number("2.1.1"), 21.1)
  expect_equal(parse_version_number("21.1.1"), 211.1)
  expect_equal(parse_version_number("0.0.1"), 0.1)
  expect_equal(parse_version_number("0.1.1"), 1.1)
  expect_equal(parse_version_number("0.1.0"), 1)
  expect_equal(parse_version_number("0.0.0.9000"), 0.09)
})
