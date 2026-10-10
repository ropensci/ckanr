context("coverage100 admin/ds")

skip_on_cran()

C2 <- '{"success":true,"result":{"id":"test-id","name":"test-name"}}'
C2LIST <- '{"success":true,"result":[{"id":"v1","name":"n1"}]}'

test_that("admin_ops switches and validations", {
  testthat::with_mocked_bindings(
    ensure_action_available = function(...) invisible(NULL),
    ckan_GET = function(...) C2,
    ckan_POST = function(...) C2,
    .package = "ckanr",
    {
      for (fmt in c("json", "list", "table")) {
        expect_false(is.null(task_status_show(as = fmt, url = "https://example.com")))
        expect_false(is.null(task_status_update(as = fmt, url = "https://example.com")))
        expect_false(is.null(task_status_delete(as = fmt, url = "https://example.com")))
        expect_false(is.null(term_translation_show(c("License"), lang_codes = "fr", as = fmt, url = "https://example.com")))
        expect_false(is.null(term_translation_update(term = "a", term_translation = "b", lang_code = "en", as = fmt, url = "https://example.com")))
        expect_false(is.null(config_option_list(as = fmt, url = "https://example.com")))
        expect_false(is.null(config_option_show("ckan.site_title", as = fmt, url = "https://example.com")))
        expect_false(is.null(config_option_update(list(a = "b"), as = fmt, url = "https://example.com")))
        expect_false(is.null(job_list(as = fmt, url = "https://example.com")))
        expect_false(is.null(job_show("j1", as = fmt, url = "https://example.com")))
        expect_false(is.null(job_clear(as = fmt, url = "https://example.com")))
        expect_false(is.null(job_cancel("j1", as = fmt, url = "https://example.com")))
        expect_false(is.null(api_token_list(as = fmt, url = "https://example.com")))
        expect_false(is.null(api_token_create("u", "n", as = fmt, url = "https://example.com")))
        expect_false(is.null(api_token_revoke(token = "t", as = fmt, url = "https://example.com")))
        expect_false(is.null(api_token_revoke(jti = "j", as = fmt, url = "https://example.com")))
      }
      expect_error(task_status_update_many(list(), url = "https://example.com"), "non-empty list")
      expect_false(is.null(task_status_update_many(list(list(id = "x")), url = "https://example.com")))
      expect_error(term_translation_update_many(list(), url = "https://example.com"), "non-empty list")
      expect_false(is.null(term_translation_update_many(list(list(term = "a")), url = "https://example.com")))
      expect_error(config_option_update(list(), url = "https://example.com"), "named list")
      expect_error(api_token_revoke(url = "https://example.com"), "token or jti")
      # extra_fields branch
      expect_false(is.null(api_token_create("u", "n", extra_fields = list(x = "y"), url = "https://example.com")))
    }
  )
})

test_that("bulk resolve branches", {
  expect_identical(ckanr:::resolve_bulk_dataset_ids(c("a", "b")), c("a", "b"))
  pkg <- structure(list(id = "p1"), class = "ckan_package")
  expect_identical(ckanr:::resolve_bulk_dataset_ids(pkg), "p1")
  expect_identical(ckanr:::resolve_bulk_dataset_ids(list(pkg, list(id = "p2"), "p3")), c("p1", "p2", "p3"))
  expect_error(ckanr:::resolve_bulk_dataset_ids(list(list(foo = 1))), "dataset id")
  expect_error(ckanr:::resolve_bulk_dataset_ids(123), "character vector")
  expect_error(ckanr:::resolve_bulk_dataset_ids(character(0)), "at least one")
  expect_error(ckanr:::resolve_bulk_dataset_ids(c("", NA)), "at least one")
})

test_that("ds and datastore_extra switches", {
  CANNED_DS <- '{"success":true,"result":{"records":[{"a":1}],"fields":[{"id":"a","type":"text"}]}}'
  fake_res <- list(
    status_code = 200,
    parse = function(...) CANNED_DS,
    status_http = function() list(message = "OK"),
    response_headers = list(`content-type` = "application/json"),
    raise_for_ct_json = function() invisible(NULL),
    raise_for_status = function() invisible(NULL)
  )
  fake_con <- list(
    post = function(...) fake_res,
    get = function(...) fake_res
  )
  FakeClient <- list(new = function(...) fake_con)
  testthat::with_mocked_bindings(
    HttpClient = FakeClient,
    .package = "crul",
    {
      for (fmt in c("json", "list", "table")) {
        expect_false(is.null(ds_create("r1", records = list(list(a = 1)), as = fmt, url = "https://example.com")))
        expect_false(is.null(ds_search_sql("SELECT 1", as = fmt, url = "https://example.com")))
      }
    }
  )
  testthat::with_mocked_bindings(
    ensure_action_available = function(...) invisible(NULL),
    ckan_GET = function(...) C2,
    ckan_POST = function(...) C2,
    .package = "ckanr",
    {
      path <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
      for (fmt in c("json", "list", "table")) {
        expect_false(is.null(suppressWarnings(ds_create_dataset("p1", "n", path, as = fmt, url = "https://example.com"))))
      }
    }
  )
})

test_that("package owner org and purge branches", {
  # owner_org_id with various shapes (mock package_show)
  testthat::with_mocked_bindings(
    package_show = function(...) list(owner_org = "org1"),
    .package = "ckanr",
    expect_identical(ckanr:::package_owner_org_id("p1", "https://example.com", NULL), "org1")
  )
  testthat::with_mocked_bindings(
    package_show = function(...) list(organization = list(id = "org2")),
    .package = "ckanr",
    expect_identical(ckanr:::package_owner_org_id("p1", "https://example.com", NULL), "org2")
  )
  testthat::with_mocked_bindings(
    package_show = function(...) list(),
    .package = "ckanr",
    expect_null(ckanr:::package_owner_org_id("p1", "https://example.com", NULL))
  )
  testthat::with_mocked_bindings(
    package_show = function(...) stop("nope"),
    .package = "ckanr",
    expect_null(ckanr:::package_owner_org_id("p1", "https://example.com", NULL))
  )
  # owner_org_update failure returns ok, verification paths
  testthat::with_mocked_bindings(
    as.ckan_package = function(x, ...) structure(list(id = "p1"), class = "ckan_package"),
    as.ckan_organization = function(x, ...) structure(list(id = "org1"), class = "ckan_organization"),
    ckan_POST = function(...) '{"success":false}',
    ckan_version = function(...) list(version_num = 211),
    .package = "ckanr",
    expect_false(isTRUE(package_owner_org_update("p1", "org1", url = "https://example.com")))
  )
  testthat::with_mocked_bindings(
    as.ckan_package = function(x, ...) structure(list(id = "p1"), class = "ckan_package"),
    ckan_POST = function(...) '{"success":true}',
    ckan_version = function(...) list(version_num = 211),
    .package = "ckanr",
    expect_true(package_owner_org_update("p1", "org1", url = "https://example.com"))
  )
})

test_that("resource_views and collaborators", {
  testthat::with_mocked_bindings(
    ensure_action_available = function(...) invisible(NULL),
    ckan_GET = function(...) C2,
    ckan_POST = function(...) C2,
    ckan_PATCH = function(...) C2,
    .package = "ckanr",
    {
      for (fmt in c("json", "list", "table")) {
        expect_false(is.null(resource_view_update("v1", as = fmt, url = "https://example.com")))
      }
      expect_false(is.null(collaborator_request("p1", as = "list", url = "https://example.com")))
    }
  )
})
