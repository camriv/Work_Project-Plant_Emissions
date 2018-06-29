library(readxl)
library(dplyr)
library(lubridate)
library(ggplot2)


## let i refer to Pollutant
## let j refer to Pollutant Source (Plant Unit/Train)

## Combine data in one list for looping       
train <- c("Unit 1", "Unit 2", "Unit 3", "Unit 4")
data <- list()
for (j in 1:4) {
        data[[j]] <- read_xlsx("Plant-Emissions.xlsx",
                sheet = train[j], na = c("", "NT", "S/D", "T/A"))
        data[[j]][,"Date"] <- as.Date(data[[j]]$Date)
}
names(data) <- train

## Add periods for plotting
pos <- as.Date("1/1/2017", format = "%m/%d/%Y") 
for (j in 1:4) {
        data[[j]] <- mutate(data[[j]], Source = as.factor(train[j]),
                Year = as.factor(year(Date)),
                Quarter = as.factor(paste0(Year, " ", quarter(Date), "Q"))
        )
}

## Combine data in one data frame for plotting
full <- data.frame()
for (j in 1:4) {
        full <- rbind(full, data[[j]])
}


## Create Plots

## Create "pol" data frame for looping
pol <- data.frame(
        type = c("SOx", "NOx", "CO", "PM"),
        Dlim = c(700, 1000, 500, 150),
        stringsAsFactors = FALSE
)

th <- theme(plot.title = element_text(size = 30, face = "bold"),
            plot.subtitle = element_text(size = 18),
            axis.text = element_text(size = 12),
            axis.title = element_text(size = 14),
            strip.text.x = element_text(face = "bold", size = 20))
labs <- labs(subtitle = "2Q 2015 - 3Q 2017", y = "Concentration (mg/Nm3)")
ticks <- scale_x_date(breaks = as.Date(c("1/1/2016", "1/1/2017"),
        format = "%m/%d/%Y"), labels = c("2016", 2017))


## 1. Create Scatter Plots for Exploratory Analysis
for (i in 1:4){
        png(paste("Scatter", pol$type[i], ".png"),
                width = 640, height = 480) 
        print({
                ggplot(full, aes_string(x = "Date", y = pol$type[i])) +
                facet_grid(facets = . ~ Source) + th + labs + ticks +
                geom_point(shape = 1, size = 4) +
                geom_point(data = filter_(full,
                                paste(pol$type[i], ">", pol$Dlim[i])),
                        col = "red", alpha = 0.5, size = 4) +
                geom_hline(yintercept = pol$Dlim[i], col = "red") +  
                geom_text(aes(x = pos, y = pol$Dlim[i],
                        label = paste(pol$Dlim[i], "mg/Nm3"),
                        vjust = -0.5), size = 5) +     
                labs(title = paste(pol$type[i], "Emissions")) 
        })   
        dev.off()
}

## Massive SOx and NOx outliers were submitted in the company's self-monitoring 
## reports for 4th quarter 2015. Even though the magnitude indicate these are 
## highly probable erroneous data, these data cannot be removed from the presentation 
## as these were already submitted to regulatory bodies. Instead, the plots were 
## bound using limits in the y-axes to avoid the outliers to squish the plots down.

pol <- mutate(pol, ylim = c(1500, 1000, 500, 150))


## 2. Create bound box plots per whole Time
for (i in 1:4){
        png(paste("BoxT", pol$type[i], ".png"),
            width = 640, height = 480) 
        print({
                ggplot(full, aes_string(x = "Source", y = pol$type[i])) + th + labs +
                coord_cartesian(ylim = c(0, pol$ylim[i])) +
                stat_boxplot(geom ="errorbar", width = 0.1, size = 0.8) +
                geom_boxplot(fill = "turquoise", outlier.size = 4,
                        outlier.shape = 1) +
                geom_hline(yintercept = pol$Dlim[i], col = "red") +
                geom_text(aes(x = 2.5, y = pol$Dlim[i],
                        label = paste(pol$Dlim[i], "mg/Nm3"),
                        vjust = -0.5), size = 5) +
                labs(title = paste(pol$type[i], "Emissions"))
        })
        dev.off()
}

