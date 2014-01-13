if (!require(assertthat)) install.packages("assertthat")

if (!require(datalist)) install.packages("datalist")

if (!require(grid)) install.packages("grid")

if (!require(ggplot2)) install.packages("ggplot2")

if (!require(knitr)) install.packages("knitr")

if (!require(knitcitations)) install.packages("knitcitations")

if (!require(lubridate)) install.packages("lubridate")

if (!require(markdown)) install.packages("markdown")

if (!require(plyr)) install.packages("plyr")

if (!require(reshape2)) install.packages("reshape2")

if (!require(RODBC)) install.packages("RODBC")

if (!require(scales)) install.packages("scales")

if (!require(stringr)) install.packages("stringr")

if (!require(devtools)) {
    install("devtools")
    library(devtools)
}

if (capabilities("http/ftp")) {
    install_github("jaggernaut", "joethorley", "v1.5.4")
    install_github("poiscon", "poissonconsulting", "v0.6.5")
} else stop("internet required to install packages")
