context("dplyr Interface")

skip_on_cran()

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
    .name <- dplyr::ident(sample(colnames(tb.raw), 1))
    .value <- tb.raw[[.name]][1]
    .criteria <- lazyeval::interp(~ name == value, name = .name, value = .value)
    r1 <- tb %>% dplyr::filter_(.criteria) %>%
      collect()
    r2 <- tb.raw %>% dplyr::filter(`[`(., .name) == .value)
    expect_equal(r1, r2)
  })

#   test_that("basic verbs: arrage", {
#     .name <- sample(colnames(tb.raw), 1)
#     .criteria <- lazyeval::interp(~ desc(name), name = .name)
#     r1 <- tb %>% dplyr::arrange_(.criteria) %>%
#       collect()
#     r2 <- tb.raw %>% dplyr::arrange_(.criteria)
#     expect_equal(r1, r2)
#   })
#
#   test_that("basic verbs: select", {
#     .name <- sample(colnames(tb.raw), 1)
#     .criteria <- lazyeval::interp(~ name, name = dplyr::ident(.name))
#     r1 <- dplyr::select_(tb, .criteria) %>% collect()
#     r2 <- dplyr::select(tb.raw, ID_ITEM, ID_SERIE_ITEM)
#     expect_equal(r1, r2)
#   })
#
#   test_that("basic_verbs: distinct", {
#     r1 <- dplyr::select(tb, GABARITO) %>%
#       dplyr::distinct() %>%
#       collect()
#     r2 <- dplyr::select(tb.raw, GABARITO) %>%
#       dplyr::distinct()
#     expect_equal(r1, r2)
#   })
#
#   test_that("basic_verbs: mutate", {
#     r1 <- dplyr::mutate(tb, t1 = as.integer(ID_ITEM)) %>%
#       dplyr::select(t1) %>%
#       collect()
#     r2 <- dplyr::mutate(tb.raw, t1 = as.integer(ID_ITEM)) %>%
#       dplyr::select(t1)
#     expect_equal(r1, r2)
#   })
#
#   test_that("basic_verbs: summarise", {
#     r1 <- dplyr::mutate(tb, t1 = as.integer(ID_SERIE_ITEM)) %>%
#       dplyr::summarise(t2 = mean(t1)) %>%
#       collect() %>%
#       mutate(t2 = as.numeric(t2)) # The default result is character
#     r2 <- dplyr::mutate(tb.raw, t1 = as.integer(ID_SERIE_ITEM)) %>%
#       dplyr::summarise(t2 = mean(t1))
#     expect_equal(r1, r2)
#   })
#
#   test_that("basic_verbs: sample_n", {
#     # sample_n is not implemented for PostgreSQL
#   })
#
#   test_that("basic_verbs: group_by", {
#     r1 <- group_by(tb, GABARITO) %>%
#       summarise(count = n()) %>%
#       collect() %>%
#       mutate(count = as.integer(count))
#     r2 <- group_by(tb.raw, GABARITO) %>%
#       summarise(count = n())
#     expect_equal(r1, r2)
#   })
#
#   tb1 <- tbl(src, from = 'SELECT * FROM "be2ccdc2-9a76-47bf-862c-60c1525f5b1b" ORDER BY _id LIMIT 100')
#   tb2 <- tbl(src, name = name_list[1])
#   tb1.raw <- collect(tb1)
#   tb2.raw <- collect(tb2)
#
#   test_that("join: left_join", {
#     r1 <- left_join(tb1, tb2, by = "_id") %>%
#       collect()
#     r2 <- left_join(tb1.raw, tb2.raw, by = "_id")
#     expect_equal(r1, r2)
#   })
}

