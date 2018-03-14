# Turotial from http://rspatial.org/sdm/rst/6_sdm_methods.html

#Citation for maxent software:  Steven J. Phillips, Miroslav Dudík, Robert E. Schapire. [Internet] Maxent software for modeling species niches and distributions (Version 3.4.1). Available from url: http://biodiversityinformatics.amnh.org/open_source/maxent/. Accessed on 2018-3-14.

# To run maxent - run the following command in the terminal
# java app java -mx512m -jar /Users/vira/Documents/PhD/WSSP\ Modelling/maxent/maxent.jar
###################################################################################


library(raster)
library(dismo)
library(rJava)

library(maptools)
data(wrld_simpl)

predictors <- stack(list.files(file.path(system.file(package="dismo"), 'ex'), pattern='grd$', full.names=TRUE ))

file <- file.path(system.file(package="dismo"), "ex/bradypus.csv")
bradypus <- read.table(file,  header=TRUE,  sep=',')
bradypus <- bradypus[,-1]
presvals <- extract(predictors, bradypus)
set.seed(0)
backgr <- randomPoints(predictors, 500)
absvals <- extract(predictors, backgr)
pb <- c(rep(1, nrow(presvals)), rep(0, nrow(absvals)))
sdmdata <- data.frame(cbind(pb, rbind(presvals, absvals)))
sdmdata[,'biome'] <- as.factor(sdmdata[,'biome'])



pred_nf <- dropLayer(predictors, 'biome')

set.seed(0)
group <- kfold(bradypus, 5)
pres_train <- bradypus[group != 1, ]
pres_test <- bradypus[group == 1, ]

ext <- extent(-90, -32, -33, 23)


set.seed(10)
backg <- randomPoints(pred_nf, n=1000, ext=ext, extf = 1.25)
colnames(backg) = c('lon', 'lat')
group <- kfold(backg, 5)
backg_train <- backg[group != 1, ]
backg_test <- backg[group == 1, ]

r <- raster(pred_nf, 1)
plot(!is.na(r), col=c('white', 'light grey'), legend=FALSE)
plot(ext, add=TRUE, col='red', lwd=2)
points(backg_train, pch='-', cex=0.5, col='yellow')
points(backg_test, pch='-',  cex=0.5, col='black')
points(pres_train, pch= '+', col='green')
points(pres_test, pch='+', col='blue')




######### Maxent fitting -------------------------

# Dismo has a function ‘maxent’ that communicates with this program. To use it you must first download the program from http://www.cs.princeton.edu/~schapire/maxent/. (already saved in the folder maxent) Put the file maxent.jar in the java folder of the dismo package. That is the folder returned by system.file("java", package="dismo"). Please note that this program (maxent.jar) cannot be redistributed or used for commercial purposes.

jar <- paste(system.file(package="dismo"), "/java/maxent.jar", sep='')
xm <- maxent(predictors, pres_train)

plot(xm)

response(xm)
e <- evaluate(pres_test, backg_test, xm, predictors)
px <- predict(predictors, xm, ext=ext, progress='')
par(mfrow=c(1,2))
plot(px, main='Maxent, raw values')
plot(wrld_simpl, add=TRUE, border='dark grey')
tr <- threshold(e, 'spec_sens')
plot(px > tr, main='presence/absence')
plot(wrld_simpl, add=TRUE, border='dark grey')
points(pres_train, pch='+')
