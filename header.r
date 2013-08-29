
library(grid)
library(ggplot2)
library(scales)
library(lubridate)
library(plyr)
library(reshape2)
library(RODBC)
library(devtools)
library(rjags)
library(abind)
library(stringr)
library(MASS)

if(.Platform$OS.type=="unix") {
  library(parallel)
  library(multicore)
  library(doMC)
}

if(.Platform$OS.type=="unix") {
  if (T) {
    if (!"package:jaggernaut" %in% search()) {
      install_github("jaggernaut","joethorley","v1.0.0")
      library(jaggernaut)
    }
    if (!"package:poiscon" %in% search()) {
      install_github("poiscon","poissonconsulting","v0.2.6")
      library(poiscon)
    }    
  } else {
    load_all("~/Documents/R/jaggernaut/jaggernaut")
    load_all("~/Documents/R/poiscon/poiscon")
  }
} else {
  load_all("~/R/jaggernaut/jaggernaut")
  load_all("~/R/poiscon/poiscon")  
}

graphics.off()
remove(list=objects(all.names=T))
reset_dirs()

theme_set(theme_Poisson())
palette (palette_Poisson())

opts_jagr(mode = "report")

if(.Platform$OS.type=="windows") {
 windowsFonts(Arial = windowsFont('Arial'))   
} else if(.Platform$OS.type=="unix") {
 quartzFonts(sans = quartzFont(rep('Arial',4)))   
}
