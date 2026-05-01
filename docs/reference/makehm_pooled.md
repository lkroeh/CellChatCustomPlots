# Create a pooled CellChat communication heatmap across multiple objects

Pools communication probabilities across multiple CellChat objects
(e.g., multiple patients) and visualizes them as a single
heatmap.

## Usage

``` r
makehm_pooled(all_objects_list, col_fun, sources, targets, fontsize, hmtitle)
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

## Value

A list of length 3: (1) quantiles of the data matrix, (2) a
ComplexHeatmap object, and (3) the data matrix used to generate the
heatmap.
