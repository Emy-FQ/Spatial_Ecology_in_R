#19/12
# Script to measure variability in remotely sensed imagery

library(imageRy)
library(terra)

im.list()

sent <- im.import("sentinel.png")
#layer 1: NIR, layer 2:red, layer 3: green
im.plotRGB(sent,r=1,g=2,b=3)
#we are in area of the Similaun glacier
#the area in red are covered in vegetation cropland and woodland(darker red), while the bluish parts are bare rocks

im.plotRGB(sent,r=2,g=1,b=3) #green overriding the NIR
im.plotRGB(sent,r=2,g=3,b=1) #this is the best rappresentation to enhance the bare soil

#we can measure the variability using standard deviation
#in the Terra package there is a function called "focal" that can be used to calculate any statistics
?focal #"w" defines the dimension of the moving window, for example 3x3 pixels
#using this function we can calculate only one value at a time, so only one band at a time

#let's calculate the mean of the NIR
sentmean<-focal(sent[[1]], w=3, fun="mean")
plot(sentmean) #since it is a 8-bit image it ranges from 0 to 255

nir <- sent[[1]]
nir

#let's calculate the standard deviation
sd3<-focal(nir, w=3, fun="sd") #avoid to call the object "sd" to avoid confusing it with the function
plot(sd3)


library(ggplot2)
library(viridis)
p1<-im.ggplot(nir)
p2<-im.ggplot(sentmean)
p3<-im.ggplot(sd3)
p1 + p2 + p3 #doesn't work, check why

plot(sd3, col=magma(1000))

#copy the ggplotRGB function from the imagery repository on the prof's github
#didn't work

sd5<-focal(nir, w=5, fun="sd")

#check the prof's code bc the last things are missing here, and many didn't work
