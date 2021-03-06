library(dplyr)
library(ggplot2)

setwd("D:/Mestrado/2020-1/COVID19")

# empty data.frame to be filled
srag = data.frame(Unidade.da.Federa��o = NA, Situa��o = NA, N�mero.de.casos = NA,
                  n = NA, year = NA, week = NA)

# loop over weekely files of SRAG reports, and adds them to the srag data.frame
for (year in 2009:2020){
        for (week in 1:52){
                if(year == 2020 & week >= 14){
                        break
                }
                file = paste0("SRAG/SRAG_", year, "_", week, ".csv")
                dff <- read.csv(file, encoding = 'UTF-8', stringsAsFactors = F)
                if (nrow(dff) > 0){
                        dff$n <- gsub( " .*$", "", dff$N�mero.de.casos)
                        dff$year <- year
                        dff$week <- week
                        srag <- rbind(srag, dff)
                }
        }
}
srag$min <- ifelse(srag$Situa��o == "Estimado. Sujeito a altera��es.",
                     sub(' -.*', '', sub('.*\\[', '', srag$N�mero.de.casos)), srag$n)
srag$max<- ifelse(srag$Situa��o == "Estimado. Sujeito a altera��es.",
                     sub('].*', '', sub('.*\\- ', '', srag$N�mero.de.casos)), srag$n)

# making it look a little better
srag <- srag[-1, which(names(srag) %in% c("Unidade.da.Federa��o", "Situa��o", 
                                          "n", "year", "week", "min", "max"))]
names(srag)[1:2] <- c("UF", "status")

# verify if we good all weeks
tab <- table(srag$year, srag$week) %>% as.data.frame()
tab[tab$Freq != 28,]

write.csv(srag, "Data/SARS.csv", fileEncoding = "UTF-8")
