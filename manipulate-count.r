source("header.r")

set_folders("input")

data <- load_rdata()

set_folders("count")

data$Released <- as.integer(data$Released)
data$Resighted <- as.integer(data$Resighted)
data$Count <- as.integer(data$Count)

data$Dayte <- dayte(data$Date)
data$Replicate <- factor(data$Replicate)
data$Year <- factor(data$Year)

data$Time <- as.integer(as.character(data$Year))

save_rdata(data)

data$Year <- as.integer(as.character(data$Year))

gp <- ggplot(data, aes(x = Date, y = Count))
gp <- gp + facet_wrap(~Site)
gp <- gp + geom_point(aes(shape = Replicate, color = Replicate))
gp <- gp + scale_x_date(name = "Year", 
                        breaks = as.Date(paste0(c("2000","2005","2010"), "-01-01")),
                        labels = date_format("%Y"))
gp <- gp + scale_y_continuous(name = "Observed Count",label=comma)
gp <- gp + scale_color_manual(values = palette())
gp <- gp + expand_limits(y=0)

gwindow(1,1)
print(gp)

save_plot("count")

gp <- ggplot(data, aes(x = Date, y = Discharge))
gp <- gp + geom_point(aes(shape = Replicate, color = Replicate))
gp <- gp + scale_x_date(name = "Year", 
                        breaks = as.Date(paste0(c("2000","2005","2010"), "-01-01")),
                        labels = date_format("%Y"))
gp <- gp + scale_y_continuous(name = "Discharge (cms)")
gp <- gp + scale_color_manual(values = palette())
gp <- gp + expand_limits(y=0)

gwindow(1.5,1.5)
print(gp)

save_plot("discharge")

gp <- ggplot(data, aes(x = Discharge, y = Visibility))
gp <- gp + geom_point(aes(shape = Replicate, color = Replicate))
gp <- gp + scale_x_continuous(name = "Discharge (cms)")
gp <- gp + scale_y_continuous(name = "Visibility (m)")
gp <- gp + scale_color_manual(values = palette())

gwindow(1.5, 1.5)
print(gp)

save_plot("visibility", type = "data")
