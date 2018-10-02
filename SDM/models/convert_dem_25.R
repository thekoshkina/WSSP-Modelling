

dem25 = raster('Data/old/DEM_c.tif')
veg = raster('Data/old/vegetation_c.tif')

mask = raster('Data/Cumberland/ce_radhp_c.tif')

dem = resample(dem25, mask)
plot(dem)
writeRaster(dem,
						'Data/Cumberland/DEM_c.tif' ,
						format = "GTiff",
						overwrite = TRUE)


veg2 = resample(veg, mask)
plot(veg2)
writeRaster(veg2,
						'Data/Cumberland/vegetation_c.tif' ,
						format = "GTiff",
						overwrite = TRUE)
