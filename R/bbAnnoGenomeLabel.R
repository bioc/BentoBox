#' Annotate genomic coordinates along the x or y-axis of a BentoBox plot
#' 
#' @usage bbAnnoGenomeLabel(
#'     plot,
#'     fontsize = 10,
#'     fontcolor = "black",
#'     linecolor = "black",
#'     margin = unit(1, "mm"),
#'     scale = "bp",
#'     commas = TRUE,
#'     sequence = TRUE,
#'     boxWidth = 0.5,
#'     axis = "x",
#'     at = NULL,
#'     tcl = 0.5,
#'     x,
#'     y,
#'     just = c("left", "top"),
#'     default.units = "inches",
#'     params = NULL,
#'     ...
#' )
#'
#' @param plot Input BentoBox plot to annotate genomic coordinates.
#' Genomic coordinates and assembly will be inherited from \code{plot}.
#' @param fontsize A numeric specifying text fontsize in points.
#' Default value is \code{fontsize = 10}.
#' @param fontcolor A character value indicating the color for text.
#' Default value is \code{fontcolor = "black"}.
#' @param linecolor A character value indicating the color of
#' the genome label axis. Default value is \code{linecolor = "black"}.
#' @param margin A numeric or unit vector specifying space between axis
#' and coordinate labels. Default value is \code{margin = unit(1, "mm")}.
#' @param scale A character value indicating the scale of the coordinates
#' along the genome label. Default value is \code{scale = "bp"}. Options are:
#' \itemize{
#' \item{\code{"bp"}: }{base pairs.}
#' \item{\code{"Kb"}: }{kilobase pairs. 1 kilobase pair is equal to
#' 1000 base pairs.}
#' \item{\code{"Mb"}: }{megabase pairs. 1 megabase pair is equal to
#' 1000000 base pairs.}
#' }
#' @param commas A logical value indicating whether to include commas in
#' start and stop labels. Default value is \code{commas = TRUE}.
#' @param sequence A logical value indicating whether to include sequence
#' information above the label of an x-axis (only at appropriate resolutions).
#' @param boxWidth A numeric value indicating the width of the boxes
#' representing sequence information at appropriate resolutions.
#' Default value is \code{boxWidth = 0.5}.
#' @param axis A character value indicating along which axis to
#' add genome label. Sequence information will not be displayed along a y-axis.
#' Default value is \code{axis = "x"}.
#' Options are:
#' \itemize{
#' \item{\code{"x"}: }{Genome label will be plotted along the x-axis.}
#' \item{\code{"y"}: }{Genome label will be plotted along the y-axis.
#' This is typically used for a square Hi-C plot made with
#' \code{bbPlotHicSquare}.}
#' }
#' @param at A numeric vector of x-value locations for tick marks.
#' @param tcl A numeric specifying the length of tickmarks as a fraction of
#' text height. Default value is \code{tcl = 0.5}.
#' @param x A numeric or unit object specifying genome label x-location.
#' @param y A numeric, unit object, or character containing a "b" combined
#' with a numeric value specifying genome label y-location.
#' The character value will place the genome label y relative to the bottom
#' of the most recently plotted BentoBox plot according to the units of the
#' BentoBox page.
#' @param just Justification of genome label relative to its (x, y) location.
#' If there are two values, the first value specifies horizontal justification
#' and the second value specifies vertical justification.
#' Possible string values are: \code{"left"}, \code{"right"}, \code{"centre"},
#' \code{"center"}, \code{"bottom"}, and \code{"top"}.
#' Default value is \code{just = c("left", "top")}.
#' @param default.units A string indicating the default units to use
#' if \code{x} or \code{y} are only given as numerics.
#' Default value is \code{default.units = "inches"}.
#' @param params An optional \link[BentoBox]{bbParams} object containing
#' relevant function parameters.
#' @param ... Additional grid graphical parameters or digit specifications.
#' See \link[grid]{gpar} and \link[base]{formatC}.
#'
#' @return Returns a \code{bb_genomeLabel} object containing
#' relevant genomic region, placement, and \link[grid]{grob} information.
#'
#' @examples
#' ## Load hg19 genomic annotation packages
#' library("TxDb.Hsapiens.UCSC.hg19.knownGene")
#' library("org.Hs.eg.db")
#'
#' ## Create BentoBox page
#' bbPageCreate(width = 5, height = 2, default.units = "inches")
#'
#' ## Plot and place gene track on a BentoBox page
#' genesPlot <- bbPlotGenes(
#'     chrom = "chr8",
#'     chromstart = 1000000, chromend = 2000000,
#'     assembly = "hg19", fill = c("grey", "grey"),
#'     fontcolor = c("grey", "grey"),
#'     x = 0.5, y = 0.25, width = 4, height = 1,
#'     just = c("left", "top"),
#'     default.units = "inches"
#' )
#'
#' ## Annotate x-axis genome labels at different scales
#' bbAnnoGenomeLabel(
#'     plot = genesPlot, scale = "Mb",
#'     x = 0.5, y = 1.25, just = c("left", "top"),
#'     default.units = "inches"
#' )
#' bbAnnoGenomeLabel(
#'     plot = genesPlot, scale = "Kb",
#'     x = 0.5, y = 1.5, just = c("left", "top"),
#'     default.units = "inches"
#' )
#' bbAnnoGenomeLabel(
#'     plot = genesPlot, scale = "bp",
#'     x = 0.5, y = 1.75, just = c("left", "top"),
#'     default.units = "inches"
#' )
#'
#' ## Hide page guides
#' bbPageGuideHide()
#' @export
bbAnnoGenomeLabel <- function(plot, fontsize = 10, fontcolor = "black",
                            linecolor = "black", margin = unit(1, "mm"),
                            scale = "bp", commas = TRUE, sequence = TRUE,
                            boxWidth = 0.5, axis = "x", at = NULL,
                            tcl = 0.5, x, y, just = c("left", "top"),
                            default.units = "inches", params = NULL, ...) {


    # =========================================================================
    # PARSE PARAMETERS
    # =========================================================================
    
    bb_genomeLabelInternal <- parseParams(
        params = params,
        defaultArgs = formals(eval(match.call()[[1]])),
        declaredArgs = lapply(match.call()[-1], eval.parent, n = 2),
        class = "bb_genomeLabelInternal"
    )
    
    # =========================================================================
    # CATCH ARGUMENT/PLOT INPUT ERRORS
    # =========================================================================
    if (is.null(bb_genomeLabelInternal$plot)) {
        stop("argument \"plot\" is missing, with no default.", call. = FALSE)
    }
    if (is.null(bb_genomeLabelInternal$x)) {
        stop("argument \"x\" is missing, with no default.", call. = FALSE)
    }
    if (is.null(bb_genomeLabelInternal$y)) {
        stop("argument \"y\" is missing, with no default.", call. = FALSE)
    }
    

    ## Check that input plot is a valid type of plot to be annotated
    if (!is(bb_genomeLabelInternal$plot, "bb_manhattan")) {

        ## Manhattan plots can do whole genome assembly but other plots can't
        inputNames <- attributes(bb_genomeLabelInternal$plot)$names
        if (!("chrom" %in% inputNames) |
            !("chromstart" %in% inputNames) |
            !("chromend" %in% inputNames)) {
            stop("Invalid input plot. Please input a plot that has genomic ",
            "coordinates associated with it.", call. = FALSE)
        }
    }

    # =========================================================================
    # ASSIGN PARAMETERS BASED ON PLOT INPUT
    # =========================================================================

    chrom <- bb_genomeLabelInternal$plot$chrom
    chromstart <- bb_genomeLabelInternal$plot$chromstart
    chromend <- bb_genomeLabelInternal$plot$chromend
    assembly <- bb_genomeLabelInternal$plot$assembly
    x <- bb_genomeLabelInternal$x
    y <- bb_genomeLabelInternal$y
    length <- bb_genomeLabelInternal$plot$width
    if (bb_genomeLabelInternal$axis == "y") {
        length <- bb_genomeLabelInternal$plot$height
    }
    
    just <- bb_justConversion(just = bb_genomeLabelInternal$just)
    
    ## Whole genome Manhattan plot spacing
    space <- bb_genomeLabelInternal$plot$space

    # =========================================================================
    # CALL BBPlotGENOMELABEL
    # =========================================================================

    bb_genomeLabel <- bbPlotGenomeLabel(
        chrom = chrom, chromstart = chromstart,
        chromend = chromend, assembly = assembly,
        fontsize = bb_genomeLabelInternal$fontsize,
        fontcolor = bb_genomeLabelInternal$fontcolor,
        linecolor = bb_genomeLabelInternal$linecolor,
        margin = bb_genomeLabelInternal$margin,
        scale = bb_genomeLabelInternal$scale,
        commas = bb_genomeLabelInternal$commas,
        sequence = bb_genomeLabelInternal$sequence,
        boxWidth = bb_genomeLabelInternal$boxWidth,
        axis = bb_genomeLabelInternal$axis,
        at = bb_genomeLabelInternal$at,
        tcl = bb_genomeLabelInternal$tcl,
        x = x, y = y, length = length,
        just = just,
        default.units = bb_genomeLabelInternal$default.units,
        space = space, params = params, ...
    )

    # =========================================================================
    # RETURN OBJECT
    # =========================================================================

    invisible(bb_genomeLabel)
}
