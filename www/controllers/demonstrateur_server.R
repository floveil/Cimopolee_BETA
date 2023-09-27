
output$map_demo<- renderLeaflet({
        map_custom
        })

proxy_custom <- leafletProxy("map_demo")


# observeEvent(input$map_demo_marker_click,{
#     event <- req(input$map_demo_marker_click)
#     date_event <- event$id
#     year <- str_sub(date_event, 1, 4)
#     nb_day <- str_pad(lubridate::yday(date_event),3,pad="0")
#     hour <- str_sub(date_event, -8, -7)
#     name_nc <- paste0(year,nb_day,".",hour,"_resampled.tif")
#
#     #Get the accumulation rain raster for the selected cyclone
#     cumul_day_file <- Sys.glob(paste0("/home/florent/PycharmProjects/precipitation_product/data/MSWEP2/3hourly/geotiff_Freddy/",name_nc))
#     cumul_day_raster <- raster(cumul_day_file, crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
#     cumul_day_raster[cumul_day_raster < 0.1] <- NA
#     #cumul_day_raster <-  flip(t(cumul_day_raster), direction = "x")
#
#     # Make vector of colors for the accumulation rain raster
#     rc1 <- colorRampPalette(colors = c("#595959", "#5a5865"), space = "Lab")(1)
#     rc2 <- colorRampPalette(colors = c("#5a5865", "#615884"), space = "Lab")(5)
#     rc3 <- colorRampPalette(colors = c("#615884", "#34758e"), space = "Lab")(10)
#     rc4 <- colorRampPalette(colors = c("#34758e", "#0b8c81"), space = "Lab")(30)
#     rc5 <- colorRampPalette(colors = c("#0b8c81", "#5c9964"), space = "Lab")(40)
#     rc6 <- colorRampPalette(colors = c("#5c9964", "#9f9d54"), space = "Lab")(80)
#     rc7 <- colorRampPalette(colors = c("#9f9d54", "#d39a78"), space = "Lab")(200)
#     rc8 <- colorRampPalette(colors = c( "#d39a78","#fa9dbe"), space = "Lab")(500)
#     rc9 <- colorRampPalette(colors = c("#fa9dbe","#dcdcdc"), space = "Lab")(800)
#     # Combine the color palettes
#     rampcols <- c(rc1, rc2,rc3,rc4,rc5,rc6,rc7,rc8,rc9)
#
#     pal <- colorNumeric(palette = rampcols, domain = c(0,800),na.color = "transparent")
#     proxy %>%removeImage(layerId = "raster2")%>%removeControl('cumul_legend')
#
#     proxy_custom %>% addRasterImage(cumul_day_raster,layerId = "raster2",colors=pal,opacity=1)%>%
#         addLegendNumeric(layerId = 'cumul_legend',pal=pal, values = values(cumul_day_raster),
#                                            title = "Cumul (mm)", width = 25, height = 180,position = 'bottomleft',
#                                            numberFormat = function(x) {prettyNum(x, format = "f", big.mark = ",", digits =0, scientific = FALSE) })
# })


