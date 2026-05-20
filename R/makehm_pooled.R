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
makehm_pooled <- function(all_objects_list, col_fun, sources, targets, fontsize, hmtitle) {
  
  df.netPx_pooled <- data.frame()
  
  for (obj_name in names(all_objects_list)) {
    hmobj <- all_objects_list[[obj_name]]
    
    df.netPx <- reshape2::melt(hmobj@netP$prob, value.name = "prob")
    colnames(df.netPx)[1:3] <- c("source","target","pathway_name")
    
    df.netPx_filtered <- df.netPx[(df.netPx$source %in% sources) & 
                                    (df.netPx$target %in% targets),]
    
    df.netPx_pooled <- rbind(df.netPx_pooled, df.netPx_filtered)
  }
  
  df.netPx1outgoing <- stats::aggregate(prob ~ source + target + pathway_name, 
                                        data = df.netPx_pooled, 
                                        FUN = sum)
  
  dfall4 <- as.matrix(prephm(df.netPx1outgoing))
  size <- as.numeric(fontsize)
  
  ht_allctrl = ComplexHeatmap::Heatmap(dfall4, name = hmtitle,
                                       top_annotation = HeatmapAnnotation(Ctrl = anno_barplot(as.numeric(colSums(dfall4)))),
                                       show_column_dend = FALSE,
                                       cluster_rows = FALSE,
                                       cluster_columns = FALSE,
                                       cluster_column_slices = FALSE,
                                       show_row_dend = FALSE,
                                       row_title = "Pathways",
                                       row_names_gp = grid::gpar(fontsize = size),
                                       column_split = paste0(c(rep("outgoing", length(sources)), 
                                                               rep("incoming", length(targets)))),
                                       column_names_gp = grid::gpar(fontsize = size),
                                       column_title_side="bottom",
                                       col = col_fun) +
    rowAnnotation(pathway = anno_barplot(rowSums(dfall4))) + 
    rowAnnotation(rn = anno_text(rownames(dfall4), gp = grid::gpar(fontsize = size)))
  
  results <- list()
  results[[1]] <- stats::quantile(dfall4)
  results[[2]] <- ht_allctrl
  results[[3]] <- dfall4
  return(results)
}
