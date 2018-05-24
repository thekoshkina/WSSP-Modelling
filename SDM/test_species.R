################################################################################
## testing models of cumberland vs the whole nsw state
## only the species with a lot of records both inside and outside cumberland ibra subregion are selected for this test :
# Myotis_macropus
# Miniopterus_schreibersii_oceanensis
# Ninox_strenua
# Epacris_purpurascens_var_purpurascens
# Acacia_pubescens
################################################################################
library(raster)
require(rgdal)
require(raster)
require(maptools)


species=c("Myotis_macropus", "Miniopterus_schreibersii_oceanensis", "Ninox_strenua,Epacris_purpurascens_var_purpurascens", "Acacia_pubescens")

preslocs<- read.csv("Data/precense records/Cumberland_species_csv/Acacia_pubescens.csv")[ ,c('Bionet_A30', 'Bionet_A31')]
# elevation = raster("Data/Data package 20180309/DEM_25m.tif")


files=list.files("Data/Data package 20180309" , pattern = "*.tif$", full.names = TRUE)
predictors <- stack(files)

mask = raster(files[1])
# plot(mask)

# select 500 random points
# set seed to assure that the examples will always
# have the same random sample.
set.seed(1963)
bg <- randomPoints(mask, 500 )

# set up the plotting area for two maps
par(mfrow=c(1,2))
plot(!is.na(mask), legend=FALSE)
points(bg, cex=0.5)


presvals <- extract(predictors, preslocs)

# # now we repeat the sampling, but limit
# # the area of sampling using a spatial extent >
# e <- extent(-80, -53, -39, -22)
# bg2 <- randomPoints(mask, 50, ext=e)
# plot(!is.na(mask), legend=FALSE)
# plot(e, add=TRUE, col='red')
# points(bg2, cex=0.5)
