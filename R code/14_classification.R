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

#apply the classification process to the Mato Grosso area
dev.off()
plot(m1992) #there are two main classes: forest and human related areas
m1992c<-im.classify(m1992, num_clusters = 2)
#class 1: human related + water
#class 2: forest

#exercise: classify the 2006 image
m2006c<- im.classify(m2006, num_clusters = 2)
#class 1: human related + water, class 2: forest

#we are going to compare the 1992 and the 2006 images

#calculating frequencies
f1992<-freq(m1992c)
f1992 #there are more than 1mln of the forest pixels, and around 300k human related pixels

#proportion: f/tot
tot1992c <- ncell(m1992c)
tot1992c
prop1992=f1992$count/tot1992c #we use the "=" because it is a matematical proportion
prop1992
 #now we can calculate the percentages:
perc1992=prop1992*100
perc1992
#1992: human areas=17% and forests=83%

#exercise: calcualte the percentages of the 2006 image
perc2006=freq(m2006c)*100/ncell(m2006c)
perc2006
#2006: human=55%, forest=45%

#let's implement a dataframe with three columns
#class
#perc1992
#perc2006

class<-c("forest","human")
perc1992<-c(83,17)
perc2006<-c(45,55)
tabout<-data.frame(class, perc1992, perc2006)
tabout

#use ggplot2 package (which is used to make graphs, there is a free book on it) for the final graph
library(ggplot2)
p1<-ggplot(tabout, aes(x=class, y=perc1992, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))
#the first thing we put is the name of the data frame, then we need to put the aesthetics which are the x axis, the y axis, and the colour, after the plus we write the type of graph we want to make, (geom_points, or geom_lines, or geom_ bar), we are making an histogram, so geom_bar.

#exercise: make the second graph for 2006
p2<-ggplot(tabout, aes(x=class, y=perc2006, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))

#let's plot one graph beside the other using the patchwork r package (it can be used paired with ggplot)
library(patchwork)
p1+p2
#one plot on top of the other:
p1/p2

#with the p1+p2 graph there is a problem: we are not seeing a big loss in forest areas because the scale is different in the two graphs
#to correct this we use the ylim function (already did in this case), setting the limits from 0 to 100 in both graphs


