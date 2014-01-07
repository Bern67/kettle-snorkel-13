source("header.r")

if (.Platform$OS.type != "windows") {
  stop("data-input must be run on windows as it queries an Access database")
} else {
  set_folders("input")
  
  db <- odbcConnectAccess2007("input/WKE_KET_GRASwimCounts.accdb")
  
  data <- sqlQuery(db, "SELECT *  FROM XqryAllSectionFishAnalysisFinal")
  
  odbcCloseAll()
  
  data <- rename(data, replace = c("PrimarySystem" = "System"))
  data <- rename(data, replace = c("Section" = "Site"))
  data <- rename(data, replace = c("GNIS_NAME" = "River"))
  data <- rename(data, replace = c("MaxSectionKm" = "SiteLength"))
  data <- rename(data, replace = c("Flow" = "Discharge"))
  data <- rename(data, replace = c("PercentSuvey" = "ProportionSurveyed"))
  data <- rename(data, replace = c("CaptureMark" = "Released"))
  data <- rename(data, replace = c("T-Bar" = "Resighted"))
  data <- rename(data, replace = c("OldT-Bar" = "OldResighted"))
  data <- rename(data, replace = c("UnMarked" = "Unmarked"))
  
  data$Date <- as.Date(data$Date)
  is.na(data$Visibility[data$Visibility < 0]) <- TRUE
  
  data$Released[is.na(data$Released)] <- 0
  data$OldResighted[is.na(data$OldResighted)] <- 0
  data$Resighted[is.na(data$Resighted)] <- 0
  
  data$Count <- data$Unmarked + data$OldResighted + data$Resighted
  
  data$OldResighted <- NULL
  data$Unmarked <- NULL
  data$SummerAnalysis <- NULL
  data$Species <- NULL
  
  save_rdata(data)
}
