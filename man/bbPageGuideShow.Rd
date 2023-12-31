% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bbPageGuideShow.R
\name{bbPageGuideShow}
\alias{bbPageGuideShow}
\title{Reshow guides drawn with \code{bbPageCreate},
\code{bbPageGuideHorizontal}, and \code{bbPageGuideVertical}}
\usage{
bbPageGuideShow()
}
\value{
None.
}
\description{
Reshow guides drawn with \code{bbPageCreate},
\code{bbPageGuideHorizontal}, and \code{bbPageGuideVertical}
}
\examples{
## Load Hi-C data
library(BentoBoxData)
data("IMR90_HiC_10kb")

## Create a page
bbPageCreate(width = 3, height = 3, default.units = "inches")

## Add a page guide
bbPageGuideHorizontal(y = 0.5, default.units = "inches")

## Plot and place Hi-C plot
hicPlot <- bbPlotHicSquare(
    data = IMR90_HiC_10kb, resolution = 10000,
    zrange = c(0, 70),
    chrom = "chr21",
    chromstart = 28000000, chromend = 30300000,
    x = 0.5, y = 0.5, width = 2, height = 2,
    just = c("left", "top"),
    default.units = "inches"
)

## Hide page guides
bbPageGuideHide()

## Re-show page guides
bbPageGuideShow()

## Annotate genome label
bbAnnoGenomeLabel(
    plot = hicPlot, scale = "Mb", axis = "x",
    x = 0.5, y = 2.53, just = c("left", "top")
)
}
\seealso{
\link[BentoBox]{bbPageCreate},
\link[BentoBox]{bbPageGuideHorizontal},
\link[BentoBox]{bbPageGuideVertical}
}
