#' Add a color scale legend for heatmap-style plots
#' 
#' @usage bbAnnoHeatmapLegend(
#'     plot,
#'     orientation = "v",
#'     fontsize = 8,
#'     fontcolor = "dark grey",
#'     scientific = FALSE,
#'     digits = 0,
#'     ticks = FALSE,
#'     breaks = NULL,
#'     border = FALSE,
#'     x,
#'     y,
#'     width,
#'     height,
#'     just = c("left", "top"),
#'     default.units = "inches",
#'     params = NULL,
#'     ...
#' )
#'
#' @param plot Heatmap-style plot object to add heatmap legend for.
#' @param orientation A string specifying legend orientation.
#' Default value is \code{orientation = "v"}. Options are:
#' \itemize{
#' \item{\code{"v"}: }{Vertical legend orientation.}
#' \item{\code{"h"}: }{Horizontal legend orientation.}
#' }
#' @param fontsize A numeric specifying text fontsize in points.
#' Default value is \code{fontsize = 8}.
#' @param fontcolor Character value specfying text fontcolor.
#' Default value is \code{fontcolor = "dark grey"}.
#' @param scientific Logical value specifying if numeric color value labels
#' should be encoded in scientific format.
#' Default value is \code{scientific = FALSE}.
#' @param digits Numeric specifying how many digits to include after decimal
#' points of numeric color value labels. Default value is \code{digits = 0}.
#' @param ticks Logical value specifying if tick marks on the heatmap
#' colorbar should be visible. Default value is \code{ticks = FALSE}.
#' @param breaks A numeric vector specifying tick breaks.
#' Default value is \code{breaks = NULL}.
#' @param border Logical value indicating whether to add a border around
#' heatmap legend. Default value is \code{border = FALSE}.
#' @param x A numeric or unit object specifying x-location of legend.
#' @param y A numeric, unit object, or character containing a "b" combined
#' with a numeric value specifying y-location of legend.
#' The character value will place the legend y relative to the bottom of the
#' most recently plotted BentoBox plot according to the units of
#' the BentoBox page.
#' @param width A numeric or unit object specifying width of legend.
#' @param height A numeric or unit object specifying height of legend.
#' @param just Justification of heatmap legend relative to
#' its (x, y) location. If there are two values, the first value specifies
#' horizontal justification and the second value specifies vertical
#' justification. Possible string values are: \code{"left"}, \code{"right"},
#' \code{"centre"}, \code{"center"}, \code{"bottom"}, and \code{"top"}.
#' Default value is \code{just = c("left", "top")}.
#' @param default.units A string indicating the default units to use if
#' \code{x}, \code{y}, \code{width}, or \code{height} are only given as
#' numerics. Default value is \code{default.units = "inches"}.
#' @param params An optional \link[BentoBox]{bbParams} object containing
#' relevant function parameters.
#' @param ... Additional grid graphical parameters. See \link[grid]{gpar}.
#'
#' @return Returns a \code{bb_heatmapLegend} object with relevant
#' color value, placement, and \link[grid]{grob} information.
#'
#' @examples
#' ## Load Hi-C data
#' library(BentoBoxData)
#' data("IMR90_HiC_10kb")
#'
#' ## Create BentoBox page
#' bbPageCreate(width = 4, height = 3.5, default.units = "inches")
#'
#' ## Plot and place a square Hi-C plot
#' hicPlot <- bbPlotHicSquare(
#'     data = IMR90_HiC_10kb, resolution = 10000,
#'     zrange = c(0, 70),
#'     chrom = "chr21",
#'     chromstart = 28000000, chromend = 30300000,
#'     assembly = "hg19",
#'     x = 0.5, y = 0.5, width = 2.5, height = 2.5,
#'     just = c("left", "top"),
#'     default.units = "inches"
#' )
#'
#' ## Add heatmap legend
#' bbAnnoHeatmapLegend(
#'     plot = hicPlot,
#'     x = 3.2, y = 0.5, width = 0.12, height = 1.2,
#'     just = c("left", "top"), default.units = "inches"
#' )
#'
#' ## Annotate genome label
#' bbAnnoGenomeLabel(
#'     plot = hicPlot, x = 0.5, y = 3.03, scale = "Mb",
#'     just = c("left", "top")
#' )
#'
#' ## Hide page guides
#' bbPageGuideHide()
#' @export
bbAnnoHeatmapLegend <- function(plot, orientation = "v", fontsize = 8,
                                fontcolor = "dark grey", scientific = FALSE,
                                digits = 0, ticks = FALSE, breaks = NULL,
                                border = FALSE, x, y, width, height,
                                just = c("left", "top"),
                                default.units = "inches", params = NULL, ...) {

    # =========================================================================
    # FUNCTIONS
    # =========================================================================

    ## Define a function that catches errors for bbAnnoHeatmapLegend
    errorcheck_bbAnnoHeatmapLegend <- function(bb_heatmapLegend, orientation) {

        ## checking min_val and max val
        if (bb_heatmapLegend$min_val >
            bb_heatmapLegend$max_val) {
            warning("/'min_val/' is larger than /'max_val/'. ",
                    "Legend labels may be incorrect.", call. = FALSE)
        }

        ## check proper orientation
        if (!orientation %in% c("v", "h")) {
            stop("Invalid /'orientation/' parameter. Options are 'v' or 'h'.",
                call. = FALSE
            )
        }
    }

    # =========================================================================
    # PARSE PARAMETERS
    # =========================================================================

    bb_heatmapLegendInternal <- parseParams(
        params = params,
        defaultArgs = formals(eval(match.call()[[1]])),
        declaredArgs = lapply(match.call()[-1], eval.parent, n = 2),
        class = "bb_heatmapLegendInternal"
    )

    ## Set gp
    bb_heatmapLegendInternal$gp <-
        gpar(fontsize = bb_heatmapLegendInternal$fontsize)
    bb_heatmapLegendInternal$gp <- setGP(
        gpList = bb_heatmapLegendInternal$gp,
        params = bb_heatmapLegendInternal, ...
    )
    if ("col" %in% names(bb_heatmapLegendInternal$gp)) {
        bb_heatmapLegendInternal$gp$linecol <- bb_heatmapLegendInternal$gp$col
    } else {
        bb_heatmapLegendInternal$gp$linecol <- "dark grey"
    }
    bb_heatmapLegendInternal$gp$col <- bb_heatmapLegendInternal$fontcolor

    ## Justification
    bb_heatmapLegendInternal$just <- 
        bb_justConversion(just = bb_heatmapLegendInternal$just)
    
    # =========================================================================
    # INITIAL ERRORS
    # =========================================================================

    if (is.null(bb_heatmapLegendInternal$plot)) {
        stop("argument \"plot\" is missing, with no default.", call. = FALSE)
    }

    if (is.null(bb_heatmapLegendInternal$plot$color_palette)) {
        stop("Cannot add heatmap legend to an input plot ",
            "that does not have a color palette.", call. = FALSE)
    }

    if (is.null(bb_heatmapLegendInternal$plot$zrange)) {
        stop("Cannot add heatmap legend to an input plot ",
            "that does not have a zrange.", call. = FALSE)
    }

    # =========================================================================
    # INITIALIZE OBJECT
    # =========================================================================

    bb_heatmapLegend <- structure(list(
        color_palette = bb_heatmapLegendInternal$plot$color_palette,
        min_val = bb_heatmapLegendInternal$plot$zrange[1],
        max_val = bb_heatmapLegendInternal$plot$zrange[2],
        x = bb_heatmapLegendInternal$x,
        y = bb_heatmapLegendInternal$y,
        width = bb_heatmapLegendInternal$width,
        height = bb_heatmapLegendInternal$height,
        just = bb_heatmapLegendInternal$just,
        grobs = NULL
    ), class = "bb_heatmapLegend")

    # =========================================================================
    # CALL ERRORS
    # =========================================================================

    check_bbpage(error = "Must have a BentoBox page with a plot before
                adding a heatmap legend.")
    errorcheck_bbAnnoHeatmapLegend(
        bb_heatmapLegend = bb_heatmapLegend,
        orientation = bb_heatmapLegendInternal$orientation
    )
    if (is.null(bb_heatmapLegend$x)) {
        stop("argument \"x\" is missing, with no default.", call. = FALSE)
    }
    if (is.null(bb_heatmapLegend$y)) {
        stop("argument \"y\" is missing, with no default.", call. = FALSE)
    }
    if (is.null(bb_heatmapLegend$width)) {
        stop("argument \"width\" is missing, with no default.", call. = FALSE)
    }
    if (is.null(bb_heatmapLegend$height)) {
        stop("argument \"height\" is missing, with no default.",
            call. = FALSE
        )
    }

    # =========================================================================
    # PARSE UNITS
    # =========================================================================

    bb_heatmapLegend <- defaultUnits(
        object = bb_heatmapLegend,
        default.units = bb_heatmapLegendInternal$default.units
    )

    # =========================================================================
    # VIEWPORTS
    # =========================================================================
    ## Convert coordinates into same units as page
    page_coords <- convert_page(object = bb_heatmapLegend)

    ## Make viewport name
    currentViewports <- current_viewports()
    vp_name <- paste0(
        "bb_heatmapLegend",
        length(grep(
            pattern = "bb_heatmapLegend",
            x = currentViewports
        )) + 1
    )

    ## Make viewport
    vp <- viewport(
        height = page_coords$height, width = page_coords$width,
        x = page_coords$x, y = page_coords$y,
        just = bb_heatmapLegend$just, name = vp_name
    )

    pushViewport(vp)

    # =========================================================================
    # SCALE COLORS
    # =========================================================================

    ## Linear scaling
    minVal <- bb_heatmapLegend$min_val
    maxVal <- bb_heatmapLegend$max_val

    ## Log scaling
    if (!is.null(bb_heatmapLegendInternal$plot$colorTrans)) {
        if (grepl("log", bb_heatmapLegendInternal$plot$colorTrans) == TRUE) {
            logBase <- utils::type.convert(gsub(
                "log", "",
                bb_heatmapLegendInternal$plot$colorTrans
            ), as.is = TRUE)
            if (is.na(logBase)) {
                logBase <- exp(1)
            }

            minVal <- log(bb_heatmapLegend$min_val, base = logBase)
            maxVal <- log(bb_heatmapLegend$max_val, base = logBase)
        }
    }

    color_scale <- bbMapColors(
        vector = seq(minVal, maxVal, length.out = 100),
        palette = bb_heatmapLegend$color_palette
    )

    # =========================================================================
    # TICK BREAKS
    # ==========================================================================

    if (bb_heatmapLegendInternal$ticks == TRUE) {
        if (!is.null(bb_heatmapLegendInternal$breaks)) {
            breaks <- bb_heatmapLegendInternal$breaks
            breaks <- breaks[which(breaks >= bb_heatmapLegend$min_val &
                breaks <= bb_heatmapLegend$max_val)]
        } else {
            breaks <- pretty(seq(minVal, maxVal, length.out = 100))
            if (!is.null(bb_heatmapLegendInternal$plot$colorTrans)) {
                if (grepl(
                    "log",
                    bb_heatmapLegendInternal$plot$colorTrans
                ) == TRUE) {
                    breaks <- pretty(seq(minVal, maxVal, length.out = 100), 20)
                    breaks <- breaks[which(breaks > minVal & breaks < maxVal)]
                    breaks <- breaks[seq((length(breaks) - 4), length(breaks))]
                    breaks <- logBase^breaks
                }
            }
        }

        bb_heatmapLegend$ticks <- breaks
    }


    # =========================================================================
    # INITIALIZE GTREE
    # =========================================================================

    assign("heatmapLegend_grobs", gTree(vp = vp), envir = bbEnv)

    # =========================================================================
    # VERTICAL ORIENTATION
    # =========================================================================
    if (bb_heatmapLegendInternal$orientation == "v") {
        digitLab <- textGrob(
            label = 0, x = 0.5, y = 0,
            just = c("center", "bottom"),
            default.units = "npc",
            gp = bb_heatmapLegendInternal$gp
        )
        lowLab <- textGrob(
            label = format(bb_heatmapLegend$min_val,
                scientific = bb_heatmapLegendInternal$scientific,
                digits = bb_heatmapLegendInternal$digits
            ),
            x = 0.5, y = 0, just = c("center", "bottom"),
            default.units = "npc",
            gp = bb_heatmapLegendInternal$gp
        )
        highLab <- textGrob(
            label = format(bb_heatmapLegend$max_val,
                scientific = bb_heatmapLegendInternal$scientific,
                digits = bb_heatmapLegendInternal$digits
            ),
            x = 0.5, y = 1, just = c("center", "top"),
            default.units = "npc",
            gp = bb_heatmapLegendInternal$gp
        )

        lH <- convertHeight(
            x = grobHeight(lowLab),
            unitTo = "npc", valueOnly = TRUE
        )
        hH <- convertHeight(
            x = grobHeight(highLab),
            unitTo = "npc", valueOnly = TRUE
        )
        dH <- convertHeight(
            x = grobHeight(digitLab),
            unitTo = "npc", valueOnly = TRUE
        )

        new_height <- 1 - (lH + hH + dH)
        yMax <- 1 - (hH + (0.5 * dH))
        color_scale <- rasterGrob(rev(color_scale),
            width = page_coords$width,
            height = unit(new_height, "npc"),
            y = unit(yMax, "npc"), x = unit(0.5, "npc"), just = "top"
        )
        if (bb_heatmapLegendInternal$ticks == TRUE) {
            tickVP <- viewport(
                x = unit(0.5, "npc"), y = unit(yMax, "npc"),
                width = page_coords$width,
                height = unit(new_height, "npc"),
                just = "top",
                yscale = c(
                    bb_heatmapLegend$min_val,
                    bb_heatmapLegend$max_val
                ),
                name = paste0(vp_name, "_ticks")
            )
            leftIDs <- seq(1, length(breaks))
            rightIDs <- seq(
                (length(breaks) + 1),
                (length(breaks) + length(breaks))
            )
            tickGrobs <- polylineGrob(
                x = unit(c(
                    rep(c(0, 0.15), length(breaks)),
                    (rep(c(0.85, 1), length(breaks)))
                ), "npc"),
                y = c(
                    unlist(lapply(breaks, rep, 2)),
                    unlist(lapply(breaks, rep, 2))
                ),
                id = c(
                    unlist(lapply(leftIDs, rep, 2)),
                    unlist(lapply(rightIDs, rep, 2))
                ),
                default.units = "native",
                gp = gpar(col = bb_heatmapLegendInternal$gp$linecol),
                vp = tickVP
            )
        }

        if (bb_heatmapLegendInternal$border == TRUE) {
            bb_heatmapLegendInternal$gp$fill <- NA
            bb_heatmapLegendInternal$gp$col <-
                bb_heatmapLegendInternal$gp$linecol
            borderGrob <- rectGrob(
                y = unit(1 - (hH + (0.5 * dH)), "npc"),
                just = "top",
                width = page_coords$width,
                height = unit(new_height, "npc"),
                gp = bb_heatmapLegendInternal$gp
            )
        }
    }

    # =========================================================================
    # HORIZONTAL ORIENTATION
    # =========================================================================
    if (bb_heatmapLegendInternal$orientation == "h") {
        digitLab <- textGrob(
            label = 0, x = 0, y = 0.5,
            just = c("left", "center"), default.units = "npc",
            gp = bb_heatmapLegendInternal$gp
        )
        lowLab <- textGrob(
            label = format(bb_heatmapLegend$min_val,
                scientific = bb_heatmapLegendInternal$scientific,
                digits = bb_heatmapLegendInternal$digits
            ),
            x = 0, y = 0.5, just = c("left", "center"),
            default.units = "npc",
            gp = bb_heatmapLegendInternal$gp
        )
        highLab <- textGrob(
            label = format(bb_heatmapLegend$max_val,
                scientific = bb_heatmapLegendInternal$scientific,
                digits = bb_heatmapLegendInternal$digits
            ),
            x = 1, y = 0.5, just = c("right", "center"),
            default.units = "npc",
            gp = bb_heatmapLegendInternal$gp
        )

        lW <- convertWidth(
            x = grobWidth(lowLab), unitTo = "npc",
            valueOnly = TRUE
        )
        hW <- convertWidth(
            x = grobWidth(highLab), unitTo = "npc",
            valueOnly = TRUE
        )
        dW <- convertWidth(
            x = grobWidth(digitLab), unitTo = "npc",
            valueOnly = TRUE
        )

        new_width <- 1 - (hW + lW + dW)
        xMin <- lW + (0.5 * dW)
        color_scale <- rasterGrob(matrix(
            data = color_scale,
            nrow = 1,
            ncol = length(color_scale)
        ),
        width = unit(new_width, "npc"),
        height = page_coords$height,
        x = unit(xMin, "npc"), just = "left"
        )

        if (bb_heatmapLegendInternal$ticks == TRUE) {
            tickVP <- viewport(
                x = unit(xMin, "npc"), y = unit(0.5, "npc"),
                width = unit(new_width, "npc"),
                height = page_coords$height,
                just = "left",
                xscale = c(
                    bb_heatmapLegend$min_val,
                    bb_heatmapLegend$max_val
                ),
                name = paste0(vp_name, "_ticks")
            )
            bottomIDs <- seq(1, length(breaks))
            topIDs <- seq(
                (length(breaks) + 1),
                (length(breaks) + length(breaks))
            )
            tickGrobs <- polylineGrob(
                x = c(
                    unlist(lapply(breaks, rep, 2)),
                    unlist(lapply(breaks, rep, 2))
                ),
                y = unit(c(
                    rep(c(0, 0.15), length(breaks)),
                    rep(c(0.85, 1), length(breaks))
                ), "npc"),
                id = c(
                    unlist(lapply(bottomIDs, rep, 2)),
                    unlist(lapply(topIDs, rep, 2))
                ),
                default.units = "native",
                gp = gpar(col = bb_heatmapLegendInternal$gp$linecol),
                vp = tickVP
            )
        }

        if (bb_heatmapLegendInternal$border == TRUE) {
            bb_heatmapLegendInternal$gp$fill <- NA
            bb_heatmapLegendInternal$gp$col <-
                bb_heatmapLegendInternal$gp$linecol
            borderGrob <- rectGrob(
                x = unit(lW + (0.5 * dW), "npc"),
                just = "left",
                width = unit(new_width, "npc"),
                height = page_coords$height,
                gp = bb_heatmapLegendInternal$gp
            )
        }
    }

    ## Go back to root viewport
    upViewport()

    # =========================================================================
    # ADD GROBS TO GTREE AND ASSIGN TO OBJECT
    # =========================================================================

    ## Add grobs to gTree
    assign("heatmapLegend_grobs",
        setChildren(get("heatmapLegend_grobs", envir = bbEnv),
            children = gList(lowLab, highLab, color_scale)
        ),
        envir = bbEnv
    )
    if (bb_heatmapLegendInternal$border == TRUE) {
        assign("heatmapLegend_grobs",
            addGrob(
                gTree = get("heatmapLegend_grobs", envir = bbEnv),
                child = borderGrob
            ),
            envir = bbEnv
        )
    }

    if (bb_heatmapLegendInternal$ticks == TRUE) {
        assign("heatmapLegend_grobs",
            addGrob(
                gTree = get("heatmapLegend_grobs", envir = bbEnv),
                child = tickGrobs
            ),
            envir = bbEnv
        )
    }

    ## Add grobs to object
    bb_heatmapLegend$grobs <- get("heatmapLegend_grobs", envir = bbEnv)
    grid.draw(bb_heatmapLegend$grobs)

    # =========================================================================
    # RETURN OBJECT
    # =========================================================================

    message("bb_heatmapLegend[", vp_name, "]")
    invisible(bb_heatmapLegend)
}
