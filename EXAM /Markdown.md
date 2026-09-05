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
The indexes used in this analysis are
