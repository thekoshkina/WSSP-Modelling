
dem25 = raster('Data/IBRA_cumberland/DEM_25m_c.tif')
veg=raster('Data/IBRA_cumberland/vegetation_c.tif')

mask = raster('Data/Cumberland/ct_tempmtwp_c.tif')

dem =resample(dem25,mask)
plot(dem)


veg2 =resample(veg,mask,, vegitation_c$PCTNo)
plot(veg)


# extent(dem)=extent(mask)

writeRaster(veg2,'Data/Cumberland/vegetation_c.tif' , format = "GTiff", overwrite=TRUE)


