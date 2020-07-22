

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


