# vegitation_c is vegitation_total cropped to cumberland plane
library(raster)
require(rgdal)

vegitation_c=readOGR ("Data/Vegetation/vegetation_c.shp")
r=raster ("Data/Vegetation/ce_radcq_c.tif")

plot(r)
names(vegitation_c)
# plot(vegitation_c)

rp <- rasterize(vegitation_c, r, vegitation_c$PCTNo )
plot(rp)

writeRaster(rp, "Data/Vegetation/vegitation_c.tif", format = "GTiff")
