
dataSetA <- read.delim("data/WOS_SciConf_ResearchGate_20180531.txt", sep="\t", header = TRUE, row.names = NULL, fill = TRUE)
dataSetB <- read.delim("data/WOS_SciConf_Research_Gate_20180531.txt", sep="\t", header = TRUE, row.names = NULL, fill = TRUE)
dataSetC <- read.delim("data/WOS_SciSocSci_ResearchGate_20180531.txt", sep="\t", header = TRUE, row.names = NULL, fill = TRUE)
dataSetD <- read.delim("data/WOS_SciSocSci_Research_Gate_20180531.txt", sep="\t", header = TRUE, row.names = NULL, fill = TRUE)

dataSets <- list(dataSetA, dataSetB, dataSetC, dataSetD)
rownames(dataSetA) <- NULL
cleanColumn <- function(data){
  emptyColumns <- sapply(data, function (x) all(is.na(x)))
  data <- data[!emptyColumns]
}


createAID <- function(data, id) {
  numElements <- nrow(dataSetA)
  names <- str(0:(numElements - 1))
 # names <- lapply(names, function(x) x)
}

createAID(dataSetA, 'C')

#for (i in range(0, length(dataSets))){
#  dataSets[i] <- cleanColumn(dataSets[i])
#}
print(dataSetA)
