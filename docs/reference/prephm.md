# Preprocess CellChat probability data for heatmap visualization

Preprocess CellChat probability data for heatmap visualization

## Usage

``` r
prephm(df.netPx1outgoing)
```

## Arguments

  - df.netPx1outgoing:
    
    A data frame with columns source, target, pathway\_name, and prob
    containing CellChat communication probabilities.

## Value

A data frame with pathways as rows and cell types as columns, filtered
for meaningful interactions and ordered by decreasing row sums.
