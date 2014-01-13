
description = c(
  "`eEfficiency[i]`" = "Expected observer efficiency during the i*th* site visit",
  "`Discharge[i]`" = "Standardised discharge during the i*th* site visit",
  "`bEfficiency0`" = "Intercept of `logit(eEfficiency)`",
  "`bEfficiencyDischarge`" = "Linear effect of standardised discharge on `logit(eEfficiency)`",
  "`eDensity[i]`" = "Expected fish density during i*th* site visit",
  "`Time[i]`" = "Centred year of i*th* site visit as a continuous varible",
  "`Year[i]`" = "Year of i*th* site visit as a factor",
  "`bDensity0`" = "Intercept of `log(eDensity)`",
  "`bDensitySite[st]`" = "Linear effect of st*th* site on `log(eDensity)`",
  "`sDensitySite`" = "SD of `bDensitySite`", 
  "`bDensitySiteYear[st, yr]`" = "Linear effect of st*th* site in yr*th* year on `log(eDensity)`",
  "`sDensitySiteYear`" = "SD of `bDensitySiteYear`", 
  "`bDensityYear[yr]`" = "Linear effect of yr*th* year on `log(eDensity)`",
  "`sDensityYear`" = "SD of `bDensityYear`", 
  "`bTime`" = "Linear effect of centred year on `log(eDensity)`",
  "`ProportionSurveyed[i]`" = "Proportion of site surveyed during i*th* site visit",                  
  "`Released[i]`" = "Number of fish marked prior to the i*th* site visit",                  
  "`Resighted[i]`" = "Number of marked fish observed during i*th* site visit",
  "`SiteLength[i]`" = "Length of site during i*th* site visit",
  "`eAbundance[i]`" = "Expected abundance during i*th* site visit",
  "`eCount[i]`" = "Expected total number of fish observed during i*th* site visit",
  "`Count[i]`" = "Total number of fish observed during i*th* site visit"
)


#### Model 1 ####

model1 <- jags_model("model {

  bEfficiency0 ~ dnorm(0, 2^-2)
  bEfficiencyDischarge ~ dnorm(0, 2^-2)

  bDensity0 ~ dnorm(0, 5^-2)
  bTime ~ dnorm(0, 5^-2)

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
                   
  for (i in 1:length(Count)) {
    logit(eEfficiency[i]) <- bEfficiency0 + bEfficiencyDischarge * Discharge[i]  
    dEfficiency[i] <- min(eEfficiency[i], Released[i])
    dReleased[i] <- max(Released[i], 1)
    Resighted[i] ~ dbin(dEfficiency[i] * ProportionSurveyed[i], dReleased[i])

    log(eDensity[i]) <- bDensity0 + bDensityYear[Year[i]]
                                  + bDensitySite[Site[i]]
                                  + bDensitySiteYear[Site[i], Year[i]]
                                  + bTime * Time[i]
    eAbundance[i] <- eDensity[i] * SiteLength[i]
    eCount[i] ~ dpois(eAbundance[i])
    Count[i] ~ dbin(eEfficiency[i] * ProportionSurveyed[i], eCount[i])
  }

} ",                                  
derived_code = "model {

  for (i in 1:length(Count)) {
    logit(eEfficiency[i]) <- bEfficiency0 + bEfficiencyDischarge * Discharge[i]  
    log(prediction[i]) <- bDensity0 + bDensityYear[Year[i]]
                                  + bDensitySite[Site[i]]
                                  + bDensitySiteYear[Site[i], Year[i]]
                                  + bTime * Time[i]
  
    residual[i] <-  log(Count[i] / SiteLength[i] / 
                       (eEfficiency[i] * ProportionSurveyed[i])) 
                     - log(prediction[i])
  }
}",
gen_inits = function (data) {

  inits <- list()
  inits$eCount <- data$Count
  inits$bDensity0 <- 5.5
  inits$sDensitySite <- 1.0
  inits$sDensitySiteYear <- 0.5
  inits$sDensityYear <- 0.5

  return (inits)
},
random_effects = list(bDensitySite = "Site", bDensityYear = "Year", 
                      bDensitySiteYear = c("Site","Year")),
select = c("Year","Time+","Site","SiteLength","ProportionSurveyed","Discharge*","Released","Resighted","Count")
)


#### Combine models ####

models <- combine(model1)
