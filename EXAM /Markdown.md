# Remote sensing of algal blooms: the case of Lough Neagh
### 07/09/2026 exam - Spatial Ecology in R 
#### Emy Filippi Quintussi

## 1. Introduction 

Lough Neagh is UK's largest freshwater lake, it is situated in Northern Ireland, spanning around 380 square kilometres. 
In recent years it has been affected by severe algal blooms, raising concerns about the safety of the drinking water drawn from it, negatively impacting local activities and posing threats to biodiversity. 

During the year 2023, the lake experienced a particularly intense proliferation of cyanobacteria (i.e. the microorganisms causing algal blooms), due multiple causes, such as: eutrophication caused by agriculture run-off, global warming, invasive species, and the calm weather conditions of that year.

Remote sensing can be a useful tool for monitoring algal blooms, allowing spatial observations that couldn’t be possible with traditional in-situ sampling.

<p align="center">
  <img src="Images/Lough_neagh.png">
</p>

###  Aim of the analysis
The aim of this analysis is to utilise remote sensing techniques to monitor the algal blooms of Lough Neagh during the year 2023, comparing their intensity across seasons.

## 2. Methodology overview 
### 2.1 Time period
In this analysis the four metereological seasons of the year 2023, starting from spring, were monitored:

 - spring: 01/03 - 31/05/2023
 - summer: 01/06 - 31/08/2023
 - autumn: 01/09 - 30/11/2023
 - winter: 01/12/2023 - 28/02/2024

