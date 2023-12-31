#' Annotates zoom lines for a specified genomic region of a BentoBox plot
#' 
#' @usage bbAnnoZoomLines(
#'     plot,
#'     chrom,
#'     chromstart = NULL,
#'     chromend = NULL,
#'     y0,
#'     x1 = NULL,
#'     y1,
#'     extend = 0,
#'     default.units = "inches",
#'     linecolor = "grey",
#'     lty = 2,
#'     params = NULL,
#'     ...
#' )
#'
#' @param plot Input BentoBox plot to annotate genomic region zoom lines from.
#' @param chrom Chromosome of region to draw zoom lines from, as a string.
#' @param chromstart Integer start position on chromosome to draw
#' zoom lines from.
#' @param chromend Integer end position on chromosome to draw
#' zoom lines from.
#' @param y0 A numeric vector or unit object indicating the starting
#' y-values of the zoom line segments. If two values are given,
#' the first value will correspond to the left zoom line and the
#' second value will correspond to the right zoom line.
#' @param x1 A numeric vector or unit object indicating the stopping
#' x-values of the zoom line segments. If two values are given,
#' the first value will correspond to the left zoom line and the
#' second value will correspond to the right zoom line. If NULL,
#' straight lines from zoomed genomic region will be drawn.
#' @param y1 A numeric vector or unit object indicating the stopping
#' y-values of the zoom line segments. If two values are given,
#' the first value will correspond to the left zoom line and the
#' second value will correspond to the right zoom line.
#' @param extend A numeric vector or unit object indicating the length
#' to extend straight lines from each end
#' of the zoom line segments. If two values are given, the first value
#' will correspond to the top extension length
#' and the second value will correspond to the bottom extension length.
#' Default value is \code{extend = 0}.
#' @param default.units A string indicating the default units to use
#' if \code{y0}, \code{x1}, \code{y1}, or \code{extend} are only given
#' as numerics or numeric vectors.
#' Default value is \code{default.units = "inches"}.
#' @param linecolor A character value specifying zoom line color.
#' Default value is \code{linecolor = "grey"}.
#' @param lty A numeric specifying zoom line type.
#' Default value is \code{lty = 2}.
#' @param params An optional \link[BentoBox]{bbParams}
#' object containing relevant function parameters.
#' @param ... Additional grid graphical parameters. See \link[grid]{gpar}.
#'
#' @return Returns a \code{bb_zoom} object containing
#' relevant genomic region, placement, and \link[grid]{grob} information.
#'
#' @examples
#' ## Create a page
#' bbPageCreate(width = 7.5, height = 4.75, default.units = "inches")
#'
#' ## Plot and place a Manhattan plot
#' library(BentoBoxData)
#' library("TxDb.Hsapiens.UCSC.hg19.knownGene")
#' data("hg19_insulin_GWAS")
#' manhattanPlot <- bbPlotManhattan(
#'     data = hg19_insulin_GWAS, assembly = "hg19",
#'     fill = c("grey", "#37a7db"),
#'     sigLine = FALSE,
#'     col = "grey", lty = 2, range = c(0, 14),
#'     x = 0.5, y = 0, width = 6.5, height = 2,
#'     just = c("left", "top"),
#'     default.units = "inches"
#' )
#' bbAnnoYaxis(
#'     plot = manhattanPlot, at = c(0, 2, 4, 6, 8, 10, 12, 14),
#'     axisLine = TRUE, fontsize = 8
#' )
#'
#' ## Annotate zoom lines for a region on chromsome 21
#' zoomRegion <- bbParams(
#'     chrom = "chr21",
#'     chromstart = 28000000, chromend = 30300000,
#'     assembly = "hg19"
#' )
#' bbAnnoZoomLines(
#'     plot = manhattanPlot, params = zoomRegion,
#'     y0 = 2, x1 = c(0.5, 7), y1 = 2.5, extend = c(0, 1.1),
#'     default.units = "inches",
#'     lty = 3
#' )
#'
#' ## Annotate highlight region for zoom region
#' bbAnnoHighlight(
#'     plot = manhattanPlot, params = zoomRegion,
#'     y = 2, height = 2, just = c("left", "bottom"),
#'     default.units = "inches",
#'     fill = "red", alpha = 0.8
#' )
#'
#' ## Plot Manhattan plot data and signal track under zoom lines
#' manhattanPlotZoom <- bbPlotManhattan(
#'     data = hg19_insulin_GWAS,
#'     fill = "grey",
#'     sigLine = FALSE,
#'     baseline = TRUE,
#'     params = zoomRegion, range = c(0, 14),
#'     x = 0.5, y = 2.6,
#'     width = 6.5, height = 1
#' )
#' data("IMR90_ChIP_H3K27ac_signal")
#' signalPlot <- bbPlotSignal(
#'     data = IMR90_ChIP_H3K27ac_signal, params = zoomRegion,
#'     range = c(0, 45),
#'     x = 0.5, y = "b0.1",
#'     width = 6.5, height = 0.65,
#'     just = c("left", "top"),
#'     default.units = "inches"
#' )
#'
#' ## Plot genome label
#' bbPlotGenomeLabel(
#'     chrom = "chr21",
#'     chromstart = 28000000, chromend = 30300000,
#'     assembly = "hg19",
#'     x = 0.5, y = 4.4, length = 6.5,
#'     default.units = "inches"
#' )
#'
#' ## Hide page guides
#' bbPageGuideHide()
#' @export
bbAnnoZoomLines <- function(plot, chrom, chromstart = NULL, chromend = NULL,
                            y0, x1 = NULL, y1, extend = 0,
                            default.units = "inches", linecolor = "grey",
                            lty = 2, params = NULL, ...) {

    # =========================================================================
    # FUNCTIONS
    # =========================================================================

    ## Define a function that catches errors for bbAnnoZoomLines
    bb_errorcheckAnnoZoomLines <- function(object) {
        if (!object$chrom %in% object$plot$chrom) {
            stop(object$chrom, "not found in input plot. ",
                "Cannot annotate zoom lines.", call. = FALSE)
        }

        if (length(object$chrom) > 1) {
            stop("Cannot annotate zoom lines for multiple chromosome regions ",
                "in one function call.", call. = FALSE)
        }
    }

    # =========================================================================
    # PARSE PARAMETERS
    # =========================================================================

    bb_zoomInternal <- parseParams(
        params = params,
        defaultArgs = formals(eval(match.call()[[1]])),
        declaredArgs = lapply(match.call()[-1], eval.parent, n = 2),
        class = "bb_zoomInternal"
    )

    ## Set gp
    bb_zoomInternal$gp <- gpar(
        col = bb_zoomInternal$linecolor,
        lty = bb_zoomInternal$lty
    )
    bb_zoomInternal$gp <- setGP(
        gpList = bb_zoomInternal$gp,
        params = bb_zoomInternal, ...
    )

    # =========================================================================
    # INITIALIZE OBJECT
    # =========================================================================

    bb_zoom <- structure(list(
        chrom = bb_zoomInternal$chrom,
        chromstart = bb_zoomInternal$chromstart,
        chromend = bb_zoomInternal$chromend,
        assembly = bb_zoomInternal$plot$assembly,
        x0 = NULL, y0 = bb_zoomInternal$y0,
        x1 = bb_zoomInternal$x1, y1 = bb_zoomInternal$y1,
        extend = bb_zoomInternal$extend, grobs = NULL
    ),
    class = "bb_zoom"
    )

    # =========================================================================
    # CATCH ERRORS
    # =========================================================================

    check_bbpage(error = "Cannot annotate zoom lines without a BentoBox page.")
    if (is.null(bb_zoomInternal$plot)) stop("argument \"plot\" is missing, ",
                                            "with no default.", call. = FALSE)
    if (is.null(bb_zoom$chrom)) {
        stop("argument \"chrom\" is missing, with no default.",
            call. = FALSE
        )
    }
    if (is.null(bb_zoom$y0)) {
        stop("argument \"y0\" is missing, with no default.",
            call. = FALSE
        )
    }
    if (is.null(bb_zoom$y1)) {
        stop("argument \"y1\" is missing, with no default.",
            call. = FALSE
        )
    }
    bb_errorcheckAnnoZoomLines(object = bb_zoomInternal)

    # =========================================================================
    # PARSE UNITS
    # =========================================================================

    ## y0
    bb_zoom$y0 <- misc_defaultUnits(value = bb_zoom$y0,
                                    name = "y0",
                                    default.units = 
                                        bb_zoomInternal$default.units,
                                    funName = "bbAnnoZoomLines",
                                    yBelow = FALSE)
    
    if (length(bb_zoom$y0) == 1) {
        bb_zoom$y0 <- rep(bb_zoom$y0, 2)
    }

    ## y1
    bb_zoom$y1 <- misc_defaultUnits(value = bb_zoom$y1,
                                    name = "y1",
                                    default.units = 
                                        bb_zoomInternal$default.units,
                                    funName = "bbAnnoZoomLines",
                                    yBelow = FALSE)

    if (length(bb_zoom$y1) == 1) {
        bb_zoom$y1 <- rep(bb_zoom$y1, 2)
    }

    ## extend
    bb_zoom$extend <- misc_defaultUnits(value = bb_zoom$extend,
                                    name = "extend",
                                    default.units = 
                                        bb_zoomInternal$default.units)

    if (length(bb_zoom$extend) == 1) {
        bb_zoom$extend <- rep(bb_zoom$extend, 2)
    }

    # =========================================================================
    # WHOLE CHROM GENOMIC SCALE
    # =========================================================================
    
    scaleChecks <- genomicScale(object = bb_zoom,
                                objectInternal = bb_zoomInternal,
                                plotType = "zoom lines")
    bb_zoom <- scaleChecks[[1]]

    # =========================================================================
    # PARSE GENOMIC REGION FOR X0
    # =========================================================================
    page_units <- get("page_units", envir = bbEnv)
    
    ## Get appropriate plot viewport
    plotVP <- getAnnoViewport(plot = bb_zoomInternal$plot)
    
    ## Convert plot viewport to bottom left to get left position on entire page
    plotVP_bottomLeft <- vp_bottomLeft(viewport = plotVP)

    ## Convert plot genomic coordinates to position on page
    seekViewport(plotVP$name)

    if (!is.null(bb_zoom$chromstart) & !is.null(bb_zoom$chromend)) {
        if (is(bb_zoomInternal$plot, "bb_manhattan")) {

            ## Multiple chromosome manhattan plot
            if (length(bb_zoomInternal$plot$chrom) > 1) {
                convertedCoords <- convertManhattan(
                    object = bb_zoom,
                    manhattanPlot = bb_zoomInternal$plot
                )
                x0_1 <- convertedCoords[[1]]
                x0_2 <- convertedCoords[[2]]
            } else {
                x0_1 <- convertX(unit(bb_zoom$chromstart, "native"),
                    unitTo = page_units, valueOnly = TRUE
                )
                x0_2 <- convertX(unit(bb_zoom$chromend, "native"),
                    unitTo = page_units, valueOnly = TRUE
                )
            }
        } else {
            x0_1 <- convertX(unit(bb_zoom$chromstart, "native"),
                unitTo = page_units, valueOnly = TRUE
            )
            x0_2 <- convertX(unit(bb_zoom$chromend, "native"),
                unitTo = page_units, valueOnly = TRUE
            )
        }

        ## Add additional page units to x0_1 and x0_2
        x0_1 <- as.numeric(plotVP_bottomLeft[[1]]) + x0_1
        x0_2 <- as.numeric(plotVP_bottomLeft[[1]]) + x0_2

        bb_zoom$x0 <- unit(c(x0_1, x0_2), page_units)
    }

    seekViewport("bb_page")

    # =========================================================================
    # PARSE X1
    # =========================================================================

    if (is.null(bb_zoom$x1)) {
        bb_zoom$x1 <- bb_zoom$x0
    } else {
        if (!"unit" %in% class(bb_zoom$x1)) {
            if (!is.numeric(bb_zoom$x1)) {
                stop("x1-coordinate is neither a unit object or a numeric ",
                    "value. Cannot annotate zoom lines.", call. = FALSE)
            }

            if (is.null(bb_zoomInternal$default.units)) {
                stop("x1-coordinate detected as numeric.\'default.units\' ",
                    "must be specified.", call. = FALSE)
            }

            bb_zoom$x1 <- unit(bb_zoom$x1, bb_zoomInternal$default.units)
        }

        if (length(bb_zoom$x1) == 1) {
            bb_zoom$x1 <- rep(bb_zoom$x1, 2)
        }
    }

    # =========================================================================
    # INITIALIZE GTREE FOR GROBS
    # =========================================================================
    name <- paste0(
        "bb_zoom",
        length(grep(
            pattern = "bb_zoom",
            x = grid.ls(
                print = FALSE,
                recursive = FALSE
            )
        )) + 1
    )
    assign("zoom_grobs", gTree(name = name), envir = bbEnv)

    if (!is.null(bb_zoom$chromstart) & !is.null(bb_zoom$chromend)) {
        # =====================================================================
        # ZOOM SEGMENTS
        # =====================================================================
        page_height <- get("page_height", envir = bbEnv)
        zoomSegment_left <- segmentsGrob(
            x0 = bb_zoom$x0[1],
            y0 = unit(page_height, page_units) - bb_zoom$y0[1],
            x1 = bb_zoom$x1[1],
            y1 = unit(page_height, page_units) - bb_zoom$y1[1],
            gp = bb_zoomInternal$gp
        )
        zoomSegment_right <- segmentsGrob(
            x0 = bb_zoom$x0[2],
            y0 = unit(page_height, page_units) - bb_zoom$y0[2],
            x1 = bb_zoom$x1[2],
            y1 = unit(page_height, page_units) - bb_zoom$y1[2],
            gp = bb_zoomInternal$gp
        )

        assign("zoom_grobs",
            addGrob(
                gTree = get("zoom_grobs", envir = bbEnv),
                child = zoomSegment_left
            ),
            envir = bbEnv
        )
        assign("zoom_grobs",
            addGrob(
                gTree = get("zoom_grobs", envir = bbEnv),
                child = zoomSegment_right
            ),
            envir = bbEnv
        )

        # =====================================================================
        # EXTEND SEGMENTS
        # =====================================================================

        topy1_left <- (unit(page_height, page_units) - bb_zoom$y0[1]) +
            bb_zoom$extend[1]
        topy1_right <- (unit(page_height, page_units) - bb_zoom$y0[2]) +
            bb_zoom$extend[1]
        bottomy1_left <- (unit(page_height, page_units) - bb_zoom$y1[1]) -
            bb_zoom$extend[2]
        bottomy1_right <- (unit(page_height, page_units) - bb_zoom$y1[2]) -
            bb_zoom$extend[2]


        extend_topLeft <- segmentsGrob(
            x0 = bb_zoom$x0[1],
            y0 = unit(page_height, page_units) - bb_zoom$y0[1],
            x1 = bb_zoom$x0[1],
            y1 = topy1_left,
            gp = bb_zoomInternal$gp
        )
        extend_topRight <- segmentsGrob(
            x0 = bb_zoom$x0[2],
            y0 = unit(page_height, page_units) - bb_zoom$y0[2],
            x1 = bb_zoom$x0[2],
            y1 = topy1_right,
            gp = bb_zoomInternal$gp
        )
        extend_bottomLeft <- segmentsGrob(
            x0 = bb_zoom$x1[1],
            y0 = unit(page_height, page_units) - bb_zoom$y1[1],
            x1 = bb_zoom$x1[1],
            y1 = bottomy1_left,
            gp = bb_zoomInternal$gp
        )
        extend_bottomRight <- segmentsGrob(
            x0 = bb_zoom$x1[2],
            y0 = unit(page_height, page_units) - bb_zoom$y1[2],
            x1 = bb_zoom$x1[2],
            y1 = bottomy1_right,
            gp = bb_zoomInternal$gp
        )

        assign("zoom_grobs",
            addGrob(
                gTree = get("zoom_grobs", envir = bbEnv),
                child = extend_topLeft
            ),
            envir = bbEnv
        )
        assign("zoom_grobs",
            addGrob(
                gTree = get("zoom_grobs", envir = bbEnv),
                child = extend_topRight
            ),
            envir = bbEnv
        )
        assign("zoom_grobs",
            addGrob(
                gTree = get("zoom_grobs", envir = bbEnv),
                child = extend_bottomLeft
            ),
            envir = bbEnv
        )
        assign("zoom_grobs",
            addGrob(
                gTree = get("zoom_grobs", envir = bbEnv),
                child = extend_bottomRight
            ),
            envir = bbEnv
        )
    }

    # =========================================================================
    # ADD GTREE TO OBJECT
    # =========================================================================

    bb_zoom$grobs <- get("zoom_grobs", envir = bbEnv)
    grid.draw(bb_zoom$grobs)

    # =========================================================================
    # RETURN OBJECT
    # =========================================================================

    message("bb_zoom[", bb_zoom$grobs$name, "]")
    invisible(bb_zoom)
}
