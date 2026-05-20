# Average CellChat communication probabilities across objects

Pools communication probabilities from multiple CellChat objects and
returns the mean probability for each source, target, and pathway
combination.

## Usage

``` r
get_avg_df(obj_list, sources, targets)
```

## Arguments

  - obj\_list:
    
    A named list of CellChat objects.

  - sources:
    
    A character vector of source cell type names.

  - targets:
    
    A character vector of target cell type names.

## Value

A data frame with columns source, target, pathway\_name, and prob.
