#02/12
# spectral indices from satellite images
library(terra)
library(imageRy)
library(viridis)

#listing files
im.list()

#importing the image
m1992<-im.import("matogrosso_l5_1992219_lrg.jpg")
#we can search the name of the file on google, we will see that it is from the earth observatory site
m1992
#layer1 = NIR, layer2= red, layer3 = green
im.plotRGB(m1992, r=1,g=2,b=3) #we are putting the NIR on top of the red
#putting the NIR on top of the green
im.plotRGB(m1992,r=2,g=1,b=3)
im.plotRGB(m1992,r=2,g=3,b=1) #this highlights the soil

#exercise: import the 2006 images
m2006<-im.import("matogrosso_ast_2006209_lrg.jpg")
im.plotRGB(m2006, r=1, g=2, b=3)
#we can build a spectral index
#let's build a DVI (Difference Vegetation Index) which is the difference between th NIR and the red 
#100 NIR
#0 red
#DVI= NIR- red
#stressed leaves have a lower capability of reflecting the NIR, so the NIR could be 60, the reflectance of the red will be higher, for example 20
#In this last case the DVI would be 40
dvi1992 <- m1992[[1]]-m1992[[2]]
dvi2006 <- m2006[[1]]-m2006[[2]]
par(mfrow=c(1,2))

plot(dvi1992, col=inferno(100)) 
plot(dvi2006, col=inferno(100))

#let's calculate the NDVI (see slides)
ndvi1992<-im.ndvi(m1992,1,2)
ndvi2006<-im.ndvi(m2006,1,2)
par(mfrow=c(1,2))
plot(ndvi1992)
plot(ndvi2006)
