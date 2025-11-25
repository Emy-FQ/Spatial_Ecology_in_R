#21/11
#code to visualize remote sensing data
install.packages("imageRy")
library(imageRy)
#all the functions of imageRy start with "im."
im.list() #this allows us to see al the functions
#zenodo is a site where we can find and upload opensource data (?)
#zenodo set: https://zenodo.org/records/15645465

#25/11
library(terra)
#we are going to use some data from Sentinel (European satellite)
#in remote sensing data the different layers of wave length that the sensor capt are called bands
#the band 2 is the blue one: all of the objects that reflect part or all the blue light
b2<-im.import("sentinel.dolomites.b2.tif")
plot(b2)
#this image represents Tofane (near Bolzano in the middle of the Dolomites)
#in the graph we can see the coordinates ( remember that in the x axis the real distance from the central meridian is n-500.000 due to the false origin)
#the color palette is based on the viridis palette of the viridis package 
#the color yellow represents the zones where the blue wave length is reflected the most, while the dark blue zones are absorbing the blue wave legnth
library(viridis)
plot(b2,col=magma(100))

#let's import another band: b3, which corresponds to the green wave length (central wavelength: 560 nm)
b3<- im.import("sentinel.dolomites.b3.tif")
plot(b3) 
#we can modify the palette to make a gray scale image
cl<- colorRampPalette(c("black","grey","white"))(100)
plot(b3,col=cl)
#using multiframe to plot one beside the other b2 and b3
#instead of using par and mfrow we can use a function from imagery
im.multiframe(1,2) #actually it doesn't work
plot(b2,col=cl)
plot(b3, col=cl)
par(mfrow=c(1,2))
plot(b2,col=cl)
plot(b3, col=cl)
# the two bands are very similar, since the reflectance of green and blue is very similar 
#the im.multiframe from CRAN doesn't work, we can try to use the one in github:
im.multiframe <- function(x,y){
  par(mfrow=c(x,y))}
plot(b2,col=cl)
plot(b3, col=cl)

#to prove that the blue and green wave length have a similar reflectance we can build a scatter plot of the single pixels from b2 and b3
dev.off()
plot(b2,b3) #we can see that the two bands plotted one on top of the other are very correlated 
#the graph is plotting 10% of the pixels, a sample of the total

#let's import the band n.4, the red wave length
b4<- im.import("sentinel.dolomites.b4.tif")
plot(b4)
plot(b4, col=cl)

#let's import the infrared wave length: n.8, called NIR (near infra red), with a wave length of 842nm
b8<- im.import("sentinel.dolomites.b8.tif")
plot(b8) #the near infrared has an higher discrimination power than the bands in the visible spectrum
im.multiframe(1,2)
plot(b4)
plot(b8)

#build your own function for plotting:
#to build a function we need to use a function called "fucntion"
duccio<-function (x,y){par(mfrow=(c(1,2)))} 
#exercise: build a multiframe of 2 rows and two coloums with the function we just created
dev.off
duccio(2,2)
plot(b2)
plot(b3)
plot(b4)
plot(b8)

#exercise: create a multiframe with 1 row and 2 colums
duccio(1,2)
plot(b2,b3)
plot(b2,b8) 
#since the NIR is not correlated to the visible spectrum, it is adding information

