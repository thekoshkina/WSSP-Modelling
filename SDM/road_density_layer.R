require(rgdal)
require(raster)
require(maptools)
require(spatstat)
library(rgeos)

# Macarthur_Vegetation = readOGR("Data/Data package 20180309/26276_Macarthur_Vegetation_DRAFT_20180223.shp")
# Cadastre = readOGR("Data/Data package 20180309/Cadastre.shp")
Study_area = readOGR("Data/Data package 20180309/Cumberland_IBRA_subregion.shp")
Cumberland=Study_area
# Plain_west = readOGR("Data/Data package 20180309/CumberlandPlainWest_2013_E_4207.shp")
# Priority_Growth = readOGR("Data/Data package 20180309/Priority_Growth_Areas.shp")
# Western_Vegetation = readOGR("Data/Data package 20180309/WesternSydneyVeg_prelimDRAFT20180309.shp")

Roads=readOGR("Data/Covariates cumberland/roads/roads_c.shp")


Road_density= spatstat::density.psp(Roads)
