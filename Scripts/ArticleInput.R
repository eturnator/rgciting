#The ArticleInput.R script is to import the data retrieved from the Cited Work search in Web of Science with the source title as "Research Gate" and "ResearchGate", deduplicate data and generate a data sheet for maunual coding. 



#load needed packages
require(dplyr)



#read in the four data sets
#The column heading abbreciations can be interpreted according to the WOS list here https://images.webofknowledge.com/images/help/WOS/hs_wos_fieldtags.html . A copy of it has been saved in file Data/WOSFieldTag.txt

#create function to import data, correct the mistake in column head (extra row.names for the first column). 

DataIn <- function(filename) {
  data <- read.delim(filename, sep="\t", header = TRUE, row.names = NULL, fill = TRUE, na.strings = c("", " "), stringsAsFactors = FALSE)
  colnames(data) <- c(colnames(data)[-1], "temp")
  data <- data[ , 1:(ncol(data)-1)]
  return(data)
}

dataSetA <- DataIn("data/WOS_SciConf_ResearchGate_20180531.txt")
dataSetB <- DataIn("data/WOS_SciConf_Research_Gate_20180531.txt")
dataSetC <- DataIn("data/WOS_SciSocSci_ResearchGate_20180531.txt")
dataSetD <- DataIn("data/WOS_SciSocSci_Research_Gate_20180531.txt")

# Andrea's original importing lines. -- TO BE DELETED
# dataSetA <- read.delim("data/WOS_SciConf_ResearchGate_20180617.txt", sep="\t", header = TRUE, row.names = NULL, fill = TRUE, na.strings = c("", " "))
# dataSetB <- read.delim("data/WOS_SciConf_Research_Gate_20180531.txt", sep="\t", header = TRUE, row.names = NULL, fill = TRUE)
# dataSetC <- read.delim("data/WOS_SciSocSci_ResearchGate_20180531.txt", sep="\t", header = TRUE, row.names = NULL, fill = TRUE)
# dataSetD <- read.delim("data/WOS_SciSocSci_Research_Gate_20180531.txt", sep="\t", header = TRUE, row.names = NULL, fill = TRUE)


#Combine dataSetA and dataSetB and check for duplications
WOS_SciConf <- rbind(dataSetA,dataSetB)
WOS_SciConf <- unique(WOS_SciConf)

#Combine dataSetC and dataSetD and check for duplications
WOS_SciSocSci <- rbind(dataSetC, dataSetD)
WOS_SciSocSci <- unique(WOS_SciSocSci)

#Identify the records that uniquely retrieved from Sci_SocialSci indexing
unique_SciSocSci <- setdiff(WOS_SciSocSci, WOS_SciConf)

#remove columns with all NA values from WOS_SciConf as the main dataset for further processing
WOS_SciConf <- WOS_SciConf[ , ! apply(WOS_SciConf, 2, function(x) all(is.na(x)))]

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
  Format <- NA
  Valid <- NA
  Fulltext_Available <-NA
  DOI_Available <- NA
  Link_Available <- NA
  RG_Details <- NA
  Work_Type <- NA
  emptyColumns <- sapply(data, function (x) all(is.na(x)))
  data <- cbind(AID, Format, Valid, Fulltext_Available, DOI_Available, Link_Available, RG_Details, Work_Type, data[!emptyColumns])
}

#run cleanColumn function over data sets
dataSetA <- cleanColumn(dataSetA, 'A')
dataSetB <- cleanColumn(dataSetB, 'B')
dataSetC <- cleanColumn(dataSetC, 'C')
dataSetD <- cleanColumn(dataSetD, 'D')

#write altered data to csv files
write.csv(dataSetA, "Cleaned_Data/WOS_SciConf_ResearchGate_20180617.csv")
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
