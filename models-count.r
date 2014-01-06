description = c(
  "`bEfficiency0`" = "Log odds observer efficiency intercept",
  "`bEfficiencyDischarge`" = "Effect of standardised discharge on `bEfficiency0`",
  "`bDensity0`" = "Log lineal fish density intercept",
  "`sDensitySite`" = "SD of effect of site on `bDensity0`",
  "`bDensitySite[st]`" = "Effect of st^th site on `bDensity0`",
  "`sDensitySiteYear`" = "SD of effect of site in year on `bDensity0`",
  "`bDensitySiteYear[st, yr]`" = "Effect of st^th site in yr^th year on `bDensity0`",
  "`sDensityYear`" = "SD of effect of year on `bDensity0`",
  "`bDensityYear[yr]`" = "Effect of yr^th year on `bDensity0`",
  "`Discharge[i]`" = "Discharge during i^th site visit",
  "`eEfficiency[i]`" = "Expected observer efficiency during the i^th site visit",
  "`ProportionSurveyed[i]`" = "Proportion of site surveyed during i^th site visit",                  
  "`Released[i]`" = "Number of fish marked prior to the i^th site visit",                  
  "`Resighted[i]`" = "Number of marked fish observed during i^th site visit",
  "`eDensity[i]`" = "Expected lineal fish density during i^th site visit",
  "`SiteLength[i]`" = "Length of site during i^th site visit",
  "`eAbundance[i]`" = "Expected abundance during i^th site visit",
  "`eCount[i]`" = "Expected total number of fish observed during i^th site visit",
  "`Count[i]`" = "Total number of fish observed during i^th site visit"
)

model1 <- jags_model("model {

  bEfficiency0 ~ dnorm(0, 2^-2)
  bEfficiencyDischarge ~ dnorm(0, 2^-2)

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
                   
  for (i in 1:length(Count)) {
    logit(eEfficiency[i]) <- bEfficiency0 + bEfficiencyDischarge * Discharge[i]  
    dEfficiency[i] <- min(eEfficiency[i], Released[i])
    dReleased[i] <- max(Released[i], 1)
    Resighted[i] ~ dbin(dEfficiency[i] * ProportionSurveyed[i], dReleased[i])

    log(eDensity[i]) <- bDensity0 + bDensityYear[Year[i]]
                                  + bDensitySite[Site[i]]
                                  + bDensitySiteYear[Site[i], Year[i]]
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
select = c("Year","Site","SiteLength","ProportionSurveyed","Discharge*","Released","Resighted","Count")
)

models <- combine(model1)
