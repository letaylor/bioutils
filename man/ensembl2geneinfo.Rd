% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ensembl2geneinfo.R
\name{ensembl2geneinfo}
\alias{ensembl2geneinfo}
\title{Ensembl ids 2 hgnc and various info}
\usage{
ensembl2geneinfo(ensembl_gene_ids, host = "grch37.ensembl.org",
  var_attributes = c("ensembl_gene_id", "hgnc_symbol",
  "external_gene_name", "start_position", "end_position", "strand"),
  drop_dot_ensembl_id = TRUE)
}
\arguments{
\item{ensembl_gene_ids}{Character vector.
List of Ensembl gene ids to get hgnc symbols for.}

\item{host}{Character.
Ensembl biomaRt host.}

\item{var_attributes}{Character vector.
List of attributes to select from Ensembl.}

\item{drop_dot_ensembl_id}{Logical.
Drop "." from ENSG00000072310.12}
}
\value{
Data.frame.
    Data.frame of the attributes requested. Note that duplicates are removed
    and the order is not the same as given. First column is always
    ensembl_gene_ids_original.
}
\description{
\code{ensembl2geneinfo} looks up information from var_attributes for Ensembl
gene ids. If "hgnc_symbol" and "external_gene_name" in var_attributes,
external_gene_name will not be returned but will be used to fill in
blanks within hgnc_symbol.
}
\examples{
ensembl2geneinfo(
    c("ENSG00000109501", "ENSG00000072310.12", "ENSG00000030066")
)

}
