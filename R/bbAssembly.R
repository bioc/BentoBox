#' Make a \code{bbAssembly} object for alternate TxDb, OrgDb,and BSgenome
#' genomic annotation packages
#' 
#' @usage bbAssembly(
#'     Genome,
#'     TxDb,
#'     OrgDb,
#'     gene.id.column = "ENTREZID",
#'     display.column = "SYMBOL",
#'     BSgenome = NULL
#' )
#'
#' @param Genome String indicating the name of the genome assembly.
#' @param TxDb String of existing TxDb package name or a TxDb object.
#' @param OrgDb String of the desired OrgDb package name.
#' @param gene.id.column String of the TxDb column name that refers to
#' the given TxDb gene IDs.
#' Default value is \code{gene.id.column = "ENTREZID"}.
#' @param display.column String of the OrgDb column name that refers to
#' the type of gene symbol to be displayed in plots.
#' Default value is \code{display.column = "SYMBOL"}.
#' @param BSgenome String of the desired BSgenome package name.
#'
#' @return Returns a \code{bbAssembly} object containing all input parameters.
#'
#' @examples
#' ## Create a custom bbAssembly object for hg38/GRCh38 packages
#' newAssembly <- bbAssembly(
#'     Genome = "hg38_GRCh38",
#'     TxDb = "TxDb.Hsapiens.UCSC.hg38.knownGene",
#'     OrgDb = "org.Hs.eg.db",
#'     BSgenome = "BSgenome.Hsapiens.NCBI.GRCh38"
#' )
#' @seealso \link[GenomicFeatures]{TxDb}, \link[AnnotationDbi]{OrgDb-class},
#' \link[BSgenome]{BSgenome}
#'
#' @export
bbAssembly <- function(Genome, TxDb, OrgDb, gene.id.column = "ENTREZID",
                        display.column = "SYMBOL", BSgenome = NULL) {
    object <- structure(list(
        Genome = Genome, TxDb = TxDb, OrgDb = OrgDb,
        gene.id.column = gene.id.column,
        display.column = display.column
    ),
    class = "bbAssembly"
    )

    if (is(object$TxDb, "TxDb")) {
        object$TxDb$packageName <- paste0("TxDb.", Genome)
    }

    if (!is.null(BSgenome)) {
        object$BSgenome <- BSgenome
    }

    invisible(object)
}
