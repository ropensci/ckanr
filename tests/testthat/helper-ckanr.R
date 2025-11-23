#' Given a TEST_API_KEY, create test resources on a CKAN site
#'
#' @keywords internal
#' @export
#' @details
#' \code{prepare_test_ckan} creates an example dataset, resource, organisation,
#' and group on \code{localhost:5000} for the test suite to use, and runs \code{ckanr_setup}
#' with the respective IDs.
#'
#' The prerequisites for the tester is to run a CKAN site at
#' \code{localhost:5000} and provide the API key as R environment variable
#' \code{TEST_API_KEY}.
#'
#' This function aims to simplify using \code{localhost:5000} as test instance.
#' @param test_url A test CKAN instance where we are allowed to create dummy resources
#' @param test_key A working API key for an account on the test instance
prepare_test_ckan <- function(test_url = Sys.getenv("CKANR_TEST_URL"),
                              test_key = Sys.getenv("CKANR_TEST_KEY")) {
  if (test_key == "") {
    message("Please provide your API key as parameter 'test_key' or via Sys.setenv(CKANR_TEST_KEY = \"my-api-key\")")
    ckanr_setup(test_url = test_url)
  } else {
    message("Setting up test CKAN instance...")
    # An example CSV file which should upload fine to the datastore
    path_csv <- system.file("examples", "actinidiaceae.csv", package = "ckanr")
    path_parquet <- system.file("examples", "iris.parquet", package = "ckanr")


    # Save ourselves from using test_url and test_key
    ckanr_setup(url = test_url, key = test_key)

    try(
      organization_create(
        name = "ckanr_test_org",
        title = "ckanr Test Organisation",
        url = test_url,
        key = test_key
      ),
      silent = TRUE
    )
    o <- organization_show(id = "ckanr_test_org")

    try(
      group_create(
        name = "ckanr_test_group",
        url = test_url,
        key = test_key
      ),
      silent = TRUE
    )
    g <- group_show(id = "ckanr_test_group")

    try(
      package_create(
        name = "ckanr_test_dataset",
        title = "ckanr Test Dataset",
        owner_org = o$id,
        tags = list(
          list("name" = "ckanr"),
          list("name" = "test")
        ),
        url = test_url,
        key = test_key
      ),
      silent = TRUE
    )
    p <- package_show(id = "ckanr_test_dataset")

    r <- resource_create(
      package_id = p$id,
      description = "CSV resource",
      name = "ckanr test resource",
      upload = path_csv,
      rcurl = "http://google.com"
    )
    push_resource_to_datastore(
      resource_id = r$id,
      csv_path = path_csv,
      url = test_url,
      key = test_key
    )

    r_parquet <- resource_create(
      package_id = p$id,
      description = "Parquet resource",
      name = "ckanr test parquet resource",
      upload = path_parquet,
      rcurl = "http://google.com"
    )

    # Note: The DataPusher will automatically push CSV resources to the datastore
    # ds_search tests will skip if the datastore is not ready yet

    vocab_name <- "ckanr_test_vocabulary"
    vocab_tags <- c("ckanr_vocab_alpha", "ckanr_vocab_beta")
    user_info <- tryCatch(current_test_user(test_url, test_key),
      error = function(e) e
    )
    if (!inherits(user_info, "error") && isTRUE(user_info$sysadmin)) {
      try(vocabulary_delete(vocab_name, url = test_url, key = test_key),
        silent = TRUE
      )
      vocab <- tryCatch(
        vocabulary_create(
          name = vocab_name,
          tags = lapply(vocab_tags, function(x) list(name = x)),
          url = test_url,
          key = test_key
        ),
        error = function(e) e
      )
      if (!inherits(vocab, "error")) {
        invisible(lapply(vocab_tags, function(tag_name) {
          try(
            tag_create(
              name = tag_name,
              vocabulary_id = vocab$id,
              url = test_url,
              key = test_key
            ),
            silent = TRUE
          )
        }))
      }
    } else {
      message("Skipping vocabulary/tag test fixtures; sysadmin rights required")
    }

    # All together now
    ckanr_setup(
      url = test_url,
      key = test_key,
      test_url = test_url,
      test_key = test_key,
      test_did = p$id,
      test_rid = r$id,
      test_oid = o$id,
      test_gid = g$id,
      test_behaviour = Sys.getenv("CKANR_TEST_BEHAVIOUR", "SKIP")
    )
    message("CKAN test instance is set up.")
  }
}

