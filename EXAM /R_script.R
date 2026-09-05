#set the working directive
setwd("C:/Users/utente/Desktop/R_exam")

#load the required packages
library("terra")
library("imageRy")
library("viridis")
library("ggplot2")
library("tidyverse")


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

#plot autumn
plot(autumn,col=viridis::turbo(100))

#import the winter rast image and align it
winter<-rast("Winter.tif")
#the "project" function alone failed, alternative: align the image in two steps
winter_lonlat <- project(winter, "EPSG:4326") #step 1: change coordinates systems
winter_aligned <- resample(winter_lonlat, spring) #align the pixels grids
winter<-winter_aligned
compareGeom(spring, winter) #it returns "TRUE"

#plot winter
plot(winter,col=viridis::turbo(100))

#visualize the images in RGB colours
par(mfrow = c(2, 2))
par(col.main = "white")
im.plotRGB(spring, r = 1, g = 2, b = 3, title = "Spring")
im.plotRGB(summer, r = 1, g = 2, b = 3, title = "Summer")
im.plotRGB(autumn, r = 1, g = 2, b = 3, title = "Autumn")
im.plotRGB(winter, r = 1, g = 2, b = 3, title = "Winter")
dev.off()


#Isolate the lake from the land using the NDWI (Normalized Difference Water Index)
#calculate the NDWI 
ndwi_spring <- (spring[["B3"]] - spring[["B8"]]) / (spring[["B3"]]  + spring[["B8"]])
#create a water mask: TRUE (1) for water, FALSE (0) for non-water
water_mask <- ndwi_spring > -0.1 #ndwi values above -0.1 identify water
water_mask[water_mask == 0] <- NA #convert non-water pixel to NA
#apply the water mask and check results
spring_lake <- mask(spring, water_mask)
plot(spring_lake)
#apply the mask to all the seasons
summer_lake <- mask(summer, water_mask)
autumn_lake <- mask(autumn, water_mask)
winter_lake <- mask(winter, water_mask)


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


#calculate the NDCI (Normalized Difference Chlorophyll Index)
ndci_spring <- (spring_lake[["B5"]] - spring_lake[["B4"]]) / (spring_lake[["B5"]] + spring_lake[["B4"]])
ndci_summer <- (summer_lake[["B5"]] - summer_lake[["B4"]]) / (summer_lake[["B5"]] + summer_lake[["B4"]])
ndci_autumn <- (autumn_lake[["B5"]] - autumn_lake[["B4"]]) / (autumn_lake[["B5"]] + autumn_lake[["B4"]])
ndci_winter <- (winter_lake[["B5"]] - winter_lake[["B4"]]) / (winter_lake[["B5"]] + winter_lake[["B4"]])

par(mfrow = c(2, 2))
plot(ndci_spring, main="NDCI Spring", col=viridis::inferno(100))
plot(ndci_summer, main="NDCI Summer", col=viridis::inferno(100))
plot(ndci_autumn, main="NDCI Autumn", col=viridis::inferno(100))
plot(ndci_winter, main="NDCI Winter", col=viridis::inferno(100))
dev.off()


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



#multitemporal comparison of the NDVI classes across seasons
#calculate the frequencies of each class
freq_ndvi_spring <- freq(spring_ndvi_classified)
freq_ndvi_summer<- freq(summer_ndvi_classified)
freq_ndvi_autumn <- freq(autumn_ndvi_classified)
freq_ndvi_winter <- freq(winter_ndvi_classified)
#calculate the percentages of each class
perc_ndvi_spring = freq_ndvi_spring$count * 100 / sum(freq_ndvi_spring$count) #use sum to avoid counting masked pixels
perc_ndvi_summer = freq_ndvi_summer$count * 100 / sum(freq_ndvi_summer$count) 
perc_ndvi_autumn = freq_ndvi_autumn$count * 100 / sum(freq_ndvi_autumn$count) 
perc_ndvi_winter = freq_ndvi_winter$count * 100 / sum(freq_ndvi_winter$count) 
#create a table
ndvi_category_labels <- c(
  "Water", 
  "Shallow Turbid Water", 
  "Sparse Vegetation", 
  "Dense Vegetation")
ndvi_table <- data.frame(
  Category = ndvi_category_labels ,
  Spring = round(perc_ndvi_spring, 2), #round to two decimals
  Summer = round(perc_ndvi_summer, 2),
  Autumn = round(perc_ndvi_autumn, 2),
  Winter = round(perc_ndvi_winter, 2))
print(ndvi_table)

#turn the wide table into a long table 
ndvi_table_long <- ndvi_table %>% 
  pivot_longer(-Category)  #transform all of the columns except "Category"
ndvi_table_long <- rename(ndvi_table_long, Season=name, Percentage=value)

ndvi_table_long <- as.data.frame(ndvi_table_long) #transform the tibble into a data.frame 
ndvi_table_long$Category <- replace_values(ndvi_table_long$Category,
                                           from = c("Water", "Shallow Turbid Water", "Sparse Vegetation", "Dense Vegetation"),
                                           to = c("1", "2", "3", "4"))


#plot the graph
ggplot(ndvi_table_long, aes(x=Season, y=Percentage, fill=Category)) +                            
  geom_bar(stat="identity", position="dodge") +                                           
  geom_text(aes(label=round(Percentage,1)),
            position=position_dodge(width=0.9),
            vjust=-0.25,size=3) +                                                        
  scale_fill_manual(name="Category",
                    label=c("Water", "Shallow Turbid Water", "Sparse Vegetation", "Dense Vegetation"),
                    values=ndvi_colours) +                                                               
  ylim(0,100) +                                                                          
  labs(title="Percentages of the NDVI classes across seasons",
       y="Percentage (%)", x="Season") +
  theme_minimal()  



