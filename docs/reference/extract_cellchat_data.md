# Extract CellChat communication data across multiple objects

Loops through a named list of CellChat objects and extracts
ligand-receptor interaction data for specified sources, targets, and
signaling pathways.

## Usage

``` r
extract_cellchat_data(
  all_objects_list,
  sources.use,
  targets.use,
  signaling,
  results_df = NULL
)
```

## Arguments

  - all\_objects\_list:
    
    A named list of CellChat objects.

  - sources.use:
    
    A character vector of source cell types to include.

  - targets.use:
    
    A character vector of target cell types to include.

  - signaling:
    
    A character vector of signaling pathways to include.

  - results\_df:
    
    Optional. An existing data frame to append results to. If NULL
    (default), a new data frame is created.

## Value

A data frame containing ligand-receptor interaction data with an added
column identifying the patient/object of origin.
