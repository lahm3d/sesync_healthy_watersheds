library(leaflet, lib.loc = "/usr/lib/R/site-library")
library(raster, lib.loc = "/usr/lib/R/site-library")
library(sf, lib.loc = "/usr/lib/R/site-library")

setwd('/home/sarah/sesync_data/')

#Read in MBSS point data and Healthy Watersheds Polygons
mbss <- read_sf("MBSS.shp")
chwa <- read_sf("CHWA_MD.shp")
#Do a spatial join of the data
chwa_mbss <- st_join(mbss, chwa)
mbss_100 <- chwa_mbss %>%  st_buffer(100)

#transform to WGS84
mbss_100 <- st_transform(mbss_100, crs = 4326)  # convert back for leaflet
chwa_mbss <- st_transform(chwa_mbss, crs = 4326)  # convert back for leaflet

#visualize buffers
mbss_100 %>%
  leaflet() %>%
  addProviderTiles(providers$Esri.WorldImagery) %>%
  addCircleMarkers(data = chwa_mbss, fillOpacity = 1, color = '#FF0000') %>% # add something from column in sf object as popup
  addPolygons(data = mbss_100, fillOpacity = 0, color = '#FFFFFF') %>%
  addMeasure(primaryLengthUnit = "meters") # fancy schmancy

#read in raster
LC <- raster("LC_MD_5m.tif")

#aggregate raster data by buffer
aggLC <- extract(LC, mbss_100) #store all pixel values for each buffer ... ?

#Create empty vectors to store percent forest and percent impervious
pctForest <- rep(0, length(aggLC))
pctImp <- rep(0, length(aggLC))

#Calculate percent forest cover and percent impervious and add to respective vectors
for(row in 1:length(aggLC)){
  tb <- as.data.frame(table(aggLC[row]))
  forest <- tb[tb == 1, 'Freq']
  imp <- tb[tb == 2, 'Freq'] #(tb[tb == 5, 'Freq'] + tb[tb == 6, 'Freq'])
  if (length(forest) != 0){
    pctForest[row] <- forest / length(aggLC[[row]]) #percent forested
  }
  if (length(imp) != 0){
    pctImp[row] <- imp / length(aggLC[[row]])  # percent impervious
  }
}

#add vectors as new columns to the spatial join of CHWA and MBSS
#THIS IS THE DF TO USE IN OTHER SCRIPT - chwa_mbss
chwa_mbss <- as.data.frame(chwa_mbss)
chwa_mbss['BUFPctFor'] <- pctForest
chwa_mbss['BUFPctImp'] <- pctImp


#visualize buffers with calculated percentages over the land cover raster
mbss_100['BUFPctFor'] <- pctForest
pal <- colorNumeric(
  palette = "Blues",
  domain = mbss_100$BUFPctFor)
mbss_100 %>%
  leaflet() %>%
  addProviderTiles(providers$Esri.WorldImagery) %>%
  addPolygons(data = mbss_100, fillOpacity = 0.5, color=~pal(BUFPctFor), popup = ~BUFPctFor) #%>%
  #addRasterImage(LC, colors = "Spectral")
  #addMeasure(primaryLengthUnit = "meters") # fancy schmancy
#addLayersControl(
 # baseGroups = c("OSM (default)", "Toner", "Toner Lite"),
  #overlayGroups = c("Quakes", "Outline"),
  #options = layersControlOptions(collapsed = FALSE)
#)




