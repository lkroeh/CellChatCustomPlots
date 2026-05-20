#' Create a pooled CellChat communication heatmap across multiple objects
#'
#' Pools communication probabilities across multiple CellChat objects
#' (e.g., multiple patients) and visualizes them as a single heatmap.
#'
#' @param all_objects_list A named list of CellChat objects.
#' @param col_fun A color mapping function (e.g., from circlize::colorRamp2).
#' @param sources A character vector of source cell type names.
#' @param targets A character vector of target cell type names.
#' @param fontsize Numeric font size for row and column labels.
#' @param hmtitle A character string for the heatmap title and legend name.
#' @param min_rowsum Numeric row-sum cutoff passed to `prephm()`.
#' @param pool_fun Character string specifying how to pool probabilities across
#'   objects. One of `"sum"` or `"mean"`.
#' @param cluster_rows Logical indicating whether to cluster heatmap rows.
#' @param cluster_columns Logical indicating whether to cluster heatmap columns
#'   within each column split.
#' @param row_order Character string specifying row ordering. One of
#'   `"signal_strength"` or `"none"`.
#' @param show_row_barplot Logical indicating whether to show the row-sum
#'   barplot.
#' @param show_col_barplot Logical indicating whether to show the column-sum
#'   barplot.
#' @param show_row_labels Logical indicating whether to show the row-label text
#'   annotation.
#' @param column_labels Optional character vector of labels to display for
#'   heatmap columns. Defaults to `c(sources, targets)`.
#'
#' @return A list of length 3: (1) quantiles of the data matrix,
#'   (2) a ComplexHeatmap object, and (3) the data matrix used
#'   to generate the heatmap.
#'
#' @importFrom reshape2 melt
#' @importFrom stats aggregate quantile
#' @importFrom ComplexHeatmap Heatmap HeatmapAnnotation anno_barplot rowAnnotation anno_text
#' @importFrom grid gpar
#' @export
makehm_pooled <- function(all_objects_list,
                          col_fun,
                          sources,
                          targets,
                          fontsize,
                          hmtitle,
                          min_rowsum = 0.05,
                          pool_fun = c("sum", "mean"),
                          cluster_rows = FALSE,
                          cluster_columns = FALSE,
                          row_order = c("signal_strength", "none"),
                          show_row_barplot = TRUE,
                          show_col_barplot = TRUE,
                          show_row_labels = TRUE,
                          column_labels = NULL) {
  pool_fun <- match.arg(pool_fun)
  row_order <- match.arg(row_order)
  
  df.netPx_pooled <- data.frame()
  
  for (obj_name in names(all_objects_list)) {
    hmobj <- all_objects_list[[obj_name]]
    
    df.netPx <- reshape2::melt(hmobj@netP$prob, value.name = "prob")
    colnames(df.netPx)[1:3] <- c("source","target","pathway_name")
    
    df.netPx_filtered <- df.netPx[(df.netPx$source %in% sources) & 
                                    (df.netPx$target %in% targets),]
    
    df.netPx_pooled <- rbind(df.netPx_pooled, df.netPx_filtered)
  }
  
  pool_function <- switch(pool_fun,
                          sum = sum,
                          mean = mean)
  df.netPx1outgoing <- stats::aggregate(prob ~ source + target + pathway_name, 
                                        data = df.netPx_pooled, 
                                        FUN = pool_function)
  
  dfall4 <- as.matrix(prephm(df.netPx1outgoing, min_rowsum = min_rowsum))
  if (row_order == "signal_strength") {
    dfall4 <- dfall4[order(-rowSums(dfall4)), , drop = FALSE]
  }

  size <- as.numeric(fontsize)
  top_anno <- NULL
  if (is.null(column_labels)) {
    column_labels <- c(sources, targets)
  }

  if (show_col_barplot) {
    top_anno <- HeatmapAnnotation(Ctrl = anno_barplot(as.numeric(colSums(dfall4))))
  }
  
  ht_allctrl = ComplexHeatmap::Heatmap(dfall4, name = hmtitle,
                                       top_annotation = top_anno,
                                       show_column_dend = cluster_columns,
                                       cluster_rows = cluster_rows,
                                       cluster_columns = cluster_columns,
                                       cluster_column_slices = FALSE,
                                       show_row_dend = cluster_rows,
                                       show_row_names = show_row_labels,
                                       row_title = "Pathways",
                                       row_names_gp = grid::gpar(fontsize = size),
                                       column_split = paste0(c(rep("outgoing", length(sources)), 
                                                               rep("incoming", length(targets)))),
                                       column_labels = column_labels,
                                       column_names_gp = grid::gpar(fontsize = size),
                                       column_title_side="bottom",
                                       col = col_fun)

  if (show_row_barplot) {
    ht_allctrl <- ht_allctrl +
      rowAnnotation(pathway = anno_barplot(rowSums(dfall4)))
  }

  if (show_row_labels) {
    ht_allctrl <- ht_allctrl +
      rowAnnotation(rn = anno_text(rownames(dfall4), gp = grid::gpar(fontsize = size)))
  }
  
  results <- list()
  results[[1]] <- stats::quantile(dfall4)
  results[[2]] <- ht_allctrl
  results[[3]] <- dfall4
  return(results)
}
