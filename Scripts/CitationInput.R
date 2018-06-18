#input citation files 
citationSetA <- read.delim("data/WOS_SciConf_ResearchGate_20180617_Citing.txt", sep="\t", header = TRUE, row.names = NULL, fill = TRUE, fileEncoding =  'UCS-2LE')

createCID <- function(data, id = 'R') {
  CID <- seq(nrow(data))
  CID <- paste(id, formatC(CID, width=3, flag="0"), sep="")
  emptyColumns <- sapply(data, function (x) all(is.na(x)))
  AID <- NA
  data <- cbind(CID, AID, data[!emptyColumns])
}

citationSetA <- createCID(citationSetA)

write.csv(citationSetA, "Cleaned_Data/WOS_SciConf_ResearchGate_20180617_Citing.csv")
