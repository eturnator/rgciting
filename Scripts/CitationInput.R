#The "CitationInput.R" script is to read in tab-delimited text files containing citations for the cited articles and generate a table to relate AIDs and CIDS and store citing article data 

#input citation files 
readFiles <- function(){
  dir_address <- paste(getwd(),"/Data/CitingArticles/", sep="" )
  file_list <- list.files(dir_address)
  data <- NA
  for(i in seq(1:length(file_list))){
    file_name = paste("Data/CitingArticles/", file_list[i], sep="" )
    data <- rbind(data, read.delim(file_name, sep="\t", header = TRUE, row.names = NULL, fill = TRUE, fileEncoding = "UCS-2LE"))
  }
  
  return(data[-1,]) 
}

citationSetA <- readFiles()

#function to generate CID, rows for data input, and remove empty columns
createCID <- function(data, id = 'C') {
  CID <- seq(nrow(data))
  CID <- paste(id, formatC(CID, width=3, flag="0"), sep="")
  emptyColumns <- sapply(data, function (x) all(is.na(x)))
  new_col_names <- c("AID", "CitedAs", "Locatable")
  new_cols <- matrix(nrow=nrow(data), ncol=length(new_col_names))
  colnames(new_cols) <- new_col_names 
  data <- cbind(CID, new_cols, data[!emptyColumns])
}

#run createCID function
citationSetA <- createCID(citationSetA)

#write table to file
write.csv(citationSetA, "ProcessedData/WOS_SciConf_CitingArticles.csv")
