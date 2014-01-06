source("header.r")

knit2html("report.rmd") 
system("pandoc -s report.md -o report.docx")
