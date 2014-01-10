source("header.r")

set_folders("count")

analysis <- load_analysis()

prediction <- predict(analysis, newdata = c("Year"))
prediction$Year <- as.integer(as.character(prediction$Year))

gp <- ggplot(data = prediction, aes(x = Year, y = estimate))
gp <- gp + geom_pointrange(aes(ymin = lower, ymax = upper))
gp <- gp + scale_x_continuous(name = "Year", breaks = c(2000, 2005, 2010))
gp <- gp + scale_y_continuous(name = "Density (fish/km)", label = comma, expand = c(0, 
    0))
gp <- gp + expand_limits(y = 0)

gwindow(2, 2)
print(gp)

save_plot("density-year")

prediction <- predict(analysis, newdata = c("Site"))

gp <- ggplot(data = prediction, aes(x = Site, y = estimate))
gp <- gp + geom_pointrange(aes(ymin = lower, ymax = upper))
gp <- gp + scale_y_continuous(name = "Density (fish/km)", label = comma, expand = c(0, 
    0))
gp <- gp + expand_limits(y = 0)

gwindow(2, 2)
print(gp)

save_plot("density-site")

prediction <- predict(analysis, newdata = c("Site", "Year"), obs_by = TRUE)
prediction$Year <- as.integer(as.character(prediction$Year))

gp <- ggplot(data = prediction, aes(x = Year, y = estimate))
gp <- gp + facet_wrap(~Site)
gp <- gp + geom_pointrange(aes(ymin = lower, ymax = upper))
gp <- gp + scale_x_continuous(name = "Year", breaks = c(2000, 2005, 2010))
gp <- gp + scale_y_continuous(name = "Density (fish/km)", label = comma, expand = c(0, 
    0))
gp <- gp + expand_limits(y = 0)

gwindow(1, 1)
print(gp)

save_plot("density-site-year")

prediction <- predict(analysis, newdata = c("Discharge"), parm = "eEfficiency")

gp <- ggplot(data = prediction, aes(x = Discharge, y = estimate))
gp <- gp + geom_line()
gp <- gp + geom_line(aes(y = lower), linetype = "dotted")
gp <- gp + geom_line(aes(y = upper), linetype = "dotted")
gp <- gp + scale_x_continuous(name = "Discharge (cms)")
gp <- gp + scale_y_continuous(name = "Observer Efficiency", labels = percent, expand = c(0, 
    0))
gp <- gp + expand_limits(y = c(0, 1))

gwindow(2, 2)
print(gp)

save_plot("efficiency") 
