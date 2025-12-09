#09/12
#this code can be used to classify satellite data
library(terra)
library(imageRy)

im.list()
m1992<- im.import("matogrosso_l5_1992219_lrg.jpg")
m1992 #there are three layers: 1: NIR, 2= red, 3=green
plot(m1992)

 #exercise: import the image from 2006
m2006<- im.import("matogrosso_ast_2006209_lrg.jpg")
plot(m2006)

#testing the first type of classification: unsupervised classification
#solar orbiter: satellite from the ESA that monitors the Sun
sun<- im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
plot(sun) #we can see three levels of energy: yellow: highest energy, dark yellow: medium energy, black: low energy
#let's classify the energy levels:
?im.classify 
sunc<-im.classify(sun, num_clusters = 3) #we are stating the number of clusters that we expect

par(mfrow=c(2,1))
plot(sun)
plot(sunc)
