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

#21/11
#we are going to use a function to produce an igraph from a table
g<- graph_from_data_frame(interactions, vertices=species,directed=TRUE) 
#the vertices arguments specifies which are the points that are going to appear in the graph (in our case they will be the predators and the preys)
#directed means that there is a direction from the predators to the preys
plot(g)
g<- graph_from_data_frame(interactions, vertices=species,directed=F) #without directions
plot(g) #there are many potential graphs that we can obtain
# the set.seed function selects one of the possible graph that we can obtain
set.seed(42) #the number here is chosen at random
