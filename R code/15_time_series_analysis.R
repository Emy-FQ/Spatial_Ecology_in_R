#16/12
# time series analysis in R
library(terra)
library(imageRy)
im.list()
#importing data
EN01<- im.import("EN_01.png" ) #data on the NO2 concentrations
#flipping the data
EN01<-flip(im.import("EN_01.png" ))
plot(EN01) #before the lockdown, we can see high concentration of NO2 in the northern part of italy, in Madrid, Paris, and also several other cities

EN01 #we can see the values, the min is 0 and the max is 255. This is the same range we saw for the reflectnace in teh matogrosso dataset (explanation on virtuale: reflectance ppt)
# the radiometric resolution is 8 bit

EN13<- flip(im.import("EN_13.png" ))
plot(EN13) #No2 concentration in March, during lockdown, the values have decreased in most of the areas
EN13 #the radiometric resolution is 8-bit

#differnce between the two images to see in which parts there are the higher differnces
diffEN <- EN01[[1]]- EN13[[1]] #differnce between the first layer of january and the first layer of march
diffEN #it ranges from -255 to 255
plot(diffEN) #in most of the EU countries the values were higher in january. There are also some areas in which in march teh values were higher, for example where industries are concentrated

#we can make ridgeline plots to show the frequency of certains values 
install.packages("ggridges")
library(ggridges)
library(ggplot2)
?im.ridgeline
#importing data from the Tofane area in the Dolomites:
ndvi<-im.import("NDVI_2020")
ndvi
im.ridgeline(ndvi,scale=1)
#the names of the layers in the file are all "NDVI", so they override eachother, tha's why we only see one plot instead of four
names(ndvi) = c("02_feb","05_may","08_aug","11_nov")
ndvi #we changed the names of the layers 
plot(ndvi)
im.ridgeline(ndvi,scale=1)
im.ridgeline(ndvi,scale=2) #the scale is a parameter to enhance the differences, 2 is a good value
im.ridgeline(ndvi, scale=10) #like this the graph becomes unreadable


#example: ice melt in Greenland
im.list()
gr<-im.import("greenland")
gr 
plot(gr) #in the plots we can see the temperatures of the area
names(gr) = c("y2000","y2005","y2010","y2015")
plot(gr)
difgr = gr[[1]]-gr[[3]]
plot(difgr)
library(viridis) #we can change the legend and the colors
plot(difgr, col=magma(100))
im.ridgeline(gr, scale=2)

#example 2: ridgeline plotting with an external image
p2<-rast("p2.png")
im.ridgeline(p2,scale=2) #the one at the top is a control layer, so we can remove the fourth layer
p2 <- c(p2$p2_1,p2$p2_2,p2$p2_3)
plot(p2)
im.ridgeline(p2, scale=2)
p1<-rast("p1.png")
p1
p1 <- c(p1$p1_1,p1$p1_2,p1$p1_3)
plot(p1)
im.plotRGB(p1, 1,2,3)
im.ridgeline(p1,scale=2) #skewed toward lower values since the reflectance was lower in this image

#tidyverse
library(patchwork) #when using this library we need to use only ggplot functions, that's why we used ggplot instead of plot
plot1<-im.ggplot(p1[[1]])
plot2<-im.ggplot(p2[[1]])
plot3<-im.ridgeline(p1,scale=2)
plot4<-im.ridgeline(p2, scale=2)

plot1+plot2+plot3+plot4

