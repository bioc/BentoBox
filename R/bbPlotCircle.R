#' Plot a circle within a BentoBox layout
#' 
#' @usage bbPlotCircle(
#'     x,
#'     y,
#'     r,
#'     default.units = "inches",
#'     linecolor = "black",
#'     lwd = 1,
#'     lty = 1,
#'     fill = NA,
#'     alpha = 1,
#'     params = NULL,
#'     ...
#' )
#'
#' @param x A numeric vector or unit object specifying circle
#' x-locations relative to center.
#' @param y A numeric vector, unit object, or a character vector
#' of values containing a "b" combined with a numeric value
#' specifying circle y-locations relative to center.
#' The character vector will place circle y-locations relative to
#' the bottom of the most recently plotted BentoBox plot according
#' to the units of the BentoBox page.
#' @param r A numeric vector or unit object specifying radii.
#' @param default.units A string indicating the default units to use
#' if \code{r}, \code{x}, or \code{y} are only given as numerics or
#' numeric vectors. Default value is \code{default.units = "inches"}.
#' @param linecolor A character value specifying circle line color.
#' Default value is \code{linecolor = "black"}.
#' @param lwd A numeric specifying circle line width.
#' Default value is \code{lwd = 1}.
#' @param lty A numeric specifying circle line type.
#' Default value is \code{lty = 1}.
#' @param fill A character value specifying circle fill color.
#' Default value is \code{fill = NA}.
#' @param alpha Numeric value specifying color transparency.
#' Default value is \code{alpha = 1}.
#' @param params An optional \link[BentoBox]{bbParams} object
#' containing relevant function parameters.
#' @param ... Additional grid graphical parameters. See \link[grid]{gpar}.
#'
#' @return Returns a \code{bb_circle} object containing
#' relevant placement and \link[grid]{grob} information.
#'
#' @examples
#' ## Create a BentoBox page
#' bbPageCreate(width = 2, height = 2, default.units = "inches")
#'
#' ## Plot two circles, one at a time
#' bbPlotCircle(
#'     x = 0.6, y = 0.5, r = 0.1, fill = "black",
#'     default.units = "inches"
#' )
#' bbPlotCircle(
#'     x = 1.4, y = 0.5, r = 0.1, fill = "black",
#'     default.units = "inches"
#' )
#'
#' ## Plot a vector of circles
#' xVals <- 1 + (0.5 * cos(seq(0, pi, pi / 8)))
#' yVals <- 1 + (0.5 * sin(seq(0, pi, pi / 8)))
#' bbPlotCircle(x = xVals, y = yVals, r = 0.05, default.units = "inches")
#'
#' ## Hide page guides
#' bbPageGuideHide()
#' @seealso \link[grid]{grid.circle}
#'
#' @export
bbPlotCircle <- function(x, y, r, default.units = "inches",
                        linecolor = "black", lwd = 1, lty = 1,
                        fill = NA, alpha = 1, params = NULL, ...) {


    # =========================================================================
    # PARSE PARAMETERS
    # =========================================================================

    bb_circleInternal <- parseParams(
        params = params,
        defaultArgs = formals(eval(match.call()[[1]])),
        declaredArgs = lapply(match.call()[-1], eval.parent, n = 2),
        class = "bb_circleInternal"
    )

    ## Set gp
    bb_circleInternal$gp <- gpar(
        col = bb_circleInternal$linecolor,
        fill = bb_circleInternal$fill,
        lwd = bb_circleInternal$lwd,
        lty = bb_circleInternal$lty,
        alpha = bb_circleInternal$alpha
    )
    bb_circleInternal$gp <- setGP(
        gpList = bb_circleInternal$gp,
        params = bb_circleInternal, ...
    )


    # =========================================================================
    # INITIALIZE OBJECT
    # =========================================================================

    bb_circle <- structure(list(
        x = bb_circleInternal$x,
        y = bb_circleInternal$y,
        r = bb_circleInternal$r, grobs = NULL,
        gp = bb_circleInternal$gp
    ), class = "bb_circle")

    # =========================================================================
    # CATCH ERRORS
    # =========================================================================

    check_bbpage(error = "Cannot plot circle without a BentoBox page.")
    if (is.null(bb_circle$x)) {
        stop("argument \"x\" is missing, with no default.",
            call. = FALSE
        )
    }
    if (is.null(bb_circle$y)) {
        stop("argument \"y\" is missing, with no default.",
            call. = FALSE
        )
    }
    if (is.null(bb_circle$r)) {
        stop("argument \"r\" is missing, with no default.",
            call. = FALSE
        )
    }
    
    bb_checkColorby(fill = bb_circle$gp$fill,
                colorby = FALSE)

    # =========================================================================
    # DEFINE PARAMETERS
    # =========================================================================

    ## Get page_height and its units from bbEnv through bb_makepage
    page_height <- get("page_height", envir = bbEnv)
    page_units <- get("page_units", envir = bbEnv)
    
    bb_circle$x <- misc_defaultUnits(value = bb_circle$x,
                                    name = "x",
                                    default.units = 
                                        bb_circleInternal$default.units)
    
    bb_circle$y <- misc_defaultUnits(value = bb_circle$y,
                                    name = "y",
                                    default.units = 
                                        bb_circleInternal$default.units)
    
    bb_circle$r <- misc_defaultUnits(value = bb_circle$r,
                                    name = "r",
                                    default.units = 
                                        bb_circleInternal$default.units)

    ## Convert coordinates to page_units
    new_x <- convertX(bb_circle$x, unitTo = page_units, valueOnly = TRUE)
    new_y <- convertY(bb_circle$y, unitTo = page_units, valueOnly = TRUE)
    new_r <- convertUnit(bb_circle$r, unitTo = page_units, valueOnly = TRUE)

    # =========================================================================
    # MAKE GROB
    # =========================================================================
    name <- paste0(
        "bb_circle",
        length(grep(
            pattern = "bb_circle",
            x = grid.ls(
                print = FALSE,
                recursive = FALSE
            )
        )) + 1
    )
    circle <- grid.circle(
        x = unit(new_x, page_units),
        y = unit(page_height - new_y, page_units),
        r = unit(new_r, page_units),
        gp = bb_circle$gp,
        name = name
    )

    # =========================================================================
    # ADD GROB TO OBJECT
    # =========================================================================

    bb_circle$grobs <- circle

    # =========================================================================
    # RETURN OBJECT
    # =========================================================================

    message("bb_circle[", circle$name, "]")
    invisible(bb_circle)
}
