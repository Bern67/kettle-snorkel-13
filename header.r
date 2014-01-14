library(assertthat)
library(ggplot2)
library(grid)
library(knitr)
library(knitcitations)
library(lubridate)
library(markdown)
library(plyr)
library(reshape2)
library(RODBC)
library(scales)
library(stringr)
library(jaggernaut)
library(poiscon)

if (.Platform$OS.type == "unix") {
    if (Sys.info()["sysname"] == "Darwin") {
        quartzFonts(sans = quartzFont(rep("Arial", 4)))
    } else {
        stop("need to set font to Arial for linux operating systems")
    }
} else {
    windowsFonts(Arial = windowsFont("Arial"))
}

graphics.off()
remove(list = objects(all = TRUE))

theme_set(theme_Poisson())
palette(palette_Poisson())

reset_folders()

if (getDoParWorkers() == 1) {
  registerDoParallel(3)
} 

opts_jagr(parallel = TRUE)
opts_jagr(mode = "report")
