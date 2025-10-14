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

#14/10
library(spatstat)
plot(bei)
dmap<-density(bei)
plot(dmap)
points(bei)
plot(dmap)
points(bei, cex=0.5)
points(bei, cex=0.2)
bei.extra
plot(bei.extra)

#plotting together the density map and the elevation
el<- bei.extra[[1]] #it is the elevation contained in the data set, we used two square brackets bc we are dealing with raster data, we could also do this with the dollar 
plot(el)

#one object is dmap and the other is el, so the question is how to plot dmap beside el?
par(mfrow=c(1,2)) #we are creating a multiframe: we are putting in the same graph several plots, following a certain scheme. Now we are plotting in one single row and two columns. At the moment nothing happens, we created a virtual space
plot(dmap)
plot(el)

#plot dmap on top of el (instead of one beside the other)
par(mfrow=c(2,1))
plot(dmap)
plot(el)
#the problem here is Rstudio if the graphs are really tiny bc it uses the resolution of the computer, using R is better

#introducing a new function that closes any graphical device
dev.off()

#changing the colors of the map (there are many possibilities, now we introduce one)
cl <- colorRampPalette(c("green", "red","blue")) #the function extends a color palette in a color ramp (remember that R is case sensitive)
plot(dmap, col=cl) #this palette and the rinbowcol palette should be avoided bc they cannot be seen by color blind people

cl <- colorRampPalette(c("green", "red","blue"))(100) #selecting the number of intermediate colors from a color to another
plot(dmap, col=cl)

#in the site R charts we can search r colors, where we can see all the colors in R:
#https://r-charts.com/colors/
cl2<- colorRampPalette(c("darkseagreen","hotpink","mediumpurple"))
plot(dmap, col=cl2)

#plot the dmap with two different colors ramps, one on top of the other
par(mfrow=c(2,1))
plot(dmap, col=cl)
plot(dmap, col=cl2)



