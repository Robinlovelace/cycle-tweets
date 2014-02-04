
library(RSQLite)
drv <- dbDriver("SQLite")
con <- dbConnect(drv, "tweet_db.sqlite")
db <- dbGetQuery(con, "SELECT * FROM main_table")
object.size(db) /1000000

aT <- RSQLite::dbReadTable("tweet_db.sqlite")

cyTweets <- db[grepl("bike|cycl|bicy", db$Text, ignore.case=T), ]
s <- which(grepl("recycle", cyTweets$Text, ignore.case=T))
cyTweets[s,]
cyTweets <- cyTweets[-s,]

library(sp)
cyS <- SpatialPointsDataFrame(coords= matrix(c(cyTweets$Lon, cyTweets$Lat), ncol=2), data=cyTweets)
plot(cyS)

proj4string(cyS) <- CRS("+proj=longlat +datum=WGS84")
library(rgdal)
writeOGR(cyS, dsn="shps/", layer="cycles", driver="ESRI Shapefile")