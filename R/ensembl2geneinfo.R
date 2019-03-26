# disable strings as factors, but re-enable upon exit
old <- options(stringsAsFactors = FALSE)
on.exit(options(old), add = TRUE)

#' Ensembl ids 2 hgnc and various info
#'
#' \code{ensembl2geneinfo} looks up information from var_attributes for Ensembl
#' gene ids. If "hgnc_symbol" and "external_gene_name" in var_attributes,
#' external_gene_name will not be returned but will be used to fill in
#' blanks within hgnc_symbol.
#'
#' @param ensembl_gene_ids Character vector.
#'     List of Ensembl gene ids to get hgnc symbols for.
#' @param host Character.
#'     Ensembl biomaRt host.
#' @param var_attributes Character vector.
#'     List of attributes to select from Ensembl.
#' @param drop_dot_ensembl_id Logical.
#'     Drop "." from ENSG00000072310.12
#'
#' @return Data.frame.
#'     Data.frame of the attributes requested. Note that duplicates are removed
#'     and the order is not the same as given. First column is always
#'     ensembl_gene_ids_original.
#'
#' @examples
#' ensembl2geneinfo(
#'     c("ENSG00000109501", "ENSG00000072310.12", "ENSG00000030066")
#' )
#'
#' @importFrom biomaRt useMart
#' @importFrom biomaRt getBM
#' @export
ensembl2geneinfo <- function(
        ensembl_gene_ids,
        host = "grch37.ensembl.org",
        var_attributes = c(
            "ensembl_gene_id",
            "hgnc_symbol",
            "external_gene_name",
            "start_position",
            "end_position",
            "strand"
        ),
        drop_dot_ensembl_id = TRUE
    ) {

    ensembl_gene_ids <- as.character(ensembl_gene_ids)
    ensembl_gene_ids_original <- ensembl_gene_ids
    if (drop_dot_ensembl_id) {
        ensembl_gene_ids <- unlist(lapply(ensembl_gene_ids,
            FUN = function(x) { return(strsplit(x, '\\.')[[1]][1]) }
        ))
    }
    # put this in a tryCatch block in case biomaRt is down!
    gene_info_tmp <- tryCatch({
        ensembl <- biomaRt::useMart(
            biomart = "ENSEMBL_MART_ENSEMBL",
            host = host,
            path = "/biomart/martservice",
            dataset = "hsapiens_gene_ensembl"
        )
        #biomaRt::listAttributes(ensembl)
        #cols <- c("ensembl_gene_id", "hgnc_symbol", "gene_biotype",
        #   "description")
        gene_info_tmp <- biomaRt::getBM(
            attributes = var_attributes,
            mart = ensembl,
            filters = c("ensembl_gene_id"),
            values = unique(ensembl_gene_ids)
        )
    }, error = function(cond) {
        warning(paste0("Problems with biomaRt, probably due to a down",
                       " website. Returning ensembl_ids rather than hgnc_id."))
        return_df <- data.frame(
            "ensembl_gene_ids_original" = unique(ensembl_gene_ids_original),
            stringsAsFactors = FALSE
        )
        row.names(return_df) <- return_df$ensembl_gene_id
        return(return_df)
    })

    # case where no results
    if (nrow(gene_info_tmp) == 0) {
        return_df <- data.frame(
            "ensembl_gene_ids_original" = unique(ensembl_gene_ids_original),
            stringsAsFactors = FALSE
        )
        row.names(return_df) <- return_df$ensembl_gene_id
    } else {
        # make the gene_info_tmp the length of ensembl_gene_ids... so that
        # the return vector is the same length
        # this command also expands cases when there are duplicates.
        gene_info_tmp <- merge(
            data.frame(
                "ensembl_gene_id" = ensembl_gene_ids,
                "ensembl_gene_ids_original" = ensembl_gene_ids_original,
                stringsAsFactors = FALSE
            ),
            gene_info_tmp,
            by = c("ensembl_gene_id"),
            all.x = T,
            all.y = T
        )
        if ("hgnc_symbol" %in% colnames(gene_info_tmp)) {
            # if hgnc_symbol is empty, replace it with external_gene_name
            if ("external_gene_name" %in% colnames(gene_info_tmp)) {
                filt <- is.na(gene_info_tmp$hgnc_symbol) |
                    gene_info_tmp$hgnc_symbol == ""
                if (any(filt)) {
                    gene_info_tmp$hgnc_symbol[filt] <- as.character(
                        gene_info_tmp$external_gene_name[filt]
                    )
                }
                gene_info_tmp$external_gene_name <- NULL # del external_gene_name
            }
            # if hgnc_symbol is *still* empty, replace it with ensembl_gene_id
            filt <- is.na(gene_info_tmp$hgnc_symbol) |
                gene_info_tmp$hgnc_symbol == ""
            if (any(filt)) {
                gene_info_tmp$hgnc_symbol[filt] <- as.character(
                    gene_info_tmp$ensembl_gene_id[filt]
                )
            }
        }
        # set the tss based on + or - strand
        #return_df$tss <- return_df$start_position
        #filt <- return_df$strand == -1
        #return_df$tss[filt] <- return_df$end_position[filt]
        return_df <- unique(gene_info_tmp)
        row.names(return_df) <- as.character(
            return_df$ensembl_gene_ids_original
        )
        # make ensembl_gene_ids_original the first column
        order_cols <- var_attributes[
            var_attributes %in% colnames(return_df)
        ]
        return_df <- return_df[c("ensembl_gene_ids_original", order_cols)]
    }

    return(return_df)
}
