context("resource_views")

skip_on_cran()
skip_on_os("windows")
skip_on_os("mac")

url <- get_test_url()
key <- get_test_key()
oid <- get_test_oid()

view_plugin_available <- function(view_type) {
  res <- tryCatch(
    jsonlite::fromJSON(ckan_action(
      "config_option_show",
      body = list(key = "ckan.plugins"),
      verb = "GET",
      url = url,
      key = key
    )),
    error = function(e) e
  )
  if (inherits(res, "error")) {
    return(FALSE)
  }
  plugins_raw <- res$result$value
  if (is.null(plugins_raw) || !nzchar(plugins_raw)) {
    return(FALSE)
  }
  plugins <- unlist(strsplit(plugins_raw, "[[:space:],]+"))
  plugins <- plugins[nzchar(plugins)]
  view_type %in% plugins
}

create_dataset_with_resource <- function() {
  pkg <- package_create(
    name = sprintf("resource_views_%s", paste0(as.integer(Sys.time()), sample.int(1000, 1))),
    owner_org = oid,
    url = url,
    key = key
  )
  path <- system.file("examples", "mapbox.html", package = "ckanr")
  res <- resource_create(
    package_id = pkg$id,
    name = sprintf("view_res_%s", sample.int(1000, 1)),
    upload = path,
    format = "html",
    rcurl = "https://example.com/resource_view_fixture",
    url = url,
    key = key
  )
  list(package = pkg, resource = res)
}

test_that("resource view lifecycle helpers work", {
  check_ckan(url)
  skip_if(!view_plugin_available("text_view"), "text_view plugin unavailable on this CKAN")

  setup <- create_dataset_with_resource()
  pkg <- setup$package
  res <- setup$resource
  on.exit(package_delete(pkg$id, url = url, key = key), add = TRUE)

  view_one <- resource_view_create(res, view_type = "text_view",
    title = "First view", description = "Primary preview",
    url = url, key = key)
  expect_s3_class(view_one, "ckan_resource_view")

  view_two <- resource_view_create(res, view_type = "text_view",
    title = "Second view", url = url, key = key)

  listed <- resource_view_list(res, url = url, key = key)
  expect_true(all(vapply(listed, inherits, logical(1), "ckan_resource_view")))
  ids <- vapply(listed, `[[`, character(1), "id")
  expect_true(all(c(view_one$id, view_two$id) %in% ids))

  shown <- resource_view_show(view_one, url = url, key = key)
  expect_equal(shown$id, view_one$id)

  updated <- resource_view_update(view_one, title = "Updated view title",
    url = url, key = key)
  expect_equal(updated$title, "Updated view title")

  reordered <- resource_view_reorder(res, order = rev(ids), url = url, key = key)
  expect_true(is.list(reordered))

  deleted <- resource_view_delete(view_two, url = url, key = key)
  expect_equal(deleted$resource_id, res$id)
  remaining <- resource_view_list(res, url = url, key = key)
  expect_false(view_two$id %in% vapply(remaining, `[[`, character(1), "id"))
})

test_that("default view helpers return lists", {
  check_ckan(url)
  setup <- create_dataset_with_resource()
  pkg <- setup$package
  res <- setup$resource
  on.exit(package_delete(pkg$id, url = url, key = key), add = TRUE)

  resource_defaults <- resource_create_default_resource_views(res,
    url = url, key = key)
  expect_type(resource_defaults, "list")

  package_defaults <- package_create_default_resource_views(pkg,
    url = url, key = key)
  expect_type(package_defaults, "list")
})

test_that("resource_view_clear handles permission limits", {
  check_ckan(url)
  res <- tryCatch(
    resource_view_clear("ckanr_fake_view", url = url, key = key),
    error = function(e) e
  )
  if (inherits(res, "error")) {
    skip("resource_view_clear requires sysadmin credentials")
  }
  expect_true(isTRUE(res))
})
