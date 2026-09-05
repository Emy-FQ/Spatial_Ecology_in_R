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
> [!NOTE]
> the JavaScript code used on Google Earth Engine for each season can be found in the folder "JavaScript" 

### Indexes
The indexes used in this analysis are:

 - **NDWI** (Normalized Difference Water Index)
 - **NDVI** (Normalized Difference Vegetation Index)
 - **NDCI** (Normalized Difference Chlorophyll Index)

> In Sentinel-2 the bands used in this analysis are:
> - RED: B4
> - RED Edge: B5
> - GREEN: B3
> - NIR: B8

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

## R analysis
> [!NOTE]
> the R code used for this analysis can be found in the file "R_script.R"


