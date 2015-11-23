## Script to investigate coal-related PM2.5 emissions throughout US over 9 years

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

# Filter SCC codes by coal combustion sources
SCC_coal <- unique(SCC %>% filter(grepl("Comb.*Coal", SCC$EI.Sector, ignore.case = TRUE)) %>% select(SCC))
SCC_coal <- sapply(SCC_coal,as.character)
NEI_coal<- NEI %>% filter(SCC %in% SCC_coal)

# Group data by year
by_year <- NEI_coal %>% group_by(year)
year_sum <- by_year %>% summarize(total = sum(Emissions))
year_sum$total <- round(year_sum$total/1000,2)

## Create ggplot w/ facets
g <- (ggplot(data = year_sum, aes(year, total))
      + geom_smooth(method = "lm", level = 0.8, col = "Black", lwd = 1.5)
      + geom_point(col = "Blue", size = 4)
      + theme_bw()
      + xlab("Year") + ylab("PM2.5 Emissions (Thousand Tons)")
      + theme(axis.text = element_text(size=16),
              axis.title = element_text(size=18, face = "plain"),
              title = element_text(size=18, face = "bold"))
      + ggtitle("Total US Coal-Related PM2.5 Emissions 1999-2008"))
plot(g)
      

# Prepare plot for copy to png
ggsave("plot4.png", dpi = 90)