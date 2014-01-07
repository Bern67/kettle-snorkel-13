source("header.r")

knit("README.rmd") 
knit("report.rmd") 
knit("figures.rmd") 

markdownToHTML("report.md") 
markdownToHTML("figures.md") 

system("pandoc -s report.md -o report.docx")
