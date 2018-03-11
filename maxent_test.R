# tutorial from https://cran.r-project.org/web/packages/dismo/vignettes/sdm.pd f

install.packages(c('raster', 'rgdal', 'dismo', 'rJava'))

library(dismo)


file <- paste(system.file(package="dismo"), "/ex/bradypus.csv", sep="")
file

bradypus <- read.table(file,  header=TRUE,  sep=",")
head(bradypus)
