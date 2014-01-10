source("header.r")

knit("README.rmd")

knit2html("report.rmd")
knit2html("figures.rmd")

system("pandoc -s report.md -o report.docx") 
