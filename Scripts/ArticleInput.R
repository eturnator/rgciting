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

#function to duplicate articles with more than 1 cited work generate AID
CleanColumn <- function(data, id){
  #generate AID
  AID <- paste(id, formatC(seq(nrow(data)), width=3, flag="0"), sep="")
  data <- cbind(AID, data)
  
  #duplicate articles with more than 1 times cited
  for(i in 1:nrow(data)) {
    for(j in 0:data[i,"TC"]){
      if(j > 1){
        data <- rbind(data, data[i,])
      }
    }
  }
  
  #sort table
  data <- data[order(data$"AID"),]
 
  #append new columns
  new_col_names <- c("CID", "CitedAs", "Locatable", "CitationDetail_RG", "FulltextAvailable", "DOI_RG", "AuthorUpload",
                     "SourcePubs", "SourcePreprint", "SourceRepo", "SourceWebsite", "SourceURl",
                     "SourceDOI","ItemClass", "Copyrighted", "Licensed", "HCISI")
  new_cols <- matrix(nrow=nrow(data), ncol=length(new_col_names))
  colnames(new_cols) <- new_col_names 
  AID <- data$"AID"
  data <- cbind(AID, new_cols, data[,-1])
}


#run cleanColumn function over data sets
WOS_SciConf <- CleanColumn(WOS_SciConf, 'P')
WOS_SciSocSci <- CleanColumn(WOS_SciSocSci, 'E')

#write altered data to csv files
write.csv(WOS_SciConf, "ProcessedData/WOS_SciConf_20180531.csv")
write.csv(WOS_SciSocSci, "ProcessedData/WOS_SciSocSci_20180531.csv")
