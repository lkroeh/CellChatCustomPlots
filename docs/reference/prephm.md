# Preprocess CellChat probability data for heatmap visualization

Preprocess CellChat probability data for heatmap visualization

## Usage

``` r
prephm(df.netPx1outgoing, min_rowsum = 0.05)
```

## Arguments

  - df.netPx1outgoing:
    
    A data frame with columns source, target, pathway\_name, and prob
    containing CellChat communication probabilities.

  - min\_rowsum:
    
    Numeric row-sum cutoff used to remove pathways with low total
    communication probability.

## Value

A data frame with pathways as rows and cell types as columns, filtered
for meaningful interactions and ordered by decreasing row sums.
