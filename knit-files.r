source("header.r")

knit2html("methods.rmd")
knit2html("models.rmd")
knit2html("parameters.rmd")
knit2html("figures.rmd") 

system("pandoc -s methods.md -o methods.docx")
system("pandoc -s models.md -o models.docx")
system("pandoc -s parameters.md -o results.docx")
