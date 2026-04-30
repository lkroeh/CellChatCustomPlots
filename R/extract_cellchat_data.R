#' Extract CellChat communication data across multiple objects
#'
#' Loops through a named list of CellChat objects and extracts ligand-receptor
#' interaction data for specified sources, targets, and signaling pathways.
#'
#' @param all_objects_list A named list of CellChat objects.
#' @param sources.use A character vector of source cell types to include.
#' @param targets.use A character vector of target cell types to include.
#' @param signaling A character vector of signaling pathways to include.
#' @param results_df Optional. An existing data frame to append results to.
#'   If NULL (default), a new data frame is created.
#'
#' @return A data frame containing ligand-receptor interaction data with
#'   an added column identifying the patient/object of origin.
#'
#' @export
extract_cellchat_data <- function(all_objects_list, sources.use, targets.use, 
                                  signaling, results_df = NULL) {
  
  if (is.null(results_df)) {
    results_df <- data.frame(
      source = character(), target = character(), ligand = character(), 
      receptor = character(), prob = numeric(), pval = numeric(),
      interaction_name = character(), interaction_name_2 = character(),
      pathway_name = character(), annotation = character(), evidence = character(),
      source.target = character(), prob.original = numeric(),
      patient = character(), stringsAsFactors = FALSE
    )
  }
  
  for (obj_name in names(all_objects_list)) {
    cat("Processing:", obj_name, "\n")
    
    cellchat_obj <- all_objects_list[[obj_name]]
    
    plot_success <- tryCatch({
      plotinfo <- CellChat::netVisual_bubble(cellchat_obj, 
                                             sources.use = sources.use, 
                                             targets.use = targets.use, 
                                             signaling = signaling, 
                                             remove.isolate = FALSE,
                                             return.data = TRUE)
      TRUE
    }, error = function(e) {
      FALSE
    }, warning = function(w) {
      FALSE
    })
    
    if (plot_success) {
      plotinfo$communication$patient <- obj_name
      results_df <- rbind(results_df, plotinfo$communication)
      cat("  -> ADDED", nrow(plotinfo$communication), "rows\n")
    }
  }
  
  cat("Total:", nrow(results_df), "interactions extracted\n")
  return(results_df)
}
