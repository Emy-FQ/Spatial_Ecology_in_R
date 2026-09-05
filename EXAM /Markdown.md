# Remote sensing of algal blooms: the case of Lough Neagh
### 07/09/2026 exam - Spatial Ecology in R 
#### Emy Filippi Quintussi

## 1. Introduction 

Lough Neagh is UK's largest freshwater lake, it is situated in Northern Ireland, spanning around 380 square kilometres. 
In recent years it has been affected by severe algal blooms, raising concerns about the safety of the drinking water drawn from it, negatively impacting local activities and posing threats to biodiversity. 

During the year 2023, the lake experienced a particularly intense proliferation of cyanobacteria (i.e. the microorganisms causing algal blooms), due multiple causes, such as: eutrophication caused by agriculture run-off, global warming, invasive species, and the calm weather conditions of that year.

Remote sensing can be a useful tool for monitoring algal blooms, allowing spatial observations that couldn’t be possible with traditional in-situ sampling. 

###  Aim of the analysis
The aim of this analysis is to utilise remote sensing techniques to monitor the algal blooms of Lough Neagh during the year 2023, comparing their intensity across seasons.

## 2. Methodology overview 
### Time period
In this analysis the four metereological seasons of the year 2023, starting from spring, were monitored:

 - spring: 01/03 - 31/05/2023
 - summer: 01/06 - 31/08/2023
 - autumn: 01/09 - 30/11/2023
 - winter: 01/12/2023 - 28/02/2024

### Satellite imagery
The satellite images, one for each season, were downloaded from the Sentinel-2 dataset, using [Google Earth Engine](https://earthengine.google.com/). 
The area of interest was selected manually on the map. 
A cloud filter was applied to extract only images with less than 30% cloud coverage; if a season had more than one image meeting this criterion, the median of the images was computed. 
Despite the filter some of the images were still disturbed by clouds, so a cloud mask was applied, exploiting the pixel classification built in Sentinel-2 data.
> [!NOTE]
> the JavaScript code used on Google Earth Engine for each season can be found in the folder "JavaScript" 

### Indexes
The indexes used in this analysis are:

 - **NDWI** (Normalized Difference Water Index)
 - **NDVI** (Normalized Difference Vegetation Index)
 - **NDCI** (Normalized Difference Chlorophyll Index)

#### NDWI
The NDWI is used to monitor changes related to water content in water bodies was used to detect the water’s surface. In this analysis it was used to separate the lake from the sorrounding land, in order to perform the next analyses only on the area within the lake. 
The NDWI formula is the following:

$$
NDWI = \frac{GREEN - NIR}{GREEN + NIR}
$$


#### NDVI
The NDVI is one of the most used vegetation indexes for assessing vegetation health, density, and photosynthetic activity. It considers the difference between the NIR and the red reflectance; since healthy plants, due to their chlorophyll content, tend to absorb red light and reflect NIR light, it can be used to assess the presence of plants, their characteristics (grass, shrubs, forests etc.), and their health. 
The formula is the following:

$$
NDVI = \frac{NIR - RED}{NIR + RED}
$$

It is conventionally applied to land vegetation, but in this analysis it was employed to assess the presence of vegetation within the lake, considering it a proxy of eutrophication, although it has the limitation of not being able to discriminate the photosynthetic activity of aquatic plants from the one of cyanobacteria.
#### NDCI
The NDCI is a novel index developed with the objective of improving the chl-_a_ retrieval in turbid productive waters. This index has been applied in several studies to assess algal blooms because chl-_a_ is the main photosynthetic pigment of cyanobacteria.

The formula is the following:

$$
NDCI = \frac{RED Edge - RED}{RED Edge + RED}
$$

> In Sentinel-2 the bands used in this analysis are:
> - RED: B4
> - RED Edge: B5
> - GREEN: B3
> - NIR: B8

## R analysis
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
After that the satellite images were imported as rast files. 
Since the images had different coordinates systems they did not match, so the spring image was chosen as reference and the others were projected over it, in order to re-align the pixels.
````r
#import the spring rast image
spring<-rast("Spring.tif")

#import the summer rast image
summer<-rast("Summer.tif")

spring
summer
compareGeom(spring, summer) #error: the two images do not align, they have different coordinates systems

#project summer over spring to make them match
summer_aligned<-project(summer, spring)
#check that they now match
compareGeom(spring, summer_aligned) #it returns "TRUE"
summer<-summer_aligned

#plot spring and summer
plot(spring, col=viridis::turbo(100))
plot(summer, col=viridis::turbo(100))

#import the autumn rast image and align it
autumn<- rast("Autumn.tif")
autumn_aligned <- project(autumn, spring)
autumn <- autumn_aligned
compareGeom(spring, autumn) #it returns "TRUE"
````
