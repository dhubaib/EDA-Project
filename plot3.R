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

## Create ggplot w/ facets
g <- (ggplot(data = year_sum, aes(year, total))
      + geom_smooth(method = "lm", level = 0.8, col = "Black", lwd = 1.5)
      + facet_grid(.~type)
      + geom_point(col = "Blue", size = 4)
      + theme_bw()
      + xlab("Year") + ylab("PM2.5 Emissions (Tons)")
      + theme(axis.text.x = element_text(angle=45),
              axis.text = element_text(size=16),
              axis.title = element_text(size=18, face = "plain"),
              title = element_text(size=18, face = "bold"))
      + ggtitle("Baltimore PM2.5 Emissions 1999-2008 By Type"))
plot(g)
      

# Prepare plot for copy to png
ggsave("plot3.png", dpi = 90)