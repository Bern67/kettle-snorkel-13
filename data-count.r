source("header.r")

db <- odbcConnectExcel2007("Kettle River data.xlsx")

data <- sqlQuery(db, paste(
  "SELECT * ",
  "FROM \"Sheet1$\" ",
  sep=""))

odbcCloseAll()

data <- subset(data,Replicate == 1)

data <- subset(data,select = c("Year","Site","SiteLength (km)","Marked","MarkObserved","Unmarked Observed"))

colnames(data) <- c("Year","Site","SiteLength","Mark","Recap","Total")

warning("corrects 2010 data at GR3 so total count 242 not 86")
data$Total[data$Site == "GR3" & data$Year == 2010 & data$Total == 86]<-242

warning("hack to ensure site overlap between years")
data$Site <- as.character(data$Site)
data$Site[data$Site == "WKTa"] <- "WKT"
data$Site[data$Site == "WKCa"] <- "WKC"
data$Site[data$Site == "GR3a"] <- "GR3"
data$Site <- factor(data$Site)

data$Year <- factor(data$Year)
data$Mark[is.na(data$Mark)] <- 0
data$Recap[is.na(data$Recap)] <- 0
data$Total <- data$Recap + data$Total

data$Mark <- as.integer(data$Mark)
data$Recap <- as.integer(data$Recap)
data$Total <- as.integer(data$Total)

warning("this is a hack to deal with inconsistent marks and recaps")

mark <- pmax(data$Mark, data$Recap)
recap <- pmin(data$Mark, data$Recap)

data$Mark <- mark
data$Recap <- recap

saveRDS(data,"count.rds")
