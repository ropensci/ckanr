context("dplyr Interface")

skip_on_cran()

if (Sys.getenv("TEST_DPLYR_INTERFACE") != "") {
  skip_on_os("windows")
  skip_on_os("mac")
  u <- get_test_url()
  check_ckan(u)
  skip_if(!datastore_enabled(u), "Datastore extension not enabled")

  test_that("src is created", {
    src <- src_ckan(u)
    str <- capture.output(print(src))
    expect_match(str[1], "ckan url")
    expect_match(str[2], "total tbls")
    expect_match(str[3], "tbls")
  })

  src <- src_ckan(u)
  name_list <- Filter(f = function(name) {
    !is.null(ds_search(name, limit = 1, url = u))
  }, dbListTables(src$con, limit = 20))

  test_that("tb is created by name", {
    tb <- tbl(src, name = sample(name_list, 1))
    expect_s3_class(tb, "tbl_lazy")
  })

  test_that("tb is created by sql", {
    tb <- tbl(src, from = sprintf('SELECT * FROM "%s" LIMIT 100', sample(name_list, 1)))
    expect_s3_class(tb, "tbl_lazy")
  })

  tb <- tbl(src, from = sprintf('SELECT * FROM "%s" LIMIT 100', get_test_rid()))
  tb.raw <- dplyr::collect(tb)

  test_that("basic verbs: filter", {
    col_name <- "ckanr_test_integer"
    skip_if(!col_name %in% names(tb.raw), "Numeric fixture column is missing")
    col_sym <- rlang::sym(col_name)
    col_value <- 1

    r1 <- tb |>
      dplyr::filter(!!col_sym == !!col_value) |>
      dplyr::collect()
    r2 <- tb.raw |>
      dplyr::filter(!!col_sym == !!col_value)

    expect_equal(r1, r2)
  })

  test_that("basic verbs: arrange", {
    col_name <- "ckanr_test_integer"
    skip_if(!col_name %in% names(tb.raw), "Numeric fixture column is missing")

    r1 <- tb |>
      dplyr::arrange(dplyr::desc(.data[[col_name]])) |>
      dplyr::collect()
    values <- r1[[col_name]]
    expect_true(all(diff(values) <= 0))
  })

  test_that("basic verbs: select", {
    cols <- sample(colnames(tb.raw), min(2, ncol(tb.raw)))
    r1 <- tb |>
      dplyr::select(dplyr::all_of(cols)) |>
      dplyr::collect()
    r2 <- tb.raw |> dplyr::select(dplyr::all_of(cols))
    expect_equal(r1, r2)
  })

  test_that("basic verbs: distinct", {
    cols <- sample(colnames(tb.raw), 1)
    r1 <- tb |>
      dplyr::select(dplyr::all_of(cols)) |>
      dplyr::distinct() |>
      dplyr::collect()
    r2 <- tb.raw |>
      dplyr::select(dplyr::all_of(cols)) |>
      dplyr::distinct()
    expect_equal(nrow(r1), nrow(r2))
  })

  test_that("basic verbs: mutate", {
    col_name <- "ckanr_test_integer"
    skip_if(!col_name %in% names(tb.raw), "Numeric fixture column is missing")
    r1 <- tb |>
      dplyr::mutate(.temp = .data[[col_name]] + 1) |>
      dplyr::select(.temp) |>
      dplyr::collect()
    r2 <- tb.raw |>
      dplyr::mutate(.temp = .data[[col_name]] + 1) |>
      dplyr::select(.temp)
    expect_equal(r1, r2)
  })

  test_that("basic verbs: summarise", {
    col_name <- "ckanr_test_numeric"
    skip_if(!col_name %in% names(tb.raw), "Numeric fixture column is missing")

    r1 <- tb |>
      dplyr::summarise(.mean = mean(.data[[col_name]], na.rm = TRUE)) |>
      dplyr::collect()
    r2 <- tb.raw |>
      dplyr::summarise(.mean = mean(.data[[col_name]], na.rm = TRUE))
    expect_equal(r1$.mean, as.numeric(r2$.mean))
  })

  test_that("basic verbs: group_by", {
    col_name <- "ckanr_test_integer"
    skip_if(!col_name %in% names(tb.raw), "Numeric fixture column is missing")

    r1 <- tb |>
      dplyr::group_by(.data[[col_name]]) |>
      dplyr::summarise(count = dplyr::n(), .groups = "drop") |>
      dplyr::collect()
    r2 <- tb.raw |>
      dplyr::group_by(.data[[col_name]]) |>
      dplyr::summarise(count = dplyr::n(), .groups = "drop")
    expect_equal(sum(as.integer(r1$count)), nrow(r2))
  })

  test_that("semi joins and set operations use valid DataStore SQL", {
    numeric_name <- "ckanr_test_integer"
    skip_if(!numeric_name %in% names(tb.raw), "Numeric fixture column is missing")

    lhs <- tb |> dplyr::select(id)
    rhs <- tb |>
      dplyr::filter(.data[[numeric_name]] <= 3) |>
      dplyr::select(id)

    semi <- dplyr::collect(dplyr::semi_join(lhs, rhs, by = "id"))
    expect_equal(nrow(semi), 3)

    union_rows <- dplyr::collect(dplyr::union(lhs, rhs))
    intersect_rows <- dplyr::collect(dplyr::intersect(lhs, rhs))
    difference_rows <- dplyr::collect(dplyr::setdiff(lhs, rhs))
    expect_equal(nrow(union_rows), nrow(lhs |> dplyr::collect()))
    expect_equal(nrow(intersect_rows), 3)
    expect_equal(nrow(difference_rows), nrow(union_rows) - 3)
  })

  test_that("dbplyr query builders render and execute DataStore SQL", {
    queries <- list(
      select = dplyr::select(tb, id, ckanr_test_integer),
      mutate = dplyr::mutate(tb, doubled = ckanr_test_integer * 2),
      arrange = dplyr::arrange(tb, dplyr::desc(ckanr_test_integer)),
      summarise = dplyr::summarise(tb, total = sum(ckanr_test_integer)),
      join = dplyr::left_join(
        dplyr::select(tb, id),
        dplyr::select(tb, id, ckanr_test_numeric),
        by = "id"
      ),
      semi_join = dplyr::semi_join(
        dplyr::select(tb, id),
        dplyr::filter(tb, ckanr_test_integer <= 3),
        by = "id"
      ),
      union = dplyr::union(dplyr::select(tb, id), dplyr::select(tb, id)),
      distinct = dplyr::distinct(dplyr::select(tb, id))
    )

    for (query in queries) {
      dplyr::show_query(query)
      expect_s3_class(dplyr::collect(query), "tbl_df")
    }
  })

  test_that("custom aggregate translations execute in the DataStore", {
    query <- dplyr::summarise(
      tb,
      correlation = cor(ckanr_test_integer, ckanr_test_numeric),
      covariance = cov(ckanr_test_integer, ckanr_test_numeric),
      standard_deviation = sd(ckanr_test_numeric),
      variance = var(ckanr_test_numeric),
      all_positive = all(ckanr_test_integer > 0),
      any_positive = any(ckanr_test_integer > 0),
      identifiers = paste(id, collapse = "|")
    )
    sql <- dbplyr::sql_render(query)
    expect_match(sql, "CORR")
    expect_match(sql, "COVAR_SAMP")
    expect_match(sql, "STRING_AGG")
    dplyr::show_query(query)
    result <- dplyr::collect(query)
    expect_equal(nrow(result), 1)
    expect_true(nchar(result$identifiers) > 0)

    expect_error(
      dbplyr::sql_render(
        dplyr::summarise(tb, value = median(ckanr_test_numeric))
      ),
      "not available"
    )
    expect_error(
      dbplyr::sql_render(
        dplyr::summarise(tb, value = quantile(ckanr_test_numeric))
      ),
      "not available"
    )
  })

  test_that("basic verbs: slice_sample", {
    # CKAN 2.9-2.11 reject the RANDOM()/NOT window query generated by
    # dbplyr. Keep this integration check for CKAN 2.12+, where the
    # DataStore SQL validator accepts the query.
    skip_if_ckan_below(u, "2.12")
    sample_size <- min(5, nrow(tb.raw))
    skip_if(sample_size == 0, "No rows available to sample")

    r1 <- tb |>
      dplyr::slice_sample(n = sample_size) |>
      dplyr::collect()

    expect_equal(nrow(r1), sample_size)
    if ("_id" %in% colnames(tb.raw)) {
      expect_true(all(r1$`_id` %in% tb.raw$`_id`))
      expect_equal(length(unique(r1$`_id`)), nrow(r1))
    }
  })

  tb1 <- tbl(src, from = sprintf(
    'SELECT * FROM "%s" ORDER BY _id LIMIT 100', get_test_rid()
  ))
  tb2 <- tbl(src, name = name_list[1])
  tb1.raw <- dplyr::collect(tb1)
  tb2.raw <- dplyr::collect(tb2)

  test_that("join: left_join", {
    skip_if(!"_id" %in% intersect(colnames(tb1.raw), colnames(tb2.raw)), "_id column missing")
    r1 <- dplyr::left_join(tb1, tb2, by = "_id") |> dplyr::collect()
    r2 <- dplyr::left_join(tb1.raw, tb2.raw, by = "_id")
    expect_equal(r1, r2)
  })

  test_that("join: inner_join", {
    skip_if(!"_id" %in% intersect(colnames(tb1.raw), colnames(tb2.raw)), "_id column missing")
    r1 <- dplyr::inner_join(tb1, tb2, by = "_id") |> dplyr::collect()
    r2 <- dplyr::inner_join(tb1.raw, tb2.raw, by = "_id")
    expect_equal(r1, r2)
  })
}
