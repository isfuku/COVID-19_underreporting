library(dplyr)
library(xts)
setwd("D:/Mestrado/2020-1/COVID19")

covid <- read.csv("Data/brazil_covid19.csv", encoding = "UTF-8") # data from kaggle

# creating a data.frame (dfc) that also contains Brazil number of cases
agg <- covid %>% group_by(date) %>% summarise(cases = sum(cases), deaths = sum(deaths))
agg$region = "Brasil"
agg$state = "Brasil"

dfc <- rbind(covid, agg)
names(dfc)[3] <- "UF"

# getting an epidemic week date reference (from portalsinan)
epidemic_week <- data.frame(week = 1, from = as.Date("2019-12-29"), 
                            to = as.Date("2020-01-04"))
for (i in 1:52){
        epidemic_week[i+1,] <- epidemic_week[i,] + c(1,7,7)
}

# aggregating covid data by epidemic week
dfc$date <- as.Date(dfc$date)
UFs <- levels(as.factor(dfc$UF))
covid <- data.frame(UF = NA, year = NA, week = NA, cases = NA, deaths = NA)
for(UF in UFs){
        data <- dfc[dfc$UF == UF,]
        data <- data[data$date %in% epidemic_week$to,]
        first_week <- epidemic_week$week[epidemic_week$to == data$date[1]]
        last_week <- epidemic_week$week[epidemic_week$to == data$date[nrow(data)]]
        data$week <- first_week:last_week
        data$year <- 2020
        data <- data[,-which(names(data) %in% c("region", "date")) ]
        covid <- rbind(covid, data)
        
}
covid <- covid[-1,]
rownames(covid) <- NULL

write.csv(covid, "Data/COVID.csv", fileEncoding = "UTF-8")
srag <- read.csv("Data/SARS.csv", encoding = "UTF-8")
flu <- read.csv("Data/SARSFLU.csv", encoding = "UTF-8")
srag <- srag[,-1]; flu <- flu[,-1]
names(srag)[c(2,3,6,7)] <- c("status_sars", "n_sars", "min_sars", "max_sars")
names(flu)[c(2,3,6,7)] <- c("status_flu", "n_flu", "min_flu", "max_flu")

df_agg <- merge(srag, covid, all.x = T, all.y = T, by = c("year", "week", "UF"))
write.csv(df_agg, "Data/COVID_SARS.csv", fileEncoding = "UTF-8")
df_agg <- merge(df_agg, flu, all.x = T, all.y = T, by = c("year", "week", "UF"))
df_agg <- df_agg[order(df_agg$year, df_agg$week),]
write.csv(df_agg, "Data/COVID_SARS_FLU.csv", fileEncoding = "UTF-8")
