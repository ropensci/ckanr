context("as_ckan offline coercion")

skip_on_cran()

test_that("as.ckan_package list coercion, predicates and print work offline", {
  pkg <- list(
    id = "pkg-123",
    title = "Test package",
    metadata_created = "2024-01-01",
    metadata_modified = "2024-01-02",
    resources = list(list(name = "res-a"), list(name = "res-b")),
    tags = list(list(name = "tag-a")),
    groups = list()
  )
  obj <- as.ckan_package(pkg)
  expect_true(is.ckan_package(obj))
  expect_false(is.ckan_package(list(a = 1)))
  expect_identical(as.ckan_package(obj), obj)
  expect_output(print(obj), "<CKAN Package> pkg-123")
  expect_output(print(obj), "Test package")

  # list title renders named list titles
  pkg2 <- pkg
  pkg2$title <- list(en = "English title", fr = "Titre")
  expect_output(print(as.ckan_package(pkg2)), "en: English title")

  # title_x and sift_res helpers
  expect_identical(ckanr:::title_x("plain"), "plain")
  expect_true(grepl("en:", ckanr:::title_x(list(en = "x"))))
  expect_null(ckanr:::sift_res(NULL))
  expect_null(ckanr:::sift_res(list()))
  expect_match(
    ckanr:::sift_res(list(list(name = "a"), list(name = "b"))),
    "a"
  )
  # sift_res handles unnamed / empty entries
  expect_true(is.character(
    ckanr:::sift_res(list(list(name = ""), list(other = "x")))
  ) || is.null(ckanr:::sift_res(list(list(name = ""), list(other = "x")))))
})

test_that("as.ckan_group / organization / resource / tag / user / vocabulary work offline", {
  g <- as.ckan_group(list(id = "g1", name = "gname", display_name = "G",
    users = list(), package_count = 2, num_followers = 1, created = "2024-01-01"))
  expect_true(is.ckan_group(g))
  expect_identical(as.ckan_group(g), g)
  expect_false(is.ckan_group(list()))
  expect_output(print(g), "<CKAN Group> g1")

  o <- as.ckan_organization(list(id = "o1", name = "oname"))
  expect_true(is.ckan_organization(o))
  expect_identical(as.ckan_organization(o), o)
  expect_false(is.ckan_organization(list()))

  r <- as.ckan_resource(list(id = "r1", name = "rname"))
  expect_true(is.ckan_resource(r))
  expect_identical(as.ckan_resource(r), r)
  expect_false(is.ckan_resource(list()))

  t <- as.ckan_tag(list(id = "t1", name = "tname"))
  expect_true(is.ckan_tag(t))
  expect_identical(as.ckan_tag(t), t)
  expect_false(is.ckan_tag(list()))

  u <- as.ckan_user(list(id = "u1", name = "uname"))
  expect_true(is.ckan_user(u))
  expect_identical(as.ckan_user(u), u)
  expect_false(is.ckan_user(list()))

  v <- as.ckan_vocabulary(list(id = "v1", name = "vname"))
  expect_true(is.ckan_vocabulary(v))
  expect_identical(as.ckan_vocabulary(v), v)
  expect_false(is.ckan_vocabulary(list()))
})

test_that("as.ckan_related and as.ckan_resource_view behave offline", {
  rel <- as.ckan_related(list(id = "rel1", title = "T", description = "D",
    type = "idea", view_count = 3, created = "2024-01-01"))
  expect_true(is.ckan_related(rel))
  expect_identical(as.ckan_related(rel), rel)
  expect_false(is.ckan_related(list()))
  expect_output(print(rel), "<CKAN Related Item> rel1")

  rv <- as.ckan_resource_view(list(id = "rv1", title = "V",
    view_type = "recline_view", resource_id = "res1"))
  expect_true(is.ckan_resource_view(rv))
  expect_identical(as.ckan_resource_view(rv), rv)
  expect_false(is.ckan_resource_view(list()))
  expect_output(print(rv), "<CKAN Resource View> rv1")

  f <- as.ckan_file(list(id = "f1", name = "a.csv", storage = "default",
    size = 10, owner_type = "package", owner_id = "p1"))
  expect_true(is.ckan_file(f))
  expect_identical(as.ckan_file(f), f)
  expect_output(print(f), "<CKAN File> f1")
  expect_error(as.ckan_file(list(name = "no-id")), "`id`")
})

test_that("print methods tolerate minimal lists", {
  expect_output(
    print(as.ckan_package(list(id = "x", title = "t"))),
    "<CKAN Package> x"
  )
  expect_output(
    print(as.ckan_resource_view(list(id = "x"))),
    "<CKAN Resource View> x"
  )
  expect_output(
    print(as.ckan_related(list(id = "x", title = "t"))),
    "<CKAN Related Item> x"
  )
})

test_that("as_ck attaches classes", {
  x <- ckanr:::as_ck(list(a = 1), "ckan_package")
  expect_true(inherits(x, "ckan_package"))
})
