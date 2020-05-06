require(rgdal)
require(raster)
require(maptools)
require(dismo)
library(sp)
library(caTools)



soil = raster("Data/Cumberland//soil_c.tif")
veg_com = raster("Data/Cumberland/extra/vegitation_vegcom_b_c.tif")
veg_pct = raster("Data/Cumberland/vegitation_pct_b_c.tif")

plot(soil)
plot(veg_pct)
plot(veg_com)


# only take into account points that are present in all three datasets

s = values(soil)[!is.na(values(veg_com))& !is.na(values(veg_pct))]
s = factor(s, labels = unique(s))


vc = values(veg_com)[!is.na(values(veg_com))& !is.na(values(veg_pct))]
vc = factor(vc, labels = unique(vc))


vp = values(veg_pct)[!is.na(values(veg_com))& !is.na(values(veg_pct))]
vp = factor(vp, labels = unique(vp))



# The measure of association does not indicate causality, but association–that is, whether a variable is associated with another variable. This measure of association also indicates the strength of the relationship, whether, weak or strong.
#
# Since, I’m dealing with nominal categorical predictor’s, the Goodman and Kruskal’s tau measure is appropriate. Interested readers are invited to see pages 68 and 69 of the Agresti book. More information on this test can be seen here

library(GoodmanKruskal)
dataframe <- cbind.data.frame(s,vp, vc)
GKmatrix1 <- GKtauDataframe(dataframe)
plot(GKmatrix1, corrColors = "blue")

