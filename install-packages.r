if (!require(assertthat))
  install.packages("assertthat")

if (!require(datalist))
  install.packages("datalist")

if (!require(grid))
  install.packages("grid")

if (!require(ggplot2))
  install.packages("ggplot2")

if (!require(knitr))
  install.packages("knitr")

if (!require(knitcitations))
  install.packages("knitcitations")

if (!require(lubridate))
  install.packages("lubridate")

if (!require(markdown))
  install.packages("markdown")

if (!require(plyr))
  install.packages("plyr")

if (!require(reshape2))
  install.packages("reshape2")

if (!require(RODBC))
  install.packages("RODBC")

if (!require(scales))
  install.packages("scales")

if (!require(stringr))
  install.packages("stringr")

if (!require(devtools)) {
  install("devtools")
  library(devtools)
}

if (capabilities("http/ftp") && TRUE) {
  install_github("jaggernaut", "joethorley", "v1.5.4")
  install_github("poiscon", "poissonconsulting", "v0.6.1")
} else {
  if (Sys.info()["user"] == "Joseph Thorley") {
    install("~/R/jaggernaut/jaggernaut")
    install("~/R/poiscon/poiscon")
  } else if (Sys.info()["user"] == "joe") {
    install("~/Documents/R/jaggernaut/jaggernaut")
    install("~/Documents/R/poiscon/poiscon")
  } else stop("required packages cannot be installed")
}
