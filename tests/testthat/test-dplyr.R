context("dplyr Interface")

skip_on_cran()

if (Sys.getenv("TEST_DPLYR_INTERFACE") != "") {
  u <- get_test_url()

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
  })

  test_that("tb is created by sql", {
    tb <- tbl(src, from = sprintf('SELECT * FROM "%s" LIMIT 100', sample(name_list, 1)))
  })

  tb <- tbl(src, from = sprintf('SELECT * FROM "%s" LIMIT 100', sample(name_list, 1)))
  tb.raw <- collect(tb)

  test_that("basic verbs: filter", {
    col_name <- sample(colnames(tb.raw), 1)
    col_sym <- rlang::sym(col_name)
    col_value <- tb.raw[[col_name]][1]

    r1 <- tb %>%
      dplyr::filter(!!col_sym == !!col_value) %>%
      collect()
    r2 <- tb.raw %>%
      dplyr::filter(!!col_sym == !!col_value)

    expect_equal(r1, r2)
  })

  test_that("basic verbs: arrange", {
    orderable <- names(tb.raw)[vapply(tb.raw, function(x) is.atomic(x) && !is.list(x), logical(1))]
    skip_if(length(orderable) == 0, "No sortable columns available")
    col_name <- sample(orderable, 1)

    r1 <- tb %>%
      dplyr::arrange(dplyr::desc(.data[[col_name]])) %>%
      collect()
    r2 <- tb.raw %>%
      dplyr::arrange(dplyr::desc(.data[[col_name]]))

    expect_equal(r1, r2)
  })

  test_that("basic verbs: select", {
    cols <- sample(colnames(tb.raw), min(2, ncol(tb.raw)))
    r1 <- tb %>%
      dplyr::select(dplyr::all_of(cols)) %>%
      collect()
    r2 <- tb.raw %>% dplyr::select(dplyr::all_of(cols))
    expect_equal(r1, r2)
  })

  test_that("basic verbs: distinct", {
    cols <- sample(colnames(tb.raw), 1)
    r1 <- tb %>%
      dplyr::select(dplyr::all_of(cols)) %>%
      dplyr::distinct() %>%
      collect()
    r2 <- tb.raw %>%
      dplyr::select(dplyr::all_of(cols)) %>%
      dplyr::distinct()
    expect_equal(r1, r2)
  })

  test_that("basic verbs: mutate", {
    numeric_cols <- names(tb.raw)[vapply(tb.raw, is.numeric, logical(1))]
    skip_if(length(numeric_cols) == 0, "No numeric columns to mutate")
    col_name <- sample(numeric_cols, 1)
    r1 <- tb %>%
      dplyr::mutate(.temp = .data[[col_name]] + 1) %>%
      dplyr::select(.temp) %>%
      collect()
    r2 <- tb.raw %>%
      dplyr::mutate(.temp = .data[[col_name]] + 1) %>%
      dplyr::select(.temp)
    expect_equal(r1, r2)
  })

  test_that("basic verbs: summarise", {
    numeric_cols <- names(tb.raw)[vapply(tb.raw, is.numeric, logical(1))]
    skip_if(length(numeric_cols) == 0, "No numeric columns to summarise")
    col_name <- sample(numeric_cols, 1)

    r1 <- tb %>%
      dplyr::summarise(.mean = mean(.data[[col_name]], na.rm = TRUE)) %>%
      collect()
    r2 <- tb.raw %>%
      dplyr::summarise(.mean = mean(.data[[col_name]], na.rm = TRUE))
    expect_equal(r1$.mean, as.numeric(r2$.mean))
  })

  test_that("basic verbs: group_by", {
    groupable <- names(tb.raw)[vapply(tb.raw, function(x) is.character(x) || is.factor(x), logical(1))]
    skip_if(length(groupable) == 0, "No categorical columns to group by")
    col_name <- sample(groupable, 1)

    r1 <- tb %>%
      dplyr::group_by(.data[[col_name]]) %>%
      dplyr::summarise(count = dplyr::n(), .groups = "drop") %>%
      collect()
    r2 <- tb.raw %>%
      dplyr::group_by(.data[[col_name]]) %>%
      dplyr::summarise(count = dplyr::n(), .groups = "drop")
    r1$count <- as.integer(r1$count)
    expect_equal(r1, r2)
  })

  test_that("basic verbs: slice_sample", {
    sample_size <- min(5, nrow(tb.raw))
    skip_if(sample_size == 0, "No rows available to sample")
    skip_if(!"_id" %in% colnames(tb.raw), "No _id column available to check sampled rows")

    r1 <- tb %>%
      dplyr::slice_sample(n = sample_size) %>%
      collect()

    expect_equal(nrow(r1), sample_size)
    expect_true(all(r1$`_id` %in% tb.raw$`_id`))
    expect_equal(length(unique(r1$`_id`)), nrow(r1))
  })

  tb1 <- tbl(src, from = 'SELECT * FROM "be2ccdc2-9a76-47bf-862c-60c1525f5b1b" ORDER BY _id LIMIT 100')
  tb2 <- tbl(src, name = name_list[1])
  tb1.raw <- collect(tb1)
  tb2.raw <- collect(tb2)

  test_that("join: left_join", {
    skip_if(!"_id" %in% intersect(colnames(tb1.raw), colnames(tb2.raw)), "_id column missing")
    r1 <- dplyr::left_join(tb1, tb2, by = "_id") %>% collect()
    r2 <- dplyr::left_join(tb1.raw, tb2.raw, by = "_id")
    expect_equal(r1, r2)
  })

  test_that("join: inner_join", {
    skip_if(!"_id" %in% intersect(colnames(tb1.raw), colnames(tb2.raw)), "_id column missing")
    r1 <- dplyr::inner_join(tb1, tb2, by = "_id") %>% collect()
    r2 <- dplyr::inner_join(tb1.raw, tb2.raw, by = "_id")
    expect_equal(r1, r2)
  })
}
