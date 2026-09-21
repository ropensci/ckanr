context("organization_show")

skip_on_cran()

u <- get_test_url()
o <- get_test_oid()

dataset_num <- local({
  check_ckan(u)
  chorg <- tryCatch(check_organization(u, o), error = function(e) e)
  if (inherits(chorg, "error")) {
    ckanr_setup(u, key = Sys.getenv("CKANR_TEST_KEY", ""))
    organization_create(o)
  }
  Sys.sleep(2)
  org <- organization_show(o, url = u)
  res <- crul::HttpClient$new(file.path(u, "organization", org$name))$get()
  res$raise_for_status()
  html <- res$parse("UTF-8")
  tmp <- regmatches(html, regexec("(\\d+) datasets? found", html))
  as.integer(tmp[[1]][2])
})

test_that("organization_show gives back expected class types", {
  check_ckan(u)
  check_organization(u, o)
  a <- organization_show(o, url = u)

  expect_is(a, "ckan_organization")
  # CKAN 2.12 changed organization_show shape: `include_users` defaults to
  # FALSE server-side (ckanr sends TRUE to preserve behavior) and the
  # `packages` key is omitted when include_datasets = FALSE (17 keys on
  # 2.12 vs 18 on 2.11).
  ver <- try(ckan_version(u)$version_num, silent = TRUE)
  if (!inherits(ver, "try-error") && !is.na(ver) && ver >= 212) {
    expect_equal(as.integer(length(a)), 17L)
  } else if (!inherits(ver, "try-error") && !is.na(ver) && ver < 212) {
    expect_equal(as.integer(length(a)), 18L)
  } else {
    expect_true(as.integer(length(a)) %in% c(17L, 18L))
  }
  expect_true("users" %in% names(a))

  a <- organization_show(o, url = u, include_datasets = TRUE)
  expect_equal(as.integer(a$package_count), dataset_num)
  expect_true(as.integer(length(a$packages)) <= dataset_num)
  # CKAN could hide packages due to pagination or default visibility
  if (dataset_num > 0) {
    expect_true(length(a$packages) > 0)
  }

  expect_ckan_formats(function(fmt) {
    organization_show(o, url = u, as = fmt)
  })
})