map_df <- reactive({
    if (nchar(format(input$years))==10){
            date_selected <- paste0(format(input$years), " 00:00:00")
        }else{
            date_selected <- format(input$years)}

    date_event <- date_selected
    values$date_event <- date_event
    year <- str_sub(date_event, 1, 4)
    nb_day <- str_pad(lubridate::yday(date_event),3,pad="0")
    hour <- str_sub(date_event, 12, 13)
    name_nc <- paste0(year,nb_day,".",hour,"_resampled.tif")
    cumul_day_file <- Sys.glob(paste0("./data/MSWEP/3hourly/",name_nc))
    cumul_day_raster <- raster(cumul_day_file, crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
    cumul_day_raster[cumul_day_raster < 0.1] <- NA
    return(cumul_day_raster)
    })

observeEvent(map_df(),{
    point_cyclone <- freddy_p

    point_selected <- point_cyclone[point_cyclone $ISO_TIME == values$date_event ,]
    other_points <- point_cyclone[point_cyclone $ISO_TIME != values$date_event , ]

    leafIcons_selected <- leaflet::icons(
                          iconUrl = dplyr::case_when(
                              point_selected $USA_SSH == 5 ~ "./www/c5.png",
                              point_selected $USA_SSH == 4 ~ "./www/c4.png",
                              point_selected $USA_SSH == 3 ~ "./www/c3.png",
                              point_selected $USA_SSH ==2  ~ "./www/c2.png",
                              point_selected $USA_SSH ==1  ~ "./www/c1.png",
                              point_selected $USA_SSH ==0  ~ "./www/cTS.png",
                              point_selected $USA_SSH ==-1  ~ "./www/cTD.png",
                              point_selected $USA_SSH ==-2  ~ "./www/NA.png",
                              point_selected $USA_SSH ==-3  ~ "./www/NA.png",
                              point_selected $USA_SSH ==-4 ~ "./www/NA.png",
                              point_selected $USA_SSH ==-5  ~ "./www/NA.png"),
                          iconWidth = 50, iconHeight = 50,
                          iconAnchorX = 0, iconAnchorY = 0)

    labels_cyclone_selected <- paste0("<font size=3px color=#212529 >",'<center><strong >', point_selected$NAME, '</strong></center>',"</font>",
                                            '<hr  class="popup" />',
                                            "<font size=2px>",'Date/Time : ', '<font color=#212529> <strong>', point_selected$ISO_TIME, '</strong>', "</font></font>",'<br/>',
                                            "<font size=2px>",'Wind Speed : ', '<font color=#212529><strong>', round(point_selected$wind_kmh,1), ' km/h </strong>',"</font></font>", '<br/>',
                                            "<font size=2px>",'Category (by SSHS*) : ','<font color=#212529><strong>', point_selected$category_t, '</strong>', "</font>",'</font><br/>',
                                            '<hr class="popup" width=10% ;  />',
                                            '<font size=1px>* Saffir-Simpson Hurricane Scale <a href="https://www.nhc.noaa.gov/aboutsshws.php">Link</a></font>', '<br/>',
                                            '<font size=1px>Source :  <a href="https://doi.org/10.25921/82ty-9e16">IBTrACS Project, Version 4</a></font>'," ")%>%
                                          lapply(htmltools::HTML)

    proxy_custom  %>%removeImage(layerId = "raster3")
        proxy_custom %>%
            addMarkers(data = other_points, layerId = paste(substr(other_points$ISO_TIME, 1,10),substr(other_points$ISO_TIME, 12,19)),
                       icon = leafIcons,label= labels_cyclone,group = "Trajectoire cyclone")%>%
             addMarkers(data = point_selected, layerId = paste(substr(point_selected$ISO_TIME, 1,10),substr(point_selected$ISO_TIME, 12,19)),
                       icon = leafIcons_selected,label=labels_cyclone_selected,group = "Trajectoire cyclone")%>%
            addRasterImage(map_df(),layerId = "raster3",colors = palh,group="Pluie horaire")%>%
            addLegendNumeric(layerId = 'rain',pal=palh, values = values(map_df()),
                             title = "Precipitation (mm/hr)", width = 25, height = 180,position = 'bottomleft',group="Pluie horaire") %>%
            updateLayersControl(addBaseGroups = c("OSM","Satellite"),
                                addOverlayGroups = c( "Zones en eau","Limites administratives","Trajectoire cyclone","Accumulation pluie","Pluie horaire"),
                                options = layersControlOptions(collapsed = FALSE))%>%
            hideGroup(group= "Accumulation pluie")})



observeEvent(input$map_demo_marker_click,{
        event <- input$map_demo_marker_click
        value_point <- as.POSIXct(event$id, tz="UTC")
        updateSliderInput(session, "years", value = value_point, label=NULL,
                          as.POSIXct("2023-02-06 00:00:00", tz="UTC"), max = as.POSIXct("2023-03-14 21:00:00", tz="UTC"),timezone="+0000")})












observeEvent(input$map_demo_shape_click,{
                event <- req(input$map_demo_shape_click)
                values$clicked <- event

                time_serie_file <- read.csv(Sys.glob(paste0("./data/MSWEP/time_serie_",values$clicked ,"_FREDDY.csv")),sep=',', header = TRUE )
                time_serie_file <- time_serie_file[order(time_serie_file$time),]
                pluie_province_df <- time_serie_file




                province_selected <- mada_admin[mada_admin$ADM2_EN==event$id,]
                proxy_custom %>%clearGroup("select")
                proxy_custom %>% addPolygons(data = province_selected  ,
                              fillColor = "red",
                              fillOpacity = 0,
                              color = "red",
                              weight = 2,
                              stroke = T,
                              group="select")






                # pluie_province_df <- pluie_province_df[order(pluie_province_df$time),]
                cumul_pluie =sum(pluie_province_df$precipitation)
                message <- HTML(paste("District: ",  province_selected$ADM2_EN,"<br> <br> (",province_selected$ADM1_EN,")<br> <br>" ))
                output$province2 <- renderText(message)

                ay <- list(tickfont = list(color = "red",size=16),
                           overlaying = "y",
                           side = "right",
                           title=list(text="Pluie accumulée (mm)", font=list(size=20, color= 'red')),
                           zeroline=FALSE,
                            range = c(0,max(cumsum(pluie_province_df$precipitation)+100))
                           # ticktext = list(0,
                           #                 100,
                           #                 200),
                           # tickvals = list(ceiling(-max(cumsum(pluie_province_df$precipitation))),
                           #                 ceiling(-max(cumsum(pluie_province_df$precipitation))/2),
                           #                 "test")
                )

                output$plot_pluie5 <- renderPlotly({plot_ly()%>% add_trace(data = pluie_province_df ,x = pluie_province_df$time, y = -pluie_province_df$precipitation,
                                                                          type = 'bar',
                                                                          marker = list(color = 'rgba(70,130,180, 0.8)',
                                                                                        line = list(color = 'rgb(70,130,180)')),
                                                                          meta = abs(-pluie_province_df$precipitation),
                                                                          hovertemplate = paste('<i>Time</i>: %{x}','<br><b>Rainfall</b>: %{meta:.2f} mm<br><extra></extra>'))%>%
                                                                add_trace(data = pluie_province_df ,
                                                                          yaxis = "y2",
                                                                          width = 4,
                                                                          x = pluie_province_df$time,
                                                                          y = cumsum(pluie_province_df$precipitation),
                                                                          line = list(color = 'rgb(205, 12, 24)'),
                                                                          type = 'scatter', mode = 'lines',
                                                                          meta = cumsum(pluie_province_df$precipitation),
                                                                          hovertemplate = paste('<i>Time</i>: %{x}','<br><b>Cumul</b>: %{meta:.2f} mm<br><extra></extra>'))%>%
                                                                add_segments(x = input$years, xend = input$years,
                                                                             y = 0, yend = -200,
                                                                             line = list(color ="black", dash="dot", size=5),
                                                                             hovertemplate = paste('<i>Time</i>: %{x}')) %>%
                                                                layout(title = " " ,
                                                                       yaxis2 = ay,
                                                                       xaxis = list(title = " ",
                                                                                    zeroline = TRUE,showline=TRUE,
                                                                                    showticklabels = FALSE, showgrid = TRUE),
                                                                       yaxis = list(title=list(text="Pluie (mm/h)", font=list(size=20, color= 'rgb(70,130,180)')),
                                                                                    tickfont = list(size=16, color= 'rgb(70,130,180)'),
                                                                                    side="left",fixedrange = TRUE, range = c(-60,0),
                                                                                    ticktext = list(0,10,
                                                                                                    20,30,40,50,60
                                                                                    ),
                                                                                    tickvals = list(0,-10,
                                                                                                    -20,-30,
                                                                                                    -40,-50,-60)),
                                                                       margin = list(l = 10, r=80),
                                                                       showlegend = FALSE)%>%
                                                                config(displayModeBar = FALSE)})




})

            #})
