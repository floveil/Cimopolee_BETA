# mada_s_tile <-st_zm(st_read("./data/mada_Sentinel_tiles/Tile_mada.shp"))
mada_admin <- st_read("./data/mada_shp/mdg_admbnda_adm2_BNGRC_OCHA_20181031.shp")
mada_admin2 <- st_read("./data/mada_shp/mdg_admbnda_adm0_BNGRC_OCHA_20181031.shp")
# tile_s <- raster::raster("/home/florent/sen2change_data/data/CVA/38KND/S2B_MSIL2A_20171225T071209_N0206_R020_T38KND_20171225T102551/S2A_MSIL2A_20180129T071211_N0206_R020_T38KND_20180129T104706/CVA3D_S2B_MSIL2A_20171225T071209_N0206_R020_T38KND_20171225T102551-S2A_MSIL2A_20180129T071211_N0206_R020_T38KND_20180129T104706_classif_CM002_SM_CM_RC.jp2")
total_rain <- raster::raster("./data/MSWEP/mean_total_Mada.nc")
pal <- colorNumeric(c("#cdc6ae", "#a3b4a2", "#38686a","#187795","#2589bd"), values(total_rain*10), na.color = "transparent")
density <- raster::raster("./data/density/mdg_pd_2020_1km_UNadj.tif")
at <- c(0,5,10,20,50,1000,round(maxValue(density),0))
pal_quant <- colorBin(palette = "YlOrRd", bins = at, domain = at,na.color = "transparent")

#DEMO : FREDDY
freddy_p <- st_read("./data/cyclones/IBTrACS.SI.list.v04r00.points_Freddy.shp")
freddy_l <- st_read("./data/cyclones/IBTrACS.SI.list.v04r00.lines_Freddy.shp")
fredd_acc <- raster::raster("./data/MSWEP/cumul_freddy.tif")
pal_acc_freddy <- colorNumeric(c("#cdc6ae", "#a3b4a2", "#38686a","#187795","#2589bd"), values(fredd_acc ), na.color = "transparent")
KLV38 <- st_read("./data/result_sen2change/38KLV_wgs84_mada.shp")
KLA38 <- st_read("./data/result_sen2change/38KLA_wgs84_mada.shp")

leafIcons <- leaflet::icons(
                              iconUrl = dplyr::case_when(
                                  freddy_p  $USA_SSH == 5 ~ "./www/c5.png",
                                  freddy_p  $USA_SSH == 4 ~ "./www/c4.png",
                                  freddy_p  $USA_SSH == 3 ~ "./www/c3.png",
                                  freddy_p  $USA_SSH ==2  ~ "./www/c2.png",
                                  freddy_p  $USA_SSH ==1  ~ "./www/c1.png",
                                  freddy_p  $USA_SSH ==0  ~ "./www/cTS.png",
                                  freddy_p  $USA_SSH ==-1  ~ "./www/cTD.png",
                                  freddy_p  $USA_SSH ==-2  ~ "./www/NA.png",
                                  freddy_p  $USA_SSH ==-3  ~ "./www/NA.png",
                                  freddy_p  $USA_SSH ==-4 ~ "./www/NA.png",
                                  freddy_p  $USA_SSH ==-5  ~ "./www/NA.png"),
                              iconWidth = 25, iconHeight = 25,
                              iconAnchorX = 0, iconAnchorY = 0)

labels_cyclone <- paste0("<font size=3px color=#212529 >",'<center><strong >', freddy_p$NAME, '</strong></center>',"</font>",
                                            '<hr  class="popup" />',
                                            "<font size=2px>",'Date/Time : ', '<font color=#212529> <strong>', freddy_p$ISO_TIME, '</strong>', "</font></font>",'<br/>',
                                            "<font size=2px>",'Wind Speed : ', '<font color=#212529><strong>', round(freddy_p$wind_kmh,1), ' km/h </strong>',"</font></font>", '<br/>',
                                            "<font size=2px>",'Category (by SSHS*) : ','<font color=#212529><strong>', freddy_p$category_t, '</strong>', "</font>",'</font><br/>',
                                            '<hr class="popup" width=10% ;  />',
                                            '<font size=1px>* Saffir-Simpson Hurricane Scale <a href="https://www.nhc.noaa.gov/aboutsshws.php">Link</a></font>', '<br/>',
                                            '<font size=1px>Source :  <a href="https://doi.org/10.25921/82ty-9e16">IBTrACS Project, Version 4</a></font>'," ")%>%
                                          lapply(htmltools::HTML)


#map past cyclone
map <- leaflet(options = leafletOptions(zoomControl = FALSE,wheelPxPerZoomLevel=150, zoomSnap= 0.05)) %>%
        addPolygons(data=mada_admin,weight = 1, fillOpacity = 0, color="#20262E",layerId = ~ADM2_EN,
                    label= sprintf("<font size=2px color=#20262E ><strong>District : %s </font><br/> <font size=1px color=#20262E >Region : %s </font></strong>", mada_admin$ADM2_EN, mada_admin$ADM1_EN) %>% lapply(htmltools::HTML),
                    highlightOptions =highlightOptions(color = "#20262E", weight = 3, bringToFront = TRUE,opacity = 0.8))%>%
        addRasterImage(total_rain*10, opacity = 0.75, group="Pluie moyenne (1980-2022)", colors=pal)%>%
        addLegend(values = values(total_rain*10), title = "Pluie moyenne (mm/mois)",pal=pal, group = "Pluie moyenne (1980-2022)",position="bottomleft" )%>%
        addRasterImage(density, opacity = 0.75, group="Densité (2020)",colors = pal_quant)%>%
        addLegend(values = values(density), title = "Densité (habitants/km2)",pal=pal_quant, group = "Densité (2020)",position="bottomleft" )%>%
        addProviderTiles(providers$CartoDB.Positron,group = "OSM")%>%
        addProviderTiles(providers$Esri.WorldImagery,group = "Satellite")%>%
        addLayersControl(baseGroups = c("OSM","Satellite"),
                         overlayGroups = c("Pluie moyenne (1980-2022)","Densité (2020)"),
                         position="topleft",
                         options = layersControlOptions(collapsed = FALSE))%>%
        hideGroup(group=c("Pluie moyenne (1980-2022)","Densité (2020)"))

