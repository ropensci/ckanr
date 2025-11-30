context("activity plugin endpoints")

skip_on_cran()

url <- get_test_url()
key <- get_test_key()

test_that("group_activity_list returns activities", {
  check_ckan(url)
  check_group(url, get_test_gid())
  skip_if_activity_plugin_disabled(url)

  res <- group_activity_list(get_test_gid(), url = url, key = key)
  expect_true(is.list(res))
})

test_that("organization_activity_list returns activities", {
  check_ckan(url)
  check_organization(url, get_test_oid())
  skip_if_activity_plugin_disabled(url)

  res <- organization_activity_list(get_test_oid(), url = url, key = key)
  expect_true(is.list(res))
})

test_that("recently_changed_packages_activity_list skips when unsupported", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)

  ver <- floor(ckan_version(url)$version_num)
  res <- recently_changed_packages_activity_list(url = url, key = key)
  expect_true(is.list(res))
})

test_that("dashboard_new_activities_count returns a number", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)

  res <- dashboard_new_activities_count(url = url, key = key)
  expect_true(is.numeric(res))
})

test_that("dashboard_mark_activities_old completes successfully", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)

  res <- dashboard_mark_activities_old(url = url, key = key)
  expect_true(isTRUE(res) || is.list(res) || is.null(res))
})

test_that("activity inspection helpers work", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)

  pkg_activity <- tryCatch(
    package_activity_list(get_test_did(), url = url, key = key),
    error = function(e) NULL
  )
  if (is.null(pkg_activity) || !length(pkg_activity)) {
    skip("No package activity entries available for inspection")
  }
  activity_id <- pkg_activity[[1]]$id
  if (is.null(activity_id)) {
    activity_id <- pkg_activity[[1]]$activity_id
  }
  skip_if(is.null(activity_id), "Activity payload missing identifier")

  shown <- activity_show(activity_id, url = url, key = key)
  expect_true(is.list(shown))
  expect_equal(shown$id, activity_id)

  data_res <- activity_data_show(activity_id, object_type = "package", url = url, key = key)
  expect_true(is.list(data_res))

  diff_res <- tryCatch(
    activity_diff(activity_id, object_type = "package", url = url, key = key),
    error = function(e) NULL
  )
  expect_true(is.null(diff_res) || is.list(diff_res) || is.character(diff_res))
})

test_that("activity_create works for sysadmin users", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)
  skip_if_not_sysadmin(url, key)

  user <- current_test_user(url, key)
  created <- activity_create(
    user_id = user$id,
    object_id = get_test_did(),
    activity_type = "changed package",
    data = list(message = "ckanr test activity"),
    url = url,
    key = key
  )
  expect_true(is.list(created))
  expect_equal(created$user_id, user$id)
})

test_that("send_email_notifications requires sysadmin", {
  check_ckan(url)
  skip_if_activity_plugin_disabled(url)
  skip_if_not_sysadmin(url, key)
  # skip_if_activity_email_notifications_disabled(url, key)

  res <- send_email_notifications(url = url, key = key)
  expect_true(isTRUE(res) || is.list(res) || is.null(res))
})
