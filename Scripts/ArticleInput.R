#read in the four data sets
dataSetA <- read.delim("data/WOS_SciConf_ResearchGate_20180617.txt", sep="\t", header = TRUE, row.names = NULL, fill = TRUE)
dataSetB <- read.delim("data/WOS_SciConf_Research_Gate_20180531.txt", sep="\t", header = TRUE, row.names = NULL, fill = TRUE)
dataSetC <- read.delim("data/WOS_SciSocSci_ResearchGate_20180531.txt", sep="\t", header = TRUE, row.names = NULL, fill = TRUE)
dataSetD <- read.delim("data/WOS_SciSocSci_Research_Gate_20180531.txt", sep="\t", header = TRUE, row.names = NULL, fill = TRUE)

#code to check duplicates
#commonRows <- intersect(dataSetC$col, dataSetD$col)  
#dataSetA[commonRows,]  
#dataSetB[commonRows,]
#dataSetC[commonRows,]
#dataSetD[commonRows,]

#function to remove empty columns and generate AID
cleanColumn <- function(data, id){
  AID <- seq(nrow(data))
  AID <- paste(id, formatC(AID, width=3, flag="0"), sep="")
  emptyColumns <- sapply(data, function (x) all(is.na(x)))
  data <- cbind(data[!emptyColumns])
}

#run cleanColumn function over data sets
dataSetA <- cleanColumn(dataSetA, 'A')
dataSetB <- cleanColumn(dataSetB, 'B')
dataSetC <- cleanColumn(dataSetC, 'C')
dataSetD <- cleanColumn(dataSetD, 'D')

#write altered data to csv files
write.csv(dataSetA, "Cleaned_Data/WOS_SciConf_ResearchGate_20180531.csv")
write.csv(dataSetB, "Cleaned_Data/WOS_SciConf_Research_Gate_20180531.csv")
write.csv(dataSetC, "Cleaned_Data/WOS_SciSocSci_ResearchGate_20180531.csv")
write.csv(dataSetD, "Cleaned_Data/WOS_SciSocSci_Research_Gate_20180531.csv")


#function to generate and append AID
#createAID <- function(data, id) {
#  AID <- seq(nrow(data))
#  AID <- paste(id, formatC(AID, width=3, flag="0"), sep="")
#  data <- cbind(AID, data)
#}

#dataSetA <- createAID(dataSetA, 'A')
#datasets <- list(dataSetA, dataSetB, dataSetC, dataSetD)
#datasets <- lapply(datasets, function(x) cleanColumn(x))