sanitize_field_id <- function(x) {
  cleaned <- gsub("[^A-Za-z0-9]+", "_", tolower(x))
  cleaned <- gsub("_+", "_", cleaned)
  cleaned <- gsub("^_+|_+$", "", cleaned)
  if (!nzchar(cleaned) || grepl("^[0-9]", cleaned)) {
    cleaned <- paste0("field_", cleaned)
  }
  cleaned
}

uniquify_ids <- function(ids) {
  seen <- new.env(parent = emptyenv())
  vapply(ids, function(id) {
    base_id <- if (nzchar(id)) id else "field"
    count <- get0(base_id, envir = seen, inherits = FALSE, ifnotfound = 0L)
    count <- count + 1L
    assign(base_id, count, envir = seen)
    if (count == 1L) {
      base_id
    } else {
      paste0(base_id, "_", count)
    }
  }, character(1), USE.NAMES = FALSE)
}

push_resource_to_datastore <- function(resource_id, csv_path, url, key) {
  if (!nzchar(resource_id) || !file.exists(csv_path)) {
    message("Unable to push resource to datastore; missing resource id or file")
    return(invisible(FALSE))
  }

  data <- readr::read_csv(csv_path, show_col_types = FALSE, progress = FALSE)
  data <- as.data.frame(data, stringsAsFactors = FALSE)
  if (!nrow(data)) {
    message("CSV file is empty; skipping datastore push")
    return(invisible(FALSE))
  }

  field_ids <- vapply(names(data), sanitize_field_id, character(1))
  field_ids <- uniquify_ids(field_ids)
  colnames(data) <- field_ids

  records <- lapply(seq_len(nrow(data)), function(i) {
    as.list(data[i, , drop = TRUE])
  })

  payload <- list(
    resource_id = resource_id,
    force = TRUE,
    fields = lapply(field_ids, function(id) list(id = id, type = "text")),
    records = records
  )
  delete_body <- jsonlite::toJSON(
    list(resource_id = resource_id, force = TRUE),
    auto_unbox = TRUE
  )
  create_body <- jsonlite::toJSON(
    payload,
    auto_unbox = TRUE,
    dataframe = "rows",
    na = "null",
    null = "null",
    digits = NA
  )

  try(
    ckan_action(
      "datastore_delete",
      body = delete_body,
      headers = list(`Content-Type` = "application/json"),
      url = url,
      key = key
    ),
    silent = TRUE
  )

  invisible(ckan_action(
    "datastore_create",
    body = create_body,
    headers = list(`Content-Type` = "application/json"),
    url = url,
    key = key
  ))
}

#' Test whether the configured test CKAN is offline
#'
#' @keywords internal
#' @importFrom testthat skip
#' @details
#' \code{check_ckan} will allow a test to fail (and not hide error messages)
#' if \code{ckanr_setup(test_strict="TRUE")} was set.
#' \code{check_ckan} will allow a test to skip (and the test suite to pass)
#' if \code{ckanr_setup(test_strict)} was set to anything but the string "TRUE".
#' @param url A URL that shall be tested whether it is online
#'
check_ckan <- function(url) {
  # Strict tests shall not skip if there's problems with CKAN

  if (get_test_behaviour() == "SKIP" && !ping(url)) {
    skip(paste(
      "CKAN is offline.",
      "Did you set CKAN test settings with ?ckanr_setup ?",
      "Does the test CKAN server run at", url, "?"
    ))
  }
}

#' Test whether the configured test CKAN resource exists
#'
#' @keywords internal
#' @importFrom testthat skip
check_resource <- function(url, x) {
  res <- resource_show(x, url = url)
  if (get_test_behaviour() == "SKIP" && !is(res, "list") && res$id != x) {
    skip(paste(
      "The CKAN test resource wasn't found.",
      "Did you set CKAN test settings with ?ckanr_setup ?",
      "Does a resource with ID", x, "exist on", url, "?"
    ))
  }
}

#' Test whether the configured test CKAN dataset exists
#'
#' @keywords internal
#' @importFrom testthat skip
check_dataset <- function(url, x) {
  d <- package_show(x, url = url)
  if (get_test_behaviour() == "SKIP" && !is(d, "list") && d$id != x) {
    skip(paste(
      "The CKAN test dataset wasn't found.",
      "Did you set CKAN test settings with ?ckanr_setup ?",
      "Does a dataset with ID", x, "exist on", url, "?"
    ))
  }
}

