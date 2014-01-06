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
remove(list = objects())

theme_set(theme_Golder())
palette(palette_Golder())

reset_folders()

opts_jagr(mode = "debug")

if (getDoParWorkers() == 1) {
  registerDoParallel(6)
  opts_jagr(parallel = TRUE)
}

opts_chunk$set(warning = FALSE, message = FALSE, echo = FALSE, 
               comment = NA, results = "asis")

.project <- "Kettle River Rainbow Trout Snorkel Count Analysis 2013"
.authors <- "Thorley J.L. & Hogan P.M."
.date <- "6^th January 2014"

.replacement <- c("count" = "",
                  "density-year" = "Year",
                  "density-site" = "Site",
                  "density-site-year" = "Site-Year",
                  "efficiency" = "Efficiency")

.bib <- read.bibtex("references.bib")

.bib <- c(.bib, 
          "jaggernaut" = citation("jaggernaut"), 
          "ggplot2" = citation("ggplot2"),
          "R" = citation())
