source("header.r")

# Load data and analysis from dist
set_folders("count")
count <- load_rdata()
analysis <- load_analysis()


#Produce and save plots of the observed counts
cdata <- count
cdata$Year <- as.integer(as.character(cdata$Year))

gp <- ggplot(data = cdata, aes(x = Year, y = Total))
gp <- gp + facet_wrap(~Site)
gp <- gp + geom_point()
gp <- gp + scale_x_continuous(name = "Year", breaks = c(2000,2005,2010))
gp <- gp + scale_y_continuous(name = "Observed Count",label=comma)
gp <- gp + expand_limits(y=0)

gwindow(1,1)
print(gp)

save_plot("observed_count", type = "data")


#Produce and save plots of the predicted counts
data <- predict(analysis, newdata = count, parm = "eCount")
data$Year <- as.integer(as.character(data$Year))
cdata <- count
cdata$Year <- as.integer(as.character(cdata$Year))

gp <- ggplot(data = data, aes(x = Year, y = estimate))
gp <- gp + facet_wrap(~Site)
gp <- gp + geom_pointrange(aes(ymin = lower, ymax = upper))
gp <- gp + scale_x_continuous(name = "Year", breaks = c(2000,2005,2010))
gp <- gp + scale_y_continuous(name = "Predicted Count",label=comma)
gp <- gp + expand_limits(y=0)

gwindow(1,1)
print(gp)

save_plot("predicted_count")


#Produce and save plots of the predicted recaptures
data <- predict(analysis, newdata = subset(count, Mark > 0), parm = "eRecap")

gp <- ggplot(data = data, aes(x = Site, y = estimate))
gp <- gp + geom_point(data = subset(cdata, Mark > 0), aes(y = Recap), color = "red")
gp <- gp + geom_pointrange(aes(ymin = lower, ymax = upper))
gp <- gp + scale_x_discrete(name = "Site")
gp <- gp + scale_y_continuous(name = "Predicted Recaptures", label = comma)
gp <- gp + expand_limits(y=0)

gwindow(1,1)
print(gp)

save_plot("recap")


#Produce and save plots of the predicted abundances
data <- predict(analysis, newdata = count, parm = "eAbundance")
data$Year <- as.integer(as.character(data$Year))

gp <- ggplot(data = data, aes(x = Year, y = estimate))
gp <- gp + facet_wrap(~Site)
gp <- gp + geom_pointrange(aes(ymin = lower, ymax = upper))
gp <- gp + scale_x_continuous(name = "Year", breaks = c(2000,2005,2010))
gp <- gp + scale_y_continuous(name = "Predicted Abundance",label=comma)
gp <- gp + expand_limits(y = 0)

gwindow(1,1)
print(gp)

save_plot("abundance")


#Produce and save plots of the efficiency
data <- predict(analysis, parm = "eEfficiency")
#print("Efficiency")
#print(subset(data, select = c("estimate","lower","upper")))

gp <- ggplot(data = data, aes(x = "Efficiency", y = estimate))
gp <- gp + geom_pointrange(aes(ymin = lower, ymax = upper))
gp <- gp + scale_x_discrete(name = "", breaks = NULL)
gp <- gp + scale_y_continuous(name = "Efficiency", labels = percent)
gp <- gp + expand_limits(y = c(0,1))
gp <- gp + theme(axis.title.x = element_blank())

gwindow(1,1)
print(gp)

save_plot("efficiency")


#Produce and save plots of the density by site
data <- predict(analysis, newdata = c("Site","Year"), parm = "eDensity")
data$Year <- as.integer(as.character(data$Year))

gp <- ggplot(data = data, aes(x = Year, y = estimate))
gp <- gp + facet_wrap(~Site)
gp <- gp + geom_pointrange(aes(ymin = lower, ymax = upper))
gp <- gp + scale_x_continuous(name = "Year", breaks = c(2000,2005,2010))
gp <- gp + scale_y_continuous(name = "Density (fish/km)", label = comma)
gp <- gp + expand_limits(y = 0)

gwindow(1,1)
print(gp)

save_plot("density")


#Produce and save plots of the density by year
data <- predict(analysis, newdata = "Year", parm = "eDensity")
data$Year <- as.numeric(as.character(data$Year))

gp <- ggplot(data = data, aes(x = Year, y = estimate))
gp <- gp + geom_pointrange(aes(ymin = lower, ymax = upper))
gp <- gp + scale_x_continuous(name = "Year", breaks = c(2000, 2004, 2008, 2012))
gp <- gp + scale_y_continuous(name = "Density (fish/km)")
gp <- gp + expand_limits(y = 0)

gwindow(1,2)
print(gp)

save_plot("year")


#Produce and save plots of the density by site
data <- predict(analysis, newdata = "Site", parm = "eDensity")
#data <- calc_expected (analysis, parameter = "eDensity", data = "Site")

gp <- ggplot(data = data, aes(x = Site, y = estimate))
gp <- gp + geom_pointrange(aes(ymin = lower, ymax = upper))
gp <- gp + scale_x_discrete(name = "Site")
gp <- gp + scale_y_continuous(name = "Density (fish/km)", labels=comma)
gp <- gp + expand_limits(y = 0)

gwindow(1,2)
print(gp)

save_plot("site")