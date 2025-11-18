#checking the relationships, in terms of food-web relationships, between species
install.packages("igraph")
library(igraph)
 #let's build a network of different species: in this case with marine species
species<- c("Algae", "Zooplankton", "Small Fish", "Large Fish", "Bird")
predator<- c("Zooplankton","Small Fish","Large Fish","Bird","Bird")
prey<- c("Algae","Zooplankton","Small Fish","Small Fish","Large Fish")
#in the prey and predator groups the order is not causual, they are paired, so each prey predator correspond to a prey (e.g. the xooplankton is the predator of the algae etc)
interactions <- data.frame(predator,prey) #this build a table, a dataset with the predator-prey interactions
interactions
