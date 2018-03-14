# tutorial from https://cran.r-project.org/web/packages/dismo/vignettes/sdm.pdf

# install.packages(c('raster', 'rgdal', 'dismo', 'rJava'))

require(dismo)
require(raster)


#read data
file <- paste(system.file(package="dismo"), '/ex/acaule.csv', sep='')
acsel <- read.csv(file)



files <- list.files(path=paste(system.file(package="dismo"), '/ex', sep=''), pattern='grd', full.names=TRUE )
predictors <- stack(files)


mask <- raster(files[1])
# select 500 random points
# set seed to assure that the examples will always
# have the same random sample.
set.seed(1963)
bg <- randomPoints(mask, 500 )

# set up the plotting area for two maps
par(mfrow=c(1,2))
plot(!is.na(mask), legend=FALSE)
points(bg, cex=0.5)
# now we repeat the sampling, but limit
# the area of sampling using a spatial extent >
e <- extent(-80, -53, -39, -22)
bg2 <- randomPoints(mask, 50, ext=e)
plot(!is.na(mask), legend=FALSE)
plot(e, add=TRUE, col='red')
points(bg2, cex=0.5)



presvals <- extract(predictors, bradypus)

set.seed(0)
backgr <- randomPoints(predictors, 500)
absvals <- extract(predictors, backgr)
pb <- c(rep(1, nrow(presvals)), rep(0, nrow(absvals)))
sdmdata <- data.frame(cbind(pb, rbind(presvals, absvals)))
sdmdata[,'biome'] = as.factor(sdmdata[,'biome'])
head(sdmdata)



# pairs plot of the values of the climate data
# at the bradypus occurrence sites.
pairs(sdmdata[,2:5], cex=0.1, fig=TRUE)
