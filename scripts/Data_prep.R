rm(list = ls())

library(tidyr)
library(dplyr)
library(magrittr)
library(stringr)
library(readr)
library(xts)
library(ggplot2)

TrainingSet <- read.csv("data/TrainingSet.csv")
SubmissionRows <- read.csv("data/SubmissionRows.csv")

SubmissionLabels <- SubmissionRows$X

names(TrainingSet) <- str_replace_all(names(TrainingSet), c(" " = "." ))

TrainingSet <- TrainingSet %>% 
               rename(Label = X) %>%
               select(-c("Series.Code"))

#TrainingTS <- ts(TrainingSet, start = 1972, frequency = 1)

TrainingSet.Short <- filter(TrainingSet, Label %in% SubmissionLabels)

TrainingSet.Short.Tidy <- TrainingSet.Short  %>% 
                          unite(Series,Label,Country.Name,Series.Name,sep=" - ") %>%
                          gather(Year, Value, -Series) %>% 
                          separate("Year", c("Year", "todrop")) %>%
                          select(-c(todrop))

#TrainingSet.Short.Tidy$Year <- as.Date(TrainingSet.Short.Tidy$Year, format='%y')

TrainingSet.Short.Wide <- TrainingSet.Short.Tidy %>%
                          spread(Year, Value)

DataYears <- as.Date(colnames(TrainingSet.Short.Wide[,2:37]), "%Y")

TSV = vector()
for (r in 1:nrow(TrainingSet.Short.Wide))
{
  xts(x = t(TrainingSet.Short.Wide[r,2:37]), order.by = DataYears)
}

write.csv(TrainingSet.Short.Wide, file = "output/TrainingSet.Short.Wide.csv", na="")

SubmissionLabels.Long <- TrainingSet.Short.Wide$Series


#for (sl in SubmissionLabels.Long) 
#{
#  p = ggplot(data = TrainingSet.Short.Tidy[which(TrainingSet.Short.Tidy$Series == sl),], aes(x  = Year, y = Value)) +
#      geom_point() +
#      geom_smooth(method = "lm",
#                  formula = y ~ poly(x, 2),
#                  se = TRUE,
#                  col = "#C42126",
#                  size = 1) +
#      ggtitle(sl)
#  print(p)
#}


