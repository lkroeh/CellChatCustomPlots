# Create a CellChat communication heatmap for a single object

Create a CellChat communication heatmap for a single object

## Usage

``` r
makehm(cellchatobj, col_fun, sources, targets, fontsize, hmtitle)
```

## Arguments

  - cellchatobj:
    
    A CellChat object containing communication probabilities.

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
