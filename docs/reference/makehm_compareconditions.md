# Compare CellChat communication heatmaps between two conditions

Creates a difference heatmap from the mean communication probabilities
in two groups of CellChat objects. Positive values indicate higher
communication in the treatment condition, and negative values indicate
higher communication in the control condition.

## Usage

``` r
makehm_compareconditions(
  list_ctrl,
  list_treat,
  sources,
  targets,
  fontsize,
  hmtitle,
  min_rowsum = 0.01,
  neg_col = "steelblue",
  mid_col = "grey95",
  pos_col = "firebrick",
  cluster_rows = FALSE,
  cluster_columns = FALSE,
  row_order = c("treat_increased", "absolute_change", "none"),
  min_diff = 1e-10,
  show_row_barplot = TRUE,
  show_col_barplot = TRUE,
  show_row_labels = TRUE
)
```

## Arguments

  - list\_ctrl:
    
    A named list of control CellChat objects.

  - list\_treat:
    
    A named list of treatment CellChat objects.

  - sources:
    
    A character vector of source cell type names.

  - targets:
    
    A character vector of target cell type names.

  - fontsize:
    
    Numeric font size for row and column labels.

  - hmtitle:
    
    A character string for the heatmap title and legend name.

  - min\_rowsum:
    
    Numeric row-sum cutoff passed to `prephm()`.

  - neg\_col:
    
    Color for negative differences.

  - mid\_col:
    
    Color for zero-centered differences.

  - pos\_col:
    
    Color for positive differences.

  - cluster\_rows:
    
    Logical indicating whether to cluster heatmap rows.

  - cluster\_columns:
    
    Logical indicating whether to cluster heatmap columns within each
    column split.

  - row\_order:
    
    Character string specifying row ordering. One of
    `"treat_increased"`, `"absolute_change"`, or `"none"`.

  - min\_diff:
    
    Numeric row-sum cutoff on absolute differences used to remove
    pathways with little or no change between conditions.

  - show\_row\_barplot:
    
    Logical indicating whether to show the row-sum difference barplot.

  - show\_col\_barplot:
    
    Logical indicating whether to show the column-sum difference
    barplot.

  - show\_row\_labels:
    
    Logical indicating whether to show the row-label text annotation.

## Value

A named list containing quantiles, heatmap, and diff\_mat.
