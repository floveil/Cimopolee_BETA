#-------------------------------
#SERVER
#Page 2 : Historical Cyclones
#-------------------------------

output$map <- renderLeaflet({
        map
        })

observeEvent(input$picker_cyclone,{

        p <- input$picker_cyclone

        if (p!=" "){
            # Create Proxy for update the leaflet map
            proxy <- leafletProxy("map")
            # Get the name of the selected cyclone
            values$name_cyclone_selected <-df_name_cyclone[df_name_cyclone$name==p,]$name

            # Get lines and points of the selected cyclone
            cycl_l_selected <- mada_cycl_l[mada_cycl_l$NAME==values$name_cyclone_selected,]
            cycl_p_selected <- mada_cycl_p[mada_cycl_p$NAME==values$name_cyclone_selected,]

            # Get the accumulation rain raster for the selected cyclone
            r_cumul_file <- Sys.glob(paste0("./data/GPM_netcdf/cumul/*",values$name_cyclone_selected,".tif"))
            r_cumul <- raster::raster(r_cumul_file)
            #Get the time series accumulation rain file for the selected cyclone
            time_series <- read.csv(Sys.glob(paste0("./data/GPM_netcdf/Time_series/*",values$name_cyclone_selected,".csv")),sep=',', header = TRUE)

            # Make vector of colors for the accumulation rain raster
            rc1 <- colorRampPalette(colors = c("#595959", "#5a5865"), space = "Lab")(1)
            rc2 <- colorRampPalette(colors = c("#5a5865", "#615884"), space = "Lab")(5)
            rc3 <- colorRampPalette(colors = c("#615884", "#34758e"), space = "Lab")(10)
            rc4 <- colorRampPalette(colors = c("#34758e", "#0b8c81"), space = "Lab")(30)
            rc5 <- colorRampPalette(colors = c("#0b8c81", "#5c9964"), space = "Lab")(40)
            rc6 <- colorRampPalette(colors = c("#5c9964", "#9f9d54"), space = "Lab")(80)
            rc7 <- colorRampPalette(colors = c("#9f9d54", "#d39a78"), space = "Lab")(200)
            rc8 <- colorRampPalette(colors = c( "#d39a78","#fa9dbe"), space = "Lab")(500)
            rc9 <- colorRampPalette(colors = c("#fa9dbe","#dcdcdc"), space = "Lab")(800)
            # Combine the color palettes
            rampcols <- c(rc1, rc2,rc3,rc4,rc5,rc6,rc7,rc8,rc9)
            # Create a sum color palette
            pal <- colorNumeric(palette = rampcols, domain = c(0,800),na.color = "transparent")

            # Remove the legend of raster and clear point of the selected cyclone
            proxy %>%removeControl('cumul_legend')%>%clearMarkers()

            if(!is.null(p)){
                # Icons for points of the selected cyclone
                leafIcons <- leaflet::icons(
                              iconUrl = dplyr::case_when(
                                  cycl_p_selected $USA_SSH == 5 ~ "./www/c5.png",
                                  cycl_p_selected $USA_SSH == 4 ~ "./www/c4.png",
                                  cycl_p_selected $USA_SSH == 3 ~ "./www/c3.png",
                                  cycl_p_selected $USA_SSH ==2  ~ "./www/c2.png",
                                  cycl_p_selected $USA_SSH ==1  ~ "./www/c1.png",
                                  cycl_p_selected $USA_SSH ==0  ~ "./www/cTS.png",
                                  cycl_p_selected $USA_SSH ==-1  ~ "./www/cTD.png",
                                  cycl_p_selected $USA_SSH ==-2  ~ "./www/NA.png",
                                  cycl_p_selected $USA_SSH ==-3  ~ "./www/NA.png",
                                  cycl_p_selected $USA_SSH ==-4 ~ "./www/NA.png",
                                  cycl_p_selected $USA_SSH ==-5  ~ "./www/NA.png"),
                              iconWidth = 25, iconHeight = 25,
                              iconAnchorX = 0, iconAnchorY = 0)

                # Set label for each point of the selected cyclone
                labels_cyclone <- paste0("<font size=3px color=#212529 >",'<center><strong >', cycl_p_selected$NAME, '</strong></center>',"</font>",
                                            '<hr  class="popup" />',
                                            "<font size=2px>",'Date/Time : ', '<font color=#212529> <strong>', cycl_p_selected$ISO_TIME, '</strong>', "</font></font>",'<br/>',
                                            "<font size=2px>",'Wind Speed : ', '<font color=#212529><strong>', round(cycl_p_selected$wind_kmh,1), ' km/h </strong>',"</font></font>", '<br/>',
                                            "<font size=2px>",'Category (by SSHS*) : ','<font color=#212529><strong>', cycl_p_selected$category_t, '</strong>', "</font>",'</font><br/>',
                                            '<hr class="popup" width=10% ;  />',
                                            '<font size=1px>* Saffir-Simpson Hurricane Scale <a href="https://www.nhc.noaa.gov/aboutsshws.php">Link</a></font>', '<br/>',
                                            '<font size=1px>Source :  <a href="https://doi.org/10.25921/82ty-9e16">IBTrACS Project, Version 4</a></font>'," ")%>%
                                          lapply(htmltools::HTML)

                # Add news layers in the leaflet map
                proxy %>% addRasterImage(r_cumul,layerId = "raster",colors = pal,group = "Rainfall")%>%
                          addLegendNumeric(layerId = 'cumul_legend',pal=pal, values = values(r_cumul),
                                           title = "Cumul (mm)", width = 25, height = 180,position = 'bottomright',
                                           numberFormat = function(x) {prettyNum(x, format = "f", big.mark = ",", digits =0, scientific = FALSE) })%>%
                          addPolylines(data=st_combine(cycl_l_selected), layerId = "line_cyclone",color = "#C21010", group = "Cyclone")%>%
                          addMarkers(data=cycl_p_selected,icon = leafIcons, group = "Cyclone",layerId = paste(substr(cycl_p_selected$ISO_TIME, 1,10),substr(cycl_p_selected$ISO_TIME, 12,19)) ,
                                     popup= labels_cyclone,
                                     popupOptions = popupOptions(style = list("font-weight" = "normal",padding = "3px 50px"),
                                                                 direction = "auto", maxWidth = 500))%>%
                         addLayersControl(baseGroups = c("Satellite","OSM"),
                                          overlayGroups = c("Rainfall","Cyclone"),
                                          options = layersControlOptions(collapsed = FALSE))

                observeEvent(input$map_marker_click,{

                    proxy %>%removeImage(layerId = "raster")

                    event <- req(input$map_marker_click)
                    date_event <- str_replace_all(substr(event$id, 1,10),"-","")

                    # Get the accumulation rain raster for the selected cyclone
                    cumul_day_file <- Sys.glob(paste0("./data/GPM_netcdf/*",date_event,"*.nc4.nc"))
                    cumul_day_raster <- raster(cumul_day_file, crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
                    cumul_day_raster <-  flip(t(cumul_day_raster), direction = "x")

                    proxy %>% addRasterImage(cumul_day_raster,layerId = "raster2")
                    })

                # Add plot of rain cumul evolution in panel
                observeEvent(input$map_shape_click,{
                    event <- req(input$map_shape_click)
                    # Get the selected province
                    province_selected <- mada_admin[mada_admin$ADM2_EN== event$id,]
                    pluie_province <- merge(province_selected,time_series,by.x = "ADM2_EN",by.y="ADM2_EN" )
                    pluie_province_df <- as.data.frame(pluie_province)
                    pluie_province_df$time2 <- as.POSIXct( pluie_province_df$time2, tz = "UTC" )
                    pluie_province_df <- pluie_province_df[order(pluie_province_df$time2),]
                    cumul_pluie =sum(pluie_province_df$precipitationCal)
                    message <- HTML(paste("Selected District: ",  province_selected$ADM2_EN,"<br> (",province_selected$ADM1_EN,")<br>","Mean cumul : ",round(cumul_pluie,1), " mm" ))
                    output$province <- renderText(message)

                    output$plot_pluie <- renderPlotly({plot_ly()%>% add_trace(data = pluie_province_df ,x = pluie_province_df$time2, y = pluie_province_df$precipitationCal,
                                                                              type = 'scatter', mode = 'lines+markers',fill = 'tozeroy',
                                                                              line = list(color = 'rgb(33, 37, 41)'), fillcolor='rgba(33, 37, 41, 0.5)')%>%
                                                                    add_trace(data = pluie_province_df ,x = pluie_province_df$time2, y = pluie_province_df$precipitationCal,
                                                                              type = 'scatter', mode = 'markers',marker = list(color = 'rgb(33, 37, 41)'),
                                                                              hovertemplate = paste('<i>Time</i>: %{x}','<br><b>Rainfall</b>: %{y:.2f} mm<br><extra></extra>'))%>%
                                                                    layout(title = " " ,
                                                                           xaxis = list(title="",
                                                                                        tickangle=-45,
                                                                                        showgrid=TRUE,
                                                                                        gridwidth=1,fixedrange = TRUE),
                                                                           yaxis = list(title=list(text="Mean rainfall (mm)", font=list(size=18)),
                                                                                        side="left",fixedrange = TRUE),
                                                                           margin = list(l = 60, r=60),
                                                                           showlegend = FALSE)%>%
                                                                    config(displayModeBar = FALSE)})
                })
            }
        }
})
