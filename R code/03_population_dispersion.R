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

#17/10
#occurrence is not related to the presence of the organism, the occurrence can be the presence or the absence (1 or 0). The absence can be recorded either when it is a real absence or when the organism was not seen, there is uncertainty.
plot(rana)
rana$Occurrence
#we can divide the presences and the absences
pres <- rana[rana$Occurrence==1] #we are making a subset, the == means that we are selecting all the occurrences that are equal to 1
pres #we see 94 points, so most of the point were absences
plot(pres)
#select all the absences:
abse <- rana[rana$Occurrence==0]
abse
plot(abse)
abse$Occurrence
pres$Occurrence

#plot the presences with the colors together with thw absences with another color
plot(pres, col="chartreuse1") #we could also use the html color codes #7FFF00
points(abse, col="deeppink") #we cannot use plot beacuse the second graph would have overlapped th e previous

#do the same in multiframe with two sets: pres on top of the other
par(mfrow=c(2,1))
plot(pres, col="chartreuse1")
plot(abse, col="deeppink")
