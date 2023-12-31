## Plot a base R plot in a BentoBox layout
#
# @param plot Plot formula of base R plotting functions.
# @param x A numeric or unit object specifying plot x-location.
# @param y A numeric, unit object, or character containing a "b"
# combined with a numeric value specifying plot y-location.
# The character value will
# place the plot y relative to the bottom of the most recently plotted
# BentoBox plot according to the units of the BentoBox page.
# @param width A numeric or unit object specifying plot width.
# @param height A numeric or unit object specifying plot height.
# @param just Justification of base plot relative to its (x, y) location.
# If there are two values, the first value specifies horizontal
# justification and the second value specifies vertical justification.
# Possible string values are: \code{"left"}, \code{"right"},
# \code{"centre"}, \code{"center"}, \code{"bottom"}, and \code{"top"}.
# Default value is \code{just = c("left", "top")}.
# @param default.units A string indicating the default units to use
# if \code{x}, \code{y}, \code{width}, or \code{height} are only given
# as numerics. Default value is \code{default.units = "inches"}.
# @param bg Character value indicating background color.
# Default value is \code{bg = NA}.
# @param params An optional \link[BentoBox]{bbParams} object
# containing relevant function parameters.
#
# @return Returns a \code{bb_base} object containing
# relevant placement and \link[grid]{grob} information.
#
# @examples
# ## Define base R plot
# p <- ~ plot(1:10) + abline(v = 2)
#
# ## Create BentoBox page
# bbPageCreate(width = 5, height = 4, default.units = "inches")
#
# ## Place base R plot in BentoBox page
# bbPlotBase(
#     plot = p,
#     x = 0.5, y = 0.5, width = 4, height = 3,
#     just = c("left", "top"), default.units = "inches"
# )
#
# ## Add title
# bbPlotText(
#     label = "Base R Plot", fontsize = 14, fontface = "bold",
#     x = 2.75, y = 0.5
# )
#
# ## Remove BentoBox page guides
# bbPageGuideHide()
bbPlotBase <- function(plot, x, y, width, height, just = c("left", "top"),
                        default.units = "inches", bg = NA, params = NULL) {

    # =========================================================================
    # PARSE PARAMETERS
    # =========================================================================

    bb_baseInternal <- parseParams(
        params = params,
        defaultArgs = formals(eval(match.call()[[1]])),
        declaredArgs = lapply(match.call()[-1], eval.parent, n = 2),
        class = "bb_baseInternal"
    )
    
    ## Justification
    bb_baseInternal$just <- bb_justConversion(just = bb_baseInternal$just)

    # =========================================================================
    # INITIALIZE PLOT OBJECT
    # =========================================================================

    bb_base <- structure(list(
        x = bb_baseInternal$x, y = bb_baseInternal$y,
        width = bb_baseInternal$width,
        height = bb_baseInternal$height,
        just = bb_baseInternal$just, grobs = NULL
    ),
    class = "bb_base"
    )

    # =========================================================================
    # CALL ERRORS
    # =========================================================================

    if (is.null(bb_baseInternal$plot)) {
        stop("argument \"plot\" is missing, with no default.", call. = FALSE)
    }
    if (is.null(bb_baseInternal$x)) {
        stop("argument \"x\" is missing, with no default.", call. = FALSE)
    }
    if (is.null(bb_baseInternal$y)) {
        stop("argument \"y\" is missing, with no default.", call. = FALSE)
    }
    if (is.null(bb_baseInternal$width)) {
        stop("argument \"width\" is missing, with no default.", call. = FALSE)
    }
    if (is.null(bb_baseInternal$height)) {
        stop("argument \"height\" is missing, with no default.",
            call. = FALSE
        )
    }

    check_bbpage(error = "Must have a BentoBox page before
                adding a base R plot.")

    # =========================================================================
    # PARSE UNITS
    # =========================================================================

    bb_base <- defaultUnits(
        object = bb_base,
        default.units = bb_baseInternal$default.units
    )

    # =========================================================================
    # VIEWPORTS
    # =========================================================================

    ## Convert coordinates into same units as page
    page_coords <- convert_page(object = bb_base)

    ## Name viewport
    currentViewports <- current_viewports()
    vp_name <- paste0(
        "bb_base",
        length(grep(
            pattern = "bb_base",
            x = currentViewports
        )) + 1
    )
    add_bbViewport(vp_name)

    ## Make viewport
    vp <- viewport(
        height = page_coords$height, width = page_coords$width,
        x = page_coords$x, y = page_coords$y,
        just = bb_baseInternal$just, name = vp_name
    )

    # =========================================================================
    # CONVERT PLOT TO A GROB
    # =========================================================================

    gtree <- ggplotify::base2grob(bb_baseInternal$plot)

    # =========================================================================
    # ASSIGN VIEWPORT TO GTREE
    # =========================================================================

    gtree$vp <- vp

    # =========================================================================
    # BACKGROUND AND BORDER
    # =========================================================================

    plotChildren <- gtree$childrenOrder
    backgroundGrob <- rectGrob(gp = gpar(
        fill = bb_baseInternal$bg,
        col = NA
    ), name = "background")
    gtree <- addGrob(gTree = gtree, child = backgroundGrob)
    gtree$childrenOrder <- c("background", plotChildren)

    # =========================================================================
    # DRAW GTREE
    # =========================================================================

    grid.draw(gtree)

    # =========================================================================
    # ADD GTREE TO OBJECT
    # =========================================================================

    bb_base$grobs <- gtree

    # =========================================================================
    # RETURN OBJECT
    # =========================================================================

    message("bb_base[", vp_name, "]")
    invisible(bb_base)
}
