#19/12
#this code is related to multivariate analysis of RS datra
library(terra)
library(imageRy)
library(ggplot2)
library(patchwork)
library(viridis)

sent <- im.import("sentinel.png")
p1 <- im.ggplot(sent[[1]])
p2 <- im.ggplot(sent[[2]])
p3 <- im.ggplot(sent[[3]]) 
p1 + p2 + p3

pairs(sent) #the nIR gives us more information since th red and the green are very correlated with one another

sentpc<- im.pca(sent) #principal component analysis
sentpc
pcsd3 <- focal(sentpc[[1]], w=3, fun="sd") #we are using the first layer bc it is the one that contains the PC1
plot(pcsd3)

p1 <- im.ggplot(sd3)
p2 <- im.ggplot(pcsd3)
p1 + p2
# in this case we subjectively chose the NIR band bc we were sure that it was the one that was bringing the most inofrmations, in cases where there are a lot of data in the images PCA is important
