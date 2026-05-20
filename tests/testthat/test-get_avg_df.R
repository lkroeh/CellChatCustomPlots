test_that("get_avg_df averages probabilities across objects", {
  obj1 <- make_mock_cellchat(make_mock_prob(list(
    list(source = "A", target = "C", pathway = "P1", prob = 0.20)
  )))
  obj2 <- make_mock_cellchat(make_mock_prob(list(
    list(source = "A", target = "C", pathway = "P1", prob = 0.40)
  )))

  out <- get_avg_df(list(obj1 = obj1, obj2 = obj2), sources = "A", targets = "C")
  p1 <- out[out$source == "A" & out$target == "C" & out$pathway_name == "P1", ]

  expect_equal(p1$prob, 0.30)
})

test_that("get_avg_df filters to requested sources and targets", {
  obj <- make_mock_cellchat(make_mock_prob(list(
    list(source = "A", target = "C", pathway = "P1", prob = 0.20),
    list(source = "B", target = "D", pathway = "P1", prob = 0.90)
  )))

  out <- get_avg_df(list(obj = obj), sources = "A", targets = "C")

  expect_true(all(out$source %in% "A"))
  expect_true(all(out$target %in% "C"))
})

test_that("get_avg_df stops when no objects match", {
  obj <- make_mock_cellchat(make_mock_prob(list(
    list(source = "A", target = "C", pathway = "P1", prob = 0.20)
  )))

  expect_error(
    get_avg_df(list(obj = obj), sources = "missing", targets = "missing"),
    "No data found"
  )
})

test_that("get_avg_df warns and skips objects with empty netP probability data", {
  empty_obj <- make_mock_cellchat(array(0, dim = c(0, 0, 0)))
  valid_obj <- make_mock_cellchat(make_mock_prob(list(
    list(source = "A", target = "C", pathway = "P1", prob = 0.20)
  )))

  expect_warning(
    out <- get_avg_df(list(empty = empty_obj, valid = valid_obj),
                      sources = "A",
                      targets = "C"),
    "netP\\$prob is empty"
  )
  expect_true(nrow(out) > 0)
})

