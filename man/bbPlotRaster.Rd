% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bbPlotRaster.R
\name{bbPlotRaster}
\alias{bbPlotRaster}
\title{Plot a raster object within a BentoBox layout}
\usage{
bbPlotRaster(
    image,
    x,
    y,
    width,
    height,
    just = "center",
    default.units = "inches",
    interpolate = TRUE,
    params = NULL,
    ...
)
}
\arguments{
\item{image}{Any R object that can be coerced to a raster object.}

\item{x}{A numeric vector or unit object specifying raster x-locations.}

\item{y}{A numeric vector, unit object, or a character vector of values
containing a "b" combined with a numeric value specifying
raster y-locations.
The character vector will place raster y relative to the bottom
of the most recently plotted BentoBox plot according to the units
of the BentoBox page.}

\item{width}{A numeric vector or unit object specifying raster widths.}

\item{height}{A numeric vector or unit object specifying raster heights.}

\item{just}{Justification of text relative to its (x, y) location.
If there are two values, the first value specifies horizontal
justification and the second value specifies vertical justification.
Possible string values are: \code{"left"}, \code{"right"},
\code{"centre"}, \code{"center"}, \code{"bottom"}, and
\code{"top"}. Default value is \code{just = "center"}.}

\item{default.units}{A string indicating the default units
to use if \code{x}, \code{y}, \code{width}, or \code{height}
are only given as numerics or numeric vectors.
Default value is \code{default.units = "inches"}.}

\item{interpolate}{A logical value indicating whether to linearly
interpolate the image. Default value is \code{interpolate = TRUE}.}

\item{params}{An optional \link[BentoBox]{bbParams} object
containing relevant function parameters.}

\item{...}{Additional grid graphical parameters. See \link[grid]{gpar}.}
}
\value{
Returns a \code{bb_raster} object containing
relevant placement and \link[grid]{grob} information.
}
\description{
Plot a raster object within a BentoBox layout
}
\examples{
library(png)

## Load images
edamaman <- readPNG(system.file("images",
    "bento-edamaman.png",
    package = "BentoBox"
))
logotype <- readPNG(system.file("images",
    "bento-logotype-singleline-black.png",
    package = "BentoBox"
))
rlogo <- readPNG(system.file("images", "Rlogo.png", package = "BentoBox"))

## Create page
bbPageCreate(width = 5, height = 6)

## Plot various images
bbPlotRaster(
    image = logotype,
    x = 2.5, y = 0.25, width = 3.25, height = 0.5, just = "top"
)

bbPlotRaster(
    image = edamaman,
    x = 2.5, y = 5.5, width = 2, height = 4, just = "bottom"
)

bbPlotRaster(
    image = rlogo,
    x = 2.5, y = 1, width = 0.5, height = 0.45,
    just = c("right", "top")
)

## Hide page guies
bbPageGuideHide()
}
\seealso{
\link[grid]{grid.raster}
}
