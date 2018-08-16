# vegitation_c is vegitation_total cropped to cumberland plane
library(raster)
require(rgdal)

soil = readOGR ("/Volumes/TOSHIBA EXT/WSSSP Modelling/SDM/Data/Soil landscapes_Cumberland_Clipped/Soil_landscapes_Cumberland_4283.shp")

r = raster ("Data/mask.tif")

plot(r)
names(soil)
# plot(vegitation_c)


rp <- rasterize(soil, r, soil$LANDSCAPE)
plot(rp)

writeRaster(rp, "Data/Cumberland/soil_c.tif", format = "GTiff")


# rcom <- rasterize(veg, r, veg$VegComm)
# plot(rcom)
#
# writeRaster(rcom, "Results/vegitation_vegcom_b.tif", format = "GTiff")
