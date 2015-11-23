## Script to compare motor-vehicle PM2.5 emissions in Baltimore & Los Angeles over 9 years

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

# Filter SCC codes by vehicle  sources
SCC_vehicle <- unique(SCC %>% filter(grepl("vehicle", SCC$EI.Sector, ignore.case = TRUE)) %>% select(SCC))
SCC_vehicle <- sapply(SCC_vehicle, as.character)
NEI_vehicle <- NEI %>% filter((fips == "24510" | fips == "06037") & SCC %in% SCC_vehicle)

# Group data by year & region
by_year <- NEI_vehicle %>% group_by(year, fips)
year_sum <- by_year %>% summarize(total = sum(Emissions))

# Change factor labels for plot
year_sum$fips <- factor(year_sum$fips)
levels(year_sum$fips) <- c("Los Angeles County", "Baltimore")

## Create ggplot w/ facets
g <- (ggplot(data = year_sum, aes(year, total))
      + geom_smooth(method = "lm", level = 0.8, col = "Black", lwd = 1.5)
      + geom_point(col = "Blue", size = 4)
      + facet_grid(fips~., scales = "free_y")
      + theme_bw()
      + xlab("Year") + ylab("PM2.5 Emissions (Tons)")
      + theme(strip.text.y = element_text(size = 15, face = "bold"),
              axis.text = element_text(size=16),
              axis.title = element_text(size=18, face = "plain"),
              title = element_text(size=18, face = "bold"))
      + ggtitle("Motor Vehicle PM2.5 Emissions 1999-2008 By Region"))
plot(g)


# Prepare plot for copy to png
ggsave("plot6.png", dpi = 90)