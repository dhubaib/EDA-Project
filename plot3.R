## Script to investigate specific PM2.5 emissions in Baltimore over 9 years
# Looking at types: point, nonpoint, onroad, nonroad

## Script to load NEI data from EPA for processing
library(data.table)
library(dplyr)
library(ggplot2)

# Don't re-load data if already in memory...
if(!exists("NEI") || (exists("NEI")&nrow(NEI) != 6497651))
{
  NEI <- readRDS("summarySCC_PM25.rds") # National Emissions Invetory
  SCC <- readRDS("Source_Classification_Code.rds") # Classification codes for SCC col in NEI
}

## Plot total emissions from baltimore 1999-2008

NEI_baltimore <- NEI %>% filter(fips == 24510)
# Group data by year & type
by_year <- NEI_baltimore %>% group_by(year, type)
year_sum <- by_year %>% summarize(total = sum(Emissions))
# Create point-plot using base system
year_sum$total <-round(year_sum$total,2)


g <- ggplot(data = year_sum, aes(year, total))
g <- g + geom_smooth(method = "lm", level = 0.8)
g <- g + facet_grid(.~type)
g <- g + geom_point()
g <- g + theme_bw()
g <- g + xlab("Year") + ylab("PM2.5 Emissions (Tons)")
g <- g + ggtitle("Baltimore PM2.5 Emissions 1999-2008 By Type")
plot(g)
      

#title("Baltimore PM2.5 Emissions 1999-2008 By Type")

# Prepare plot for copy to png
dev.copy(png, "plot3.png")

# Inspect plot & confirm save to png
cat ("Press [enter] to save plot")
readline()
dev.off()
dev.off()