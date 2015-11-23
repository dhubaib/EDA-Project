## Script to investigate total PM2.5 emissions in the US over 9 years

## Script to load NEI data from EPA for processing
library(data.table)
library(dplyr)

# Don't re-load data if already in memory...
if(!exists("NEI") || (exists("NEI")&nrow(NEI) != 6497651))
{
  NEI <- readRDS("summarySCC_PM25.rds") # National Emissions Invetory
  SCC <- readRDS("Source_Classification_Code.rds") # Classification codes for SCC col in NEI
}

## Plot total emissions from all sources 1999-2008

# Group data by emission-type & year
by_year <- NEI %>% group_by(year)
year_sum <- by_year %>% summarize(total = sum(Emissions))
# Create point-plot using base system
year_sum$total <-round(year_sum$total/1000000,2) # Scale by millions

plot(year_sum,
     pch = 15,
     col = "Blue",
     xlab = "Year",
     ylab = "Total Emissions (Million Tons)",
     cex = 1.25)

lines(year_sum, # Include line to emphasize trend..
      lwd = 2,
      col = "Black")
title("US PM2.5 Emissions Decreasing 1999-2008")

# Prepare plot for copy to png
dev.copy(png, "plot1.png")

# Inspect plot & confirm save to png
cat ("Press [enter] to save plot")
readline()
dev.off()
dev.off()