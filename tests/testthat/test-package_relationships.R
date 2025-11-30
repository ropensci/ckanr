context("package_relationships")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
oid <- get_test_oid()

create_temp_package <- function(prefix = "rel_pkg_") {
  pkg_name <- paste0(prefix, as.integer(Sys.time()), sample.int(1000, 1))
  package_create(name = pkg_name, owner_org = oid, url = url, key = key)
}

test_that("package_relationship lifecycle works", {
  check_ckan(url)
  pkg_a <- create_temp_package("rel_subj_")
  pkg_b <- create_temp_package("rel_obj_")
  on.exit(
    {
      package_delete(pkg_a$id, url = url, key = key)
      package_delete(pkg_b$id, url = url, key = key)
    },
    add = TRUE
  )

  rel <- package_relationship_create(pkg_a, pkg_b,
    relationship_type = "depends_on",
    comment = "initial", url = url, key = key
  )
  expect_type(rel, "list")
  expect_equal(rel$type, "depends_on")

  expect_error(
    package_relationship_update(pkg_a, pkg_b,
      relationship_type = "depends_on", comment = "updated",
      url = url, key = key
    ),
    "Internal Server Error",
    info = "CKAN core currently raises 500 when updating relationships"
  )

  expect_true(package_relationship_delete(pkg_a, pkg_b,
    relationship_type = "depends_on", url = url, key = key
  ))
})

test_that("package_relationships_list filters by partner", {
  check_ckan(url)
  pkg_a <- create_temp_package("rel_list_a_")
  pkg_b <- create_temp_package("rel_list_b_")
  on.exit(
    {
      package_delete(pkg_a$id, url = url, key = key)
      package_delete(pkg_b$id, url = url, key = key)
    },
    add = TRUE
  )

  package_relationship_create(pkg_a, pkg_b,
    relationship_type = "derives_from",
    comment = "list test", url = url, key = key
  )

  rels <- package_relationships_list(pkg_a, url = url, key = key)
  expect_type(rels, "list")
  expect_true(any(vapply(rels, function(x) x$type == "derives_from", logical(1))))

  scoped <- package_relationships_list(pkg_a,
    id2 = pkg_b,
    relationship_type = "derives_from", url = url, key = key
  )
  expect_equal(length(scoped), 1)
  expect_equal(scoped[[1]]$object, pkg_b$name)

  package_relationship_delete(pkg_a, pkg_b,
    relationship_type = "derives_from",
    url = url, key = key
  )
})
