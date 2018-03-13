# tutorial from https://cran.r-project.org/web/packages/dismo/vignettes/sdm.pd f

# install.packages(c('raster', 'rgdal', 'dismo', 'rJava'))

require(dismo)


file <- paste(system.file(package="dismo"), "/ex/bradypus.csv", sep="")
file

bradypus <- read.table(file,  header=TRUE,  sep=",")
head(bradypus)


# we only need columns 2 and 3:
bradypus <- bradypus[,2:3]
head(bradypus)


# If you do not have any species distribution data you can get started by down- loading data from the Global Biodiversity Inventory Facility (GBIF) (http: //www.gbif.org/). In the dismo package there is a function ’gbif’ that you can use for this. The data used below were downloaded (and saved to a perma- nent data set for use in this vignette) using the gbif function like this:
# acaule = gbif("solanum", "acaule*", geo=FALSE)

# load the saved S. acaule data
data(acaule)
dim(acaule)

#select the records that have longitude and latitude data
colnames(acaule)

acgeo <- subset(acaule, !is.na(lon) & !is.na(lat))
dim(acgeo)

# show some values
acgeo[1:4, c(1:5,7:10)]





