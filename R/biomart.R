###**************************************************.
###*wrapper of bioMart
###**************************************************.

#' Lists available archived versions of Ensembl (hosts), marts, snp attributes/filters, gene attributes/filters
#' @param what one of 'hosts', 'marts', 'snp', 'gene'
#' @param host default 'www.ensembl.org'. Other eg, 'grch37.ensembl.org', 'May2017.archive.ensembl.org'. See all, run \code{\link{mart.list}}
#' @return view in RStudio
#' @export
mart.list <- function(what='snp',host=NULL,...) {
    if (is.null(host)) {host='www.ensembl.org'}

    if (what=='hosts') {
        #' code of listEnsemblArchives from bioMart v2.34 (not available in v2.30)
        html <- XML::htmlParse("http://www.ensembl.org/info/website/archives/index.html")
        archive_box <- XML::getNodeSet(html, path = "//div[@class='plain-box float-right archive-box']")[[1]]
        archive_box_string <- XML::toString.XMLNode(archive_box)
        archives <- strsplit(archive_box_string, split = "<li>")[[1]][-1]
        extracted <- stringr::str_extract_all(string = archives, 
                                   pattern = "Ensembl [A-Za-z0-9 ]{2,6}|http://.*ensembl\\.org|[A-Z][a-z]{2} [0-9]{4}")
        hosts <- do.call("rbind", extracted)
        colnames(hosts) <- c("url", "version", "date")
        hosts <- hosts[,c(2,3,1)]
        View(hosts)
    }

    if (what=='marts') {
        marts = biomaRt::listEnsembl(host=host, ...)
        View(marts)
    }

    if (what=='snp') {
        SNP_Attributes = biomaRt::listAttributes(biomaRt::useEnsembl(biomart="snp", dataset="hsapiens_snp", host=host, ...))
        SNP_Filters = biomaRt::listFilters(biomaRt::useEnsembl(biomart="snp", dataset="hsapiens_snp", host=host, ...))
        View(SNP_Attributes)
        View(SNP_Filters)
    }

    if (what=='gene') {
        Gene_Attributes = biomaRt::listAttributes(biomaRt::useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl", host=host, ...))
        Gene_Filters = biomaRt::listFilters(biomaRt::useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl", host=host, ...))
        View(Gene_Attributes)
        View(Gene_Filters)
    }

}

#' return a mart object representing snp:hsapiens_snp
#' @param host default 'www.ensembl.org'. Other eg, 'grch37.ensembl.org', 'May2017.archive.ensembl.org'. See all, run \code{\link{mart.list}}
#' @export
mart.snp = function(host=NULL, biomart="snp", dataset="hsapiens_snp", ...) {
    if (is.null(host)) {host='www.ensembl.org'}
    return(biomaRt::useEnsembl(biomart=biomart, dataset=dataset, host=host, ...))
}

#' return a mart object representing ensembl:hsapiens_gene_ensembl
#' @param host default 'www.ensembl.org'. Other eg, 'grch37.ensembl.org', 'May2017.archive.ensembl.org'. See all, run \code{\link{mart.list}}
#' @export
mart.gene = function(host=NULL, biomart="ensembl", dataset="hsapiens_gene_ensembl", ...) {
    if (is.null(host)) {host='www.ensembl.org'}
    return(biomaRt::useEnsembl(biomart=biomart, dataset=dataset, host=host, ...))
}
