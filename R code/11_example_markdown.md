# This is an example of code fot the exam

## How to import external data in R

the packages needed in thsi script are the following:
```r
library(terra) #package for managing raster and vector data
library(imageRy) #analysing RS data
```

In order to import data in R we should set the working directory:

```r
library(terra)
setwd(C:\Users\Emyfq\OneDrive\Documents\UNI\GLOBAL CHANGE ECOLOGY AND SDGs\Spatial ecology) #this function allows us to set the working directory
```
```r
To check for the folder you can make use of:
```
getwd()
```
The import of the data is done by:
```r
group<- rast("image.JPG")
```
to get info on the image, digit its name by: 
```r
group
```
## Visualizing the data
In order to plot the image we will use the RGB scheme
```r
im.plotRGB(group, r=1, g=2, b=3)
```
The image is flipped, we can fix this using the flip() function
```r
group<-flip(group)
im.plotRGB(group, r=1, g=2, b=3)
```

The output plot can be exported by the png() function
```r
png("group_photo.png")
im.plotRGB(group, r=1, g=2, b=3)
dev.off()
```
The output image looks like:
<img width="480" height="480" alt="group_photo" src="https://github.com/user-attachments/assets/a5fe2d7b-ef23-4ac7-b41c-c1c5842fdc60" />

let's invert the bands to create a false color image:
```r
png("group_photo_false.png")
im.plotRGB(group, r=2, g=1, b=3)
dev.off()
```
The false color image is something like:
<img width="480" height="480" alt="group_photo_false" src="https://github.com/user-attachments/assets/38f8e734-4ab5-46c2-8cb7-aca53ed39c0a" />