#classify the area using the NDCI
class_matrix_ndci <- matrix(c(
  -Inf,  -0.1,  1,   # Class 1: Oligotrophic/clean water 
  -0.1,   0.0,  2,   # Class 2: Low algae content
   0.0,  0.1,  3,    # Class 3: Moderate eutrophic 
   0.1,  0.2,  4,    # Class 4: High eutrophic 
   0.2,  0.4,  5,    # Class 5: Very high algae biomass
   0.4,  0.5,  6,    # Class 6: Algal bloom conditions
   0.5,  Inf,  7     # Class 7: Severe bloom/hypereutrophic
), ncol = 3, byrow = TRUE)

  
par(mfcol = c(2, 3), oma = c(1, 1, 3, 0)) 
#spring classification
spring_ndci_classified <- classify(ndci_spring, class_matrix_ndci)
plot(spring_ndci_classified, 
     col = viridis::turbo(7), 
     main = "Spring",
     type = "classes")

#summer classification
summer_ndci_classified <- classify(ndci_summer, class_matrix_ndci)
plot(summer_ndci_classified, 
     col = viridis::turbo(7), 
     main = "Summer",
     type = "classes")

#autumn classification
autumn_ndci_classified <- classify(ndci_autumn, class_matrix_ndci)
plot(autumn_ndci_classified, 
     col = viridis::turbo(7), 
     main = "Autumn",
     type = "classes")

#winter classification
winter_ndci_classified <- classify(ndci_winter, class_matrix_ndci)
plot(winter_ndci_classified, 
     col = viridis::turbo(7), 
     main = "Winter",
     type = "classes")

mtext("NDCI Classification: eutrophication level", 
      side = 3,        # 3 = top margin
      outer = TRUE,    # Place it in the outer margin space
      line = 1,        # Distance from the top plot boundary
      font = 2,        # Bold text
      cex = 1.3)       # Title text size
par(mfrow=c(1,1))
legend("right", 
       legend = c("Oligotrophic/clean water", 
                  "Low algae content", 
                  "Moderate eutrophic", 
                  "High eutrophic", 
                  "Very high algae biomass", 
                  "Algal bloom conditions", 
                  "Severe bloom/hypereutrophic"), 
       fill = viridis::turbo(7),
       xpd = NA,
       inset = -0.3,
       cex = 0.8)
dev.off()


#multitemporal comparison of the NDCI classes across seasons
#calculate the frequencies of each class
freq_ndci_spring <- freq(spring_ndci_classified) 
freq_ndci_summer <- freq(summer_ndci_classified)
freq_ndci_autumn <- freq(autumn_ndci_classified)
freq_ndci_winter <- freq(winter_ndci_classified)
#calculate the percentages of each class
perc_ndci_spring = freq_ndci_spring$count * 100 / sum(freq_ndci_spring$count) #use sum to avoid counting masked pixels
perc_ndci_summer = freq_ndci_summer$count * 100 / sum(freq_ndci_summer$count) 
perc_ndci_autumn = freq_ndci_autumn$count * 100 / sum(freq_ndci_autumn$count) 
perc_ndci_winter = freq_ndci_winter$count * 100 / sum(freq_ndci_winter$count) 
#create a table
ndci_category_labels <- c("Oligotrophic/clean water", 
                          "Low algae content", 
                          "Moderate eutrophic", 
                          "High eutrophic", 
                          "Very high algae biomass", 
                          "Algal bloom conditions", 
                          "Severe bloom/hypereutrophic")
ndci_table <- data.frame(
  Category = ndci_category_labels ,
  Spring = round(perc_ndci_spring, 2), #round to two decimals
  Summer = round(perc_ndci_summer, 2),
  Autumn = round(perc_ndci_autumn, 2),
  Winter = round(perc_ndci_winter, 2))
print(ndci_table)

#turn the wide table into a long table 
ndci_table_long <- ndci_table %>% 
  pivot_longer(-Category)  #transform all of the columns except "Category"
ndci_table_long <- rename(ndci_table_long, Season=name, Percentage=value)

ndci_table_long <- as.data.frame(ndci_table_long) #transform the tibble into a data.frame 
ndci_table_long$Category <- replace_values(ndci_table_long$Category,
                                           from = c("Oligotrophic/clean water", 
                                                    "Low algae content", 
                                                    "Moderate eutrophic", 
                                                    "High eutrophic", 
                                                    "Very high algae biomass", 
                                                    "Algal bloom conditions", 
                                                    "Severe bloom/hypereutrophic"),
                                           to = c("1", "2", "3", "4","5","6","7"))
ndci_colours <- viridis::turbo(7)

#plot the graph
ggplot(ndci_table_long, aes(x=Season, y=Percentage, fill=Category)) +                            
  geom_bar(stat="identity", position="dodge") +                                           
  geom_text(aes(label=round(Percentage,1)),
            position=position_dodge(width=0.9),
            vjust=-0.25,size=2.5) +                                                        
  scale_fill_manual(name="Category",
                    label= c("Oligotrophic/clean water", 
                             "Low algae content", 
                             "Moderate eutrophic", 
                             "High eutrophic", 
                             "Very high algae biomass", 
                             "Algal bloom conditions", 
                             "Severe bloom/hypereutrophic"),
                    values= ndci_colours) +                                                               
  ylim(0,100) +                                                                          
  labs(title="Percentages of the NDVI classes across seasons",
       y="Percentage (%)", x="Season") +
  theme_minimal()  

