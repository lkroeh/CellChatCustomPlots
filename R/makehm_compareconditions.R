#' Compare CellChat communication heatmaps between two conditions
#'
#' Creates a difference heatmap from the mean communication probabilities in two
#' groups of CellChat objects. Positive values indicate higher communication in
#' the treatment condition, and negative values indicate higher communication in
#' the control condition.
#'
#' @param list_ctrl A named list of control CellChat objects.
#' @param list_treat A named list of treatment CellChat objects.
#' @param sources A character vector of source cell type names.
#' @param targets A character vector of target cell type names.
#' @param fontsize Numeric font size for row and column labels.
#' @param hmtitle A character string for the heatmap title and legend name.
#' @param min_rowsum Numeric row-sum cutoff passed to `prephm()`.
#'
#' @return A named list containing quantiles, heatmap, and diff_mat.
#'
#' @importFrom ComplexHeatmap Heatmap HeatmapAnnotation anno_barplot rowAnnotation anno_text
#' @importFrom circlize colorRamp2
#' @importFrom grid gpar
#' @export
makehm_compareconditions <- function(list_ctrl,
                                     list_treat,
                                     sources,
                                     targets,
                                     fontsize,
                                     hmtitle,
                                     min_rowsum = 0.01) {
  size <- as.numeric(fontsize)

  mat_ctrl <- as.matrix(prephm(get_avg_df(list_ctrl, sources, targets),
                               min_rowsum = min_rowsum))
  mat_treat <- as.matrix(prephm(get_avg_df(list_treat, sources, targets),
                                min_rowsum = min_rowsum))

  all_rows <- union(rownames(mat_ctrl), rownames(mat_treat))
  outgoing_cols <- paste("outgoing", sources, sep = ":")
  incoming_cols <- paste("incoming", targets, sep = ":")
  all_cols <- c(outgoing_cols, incoming_cols)

  expand_to <- function(mat) {
    m <- matrix(0,
                nrow = length(all_rows),
                ncol = length(all_cols),
                dimnames = list(all_rows, all_cols))
    r <- intersect(all_rows, rownames(mat))

    for (i in seq_along(sources)) {
      source <- sources[i]
      source_col <- match(TRUE, c(paste0(source, ".x"), source) %in% colnames(mat))
      if (!is.na(source_col)) {
        m[r, outgoing_cols[i]] <- mat[r, c(paste0(source, ".x"), source)[source_col]]
      }
    }

    for (i in seq_along(targets)) {
      target <- targets[i]
      target_col <- match(TRUE, c(paste0(target, ".y"), target) %in% colnames(mat))
      if (!is.na(target_col)) {
        m[r, incoming_cols[i]] <- mat[r, c(paste0(target, ".y"), target)[target_col]]
      }
    }

    m
  }

  mat_ctrl_al <- expand_to(mat_ctrl)
  mat_treat_al <- expand_to(mat_treat)

  mat_diff <- mat_treat_al - mat_ctrl_al
  mat_diff <- mat_diff[rowSums(abs(mat_diff)) > 1e-10, , drop = FALSE]

  if (nrow(mat_diff) == 0) {
    stop("No non-zero differences found after filtering with min_rowsum.")
  }

  mat_diff <- mat_diff[order(-rowSums(mat_diff)), , drop = FALSE]

  max_abs <- max(abs(mat_diff), na.rm = TRUE)
  col_fun_diff <- circlize::colorRamp2(c(-max_abs, 0, max_abs),
                                       c("steelblue", "grey95", "firebrick"))
  bar_fill <- function(x) ifelse(x >= 0, "firebrick", "steelblue")

  ht <- ComplexHeatmap::Heatmap(
    mat_diff,
    name = hmtitle,
    col = col_fun_diff,
    top_annotation = HeatmapAnnotation(
      `Delta col` = anno_barplot(as.numeric(colSums(mat_diff)),
                                 gp = grid::gpar(fill = bar_fill(colSums(mat_diff))))
    ),
    show_column_dend = FALSE,
    cluster_rows = FALSE,
    cluster_columns = FALSE,
    cluster_column_slices = FALSE,
    show_row_dend = FALSE,
    row_title = "Pathways",
    row_names_gp = grid::gpar(fontsize = size),
    column_split = c(rep("outgoing", length(sources)),
                     rep("incoming", length(targets))),
    column_labels = c(sources, targets),
    column_names_gp = grid::gpar(fontsize = size),
    column_title_side = "bottom"
  ) +
    rowAnnotation(
      `Delta row` = anno_barplot(rowSums(mat_diff),
                                 gp = grid::gpar(fill = bar_fill(rowSums(mat_diff))))
    ) +
    rowAnnotation(
      rn = anno_text(rownames(mat_diff), gp = grid::gpar(fontsize = size))
    )

  list(
    quantiles = quantile(mat_diff),
    heatmap = ht,
    diff_mat = mat_diff
  )
}
