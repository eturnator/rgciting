dataSetA <- read.delim("data/WOS_SciConf_ResearchGate_20180531.txt", sep="\t", header = TRUE, row.names = NULL, fill = TRUE)
dataSetB <- read.delim("data/WOS_SciConf_Research_Gate_20180531.txt", sep="\t", header = TRUE, row.names = NULL, fill = TRUE)
dataSetC <- read.delim("data/WOS_SciSocSci_ResearchGate_20180531.txt", sep="\t", header = TRUE, row.names = NULL, fill = TRUE)
dataSetD <- read.delim("data/WOS_SciSocSci_Research_Gate_20180531.txt", sep="\t", header = TRUE, row.names = NULL, fill = TRUE)

#function to remove empty columns
cleanColumn <- function(data){
  emptyColumns <- sapply(data, function (x) all(is.na(x)))
  data <- data[!emptyColumns]
}

#function to generate and append AID
createAID <- function(data, id) {
  AID <- seq(nrow(data))
  AID <- paste(id, formatC(AID, width=3, flag="0"), sep="")
  data <- cbind(data, AID)
}

dataSetA <- cleanColumn(dataSetA)
dataSetA <- createAID(dataSetA, 'A')
