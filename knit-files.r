source("header.r")

.title <- "Kettle River Rainbow Trout Snorkel Count Analysis 2013"
.authors <- "Thorley J.L. and Hogan P.M."
.tags <- c("kettle river", "rainbow trout", "snorkel")
.web_dir <- "ieurhtg" # as.Date("2014-01-13")

output_dir <- paste0("output/report/", project_folder())

knit("README.rmd")  

.figures <- FALSE
knit("report.rmd", output = paste0(output_dir,".md"))
text <- readLines(paste0(output_dir,".md"))
text <- str_replace_all(text[-(1:2)], "&", "and")
writeLines(text,paste0(output_dir,".md"))

system(paste0("pandoc -s ",output_dir,".md -o ",output_dir,".docx"))

.figures <- TRUE
knit("report.rmd", output = paste0(output_dir,".md"))
text <- readLines(paste0(output_dir,".md"))
text <- str_replace_all(text[-(1:2)], "&", "and")
writeLines(text,paste0(output_dir,".md"))

upload_files(.web_dir)
