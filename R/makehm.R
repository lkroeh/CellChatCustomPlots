#' Create a CellChat communication heatmap for a single object
#'
#' @param cellchatobj A CellChat object containing communication probabilities.
#' @param col_fun A color mapping function (e.g., from circlize::colorRamp2).
#' @param sources A character vector of source cell type names.
#' @param targets A character vector of target cell type names.
#' @param fontsize Numeric font size for row and column labels.
#' @param hmtitle A character string for the heatmap title and legend name.
#'
#' @return A list of length 3: (1) quantiles of the data matrix,
#'   (2) a ComplexHeatmap object, and (3) the data matrix used
#'   to generate the heatmap.
#'
#' @importFrom reshape2 melt
#' @importFrom ComplexHeatmap Heatmap HeatmapAnnotation anno_barplot rowAnnotation anno_text
#' @importFrom grid gpar
#' @export
makehm <- function(cellchatobj, col_fun, sources, targets, fontsize, hmtitle) {
  hmobj <- cellchatobj
  col_fun = col_fun
  size <- as.numeric(fontsize)
  title <- as.character(hmtitle)
  
  df.netPx <- reshape2::melt(hmobj@netP$prob, value.name = "prob")
  colnames(df.netPx)[1:3] <- c("source","target","pathway_name")
  
  df.netPx1outgoing <- df.netPx[(df.netPx$source %in% sources) & (df.netPx$target %in% targets),]
  
  dfall4 <- as.matrix(prephm(df.netPx1outgoing))
  
  ht_allctrl = ComplexHeatmap::Heatmap(dfall4, name = hmtitle,
                                       top_annotation = HeatmapAnnotation(Ctrl = anno_barplot(as.numeric(colSums(dfall4)))),
                                       show_column_dend = FALSE,
                                       cluster_rows = FALSE,
                                       cluster_columns = FALSE,
                                       cluster_column_slices = FALSE,
                                       show_row_dend = FALSE,
                                       row_title = "Pathways",
                                       row_names_gp = grid::gpar(fontsize = size),
                                       column_split = paste0(c(rep("outgoing", length(sources)), rep("incoming", length(targets)))),
                                       column_names_gp = grid::gpar(fontsize = size),
                                       column_title_side="bottom",
                                       col = col_fun) +
    rowAnnotation(pathway = anno_barplot(rowSums(dfall4))) +
    rowAnnotation(rn = anno_text(rownames(dfall4), gp = grid::gpar(fontsize = size)))
  
  results <- list()
  results[[1]] <- quantile(dfall4)
  results[[2]] <- ht_allctrl
  results[[3]] <- dfall4
  return(results)
}