## For SOx almost all values above the 3rd quartile of all Units exceed limits.
## These plots do not show that the company had been fully compliant since the 
## last quarters of 2017.



## 3. Create bound box plots per year
for (i in 1:4){
        png(paste("BoxY", pol$type[i], ".png"),
            width = 640, height = 480) 
        print({
                ggplot(full, aes_string(x = "Year", y = pol$type[i])) +
                facet_grid(facets = . ~ Source) + th + labs +
                coord_cartesian(ylim = c(0, pol$ylim[i])) +
                stat_boxplot(geom ="errorbar", width = 0.1, size = 0.8) +
                geom_boxplot(fill = "turquoise", outlier.size = 4,
                        outlier.shape = 1) +
                geom_hline(yintercept = pol$Dlim[i], col = "red") +
                geom_text(aes(x = 2.5, y = pol$Dlim[i],
                        label = paste(pol$Dlim[i], "mg/Nm3"),
                        vjust = -0.5), size = 5) +
                labs(title = paste(pol$type[i], "Emissions"))
        })
        dev.off()
}

## Even though box plots plotted per year already shows the great improvement of
## the company in following regulatory limits by year 2017, it did not show the
## progressive improvement within 2017 particularly in SOx for which 2017 box
## plots still have whiskers extending beyond the regulatory limits.


## 4. Create bound box plots per quarter
for (j in 1:4) {
        for (i in 1:4){
                png(paste("BoxQ", pol$type[i], train[j], ".png"),
                        width = 640, height = 480)
                print({
                ggplot(data[[j]], aes_string(x = "Quarter", y = pol$type[i])) +
                coord_cartesian(ylim = c(0, pol$ylim[i])) + th + labs +
                stat_boxplot(geom ="errorbar", width = 0.1, size = 0.8) +
                geom_boxplot(fill = "turquoise", outlier.size = 4,
                        outlier.shape = 1) +
                geom_hline(yintercept = pol$Dlim[i], col = "red") +
                geom_text(aes(x = 2.5, y = pol$Dlim[i],
                        label = paste(pol$Dlim[i], "mg/Nm3"),
                        vjust = -0.5), size = 5) +
                labs(title = paste(train[j], pol$type[i], "Emissions"))
                })
                dev.off()
        }
}

## Plotting per quarter highlights the effect of extreme outlier data for
## 2015 4th Quarter SOx values of all Units.


## 5. Create bound box plots per year in 2015-2016; quarter in 2017

full <- mutate(full, Period = ifelse(Date < pos, levels(Year)[Year], 
        levels(Quarter)[Quarter]))

for (i in 1:4){
        png(paste("BoxP", pol$type[i], ".png"),
            width = 1120, height = 480) 
        print({
                ggplot(full, aes_string(x = "Period", y = pol$type[i])) +
                facet_grid(facets = . ~ Source) + th + labs +
                coord_cartesian(ylim = c(0, pol$ylim[i])) +
                stat_boxplot(geom ="errorbar", width = 0.1, size = 0.8) +
                geom_boxplot(fill = "turquoise", outlier.size = 4,
                     outlier.shape = 1) +
                geom_hline(yintercept = pol$Dlim[i], col = "red") +
                geom_text(aes(x = 2.5, y = pol$Dlim[i],
                      label = paste(pol$Dlim[i], "mg/Nm3"),
                      vjust = -0.5), size = 5) +
                labs(title = paste(pol$type[i], "Emissions"))
        })
        dev.off()
}

## When data are plotted yearly in 2015 & 201 and quarterly in 2017, almost all 
## of the box plots now have whiskers below regulatory limits. The medians are 
## also progressing downwards from 1Q to 3Q 2017. 

## These are the final plots proposed to management and which they found acceptable.



## EXTRA: Analyze Exceedances
     
exlist <- list()
for (i in 1:4) {
        exlist[[i]] <- filter_(full, paste(pol$type[i], ">", pol$Dlim[i]))
}
names(exlist) <- c("exSOx", "exNOx", "exCO", "exPM")

exdata <- data.frame()
for (i in 1:4) {
        exdata <- distinct(bind_rows(exdata, exlist[[i]]))
}

write.csv(exdata, file = "Plant-Emissions-exceedances.csv", row.names = FALSE)

## END

