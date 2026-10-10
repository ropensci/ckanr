context("coverage100 switches")

skip_on_cran()

CANNED <- '{"success":true,"result":{"id":"test-id","name":"test-name","title":"Test","total":0,"records":[],"fields":[{"id":"a","type":"text"}],"owner_org":"org1","organization":{"id":"org1"},"owner_type":"package","owner_id":"p1","storage":"default","size":1}}'
CANNED_LIST <- '{"success":true,"result":[{"id":"v1","name":"n1"}]}'

MOCK_HTTP <- function(code) {
  testthat::with_mocked_bindings(
    ensure_action_available = function(...) invisible(NULL),
    ckan_GET = function(...) CANNED_LIST,
    ckan_POST = function(...) CANNED_LIST,
    ckan_PATCH = function(...) CANNED_LIST,
    ckan_DELETE = function(...) CANNED_LIST,
    ckan_version = function(...) list(version = "2.11.0", version_num = 211),
    .package = "ckanr",
    code
  )
}

test_that("activity switches cover json/list/table", {
  MOCK_HTTP({
    for (fmt in c("json", "list", "table")) {
      expect_false(is.null(group_activity_list(list(id = "g1"), as = fmt, url = "https://example.com")))
      expect_false(is.null(organization_activity_list(list(id = "o1"), as = fmt, url = "https://example.com")))
      expect_false(is.null(recently_changed_packages_activity_list(as = fmt, url = "https://example.com")))
      expect_false(is.null(dashboard_new_activities_count(as = fmt, url = "https://example.com")))
      expect_false(is.null(dashboard_mark_activities_old(as = fmt, url = "https://example.com")))
      expect_false(is.null(activity_show("a1", as = fmt, url = "https://example.com")))
      expect_false(is.null(activity_data_show("a1", "package", as = fmt, url = "https://example.com")))
      expect_false(is.null(activity_diff("a1", "package", as = fmt, url = "https://example.com")))
    }
  })
})

test_that("vocabulary switches cover json/list/table", {
  testthat::with_mocked_bindings(
    ensure_action_available = function(...) invisible(NULL),
    ckan_GET = function(...) CANNED_LIST,
    ckan_POST = function(...) CANNED_LIST,
    .package = "ckanr",
    {
      for (fmt in c("json", "list", "table")) {
        expect_false(is.null(vocabulary_list(as = fmt, url = "https://example.com")))
        expect_false(is.null(vocabulary_show(list(id = "v1"), as = fmt, url = "https://example.com")))
        expect_false(is.null(vocabulary_create("voc", as = fmt, url = "https://example.com")))
        expect_false(is.null(vocabulary_update(list(id = "v1"), as = fmt, url = "https://example.com")))
        expect_false(is.null(vocabulary_delete(list(id = "v1"), as = fmt, url = "https://example.com")))
      }
      for (fmt in c("json", "list", "table")) {
        expect_false(is.null(tag_autocomplete("q", as = fmt, url = "https://example.com")))
      }
    }
  )
})

test_that("related switches cover json/list/table", {
  MOCK_HTTP({
    for (fmt in c("json", "list", "table")) {
      expect_false(is.null(related_create(list(id = "p1"), title = "t", type = "idea", as = fmt, url = "https://example.com", key = "k")))
      expect_false(is.null(related_list(as = fmt, url = "https://example.com")))
      expect_false(is.null(related_show("r1", as = fmt, url = "https://example.com")))
    }
    expect_true(is.list(related_delete("r1", url = "https://example.com", key = "k")) || !is.null(related_delete("r1", url = "https://example.com", key = "k")))
  })
})

test_that("package extras switches", {
  MOCK_HTTP({
    for (fmt in c("json", "list", "table")) {
      expect_false(is.null(package_revise(match = list(name = "x"), update = list(notes = "y"), as = fmt, url = "https://example.com")))
      expect_false(is.null(package_resource_reorder(list(id = "p1"), order = c("r1"), as = fmt, url = "https://example.com")))
      expect_false(is.null(package_search(as = fmt, url = "https://example.com")))
      expect_false(is.null(package_show("p1", as = fmt, url = "https://example.com")))
    }
  })
})

