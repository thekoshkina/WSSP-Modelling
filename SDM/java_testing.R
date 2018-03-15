# java returns an error when i try to run maxent.
# in this script i'm trying to determine if the error is caused be jdk or by maxent

install.packages('rJava', type='source')

# library(rJava)
.jinit()


	library(rJava)
	library(dismo)
	maxent()