### 2.2 Satellite imagery
The satellite images, one for each season, were downloaded from the Sentinel-2 dataset, using [Google Earth Engine](https://earthengine.google.com/). 
The area of interest was selected manually on the map. 
A cloud filter was applied to extract only images with less than 30% cloud coverage; if a season had more than one image meeting this criterion, the median of the images was computed. 
Despite the filter some of the images were still disturbed by clouds, so a cloud mask was applied, exploiting the pixel classification built in Sentinel-2 data.
> [!NOTE]
> the JavaScript code used on Google Earth Engine for each season can be found in the folder "JavaScript" 

### 2.3 Indexes
The indexes used in this analysis are:

 - **NDWI** (Normalized Difference Water Index)
 - **NDVI** (Normalized Difference Vegetation Index)
 - **NDCI** (Normalized Difference Chlorophyll Index)

#### 2.3.1 NDWI
The NDWI is used to monitor changes related to water content in water bodies was used to detect the water’s surface. In this analysis it was used to separate the lake from the sorrounding land, in order to perform the next analyses only on the area within the lake. 
The NDWI formula is the following:

$$
NDWI = \frac{GREEN - NIR}{GREEN + NIR}
$$


#### 2.3.2 NDVI
The NDVI is one of the most used vegetation indexes for assessing vegetation health, density, and photosynthetic activity. It considers the difference between the NIR and the red reflectance; since healthy plants, due to their chlorophyll content, tend to absorb red light and reflect NIR light, it can be used to assess the presence of plants, their characteristics (grass, shrubs, forests etc.), and their health. 
The formula is the following:

$$
NDVI = \frac{NIR - RED}{NIR + RED}
$$

It is conventionally applied to land vegetation, but in this analysis it was employed to assess the presence of vegetation within the lake, considering it a proxy of eutrophication, although it has the limitation of not being able to discriminate the photosynthetic activity of aquatic plants from the one of cyanobacteria.

#### 2.3.3 NDCI
The NDCI is a novel index developed with the objective of improving the chl-_a_ retrieval in turbid productive waters. This index has been applied in several studies to assess algal blooms because chl-_a_ is the main photosynthetic pigment of cyanobacteria.

The formula is the following:

$$
NDCI = \frac{RED Edge - RED}{RED Edge + RED}
$$

> In Sentinel-2 the bands used in this analysis are:
> - RED: B4
> - RED Edge: B5
> - GREEN: B3
> - BLUE: B2
> - NIR: B8

## 3. R analysis
> [!NOTE]
> the R code used for this analysis can be found in the file "R_script.R"

The first step is setting the working directory:
````r
setwd("C:/Users/utente/Desktop/R_exam")
````
Then the libraries of the necessary packages were loaded:
````r
library("terra")
library("imageRy")
library("viridis")
library("ggplot2")
library("tidyverse")
````
After that, the satellite images were imported as raster files and plotted. 

````r
#import the spring rast image
spring<-rast("Spring.tif")

#plot spring
plot(spring, col=viridis::turbo(100))
````
<p align="center">
  <img src="Images/Spring_plot.png">
</p>

> Spring plot

````r

#import the summer rast image
summer<-rast("Summer.tif")

spring
summer
compareGeom(spring, summer) #error: the two images do not align, they have different coordinates systems
````
It was found that the images did not match, because they had different coordinates systems. To solve this issue, the spring image was chosen as model and the others were projected on it, in order to standardize the coordinates systems and align the pixels.

````r
#project summer over spring to make them match
summer_aligned<-project(summer, spring)
#check that they now match
compareGeom(spring, summer_aligned) #it returns "TRUE"
summer<-summer_aligned

#plot summer
plot(summer, col=viridis::turbo(100))
````
<p align="center">
  <img src="Images/Summer_plot.png">
</p>

> Summer plot

````r
#import the autumn rast image and align it
autumn<- rast("Autumn.tif")
autumn_aligned <- project(autumn, spring)
autumn <- autumn_aligned
compareGeom(spring, autumn) #it returns "TRUE"

#plot autumn
plot(autumn,col=viridis::turbo(100))
````
<p align="center">
  <img src="Images/Autumn_plot.png">
</p>

> Autumn plot

````r
#import the winter rast image and align it
winter<-rast("Winter.tif")
#the "project" function alone failed, alternative: align the image in two steps
winter_lonlat <- project(winter, "EPSG:4326") #step 1: change coordinates systems
winter_aligned <- resample(winter_lonlat, spring) #align the pixels grids
winter<-winter_aligned
compareGeom(spring, winter) #it returns "TRUE"

#plot winter
plot(winter,col=viridis::turbo(100))
````
<p align="center">
  <img src="Images/Winter_plot.png">
</p>

> Winter plot

> [!NOTE]
> The plots show some missing pixels that have probably been caused by the cloud mask applied when retriving the images from Google Earth Engine. Since they are only a few, over a large area of hundreds of square kilometers, they should't affect the results of the analysis.  

### 3.1 RGB colours visualization
````r
#visualize the images in RGB colours
par(mfrow = c(2, 2))
par(col.main = "white")
im.plotRGB(spring, r = 1, g = 2, b = 3, title = "Spring")
im.plotRGB(summer, r = 1, g = 2, b = 3, title = "Summer")
im.plotRGB(autumn, r = 1, g = 2, b = 3, title = "Autumn")
im.plotRGB(winter, r = 1, g = 2, b = 3, title = "Winter")
dev.off()
````
<p align="center">
  <img src="Images/RGB_plot.png">
</p>

> RGB plot of the four seasons

#### 3.1.1 Results
In summer and autumn, green swirls that probably indicate intense algal blooms, are clearly visible on the lake's surface. In summer they are concentrated in the North-West portion of the lake; in autumn they occupy a larger area, they can be observed along the entire East shore, as well as in the previous area (albeit less conspicuous than in summer).
In spring and winter no distinct evidences of algal blooms can be observed.

### 3.2 Lake's area isolation
In order to isolate the area of the lake's surface from the surrounding land it was used the NDWI. It was selected a threshold value of -0.1 to distinguish water from the other types of land cover: 
-	NDWI > -0.1: water
-	NDWI < -0.1: non-water

Then a mask was created to maintain only the water pixels, converting non-water pixels to NA data. It was chosen to utilize a static mask, calculated over the spring image and then applied to the other seasons.

````r
#Isolate the lake from the land using the NDWI (Normalized Difference Water Index)
#calculate the NDWI 
ndwi_spring <- (spring[["B3"]] - spring[["B8"]]) / (spring[["B3"]]  + spring[["B8"]])
#create a water mask: TRUE (1) for water, FALSE (0) for non-water
water_mask <- ndwi_spring > -0.1 #ndwi values above -0.1 identify water
water_mask[water_mask == 0] <- NA #convert non-water pixel to NA
#apply the water mask and check results
spring_lake <- mask(spring, water_mask)
plot(spring_lake)
````
<p align="center">
  <img src="Images/spring_lake_plot.png">
</p>

> Spring plot of the area within the lake

````r
#apply the mask to all the seasons
summer_lake <- mask(summer, water_mask)
autumn_lake <- mask(autumn, water_mask)
winter_lake <- mask(winter, water_mask)
````

### 3.3 Water surface classification
#### 3.3.1 NDVI classification
The NDVI can assume values between -1 and +1, generally positive values indicate the presence of vegetation, while negative values are associated to bare soil, water and snow. 
````r
#calculate the NDVI (Normalized Difference Vegetation Index)
ndvi_spring <- (spring_lake[["B8"]] - spring_lake[["B4"]]) / (spring_lake[["B8"]] + spring_lake[["B4"]])
ndvi_summer <- (summer_lake[["B8"]] - summer_lake[["B4"]]) / (summer_lake[["B8"]] + summer_lake[["B4"]])
ndvi_autumn <- (autumn_lake[["B8"]] - autumn_lake[["B4"]]) / (autumn_lake[["B8"]] + autumn_lake[["B4"]])
ndvi_winter <- (winter_lake[["B8"]] - winter_lake[["B4"]]) / (winter_lake[["B8"]] + winter_lake[["B4"]])

par(mfrow = c(2, 2))
plot(ndvi_spring, main="NDVI Spring", col=viridis::mako(100))
plot(ndvi_summer, main="NDVI Summer", col=viridis::mako(100))
plot(ndvi_autumn, main="NDVI Autumn", col=viridis::mako(100))
plot(ndvi_winter, main="NDVI Winter", col=viridis::mako(100))
dev.off()
````
<p align="center">
  <img src="Images/NDVI.png">
</p>

> It can already be observed that most seasons, but especially autumn, have areas of the lake with NDVI values that are usually associated to vegetation (>0).

To classify the water surface using NDVI values, the following classes were created: 
- **Water**: -Inf < NDVI < -0.2
- **Shallow Turbid Water**: -0.2 < NDVI < 0.0
- **Sparse Vegetation**: 0.0 < NDVI < 0.2
- **Dense Vegetation**: 0.2 < NDVI < Inf

> [!NOTE]
> The classes were based on the work of Selvarajan (2026)

````r
#classify the area using the NDVI
class_matrix_ndvi <- matrix(c(
  -Inf,  -0.2,  1,   # Class 1: Water 
  -0.2,  0.0,  2,   # Class 2: Shallow Turbid Water
  0.0,  0.2,  3,   # Class 3: Sparse Vegetation
  0.2,  Inf,  4    # Class 4: Dense Vegetation
), ncol = 3, byrow = TRUE)


ndvi_colours <-c("cadetblue1","#CDB79E","#9AFF9A","#698B69")

par(mfcol = c(2,3),oma = c(1, 1, 3, 0))
#spring classification
spring_ndvi_classified <- classify(ndvi_spring, class_matrix_ndvi)
plot(spring_ndvi_classified, 
     col = ndvi_colours, 
     main = "Spring",
     type = "classes")

#summer classification
summer_ndvi_classified <- classify(ndvi_summer, class_matrix_ndvi)
plot(summer_ndvi_classified, 
     col = ndvi_colours, 
     main = "Summer",
     type = "classes")

#autumn classification
autumn_ndvi_classified <- classify(ndvi_autumn, class_matrix_ndvi)
plot(autumn_ndvi_classified, 
     col = ndvi_colours, 
     main = "Autumn",
     type = "classes")

#winter classification
winter_ndvi_classified <- classify(ndvi_winter, class_matrix_ndvi)
plot(winter_ndvi_classified, 
     col = ndvi_colours, 
     main = "Winter",
     type = "classes")

mtext("NDVI classification", 
      side = 3,        # 3 = top margin
      outer = TRUE,    # Place it in the outer margin space
      line = 1,        # Distance from the top plot boundary
      font = 2,        # Bold text
      cex = 1.3)       # Title text size
par(mfrow = c(1, 1))
legend("right", 
       legend = c("Water", 
                  "Shallow Turbid Water", 
                  "Sparse Vegetation", 
                  "Dense Vegetation"), 
       fill = ndvi_colours,
       xpd = NA,
       inset = -0.3,
       cex = 0.8)
dev.off()
````
<p align="center">
  <img src="Images/NDVI_classification.png">
</p>

