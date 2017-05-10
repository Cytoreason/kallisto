suppressPackageStartupMessages(require(optparse))
require(tximport)
require(dplyr)
options(stringsAsFactors =F)

# 
# dir <- "/Users/dwells/Box Sync/all-files/data-analysis-projects/berkeley-lights-bluestone"
# dir1 <- "/Users/dwells/Box Sync/all-files/data-analysis-projects/berkeley-lights-bluestone/berkeley-lights-sample_1-plate_1"
# print(list.files(dir))
# setwd(dir)

option_list = list(
  make_option(c("-i","--input"), action="store", default=NA, type='character',help="file or path to the file"),
  make_option(c("-o","--output"), action="store", default=NA, type='character',help="output path"),
  make_option(c("-r","--reference"), action="store", default=NA, type='character',help="output path")
)
opt = parse_args(OptionParser(option_list=option_list))

if(!is.na(opt$input) & !is.na(opt$output)){



  gene_table <- data.frame(read.csv('ENSG_to_Hugo.txt',sep='\t', header = 1))
  gene_table <- dplyr::select(gene_table, Transcript.stable.ID,Gene.name)

  # txi <- tximport(files, type = "salmon", tx2gene = tx2gene)

  # dat.files  <- list.files(path=dir,recursive=T,pattern='abundance.tsv' ,full.names=T)
  infile <- opt$input
  gene_table_name <- opt$reference 
  gene_table <- data.frame(read.csv(gene_table_name,sep='\t', header = 1))
  gene_table <- dplyr::select(gene_table, Transcript.stable.ID,Gene.name)
  # f<-read.csv(dat.files[[1]],sep='\t')
  f<-read.csv(infile,sep='\t')
  f$target_id <- sapply(strsplit(f$target_id, "\\."), "[", 1)
  write.table(f,file=infile, sep="\t")
  txi_data <- tximport(infile, type = "kallisto",tx2gene = gene_table)
  write.table(txi_data, file=opt$output,sep='\t', quote=F)
}

