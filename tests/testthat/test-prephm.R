test_that("prephm respects min_rowsum", {
  df <- data.frame(
    source = c("A", "A", "B", "B"),
    target = c("C", "D", "C", "D"),
    pathway_name = c("P1", "P1", "P2", "P2"),
    prob = c(0.10, 0.10, 0.001, 0.001)
  )

  out <- prephm(df, min_rowsum = 0.05)

  expect_true("P1" %in% rownames(out))
  expect_false("P2" %in% rownames(out))
})

test_that("prephm keeps old default row-sum behavior", {
  df <- data.frame(
    source = c("A", "A"),
    target = c("C", "C"),
    pathway_name = c("P_keep", "P_drop"),
    prob = c(0.03, 0.01)
  )

  out <- prephm(df)

  expect_true(all(rowSums(out) >= 0.05))
  expect_true("P_keep" %in% rownames(out))
  expect_false("P_drop" %in% rownames(out))
})

test_that("prephm orders pathways by decreasing row sum", {
  df <- data.frame(
    source = c("A", "A", "A"),
    target = c("C", "C", "C"),
    pathway_name = c("mid_pathway", "high_pathway", "low_pathway"),
    prob = c(0.08, 0.20, 0.03)
  )

  out <- prephm(df, min_rowsum = 0)

  expect_equal(rownames(out), c("high_pathway", "mid_pathway", "low_pathway"))
})

test_that("prephm produces outgoing and incoming columns", {
  df <- data.frame(
    source = "source_cell",
    target = "target_cell",
    pathway_name = "P1",
    prob = 0.10
  )

  out <- prephm(df, min_rowsum = 0)

  expect_true("source_cell" %in% colnames(out))
  expect_true("target_cell" %in% colnames(out))
})

