#11/11
#This code is analysing the temporal overlap between species (we can also do i among species, with 3 or more)
#we use the overla function which provides a kernel density function, which creates a continous graph
install.packages("overlap")
library(overlap)
data(kerinci)
kerinci
head(kerinci) #the time in the data set is indicated by imagining time from 0 to 1 in a day
#we are going to change the time in radiants, so from a linear to a circular dimension
circulartime<-kerinci$Time*2*pi
circulartime #we are going to put these data in the data table:
kerinci$circ<-kerinci$Time*2*pi #the $ links the variable to the data
head(kerinci)

#subsetting a single species, in this case the tiger
tiger<-kerinci[kerinci$Sps=="tiger",] #== means equal while != means not equal in the sql language #the comma is important to define the colums
#now we can create an object in which we can put the circualr time for the tiger
timetiger<-tiger$circ

densityPlot(timetiger)
#we can see that the times at which the tiger moves more are 6AM and around 6PM

#18/11
#exercise: repeat the graph for the macaque
macaque<- kerinci[kerinci$Sps=="macaque",]
timemacaque<- macaque$circ
densityPlot(timemacaque)
#to consider two different times in the data set and compare them, we can use the function "overlapPlot":
dev.off() #to close the window since we used par before
overlapPlot(timetiger,timemacaque)



