install.packages("sdm")
library(sdm)
install.packages("terra")
library(terra)
file <- system.file("external/species.shp", package="sdm") #searching for file species.hsp (a shape file, not open source) in the folder external inside the package sdm
file
#using the vect function to create a SpatVector, a vector (points: vector of two coordinates, lines, and polygons) of coordinates in space
rana <- vect(file)
rana #there are 200 points with a table related to the points containing all the data
plot(rana)
dev.off()
plot(rana) #we see the distribution in space of the occurrence of this species in the samples (each point could be 1 if there is the species, or 0 if there was no occurrence)
rana$Occurrence #these are the data stored for each point that we see in teh graph

