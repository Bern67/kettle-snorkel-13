source("header.r")

knit2html("report.rmd") 
knit2html("figures.rmd") 

system("pandoc -s report.md -o report.docx")
