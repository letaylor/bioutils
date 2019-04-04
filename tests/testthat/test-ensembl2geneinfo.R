context('ensembl2geneinfo')

df_test1_order <- c('ENSG00000109501', 'ENSG00000030066', 'ENSG00000072310.12',
                    'ENSG00000072310')
df_test1 <- data.frame(
    'ensembl_gene_ids_original' = df_test1_order,
    'ensembl_gene_id' = c('ENSG00000109501', 'ENSG00000030066',
                          'ENSG00000072310', 'ENSG00000072310'),
    'hgnc_symbol' = c('WFS1', 'NUP160', 'SREBF1', 'SREBF1'),
    'start_position' = c(6271576, 47799639, 17713713, 17713713),
    stringsAsFactors = FALSE
)
row.names(df_test1) <- df_test1$ensembl_gene_ids_original


test_that('ensembl2geneinfo returns correct data.frame', {
    expect_equal(
        bioutils::ensembl2geneinfo(
            ensembl_gene_ids = c(df_test1_order, 'ENSG00000072310.12'),
            var_attributes = c('ensembl_gene_id', 'hgnc_symbol', 'start_position')
        )[df_test1_order,],
        df_test1
    )
})
