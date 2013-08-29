source("header.r")

count <- readRDS("count.rds")
analysis <- readRDS("analysis.rds")

cdata <- count
cdata$Year <- as.integer(as.character(cdata$Year))

gp <- ggplot(data = cdata,aes(x=Year,y= Total))
gp <- gp + facet_wrap(~Site)
gp <- gp + geom_point()
gp <- gp + scale_x_continuous(name = "Year", breaks = c(2000,2005,2010))
gp <- gp + scale_y_continuous(name = "Observed Count",label=comma)
gp <- gp + expand_limits(y=0)

windows(6,6)
print(gp)

ggsave("observed_count.png",width=6,height=6)

data <- calc_expected (analysis, parameter = "eCount", data = count)
data$Year <- as.integer(as.character(data$Year))
cdata <- count
cdata$Year <- as.integer(as.character(cdata$Year))

gp <- ggplot(data = data,aes(x=Year,y=estimate))
gp <- gp + facet_wrap(~Site)
gp <- gp + geom_pointrange(aes(ymin = lower, ymax = upper))
gp <- gp + scale_x_continuous(name = "Year", breaks = c(2000,2005,2010))
gp <- gp + scale_y_continuous(name = "Predicted Count",label=comma)
gp <- gp + expand_limits(y=0)

windows(6,6)
print(gp)

ggsave("predicted_count.png",width=6,height=6)

data <- calc_expected (analysis, parameter = "eRecap", data = subset(count,Mark > 0))

gp <- ggplot(data = data,aes(x=Site,y=estimate))
gp <- gp + geom_point(data = subset(cdata,Mark > 0), aes(y=Recap),color="red")
gp <- gp + geom_pointrange(aes(ymin = lower, ymax = upper))
gp <- gp + scale_x_discrete(name = "Site")
gp <- gp + scale_y_continuous(name = "Predicted Recaptures",label=comma)
gp <- gp + expand_limits(y=0)

windows(3,3)
print(gp)

ggsave("recap.png",width=6,height=6)

data <- calc_expected (analysis, parameter = "eAbundance", data = count)
data$Year <- as.integer(as.character(data$Year))

gp <- ggplot(data = data,aes(x=Year,y=estimate))
gp <- gp + facet_wrap(~Site)
gp <- gp + geom_pointrange(aes(ymin = lower, ymax = upper))
gp <- gp + scale_x_continuous(name = "Year", breaks = c(2000,2005,2010))
gp <- gp + scale_y_continuous(name = "Predicted Abundance",label=comma)
gp <- gp + expand_limits(y=0)

windows(6,6)
print(gp)

ggsave("abundance.png",width=6,height=6)


data <- calc_expected (analysis, parameter = "eEfficiency")
print("Efficiency")
print(subset(data,select=c("estimate","lower","upper")))

gp <- ggplot(data = data,aes(x="Efficiency",y=estimate))
gp <- gp + geom_pointrange(aes(ymin = lower, ymax = upper))
gp <- gp + scale_x_discrete(name = "", breaks = NULL)
gp <- gp + scale_y_continuous(name = "Efficiency",labels = percent)
gp <- gp + expand_limits(y=c(0,1))
gp <- gp + theme(axis.title.x = element_blank())

windows(2,2)
print(gp)

ggsave("efficiency.png",width=2,height=2)

data <- calc_expected (analysis, parameter = "eDensity", data = c("Site","Year"))
data$Year <- as.integer(as.character(data$Year))

gp <- ggplot(data = data,aes(x=Year,y=estimate))
gp <- gp + facet_wrap(~Site)
gp <- gp + geom_pointrange(aes(ymin = lower, ymax = upper))
gp <- gp + scale_x_continuous(name = "Year", breaks = c(2000,2005,2010))
gp <- gp + scale_y_continuous(name = "Density (fish/km)",label=comma)
gp <- gp + expand_limits(y=0)

windows(6,6)
print(gp)

ggsave("density.png",width=6,height=6)

data <- calc_expected (analysis, parameter = "eDensity",  data = "Year")
data$Year <- as.numeric(as.character(data$Year))

gp <- ggplot(data = data,aes(x=Year,y=estimate))
gp <- gp + geom_pointrange(aes(ymin = lower, ymax = upper))
gp <- gp + scale_x_continuous(name = "Year", breaks = c(2000,2004,2008,2012))
gp <- gp + scale_y_continuous(name = "Density (fish/km)")
gp <- gp + expand_limits(y=0)

windows(6,3)
print(gp)

ggsave("year.png",width=6,height=3)

data <- calc_expected (analysis, parameter = "eDensity", data = "Site")

gp <- ggplot(data = data,aes(x=Site,y=estimate))
gp <- gp + geom_pointrange(aes(ymin = lower, ymax = upper))
gp <- gp + scale_x_discrete(name = "Site")
gp <- gp + scale_y_continuous(name = "Density (fish/km)",labels=comma)
gp <- gp + expand_limits(y=0)

windows(6,3)
print(gp)

ggsave("site.png",width=6,height=3)
 