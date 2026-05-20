test_that("makehm_compareconditions calculates treatment minus control differences", {
  ctrl <- make_mock_cellchat(make_mock_prob(list(
    list(source = "A", target = "C", pathway = "P1", prob = 0.20)
  )))
  treat <- make_mock_cellchat(make_mock_prob(list(
    list(source = "A", target = "C", pathway = "P1", prob = 0.50)
  )))

  results <- makehm_compareconditions(list(ctrl = ctrl),
                                      list(treat = treat),
                                      sources = "A",
                                      targets = "C",
                                      fontsize = 10,
                                      hmtitle = "difference",
                                      min_rowsum = 0,
                                      show_row_barplot = FALSE,
                                      show_col_barplot = FALSE,
                                      show_row_labels = FALSE)

  expect_equal(results$diff_mat["P1", "outgoing:A"], 0.30)
  expect_equal(results$diff_mat["P1", "incoming:C"], 0.30)
})

test_that("makehm_compareconditions positive values mean treatment increased", {
  ctrl <- make_mock_cellchat(make_mock_prob(list(
    list(source = "A", target = "C", pathway = "P1", prob = 0.10)
  )))
  treat <- make_mock_cellchat(make_mock_prob(list(
    list(source = "A", target = "C", pathway = "P1", prob = 0.40)
  )))

  results <- makehm_compareconditions(list(ctrl = ctrl),
                                      list(treat = treat),
                                      sources = "A",
                                      targets = "C",
                                      fontsize = 10,
                                      hmtitle = "difference",
                                      min_rowsum = 0,
                                      show_row_barplot = FALSE,
                                      show_col_barplot = FALSE,
                                      show_row_labels = FALSE)

  expect_gt(results$diff_mat["P1", "outgoing:A"], 0)
})

test_that("makehm_compareconditions row_order absolute_change puts strongest changes first", {
  ctrl <- make_mock_cellchat(make_mock_prob(
    list(
      list(source = "A", target = "C", pathway = "P1", prob = 0.10),
      list(source = "A", target = "C", pathway = "P2", prob = 0.90)
    ),
    pathways = c("P1", "P2")
  ))
  treat <- make_mock_cellchat(make_mock_prob(
    list(
      list(source = "A", target = "C", pathway = "P1", prob = 0.70),
      list(source = "A", target = "C", pathway = "P2", prob = 0.80)
    ),
    pathways = c("P1", "P2")
  ))

  results <- makehm_compareconditions(list(ctrl = ctrl),
                                      list(treat = treat),
                                      sources = "A",
                                      targets = "C",
                                      fontsize = 10,
                                      hmtitle = "difference",
                                      min_rowsum = 0,
                                      row_order = "absolute_change",
                                      show_row_barplot = FALSE,
                                      show_col_barplot = FALSE,
                                      show_row_labels = FALSE)

  expect_equal(rownames(results$diff_mat)[1], "P1")
})

test_that("makehm_compareconditions row_order none preserves pathway union order", {
  ctrl <- make_mock_cellchat(make_mock_prob(
    list(
      list(source = "A", target = "C", pathway = "P1", prob = 0.10),
      list(source = "A", target = "C", pathway = "P2", prob = 0.10)
    ),
    pathways = c("P1", "P2")
  ))
  treat <- make_mock_cellchat(make_mock_prob(
    list(
      list(source = "A", target = "C", pathway = "P1", prob = 0.20),
      list(source = "A", target = "C", pathway = "P2", prob = 0.40)
    ),
    pathways = c("P1", "P2")
  ))

  results <- makehm_compareconditions(list(ctrl = ctrl),
                                      list(treat = treat),
                                      sources = "A",
                                      targets = "C",
                                      fontsize = 10,
                                      hmtitle = "difference",
                                      min_rowsum = 0,
                                      row_order = "none",
                                      show_row_barplot = FALSE,
                                      show_col_barplot = FALSE,
                                      show_row_labels = FALSE)

  expect_equal(rownames(results$diff_mat), c("P1", "P2"))
})

test_that("makehm_compareconditions accepts custom colors", {
  ctrl <- make_mock_cellchat(make_mock_prob(list(
    list(source = "A", target = "C", pathway = "P1", prob = 0.10)
  )))
  treat <- make_mock_cellchat(make_mock_prob(list(
    list(source = "A", target = "C", pathway = "P1", prob = 0.40)
  )))

  expect_no_error(
    makehm_compareconditions(list(ctrl = ctrl),
                             list(treat = treat),
                             sources = "A",
                             targets = "C",
                             fontsize = 10,
                             hmtitle = "difference",
                             min_rowsum = 0,
                             neg_col = "navy",
                             mid_col = "white",
                             pos_col = "red")
  )
})

test_that("makehm_compareconditions min_diff removes tiny differences", {
  ctrl <- make_mock_cellchat(make_mock_prob(
    list(
      list(source = "A", target = "C", pathway = "P1", prob = 0.10),
      list(source = "A", target = "C", pathway = "P2", prob = 0.20)
    ),
    pathways = c("P1", "P2")
  ))
  treat <- make_mock_cellchat(make_mock_prob(
    list(
      list(source = "A", target = "C", pathway = "P1", prob = 0.101),
      list(source = "A", target = "C", pathway = "P2", prob = 0.40)
    ),
    pathways = c("P1", "P2")
  ))

  results <- makehm_compareconditions(list(ctrl = ctrl),
                                      list(treat = treat),
                                      sources = "A",
                                      targets = "C",
                                      fontsize = 10,
                                      hmtitle = "difference",
                                      min_rowsum = 0,
                                      min_diff = 0.01,
                                      show_row_barplot = FALSE,
                                      show_col_barplot = FALSE,
                                      show_row_labels = FALSE)

  expect_false("P1" %in% rownames(results$diff_mat))
  expect_true("P2" %in% rownames(results$diff_mat))
})
