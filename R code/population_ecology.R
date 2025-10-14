install.packages("spatstat")
library(spatstat)
plot(bei)
plot(bei.extra)
#how to plot only the elevation
plot(bei.extra$elev)
#there is another method in which we subset the dataset putting the number of the variable
plot(bei.extra[[1]])
plot(bei.extra[[2]])
el<- bei.extra[[1]]
plot(el)
#how to produce a density map: we are transforming (points) vectors into (map) rasters
?density
density(bei)
beidens<-density(bei)
plot(beidens)
plot(el)
#el is basically the opposite of the density, so at higher elevations we have lower amounts of trees
plot(beidens)
points(bei, cex=.2)
