#The "CitationInput.R" script is to read in tab-delimited text files containing citations for the cited articles and generate a table to relate AIDs and CIDS and store citing article data 

#Read collected CitedAs, Locatable, and AID data for Citing Articles from spreadsheet
data_path <- paste(getwd(),"/ProcessedData/SCICONF_Copy.csv", sep="" )
data <- read.csv(data_path, row.names= NULL, fill = TRUE, header = FALSE, stringsAsFactors = FALSE)

#function to generate CIDs
CreateCID <- function(data, id = 'C') {
  CID <- seq(nrow(data)) #generate sequence with length of data
  CID <- paste(id, formatC(CID, width=3, flag="0"), sep="") #append number to 'C'
  new_col_names <- c("AID", "CitedAs", "Locatable")
  data <- cbind(data$V3, data$V1, data$V2)
  colnames(data) <- new_col_names 
  data <- cbind(CID, data) #, article_data[!emptyColumns])
}

#function to import data, correct the mistake in column header (extra row.names for the first column). 
DataIn <- function(file_name) {
  temp_data <- NULL
  temp_data <- read.delim(file_name, sep="\t", header = TRUE, row.names = NULL, fill = TRUE, na.strings = c("", " "), stringsAsFactors = FALSE, fileEncoding = "UCS-2LE")
  colnames(temp_data) <- c(colnames(temp_data)[-1], "temp")
  temp_data <- temp_data[ , 1:(ncol(temp_data)-1)]
  return(temp_data)
}

#input citation files 
ReadFiles <- function(data){
  final_data <- NULL
  for(i in seq(nrow(data))) {
    file_name <- paste(getwd(),"/Data/CitingArticles/", data[i, 1], ".txt", sep="" )
    if(is.na(data[i,2]) && is.na(data[i,3]) && is.na(data[i,4])){
      temp_data <- NA
      print("Missing file")
      print(file_name)
      
    } else {
      temp_data <- DataIn(file_name) 
    }
    
    final_data <- rbind(final_data, temp_data)
  }
  print(nrow(final_data))
  write.csv(final_data, "ProcessedData/WOS_SciConf_CitingArticlesTEST.csv")
  final_data <- cbind(data, final_data)
  print("Files read")
  return(final_data)
} 

data <- CreateCID(data)
data <- ReadFiles(data)

#remove columns with all NA values from WOS_SciConf as the main dataset for further processing
data <- data[ , ! apply(data, 2, function(x) all(is.na(x)))]

#write table to file
write.csv(data, "ProcessedData/WOS_SciConf_CitingArticles.csv", row.names = FALSE)

