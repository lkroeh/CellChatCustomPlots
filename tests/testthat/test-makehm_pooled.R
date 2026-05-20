test_that("makehm_pooled sums probabilities by default", {
  obj1 <- make_mock_cellchat(make_mock_prob(list(
    list(source = "A", target = "C", pathway = "P1", prob = 0.20)
  )))
  obj2 <- make_mock_cellchat(make_mock_prob(list(
    list(source = "A", target = "C", pathway = "P1", prob = 0.40)
  )))

  results <- makehm_pooled(list(obj1 = obj1, obj2 = obj2),
                           col_fun = circlize::colorRamp2(c(0, 1), c("white", "red")),
                           sources = "A",
                           targets = "C",
                           fontsize = 10,
                           hmtitle = "pooled",
                           min_rowsum = 0,
                           pool_fun = "sum")

  expect_equal(results[[3]]["P1", "A"], 0.60)
  expect_equal(results[[3]]["P1", "C"], 0.60)
})

test_that("makehm_pooled can average probabilities", {
  obj1 <- make_mock_cellchat(make_mock_prob(list(
    list(source = "A", target = "C", pathway = "P1", prob = 0.20)
  )))
  obj2 <- make_mock_cellchat(make_mock_prob(list(
    list(source = "A", target = "C", pathway = "P1", prob = 0.40)
  )))

  results <- makehm_pooled(list(obj1 = obj1, obj2 = obj2),
                           col_fun = circlize::colorRamp2(c(0, 1), c("white", "red")),
                           sources = "A",
                           targets = "C",
                           fontsize = 10,
                           hmtitle = "pooled",
                           min_rowsum = 0,
                           pool_fun = "mean")

  expect_equal(results[[3]]["P1", "A"], 0.30)
  expect_equal(results[[3]]["P1", "C"], 0.30)
})

test_that("makehm_pooled min_rowsum filters low-signal pathways", {
  obj <- make_mock_cellchat(make_mock_prob(
    list(
      list(source = "A", target = "C", pathway = "P1", prob = 0.20),
      list(source = "A", target = "C", pathway = "P2", prob = 0.001)
    ),
    pathways = c("P1", "P2")
  ))

  results <- makehm_pooled(list(obj = obj),
                           col_fun = circlize::colorRamp2(c(0, 1), c("white", "red")),
                           sources = "A",
                           targets = "C",
                           fontsize = 10,
                           hmtitle = "pooled",
                           min_rowsum = 0.05)

  expect_false("P2" %in% rownames(results[[3]]))
})

test_that("makehm_pooled optional annotations can be disabled", {
  obj <- make_mock_cellchat(make_mock_prob(list(
    list(source = "A", target = "C", pathway = "P1", prob = 0.20)
  )))

  results <- makehm_pooled(list(obj = obj),
                           col_fun = circlize::colorRamp2(c(0, 1), c("white", "red")),
                           sources = "A",
                           targets = "C",
                           fontsize = 10,
                           hmtitle = "pooled",
                           min_rowsum = 0,
                           show_row_barplot = FALSE,
                           show_col_barplot = FALSE,
                           show_row_labels = FALSE)

  expect_s4_class(results[[2]], "Heatmap")
})

