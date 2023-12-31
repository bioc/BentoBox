test_that("read_rangeData", {
    library(GenomicRanges)
    library(BentoBoxData)
    ## GRanges reading
    gr <- GRanges(seqnames = "chr1", strand = c("+", "-", "+"),
                  ranges = IRanges(start = c(1,3,5), width = 3))
    values(gr) <- DataFrame(score = c(0.1, 0.5, 0.3))
    
    expectedgr <- as.data.frame(gr)
    colnames(expectedgr)[1:3] <- c("chrom", "start", "end")
    
    expect_equal(BentoBox:::read_rangeData(data = gr,
                              assembly = "hg19"),
                 expectedgr)
    
    ## Errors for invalid column types
    expectedgr$start <- as.character(expectedgr$start)
    expectedgr$end <- as.character(expectedgr$end)
    expect_error(BentoBox:::read_rangeData(data = expectedgr,
                              assembly = "hg19"))
    
})

test_that("read_pairedData", {
    ## GInteractions reading
    library(GenomicRanges)
    library(InteractionSet)
    all.regions <- GRanges("chrA", IRanges(0:9*10+1, 1:10*10))
    index.1 <- c(1,5,10)
    index.2 <- c(3,2,6)
    region.1 <- all.regions[index.1]
    region.2 <- all.regions[index.2]
    gi <- GInteractions(region.1, region.2)
    
    expectedgi <- as.data.frame(gi)[,c(1,2,3,6,7,8,4,5,9,10)]
    
    colnames(expectedgi)[1:6] <- c("chrom1", "start1", "end1",
                                   "chrom2", "start2", "end2")
    expect_equal(BentoBox:::read_pairedData(data = gi,
                                           assembly = "hg19"),
                 expectedgi)
    
    ## Errors for invalid column types
    expectedgi$start1 <- as.character(expectedgi$start1)
    expectedgi$end2 <- as.character(expectedgi$end2)
    expect_error(BentoBox:::read_pairedData(data = expectedgi,
                                            assembly = "hg19"))
    
})

test_that("checkAssemblyMatch", {
    library("TxDb.Hsapiens.UCSC.hg19.knownGene")
    ## warning for invalid matching
    tx_db <- TxDb.Hsapiens.UCSC.hg19.knownGene
    expect_warning(BentoBox:::checkAssemblyMatch(data = tx_db,
            assembly = BentoBox:::parse_bbAssembly("hg38")))
})