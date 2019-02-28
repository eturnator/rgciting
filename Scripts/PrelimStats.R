#install.packages('plyr')


##@knitr part1
library(plyr)

#determine data paths/read data for citing articles and articles
citing_path <- paste(getwd(),"/ProcessedData/WOS_SciConf_CitingArticles.csv", sep="" )
citing_data <- read.csv(citing_path, row.names= NULL, fill = TRUE, header = TRUE, stringsAsFactors = FALSE)
data_path <- paste(getwd(),"/ProcessedData/WOS_SciConf_20180531_Edited.csv", sep="" )
article_data <- read.csv(data_path, row.names= NULL, fill = TRUE, header = TRUE, stringsAsFactors = FALSE)


#Additional Stats
#Copyright count
copyright_count <- count(article_data, 'Copyrighted')

#fulltext count
fulltext_count <- count(article_data, 'FulltextAvailable')

#how are articles cited as: Title, URL, etc
cited_as <- count(citing_data, 'CitedAs')

#types of articles
article_type <- count(article_data, 'ItemClass')



## @knitr a1
# a1: how many articles are locatable
locatable <- count(citing_data, 'Locatable')
locatable_articles <- article_data[(article_data$AID %in% citing_data[ (citing_data$Locatable == 'Yes') & (!is.na(citing_data$Locatable)),"AID"]), ]


#b1: how many articles were cited as title but have true source
temp_titles <- unlist(unique(citing_data[(citing_data['CitedAs'] == 'Title'), "AID"])) #removed duplicate AIDs
title_source <- article_data[(article_data[,"AID"] %in% temp_titles) & (!is.na(article_data[,"SourcePubs"])) & (article_data[,"SourcePubs"] != "No"),] #remove values that are NA or No

#b2: how many articles cited as a title but have details available in RG
title_details <- article_data[(article_data[,"AID"] %in% temp_titles) & (article_data[,"CitationDetail_RG"] == "Yes") & (!is.na(article_data[,"CitationDetail_RG"])),] #remove values that are NA or No

#b3: Sources that have citing articles citing the original source AND a research gate source
temp <- citing_data[duplicated(citing_data["AID"]),]$AID #get the AIDs that are duplicated
dups <- citing_data[(citing_data$AID %in% temp), ] #extract duplicated rows
original_title <- ddply(dups,~AID,summarise,TF=(grep("Title", as.character(unique(CitedAs))) & grep("Original",as.character(unique(CitedAs)))))

#c1: articles with no publication source/DOI RG
doirg <- article_data[ (article_data['DOI_RG'] == 'Yes' & !is.na(article_data['DOI_RG'])) & (article_data['SourcePubs'] == 'No'), ]

# d1: copyrighted articles w/ fulltext available on research gate
full_copyright <- article_data[ (article_data['Copyrighted'] == 'Yes' & !is.na(article_data['Copyrighted'])) & (article_data['FulltextAvailable'] == 'Yes' & !is.na(article_data['FulltextAvailable'])) , ]
copyright_info <- full_copyright[,c("Copyrighted", "FulltextAvailable", "AID", "AU", "TI")]
copyright_info <- rbind(nrow(full_copyright), copyright_info)

#d2: num copyrighted articles with also fulltext in specified locations
copyright_repo <- article_data[ (article_data['Copyrighted'] == 'Yes') & (!is.na(article_data['Copyrighted'])) & (!is.na(article_data["SourceRepo"])) & (article_data['SourceRepo'] != 'No'),]
copyright_preprint <- article_data[ (article_data['Copyrighted'] == 'Yes') & (!is.na(article_data['Copyrighted'])) & (!is.na(article_data["SourcePreprint"])) & (article_data['SourcePreprint'] != 'No'),]
copyright_website <- article_data[ (article_data['Copyrighted'] == 'Yes') & (!is.na(article_data['Copyrighted'])) & (!is.na(article_data["SourceWebsite"])) & (article_data['SourceWebsite'] != 'No'),]

#d3: copyrighted articles with no full text available on RG
copyright_no_fulltext <- article_data[ (article_data['Copyrighted'] == 'Yes') & (!is.na(article_data['Copyrighted'])) & (!is.na(article_data["FulltextAvailable"])) & (article_data['FulltextAvailable'] == 'No'),]

#d4: Articles w/ OA or Cretive Commons License
oa_num <- article_data[ !is.na(article_data['Licensed']) & article_data['Licensed']!="No", ]

#d4: Articles w/ HCISI option
hcisi <- article_data[ !is.na(article_data['HCISI']) & article_data['HCISI']!="No", ]

#Create table to summarize results
##@knitr tablef

names <- c("A1", "B1", "B2", "B3", "C1", "D1","D2R", "D2P", "D2W", "D3", "D4O", "D4H")
table <- NULL
table <- rbind(table,
               c("How many of the articles were locatable",nrow(locatable_articles), list(locatable_articles$AID)),
               c("Articles cited as a title but have a True source", nrow(title_source), list(title_source$AID)),
               c("Articles cited as a title but have details available in researchgate", nrow(title_details), list(title_details$AID)),
               c("Citing articles citing the original source AND a research gate source", nrow(original_title), list(original_title$AID)),
               c("Articles that have RG Doi/no other source", nrow(doirg), list(doirg$AID)),
               c("Articles that are copyrighted and have full text available on RG", nrow(full_copyright), list(full_copyright$AID)),
               c("Copyrighted articles on repository", nrow(copyright_repo), list(copyright_repo$AID)),
               c("Copyrighted articles on preprint", nrow(copyright_preprint), list(copyright_preprint$AID)),
               c("Copyrighted atricles on website", nrow(copyright_website), list(copyright_website$AID)),
               c("Articles that are copyrighted and have NO full text available", nrow(copyright_no_fulltext), list(copyright_no_fulltext$AID)),
               c("Open Access articles", nrow(oa_num), list(oa_num$AID)),
               c("HCISI articles", nrow(hcisi), list(hcisi$AID)))
table <- data.frame(table)  
row.names(table) <- names
colnames(table) <- c("Question", "Number Matches", "AIDs of Matches")

#knitr::kable(table)
#kableExtra::column_spec(2:3, width = "5cm")

