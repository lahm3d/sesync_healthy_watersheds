library(dplyr)
library(leaflet)
library(raster)
library(sf)
library(foreign)
library(data.table)

# project directory

proj_dir <- "/home/labeeb/sesync_healthy_watersheds"
data_dir <- file.path(proj_dir, 'data')

setwd(data_dir)

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

# Column lists to fix
old_names <- c("SITEID", "YEAR1", "CBI_1", "FIBI_1", "BIBI_1",
               "HYPERLIN_1", "HWUniqID", "HWFlag", "HWGroup", "CBPModAGN","CBPModAGP",
               "CBPModAGS", "CBPModCSON", "CBPModCSOP", "CBPModCSOS",
               "CBPModDEVN", "CBPModDEVP", "CBPModDEVS", "CBPModSEPN",
               "CBPModSEPP", "CBPModSEPS", "CBPModWWN",  "CBPModWWP",
               "CBPModWWS",  "ClimateStr", "HousingUni", "MineDensit", "OutletAqCo",
               "PctAgOnHyd", "PctForestR", "PctForestW", "PctImpRZWs", "PctImpWs",
               "WildfireRi", "MngdTurfHC", "PctForestL", "PctFores_1", "PctWetla_1",
               "PctWetla_2", "DomesticWa", "Industrial", "RoadDensit", "Pct303dImp",
               "HabConditi", "HabCondi_1", "HabCondi_2", "CatchmentA",
               "WaterUseSu", "LandUseCha", "ClimateCha", "WaterQuali", "Geomorphol",
               "HabitatSub", "LandCondSu", "BioCondSub", "HydrologyS", "WildfireSu",
               "Vulnerabil", "Health_Ind", "Brook_Trou", "Brook_Tr_1"
)
new_names <- c ("MDSITEID", "YEAR", "MD_CUMBI", "MD_FIBI", "MD_BIBI", "HYPERLINK", "HWUID",
                "CBP_SIHW", "HW_Outlet", "CBP_Ag_N", "CBP_Ag_P", "CBP_Ag_S", "CBP_CSO_N", "CBP_CSO_P","CBP_CSO_S",
                "CBP_DEV_N", "CBP_DEV_P", "CBP_DEV_S", "CBP_SEP_N",
                "CBP_SEP_P", "CBP_SEP_S", "CBP_WW_N",  "CBP_WW_P",
                "CBP_WW_S",  "Cli_Stress", "HousUnit", "MineDensity", "Out_Aq_Con",
                "PctAg_Hyd_S", "PctForeRZ", "PctForeWshed", "PctImpRZ", "PctImpWshed",
                "Wld_Fir_Rsk", "Mngd_TF_HCZ", "PctForeLos", "PctFores_1", "PctWetWshed",
                "PctWetla_2", "Dom_WatUse", "Ind_WatUse", "Road_Dens", "Pct_303d_Cat",
                "HabConditi", "HabCondi_1", "HabCondi_2", "Catch_Area",
                "WatUse_SIndx", "LUChange_SIndx", "ClimtChg_SIndx", "WatQual_SIndx", "Geomor_SIndx",
                "Hab_SIndx", "LandCondSu", "BioCondSub", "HydrologyS", "WildfireSu",
                "Vuln_SInx", "Health_Index", "BrkTrt_Curr", "BrkTrt_6deg"
)
new_columns <- c("OBJECTID", "MDSITEID", "YEAR", "MD_CUMBI", "MD_FIBI", "MD_BIBI", "HYPERLINK",
                 "COMID", "HWUID", "CBP_SIHW", "HW_Outlet", "State", "County", "PctNatural", "PctForeRZ","PopDensity","HousUnit",
                 "MineDensity","Mngd_TF_HCZ","PctForeLos", "LandCondSu","PctAg_Hyd_S","PctWetla_2","PctForeWshed", "PctImpWshed",
                 "RoadStream", "PctForeLos","PctWetland","DamDensity","Road_Dens","PctWetWshed", "PctImpRZ","PctVulnGeo", "HabConditi","HabCondi_1", "HabCondi_2", "PctNatlCon",
                 "Out_Aq_Con","Pct_303d_Cat","SPARROWTN", "SPARROWTP","CBP_Ag_N", "CBP_Ag_P","CBP_Ag_S", "CBP_CSO_N", "CBP_CSO_P", "CBP_CSO_S",
                 "CBP_DEV_N", "CBP_DEV_P", "CBP_DEV_S", "CBP_SEP_N", "CBP_SEP_P", "CBP_SEP_S", "CBP_WW_N", "CBP_WW_P", "CBP_WW_S",
                 "FutureDev","AvgPctFore", "PctProtLan", "AgWaterUse", "Dom_WatUse","Ind_WatUse","Wld_Fir_Rsk", "BrkTrt_Curr", "BrkTrt_6deg",
                 "Cli_Stress", "HUC12_ID", "HUC12_Acre", "HUC12_DS", "HUC12_Name","HUC12_Type", "Headwater", "Catch_Area", "StateFIPS", "CountyFIPS",
                 "FIPS",  "Shape_Leng", "Shape_Area", "BUFPctFor", "BUFPctImp")

# fix columns
chwa_mbss_df <- data.frame(chwa_mbss)
chwa_mbss_df <- setnames(chwa_mbss_df, old=old_names, new=new_names, skip_absent = TRUE)
chwa_mbss_df <- chwa_mbss_df[new_columns]
write.csv(chwa_mbss_df, 'chwa_mbss.csv', row.names=FALSE)

####

df <- read.csv('chwa_mbss.csv')

df %>%
  # 1 - filter and excludes catchments with no data
  filter(COMID > 0) %>%
  # 2 - group by comid
  group_by(COMID) %>%
  # 3 - calculate min ranks 
  summarize(mn_yr = min(YEAR)) -> ranks_df

# 4 - merge ranks_df to df
df <- merge(df, ranks_df, by = "COMID", all = TRUE)
# 5 - calculate ranks using yr-(min_year-1)
df['ranks'] <- df$YEAR - (df$mn_yr -1)
# 6 - convert chars to numeric
char_cols <- c("MD_CUMBI", "MD_FIBI", "MD_BIBI")
df[char_cols] <- sapply(df[char_cols],as.numeric)

df %>%
  # 7 - use group-by on COMID
  group_by(COMID) %>%
  # 8 - summarize using weighted.mean()
  mutate(wgt_mdcubi = weighted.mean(MD_CUMBI, ranks, na.rm = TRUE)) %>%
  mutate(wgt_mdfibi = weighted.mean(MD_FIBI, ranks, na.rm = TRUE)) %>%
  mutate(wgt_mdbibi = weighted.mean(MD_BIBI, ranks, na.rm = TRUE)) %>%
  # 9 remove duplicates
  distinct(COMID, .keep_all = TRUE) -> df

############VISUALIZATION

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
