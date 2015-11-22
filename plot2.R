## Script to investigate total PM2.5 emissions in Baltimore over 9 years

## Script to load NEI data from EPA for processing
library(data.table)
library(dplyr)

# Don't re-load data if already in memory...
if(!exists("NEI") || (exists("NEI")&nrow(NEI) != 6497651))
{
  NEI <- readRDS("summarySCC_PM25.rds") # National Emissions Invetory
  SCC <- readRDS("Source_Classification_Code.rds") # Classification codes for SCC col in NEI
}

## Plot total emissions from baltimore 1999-2008

NEI_baltimore <- NEI %>% filter(fips == 24510)
# Group data by year
by_year <- NEI_baltimore %>% group_by(year)
year_sum <- by_year %>% summarize(total = sum(Emissions))
# Create point-plot using base system
year_sum$total <-round(year_sum$total/1000,2) # Scale by thousands

plot(year_sum,
     pch = 15,
     xlab = "Year",
     ylab = "Total Emissions (Thousand Tons)")

lines(year_sum, # Include line to emphasize trend..
      lty = 2,
      lwd = 2,
      col = "Blue")
title("Baltimore PM2.5 Emissions 1999-2008")

# Prepare plot for copy to png
dev.copy(png, "plot2.png")

# Inspect plot & confirm save to png
cat ("Press [enter] to save plot")
readline()
dev.off()
dev.off()