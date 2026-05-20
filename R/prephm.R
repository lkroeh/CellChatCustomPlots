#' Preprocess CellChat probability data for heatmap visualization
#'
#' @param df.netPx1outgoing A data frame with columns source, target,
#'   pathway_name, and prob containing CellChat communication probabilities.
#' @param min_rowsum Numeric row-sum cutoff used to remove pathways with low
#'   total communication probability.
#'
#' @return A data frame with pathways as rows and cell types as columns,
#'   filtered for meaningful interactions and ordered by decreasing row sums.
#'
#' @importFrom reshape cast
#' @importFrom stats na.omit
#' @export
prephm <- function(df.netPx1outgoing, min_rowsum = 0.05) {
  dfoutgoing <- reshape::cast(df.netPx1outgoing, pathway_name~source, value = 'prob', fun.aggregate = 'sum')
  dfincoming <- reshape::cast(df.netPx1outgoing, pathway_name~target, value = 'prob', fun.aggregate = 'sum')
  
  rownames(dfoutgoing) <- dfoutgoing$pathway_name
  rownames(dfincoming) <- dfincoming$pathway_name
  dfall <- as.data.frame(merge(dfoutgoing, dfincoming, by = 'pathway_name'))
  rownames(dfall) <- dfall$pathway_name
  dfall1 <- dfall[,-1]
  
  dfall2 <- stats::na.omit(dfall1)
  pt1 <- which(rowSums(dfall2) >= min_rowsum)
  dfall3 <- dfall2[pt1,]
  
  dfall5 <- dfall3[order(-rowSums(dfall3)),]
  return(dfall5)
}