#' Test whether the configured test CKAN group exists
#'
#' @keywords internal
#' @importFrom testthat skip
check_group <- function(url, x) {
  grp <- group_show(x, url = url)
  if (get_test_behaviour() == "SKIP" && !is(grp, "list") && grp$id != x) {
    skip(paste(
      "The CKAN test group wasn't found.",
      "Did you set CKAN test settings with ?ckanr_setup ?",
      "Does a dataset with slug", x, "exist on", url, "?"
    ))
  }
}

ok_group <- function(url, x) {
  grp <- tryCatch(group_show(x, url = url), error = function(e) e)
  !inherits(grp, "error")
}

#' Test whether the configured test CKAN group exists
#'
#' @keywords internal
#' @importFrom testthat skip
check_organization <- function(url, x) {
  org <- organization_show(x, url = url)
  if (get_test_behaviour() == "SKIP" && !is(org, "list") && org$id != x) {
    skip(paste(
      "The CKAN test group wasn't found.",
      "Did you set CKAN test settings with ?ckanr_setup ?",
      "Does an organization with slug", x, "exist on", url, "?"
    ))
  }
}

collaborators_feature_enabled <- function(url, key) {
  override <- Sys.getenv("CKANR_ASSUME_COLLABORATORS")
  if (nzchar(override)) {
    return(tolower(override) %in% c("true", "1", "yes"))
  }
  res <- tryCatch(
    {
      txt <- ckan_action(
        "config_option_show",
        body = list(key = "ckan.auth.allow_dataset_collaborators"),
        verb = "GET",
        url = url,
        key = key
      )
      jsonlite::fromJSON(txt)
    },
    error = function(e) e
  )
  if (inherits(res, "error")) {
    return(FALSE)
  }
  val <- res$result$value
  isTRUE(val) || identical(val, "True") || identical(val, "true") ||
    identical(val, 1L) || identical(val, "1")
}

skip_if_collaborators_disabled <- function(url, key) {
  if (!collaborators_feature_enabled(url, key)) {
    skip("Dataset collaborators feature disabled or unavailable")
  }
}

current_test_user <- function(url, key) {
  if (!nzchar(key)) {
    stop("An API key is required to query the current user", call. = FALSE)
  }
  txt <- ckan_action("user_show", verb = "GET", url = url, key = key)
  jsonlite::fromJSON(txt, simplifyVector = FALSE)$result
}

skip_if_not_sysadmin <- function(url, key) {
  user <- tryCatch(current_test_user(url, key), error = function(e) e)
  if (inherits(user, "error")) {
    skip("Unable to determine current user; requires authenticated CKAN")
  }
  if (!isTRUE(user$sysadmin)) {
    skip("Sysadmin privileges required for this test")
  }
}

activity_plugin_enabled <- local({
  cache <- new.env(parent = emptyenv())
  function(url) {
    cached <- get0(url, envir = cache, inherits = FALSE)
    if (!is.null(cached)) {
      return(cached)
    }
    status <- tryCatch(
      jsonlite::fromJSON(ckan_action("status_show", verb = "GET", url = url)),
      error = function(e) NULL
    )
    enabled <- FALSE
    if (!is.null(status) && !is.null(status$result$extensions)) {
      enabled <- "activity" %in% status$result$extensions
    }
    assign(url, enabled, envir = cache)
    enabled
  }
})

skip_if_activity_plugin_disabled <- function(url) {
  if (!activity_plugin_enabled(url)) {
    skip("Activity plugin not enabled on test CKAN instance")
  }
}

skip_if_activity_email_notifications_disabled <- function(url, key) {
  status <- tryCatch(
    ckanr:::activity_email_notifications_enabled(url = url, key = key),
    error = function(e) NA
  )
  if (identical(status, FALSE)) {
    skip("Activity email notifications are disabled on this CKAN instance")
  }
  if (is.na(status)) {
    skip("Unable to determine activity email notification setting")
  }
}

expect_ckan_formats <- function(call_with_as, formats = c("list", "json", "table")) {
  stopifnot(is.function(call_with_as))
  for (fmt in formats) {
    result <- call_with_as(fmt)
    if (fmt == "json") {
      testthat::expect_type(result, "character")
      testthat::expect_gt(nchar(result), 0)
    } else if (fmt == "list") {
      testthat::expect_true(is.list(result) || is.character(result))
      testthat::expect_false(is.null(result))
    } else if (fmt == "table") {
      testthat::expect_true(
        is.list(result) || inherits(result, "data.frame") || is.atomic(result)
      )
      testthat::expect_false(is.null(result))
    }
  }
  invisible(NULL)
}

u <- get_test_url()

if (ping(u)) {
  prepare_test_ckan(test_url = u)
} else {
  message("CKAN is offline. Running tests that don't depend on CKAN.")
}
