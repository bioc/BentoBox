% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bbPlotHicTriangle.R
\name{bbPlotHicTriangle}
\alias{bbPlotHicTriangle}
\title{Plot a Hi-C interaction matrix in a triangular format}
\usage{
bbPlotHicTriangle(
    data,
    resolution = "auto",
    zrange = NULL,
    norm = "KR",
    matrix = "observed",
    chrom,
    chromstart = NULL,
    chromend = NULL,
    assembly = "hg38",
    palette = colorRampPalette(brewer.pal(n = 9, "YlGnBu")),
    colorTrans = "linear",
    x = NULL,
    y = NULL,
    width = NULL,
    height = NULL,
    just = c("left", "top"),
    default.units = "inches",
    draw = TRUE,
    params = NULL,
    quiet = FALSE
)
}
\arguments{
\item{data}{Path to .hic file as a string or a 3-column
dataframe of interaction counts in sparse upper triangular format.}

\item{resolution}{A numeric specifying the width in basepairs of
each pixel. For hic files, "auto" will attempt to choose a
resolution based on the size of the region. For
dataframes, "auto" will attempt to detect the resolution
the dataframe contains.}

\item{zrange}{A numeric vector of length 2 specifying the
range of interaction scores to plot, where extreme values
will be set to the max or min.}

\item{norm}{Character value specifying hic data normalization method,
if giving .hic file. This value must be found in the .hic file.
Default value is \code{norm = "KR"}.}

\item{matrix}{Character value indicating the type of matrix to output.
Default value is \code{matrix = "observed"}. Options are:
\itemize{
\item{\code{"observed"}: }{Observed counts.}
\item{\code{"oe"}: }{Observed/expected counts.}
\item{\code{"log2oe"}: }{Log2 transformed observed/expected counts.}
}}

\item{chrom}{Chromosome of region to be plotted, as a string.}

\item{chromstart}{Integer start position on chromosome to be plotted.}

\item{chromend}{Integer end position on chromosome to be plotted.}

\item{assembly}{Default genome assembly as a string or a
\link[BentoBox]{bbAssembly} object.
Default value is \code{assembly = "hg38"}.}

\item{palette}{A function describing the color palette to use for
representing scale of interaction scores. Default value is
\code{palette =  colorRampPalette(brewer.pal(n = 9, "YlGnBu"))}.}

\item{colorTrans}{A string specifying how to scale Hi-C colors.
Options are "linear", "log", "log2", or "log10".
Default value is \code{colorTrans = "linear"}.}

\item{x}{A numeric or unit object specifying triangle Hi-C plot x-location.}

\item{y}{A numeric, unit object, or character containing a "b"
combined with a numeric value specifying triangle Hi-C plot y-location.
The character value will
place the triangle Hi-C plot y relative to the bottom of the most
recently plotted BentoBox plot according to the units of the BentoBox page.}

\item{width}{A numeric or unit object specifying the bottom
width of the Hi-C plot triangle.}

\item{height}{A numeric or unit object specifying the height of
the Hi-C plot triangle.}

\item{just}{Justification of triangle Hi-C plot relative to
its (x, y) location. If there are two values, the first value specifies
horizontal justification and the second value specifies vertical
justification.
Possible string values are: \code{"left"}, \code{"right"},
\code{"centre"}, \code{"center"}, \code{"bottom"}, and \code{"top"}.
Default value is \code{just = c("left", "top")}.}

\item{default.units}{A string indicating the default units to use if
\code{x}, \code{y}, \code{width}, or \code{height} are only given as
numerics. Default value is \code{default.units = "inches"}.}

\item{draw}{A logical value indicating whether graphics output should
be produced. Default value is \code{draw = TRUE}.}

\item{params}{An optional \link[BentoBox]{bbParams} object containing
relevant function parameters.}

\item{quiet}{A logical indicating whether or not to print messages.}
}
\value{
Returns a \code{bb_hicTriangle} object containing relevant
genomic region, Hi-C data, placement, and \link[grid]{grob} information.
}
\description{
Plot a Hi-C interaction matrix in a triangular format
}
\details{
A triangle Hi-C plot can be placed on a BentoBox coordinate page
by providing plot placement parameters:
\preformatted{
bbPlotHicTriangle(data, chrom,
                chromstart = NULL, chromend = NULL,
                x, y, width, height, just = c("left", "top"),
                default.units = "inches")
}
This function can also be used to quickly plot an unannotated triangle
Hi-C plot by ignoring plot placement parameters:
\preformatted{
bbPlotHicTriangle(data, chrom,
                chromstart = NULL, chromend = NULL)
}

If \code{height} is \eqn{<} \eqn{0.5 * sqrt(2)}, the top of the triangle
will be cropped to the given \code{height}.
}
\examples{
## Load Hi-C data
library(BentoBoxData)
data("IMR90_HiC_10kb")

## Create a page
bbPageCreate(width = 4, height = 2.5, default.units = "inches")

## Plot and place triangle Hi-C plot
hicPlot <- bbPlotHicTriangle(
    data = IMR90_HiC_10kb, resolution = 10000,
    zrange = c(0, 70),
    chrom = "chr21",
    chromstart = 28000000, chromend = 30300000,
    assembly = "hg19",
    x = 2, y = 0.5, width = 3, height = 1.5,
    just = "top", default.units = "inches"
)

## Annotate x-axis genome label
bbAnnoGenomeLabel(
    plot = hicPlot, scale = "Mb", x = 0.5, y = 2.03,
    just = c("left", "top")
)

## Annotate heatmap legend
bbAnnoHeatmapLegend(
    plot = hicPlot, x = 3.5, y = 0.5,
    width = 0.13, height = 1.2,
    just = c("right", "top")
)

## Hide page guides
bbPageGuideHide()
}
\seealso{
\link[BentoBox]{bbReadHic}
}
