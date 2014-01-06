source("header.r")

knit2html("methods.rmd")
system("pandoc -s methods.md -o methods.docx")
knit2html("models.rmd")
system("pandoc -s models.md -o models.docx")
knit2html("parameters.rmd")
system("pandoc -s parameters.md -o results.docx")
knit2html("figures.rmd") 
