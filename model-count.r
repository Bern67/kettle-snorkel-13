model <- jmodel(
  description = c("bEfficiency0" = "Logit observer efficiency intercept",
                  "bDensity0" = "Log density intercept",
                  "sDensitySite" = "SD of effect of site on log density",
                  "nSite" = "Number of sites",
                  "bDensitySite[st]" = "Effect of stth site on log density",
                  "sDensityYear" = "SD of effect of year on log density",
                  "nYear" = "Number of years",
                  "sDensitySiteYear" = "SD of effect of site in year on log density",                  "bDensityYear[yr]" = "Effect of yrth year on log density",
                  "bDensitySiteYear[st, yr]" = "Effect of stth site in yrth year on log density",
                  "nrow" = "Number of site counts",
                  "eEfficiency[i]" = "Expected observer efficiency on the ith site count",
                  "Mark[i]" = "Number of fish marked prior to the ith site count",                  
                  "Recap[i]" = "Number of marked fish observed during ith site count",
                  "eDensity[i]" = "Expected density at ith site count",
                  "SiteLength[i]" = "Length site during ith site count",
                  "eAbundance[i]" = "Expected abundance at ith site count",
                  "eTotal[i]" = "Expected total number of fish at ith site count",
                  "Total[i]" = "Total number of fish observed during ith site count"
),
model = "model {

  bEfficiency0 ~ dnorm(0, 2^-2)

  bDensity0 ~ dnorm(0, 5^-2)

  sDensitySite ~ dunif(0, 5)
  sDensitySiteYear ~ dunif(0, 5)
  for (st in 1:nSite) {
    bDensitySite[st] ~ dnorm(0, sDensitySite^-2)
    for (yr in 1:nYear) {
      bDensitySiteYear[st, yr] ~ dnorm(0, sDensitySiteYear^-2)
    }
  }

  sDensityYear ~ dunif(0, 5)
  for (yr in 1:nYear) {
    bDensityYear[yr] ~ dnorm(0, sDensityYear^-2)
  }


  for (i in 1:nrow) {
    logit(eEfficiency[i]) <- bEfficiency0

    dEfficiency[i] <- min(eEfficiency[i], Mark[i])
    dMark[i] <- max(Mark[i], 1)
    Recap[i] ~ dbin(dEfficiency[i], dMark[i])

    log(eDensity[i]) <- bDensity0 + bDensityYear[Year[i]] + bDensitySite[Site[i]] 
      + bDensitySiteYear[Site[i], Year[i]]
    eAbundance[i] <- eDensity[i] * SiteLength[i]
    eTotal[i] ~ dpois(eAbundance[i])
    Total[i] ~ dbin(eEfficiency[i], eTotal[i])

  }
} ",
  derived = "model {
    for (i in 1:nrow) {
    logit(eEfficiency[i]) <- bEfficiency0
    dEfficiency[i] <- min(eEfficiency[i], Mark[i])
    dMark[i] <- max(Mark[i], 1)
    eRecap[i] ~ dbin(dEfficiency[i],dMark[i]) 

    log(eDensity[i]) <- bDensity0 + bDensityYear[Year[i]] + bDensitySite[Site[i]]
      + bDensitySiteYear[Site[i], Year[i]]
    eAbundance[i] <- eDensity[i] * SiteLength[i]
    eTotal[i] ~ dpois(eAbundance[i])
    eCount[i] ~ dbin(eEfficiency[i],eTotal[i]) 

    eResidual[i] <-  log(Total[i] / SiteLength[i] / eEfficiency[i]) - log(eDensity[i])
    }
  }",
  gen_inits = function (data) {
    inits <- list()
    inits$eTotal <- data$Total
    inits$bDensity0 <- 5.5
    inits$sDensitySite <- 1.0
    inits$sDensitySiteYear <- 0.5
    inits$sDensityYear <- 0.5
    return (inits)
  },
  random = list(bDensitySite = "Site", bDensityYear = "Year", bDensitySiteYear = c("Site","Year"))
)
