# Create a pooled CellChat communication heatmap across multiple objects

Pools communication probabilities across multiple CellChat objects
(e.g., multiple patients) and visualizes them as a single heatmap.

## Usage

``` r
makehm_pooled(
  all_objects_list,
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
  column_labels = NULL
)
```

## Arguments

  - all\_objects\_list:
    
    A named list of CellChat objects.

  - col\_fun:
    
    A color mapping function (e.g., from circlize::colorRamp2).

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

  - pool\_fun:
    
    Character string specifying how to pool probabilities across
    objects. One of `"sum"` or `"mean"`.

  - cluster\_rows:
    
    Logical indicating whether to cluster heatmap rows.

  - cluster\_columns:
    
    Logical indicating whether to cluster heatmap columns within each
    column split.

  - row\_order:
    
    Character string specifying row ordering. One of `"signal_strength"`
    or `"none"`.

  - show\_row\_barplot:
    
    Logical indicating whether to show the row-sum barplot.

  - show\_col\_barplot:
    
    Logical indicating whether to show the column-sum barplot.

  - show\_row\_labels:
    
    Logical indicating whether to show the row-label text annotation.

  - column\_labels:
    
    Optional character vector of labels to display for heatmap columns.
    Defaults to `c(sources, targets)`.

## Value

A list of length 3: (1) quantiles of the data matrix, (2) a
ComplexHeatmap object, and (3) the data matrix used to generate the
heatmap.
