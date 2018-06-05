################################################################################
## testing models of cumberland vs the whole nsw state
## only the species with a lot of records both inside and outside cumberland ibra subregion are selected for this test :
# Myotis_macropus
# Miniopterus_schreibersii_oceanensis
# Ninox_strenua
# Epacris_purpurascens_var_purpurascens
# Acacia_pubescens
################################################################################

require(rgdal)
require(raster)
require(maptools)
require(dismo)
dyn.load('/Library/Java/JavaVirtualMachines/jdk1.8.0_161.jdk/Contents/Home/jre/lib/server/libjvm.dylib')
library(rJava)


cumberland <-  readOGR("Data/IBRA_cumberland/Cumberland_IBRA_subregion.shp")

species_list = c("Acacia_pubescens",	"Pimelea_spicata", "Anthochaera_phrygia")


#specify folder for the precense point data and covariate data files
folder = "Data/Cumberland"


#read all the covariate tif files from covariate folder
files=list.files(folder , pattern = "*.tif$", full.names=TRUE)
no_cov=length(files) #number of covariates
predictors <- stack(files)



### add zeros instead of NA in the vegetation layer
predictors <- dropLayer(predictors, 'vegetation_c')
vegetation=raster(paste(folder, '/', 'vegetation_c.tif', sep=''))
vegetation[is.na(vegetation[])] <- 0
plot(vegetation)
predictors <- addLayer(predictors, vegetation)
#


# create a folder for output
dir.create(paste(folder, '/Output', sep=''))
#write a readme file


ppi=300
png(filename =paste(folder, '/Output/',  "covariates.png", sep=""), width = 3*ppi, height = 3*ppi)
plot(predictors)
dev.off()




#set up one of the raster files as a study area
# mask <- raster(files[1])
# set.seed(1963)

##### select beckground points - randomly selecting points
backgr <- randomPoints(predictors, 1000)
group <- kfold(backgr, 5)
backgr_train <- backgr[group != 1, ]
backgr_test <- backgr[group == 1, ]






# species="Acacia_pubescens"

for (species in species_list)
{

# read presence data for all the species
presences <- read.table(paste(folder,"/", species, ".csv", sep="" ),  header=TRUE,  sep=",")
presences = SpatialPoints( presences[, c("Bionet_A31","Bionet_A30")])
proj4string(presences)=cumberland@proj4string



##### select 20% of the data for testing - randomly selecting points
group <- kfold(presences, 5)
pres_train <- presences[group != 1, ]
pres_test <- presences[group == 1, ]





png(filename =paste(folder, '/Output/', species,  "_presence_background_points.png", sep=""), width = 3*ppi, height = 3*ppi)
# plot presence and bacground points
plot(!is.na(mask), col=c('white', 'light grey'), legend=FALSE)
points(backgr_train, pch='-', cex=0.5, col='yellow')
points(backgr_test, pch='-',  cex=0.5, col='black')
points(pres_train, pch= '+', col='green')
points(pres_test, pch='+', col='blue')

legend("topright", legend=c("background - train","background - test","presence - train","presence - test"), pch=c('-','-','+','+'), col = c('yellow', 'black', 'green','blue'))
dev.off()




jar <- paste(system.file(package="dismo"), "/java/maxent.jar", sep='')
xm <- maxent(predictors, pres_train, factors='vegetation_c')
# xm <- maxent(predictors, pres_train)



png(filename =paste(folder, '/Output/', species,  "_variable_contribution.png", sep=""), width = 3*ppi, height = 3*ppi)
plot(xm)
dev.off()

png(filename =paste(folder, '/Output/', species,  "_variable_responce.png", sep=""), width = 6*ppi, height = 3*ppi)
response(xm)
dev.off()



e <- evaluate(pres_test, backgr_test, xm, predictors)
px <- predict(predictors, xm, progress='')

writeRaster(px, paste(folder, '/Output/', species,  "_maxent_output.tif", sep=""), format = "GTiff")

png(filename =paste(folder, '/Output/', species,  "_maxent_results.png", sep=""), width = 6*ppi, height = 3*ppi)
par(mfrow=c(1,2))
plot(px, main='Maxent, raw values')

tr <- threshold(e, 'spec_sens')
plot(px > tr, main='presence/absence')
dev.off()








}