#map customize
map_custom <- leaflet(options = leafletOptions(wheelPxPerZoomLevel=150, zoomSnap= 0.05)) %>%
        #addPolygons(data=mada_s_tile, color =  "grey", weight = 1, fillOpacity = 0.2,group="Tiles",layerId = ~)%>%
        addPolygons(data=mada_admin,weight = 1, fillOpacity = 0, color="black",layerId = ~ADM2_EN ,group="Limites administratives", label = paste("District :",mada_admin$ADM2_EN," - Region :" ,mada_admin$ADM1_EN),
                    highlightOptions =highlightOptions(color = "#CC0000", weight = 3, bringToFront = TRUE))%>%
        addPolygons(data=KLV38 ,weight = 1, fillOpacity = 1, color="blue", group="Zones en eau")%>%
        addPolygons(data=KLA38 ,weight = 1, fillOpacity = 1, color="blue", group="Zones en eau")%>%
        addPolylines(data=freddy_l, layerId = "freddy_l",color = "#C21010", group = "Trajectoire cyclone")%>%
        addMarkers(data=freddy_p, group = "Trajectoire cyclone",icon = leafIcons,layerId = paste(substr(freddy_p$ISO_TIME, 1,10),substr(freddy_p$ISO_TIME, 12,19)),
               popup= labels_cyclone,
               popupOptions = popupOptions(style = list("font-weight" = "normal",padding = "3px 50px"),
                                           direction = "auto", maxWidth = 500))%>%
        addRasterImage(fredd_acc, opacity = 0.75, group="Accumulation pluie", colors=pal_acc_freddy)%>%
        addLegendNumeric(values = values(fredd_acc), title = "Accumulation pluie (mm)",pal=pal_acc_freddy, group = "Accumulation pluie",position="bottomleft" )%>%
        addProviderTiles(providers$CartoDB.Positron,group = "OSM")%>%
        addProviderTiles(providers$Esri.WorldImagery,group = "Satellite")%>%
        addLayersControl(baseGroups = c("OSM","Satellite"),
                         overlayGroups = c("Zones en eau","Limites administratives","Trajectoire cyclone","Accumulation pluie"),
                         position="topleft",
                         options = layersControlOptions(collapsed = FALSE))%>%
        hideGroup(group=c("Accumulation pluie"))







#
# #map customize 2
# map_custom2 <- leaflet() %>%
#         #addPolygons(data=mada_s_tile, color =  "grey", weight = 1, fillOpacity = 0.2,group="Tiles",layerId = ~)%>%
#         addPolygons(data=mada_admin,weight = 1, fillOpacity = 0, color="black",layerId = ~ADM2_PCODE , label = paste("District :",mada_admin$ADM2_EN," - Region :" ,mada_admin$ADM1_EN),
#                     highlightOptions =highlightOptions(color = "#CC0000", weight = 3, bringToFront = TRUE))%>%
#         addProviderTiles(providers$Esri.WorldImagery,group = "Satellite")%>%
#         addProviderTiles(providers$OpenStreetMap.DE,group = "OSM")%>%
#         addLayersControl(baseGroups = c("Satellite","OSM"),
#                          options = layersControlOptions(collapsed = FALSE))


# #map customize
# map_custom1 <- leaflet() %>%
#         #addPolygons(data=mada_s_tile, color =  "grey", weight = 1, fillOpacity = 0.2,group="Tiles",layerId = ~)%>%
#         addPolygons(data=mada_admin,weight = 1, fillOpacity = 0, color="black",layerId = ~ADM2_PCODE , label = paste("District :",mada_admin$ADM2_EN," - Region :" ,mada_admin$ADM1_EN),
#                     highlightOptions =highlightOptions(color = "#CC0000", weight = 3, bringToFront = TRUE))%>%
#         addProviderTiles(providers$Esri.WorldImagery,group = "Satellite")%>%
#         addProviderTiles(providers$OpenStreetMap.DE,group = "OSM")%>%
#         addLayersControl(baseGroups = c("Satellite","OSM"),
#                          options = layersControlOptions(collapsed = FALSE))
#
# #map customize 2
# map_custom3 <- leaflet() %>%
#         #addPolygons(data=mada_s_tile, color =  "grey", weight = 1, fillOpacity = 0.2,group="Tiles",layerId = ~)%>%
#         addPolygons(data=mada_admin,weight = 1, fillOpacity = 0, color="black",layerId = ~ADM2_PCODE , label = paste("District :",mada_admin$ADM2_EN," - Region :" ,mada_admin$ADM1_EN),
#                     highlightOptions =highlightOptions(color = "#CC0000", weight = 3, bringToFront = TRUE))%>%
#         addProviderTiles(providers$Esri.WorldImagery,group = "Satellite")%>%
#         addProviderTiles(providers$OpenStreetMap.DE,group = "OSM")%>%
#         addLayersControl(baseGroups = c("Satellite","OSM"),
#                          options = layersControlOptions(collapsed = FALSE))