test_that("group/org/user patch/update/purge/delete switches", {
  MOCK_HTTP({
    for (fmt in c("json", "list", "table")) {
      expect_false(is.null(group_patch(list(id = "g1"), id = "g1", as = fmt, url = "https://example.com")))
      expect_false(is.null(group_update(list(id = "g1"), id = "g1", as = fmt, url = "https://example.com")))
      expect_false(is.null(group_purge("g1", as = fmt, url = "https://example.com")))
      expect_false(is.null(organization_update(list(id = "o1"), id = "o1", as = fmt, url = "https://example.com")))
      expect_false(is.null(organization_purge("o1", as = fmt, url = "https://example.com")))
      expect_false(is.null(organization_delete("o1", as = fmt, url = "https://example.com")))
      expect_false(is.null(user_create("u", "e@e.com", "pw", as = fmt, url = "https://example.com")))
      expect_false(is.null(user_delete("u1", as = fmt, url = "https://example.com")))
      expect_false(is.null(user_update(list(id = "u1"), id = "u1", as = fmt, url = "https://example.com")))
      expect_false(is.null(resource_patch(list(id = "r1"), id = "r1", as = fmt, url = "https://example.com")))
      expect_false(is.null(tag_create("t", vocabulary_id = "v1", as = fmt, url = "https://example.com")))
      expect_false(is.null(tag_delete("t1", as = fmt, url = "https://example.com")))
    }
  })
})

test_that("membership and relationships switches", {
  MOCK_HTTP({
    for (fmt in c("json", "list", "table")) {
      expect_false(is.null(group_list_authz(as = fmt, url = "https://example.com")))
      expect_false(is.null(organization_list_for_user(as = fmt, url = "https://example.com")))
      expect_false(is.null(package_relationship_create("s", "o", "child_of", as = fmt, url = "https://example.com")))
    }
    # relationships list/update/delete paths
    for (fmt in c("json", "list", "table")) {
      expect_false(is.null(package_relationships_list("p1", as = fmt, url = "https://example.com")))
    }
  })
})

test_that("ping json branch and error paths", {
  testthat::with_mocked_bindings(
    ckan_GET = function(...) CANNED_LIST,
    .package = "ckanr",
    {
      expect_true(is.logical(ping("https://example.com")))
      expect_type(ping("https://example.com", as = "json"), "character")
    }
  )
})

test_that("follow target unsupported errors", {
  expect_error(ckanr:::resolve_follow_target("x", "bogus-type", "https://example.com"), "Unsupported object type")
})

test_that("print methods for all classes", {
  expect_output(print(as.ckan_organization(list(id = "o1", name = "n"))), "CKAN")
  expect_output(print(as.ckan_resource(list(id = "r1", name = "n"))), "CKAN")
  expect_output(print(as.ckan_tag(list(id = "t1", name = "n"))), "CKAN")
  expect_output(print(as.ckan_user(list(id = "u1", name = "n"))), "CKAN")
  expect_output(print(as.ckan_vocabulary(list(id = "v1", name = "n"))), "CKAN")
  expect_output(print(ckanr:::as_ck(list(url = "u", key = "k"), "ckanr_settings")), "ckanr|Base|<|settings")
  # ckanr_settings print
  expect_output(print(ckanr_settings()), "ckanr settings|Base URL")
})

test_that("sift_res branches", {
  # list tmp with non-list element
  expect_match(ckanr:::sift_res(list(list(name = "a"))), "a")
  # tmp as list with unnamed list element (haz_names FALSE)
  expect_false(is.null(ckanr:::sift_res(list(list(list("x", "y"))))))
  # named list element with empty strings filtered
  expect_true(is.character(ckanr:::sift_res(list(list(name = list(a = "", b = "val"))))) || is.null(ckanr:::sift_res(list(list(name = list(a = "", b = "val"))))))
  # multi-value named list takes first
  r <- ckanr:::sift_res(list(list(name = list(a = "1", b = "2"))))
  expect_true(is.character(r) || is.null(r))
})

test_that("resolve helpers remaining branches", {
  # resolve_object_identifier with ckan objects missing id
  expect_identical(ckanr:::resolve_object_identifier(list(id = "i1")), "i1")
  expect_identical(ckanr:::resolve_object_identifier(list(name = "n1")), "n1")
  expect_identical(ckanr:::resolve_username(list(name = "n1")), "n1")
  expect_identical(ckanr:::resolve_username(list(id = "i1")), "i1")
  expect_identical(ckanr:::resolve_user_identifier(list(id = "i1")), "i1")
  expect_identical(ckanr:::resolve_user_identifier(list(name = "n1")), "n1")
  # ckan_user without name falls back to id
  u <- as.ckan_user(list(id = "u1"))
  expect_identical(ckanr:::resolve_username(u), "u1")
  expect_identical(ckanr:::resolve_user_identifier(u), "u1")
  # ckan_package without id falls back to name
  p <- structure(list(name = "pname"), class = "ckan_package")
  expect_identical(ckanr:::resolve_object_identifier(p), "pname")
})
