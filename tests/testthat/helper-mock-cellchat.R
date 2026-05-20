if (!methods::isClass("MockCellChat")) {
  methods::setClass("MockCellChat", slots = c(netP = "list"))
}

make_mock_prob <- function(values,
                           sources = c("A", "B"),
                           targets = c("C", "D"),
                           pathways = c("P1", "P2", "P3")) {
  prob <- array(
    0,
    dim = c(length(sources), length(targets), length(pathways)),
    dimnames = list(
      source = sources,
      target = targets,
      pathway_name = pathways
    )
  )

  for (value in values) {
    prob[value$source, value$target, value$pathway] <- value$prob
  }

  prob
}

make_mock_cellchat <- function(prob_array) {
  methods::new("MockCellChat", netP = list(prob = prob_array))
}

