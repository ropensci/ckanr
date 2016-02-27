context("dplyr Interface")

if (Sys.getenv("TEST_DPLYR_INTERFACE") != "") {

  u <- get_test_url()

  test_that("src is created",{
    src <- src_ckan(u)
    str <- capture.output(print(src))
    expect_match(str[1], "ckan url")
    expect_match(str[2], "total tbls")
    expect_match(str[3], "tbls")
  })

  src <- src_ckan(u)
  name_list <- Filter(f = function(name) {
    !is.null(ds_search(name, limit = 1, url = u))
  }, dbListTables(src$con, limit = 6))

  test_that("tb is created by name", {
    tb <- tbl(src, name = name_list[1])
  })

  test_that("tb is created by sql", {
    tb <- tbl(src, from = sprintf('SELECT * FROM "%s" LIMIT 100', name_list[1]))
  })

  tb <- tbl(src, from = 'SELECT * FROM "be2ccdc2-9a76-47bf-862c-60c1525f5b1b" LIMIT 100')
  tb.raw <- collect(tb)

  test_that("basic verbs: filter", {
    r1 <- dplyr::filter(tb, GABARITO == "D") %>%
      collect()
    r2 <- dplyr::filter(tb.raw, GABARITO == "D")
    expect_equal(r1, r2)
  })

  test_that("basic verbs: arrage", {
    r1 <- dplyr::arrange(tb, desc(ID_ITEM)) %>%
      collect()
    r2 <- dplyr::arrange(tb.raw, desc(ID_ITEM))
    expect_equal(r1, r2)
  })

  test_that("basic verbs: select", {
    r1 <- dplyr::select(tb, ID_ITEM, ID_SERIE_ITEM) %>% collect()
    r2 <- dplyr::select(tb.raw, ID_ITEM, ID_SERIE_ITEM)
    expect_equal(r1, r2)
  })

  test_that("basic_verbs: distinct", {
    r1 <- dplyr::select(tb, GABARITO) %>%
      dplyr::distinct() %>%
      collect()
    r2 <- dplyr::select(tb.raw, GABARITO) %>%
      dplyr::distinct()
    expect_equal(r1, r2)
  })

  test_that("basic_verbs: mutate", {
    r1 <- dplyr::mutate(tb, t1 = as.integer(ID_ITEM)) %>%
      dplyr::select(t1) %>%
      collect()
    r2 <- dplyr::mutate(tb.raw, t1 = as.integer(ID_ITEM)) %>%
      dplyr::select(t1)
    expect_equal(r1, r2)
  })


}

