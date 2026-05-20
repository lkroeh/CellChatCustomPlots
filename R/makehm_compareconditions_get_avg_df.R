#' Average CellChat communication probabilities across objects
#'
#' Pools communication probabilities from multiple CellChat objects and returns
#' the mean probability for each source, target, and pathway combination.
#'
#' @param obj_list A named list of CellChat objects.
#' @param sources A character vector of source cell type names.
#' @param targets A character vector of target cell type names.
#'
#' @return A data frame with columns source, target, pathway_name, and prob.
#'
#' @importFrom reshape2 melt
#' @importFrom stats aggregate
#' @export
get_avg_df <- function(obj_list, sources, targets) {
  rows <- lapply(names(obj_list), function(obj_name) {
    hmobj <- obj_list[[obj_name]]

    if (is.null(hmobj@netP$prob) || length(hmobj@netP$prob) == 0) {
      warning(obj_name, ": netP$prob is empty -- skipping.")
      return(NULL)
    }

    df.netPx <- reshape2::melt(hmobj@netP$prob, value.name = "prob")
    colnames(df.netPx)[1:3] <- c("source", "target", "pathway_name")

    filtered <- df.netPx[(df.netPx$source %in% sources) &
                           (df.netPx$target %in% targets), ]

    if (nrow(filtered) == 0) {
      warning(obj_name, ": no rows match sources/targets -- skipping.")
      return(NULL)
    }

    filtered
  })

  rows <- Filter(Negate(is.null), rows)

  if (length(rows) == 0) {
    stop(
      "No data found in any object for sources: [", paste(sources, collapse = ", "),
      "] and targets: [", paste(targets, collapse = ", "), "]\n",
      "Run check_celltypes() to see available names."
    )
  }

  df_pooled <- do.call(rbind, rows)
  stats::aggregate(prob ~ source + target + pathway_name,
                   data = df_pooled,
                   FUN = mean)
}
