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
