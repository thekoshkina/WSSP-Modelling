require(rgdal)
require(raster)
require(maptools)
require(spatstat)
library(rgeos)

# Macarthur_Vegetation = readOGR("Data/Data package 20180309/26276_Macarthur_Vegetation_DRAFT_20180223.shp")
# Cadastre = readOGR("Data/Data package 20180309/Cadastre.shp")
cumberland = readOGR("Data/Data package 20180309/Cumberland_IBRA_subregion.shp")
# Plain_west = readOGR("Data/Data package 20180309/CumberlandPlainWest_2013_E_4207.shp")
# Priority_Growth = readOGR("Data/Data package 20180309/Priority_Growth_Areas.shp")
# Western_Vegetation = readOGR("Data/Data package 20180309/WesternSydneyVeg_prelimDRAFT20180309.shp")

roads=readOGR("Data/Covariates cumberland/roads/roads_c.shp")
plot(roads)

# Convert SpatialLines to psp object using maptools library
psp_roads <- as.psp(roads)
plot(psp_roads)

road_density= spatstat::density.psp(psp_roads)



plot(road_density)
road_density_c=mask(raster(road_density), cumberland)

plot(road_density_c)
writeRaster(road_density_c, "Data/Covariates cumberland/road_density_c.tif", format = "GTiff")
