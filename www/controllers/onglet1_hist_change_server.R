output$map_custom <- renderLeaflet({
        map_custom
        })

output$map_custom2 <- renderLeaflet({
        map_custom2%>%
                    addPolygons(data=mada_s_tile, color =  "grey", weight = 1, fillOpacity = 0.2,group="Tiles", label = ~Name,layerId = ~Name,
                                highlightOptions =highlightOptions(color = "#CC0000", weight = 3, bringToFront = TRUE))
        })



# Create Proxy for update the leaflet map
proxy <- leafletProxy("map_custom")


observeEvent(input$picker_cyclone,{

    p <- input$picker_cyclone

    if (p!=" "){
        # Get the name of the selected cyclone
        values$name_cyclone_selected <-df_name_cyclone[df_name_cyclone$name==p,]$name

        # Get lines and points of the selected cyclone
        cycl_l_selected <- mada_cycl_l[mada_cycl_l$NAME==values$name_cyclone_selected,]
        cycl_p_selected <- mada_cycl_p[mada_cycl_p$NAME==values$name_cyclone_selected,]
        values$point_cyclone <- cycl_p_selected


        # Get the accumulation rain raster for the selected cyclone
        # r_cumul_file <- Sys.glob(paste0("./data/GPM_netcdf/cumul/*",values$name_cyclone_selected,".tif"))
        # r_cumul <- raster::raster(r_cumul_file)
        #Get the time series accumulation rain file for the selected cyclone
        time_series <- read.csv(Sys.glob(paste0("/home/florent/PycharmProjects/ShinyApp/data/GPM_hourly/test/*",values$name_cyclone_selected,".csv")),sep=',', header = TRUE)


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
            values$icon_leaf <- leafIcons


            # Set label for each point of the selected cyclone
            labels_cyclone <- paste0("<font size=3px color=#198754 >",'<center><strong >', cycl_p_selected$NAME, '</strong></center>',"</font>",
                                        '<hr  class="popup" />',
                                        "<font size=2px>",'Date/Time : ', '<font color=#198754> <strong>', cycl_p_selected$ISO_TIME, '</strong>', "</font></font>",'<br/>',
                                        "<font size=2px>",'Wind Speed : ', '<font color=#198754><strong>', round(cycl_p_selected$wind_kmh,1), ' km/h </strong>',"</font></font>", '<br/>',
                                        "<font size=2px>",'Pressure (hPa) : ', '<font color=#198754><strong>', round(cycl_p_selected$USA_PRES,1), ' hPa </strong>',"</font></font>", '<br/>',
                                        "<font size=2px>",'Category (by SSHS*) : ','<font color=#198754><strong>', cycl_p_selected$category_t, '</strong>', "</font>",'</font><br/>',
                                        '<hr class="popup" width=10% ;  />',
                                        '<font size=1px>* Saffir-Simpson Hurricane Scale <a href="https://www.nhc.noaa.gov/aboutsshws.php">Link</a></font>', '<br/>',
                                        '<font size=1px>Source :  <a href="https://doi.org/10.25921/82ty-9e16">IBTrACS Project, Version 4</a></font>'," ")%>%
                                      lapply(htmltools::HTML)
            values$lab_cycl <- labels_cyclone

            # Add news layers in the leaflet map
            proxy %>% #addRasterImage(r_cumul,layerId = "raster",colors = pal,group = "Rainfall")%>%
                      # addLegendNumeric(layerId = 'cumul_legend',pal=pal, values = values(r_cumul),
                      #                  title = "Cumul (mm)", width = 25, height = 180,position = 'bottomright',group="Rainfall",
                      #                  numberFormat = function(x) {prettyNum(x, format = "f", big.mark = ",", digits =0, scientific = FALSE) })%>%
                      addPolylines(data=st_combine(cycl_l_selected), layerId = "line_cyclone",color = "#C21010", group = "Cyclone")%>%
                      addMarkers(data=cycl_p_selected,icon = leafIcons, group = "Cyclone",layerId = paste(substr(cycl_p_selected$ISO_TIME, 1,10),substr(cycl_p_selected$ISO_TIME, 12,19)) ,
                                 popup= labels_cyclone,
                                 popupOptions = popupOptions(style = list("font-weight" = "normal",padding = "3px 50px"),
                                                             direction = "auto", maxWidth = 500))%>%
                     addLayersControl(baseGroups = c("Satellite","OSM"),
                                      overlayGroups = c("Rainfall","Cyclone"),
                                      options = layersControlOptions(collapsed = FALSE))

            # observeEvent(input$map_marker_click,{
            #
            #     proxy %>%removeImage(layerId = "raster")
            #
            #     event <- req(input$map_marker_click)
            #     date_event <- str_replace_all(substr(event$id, 1,10),"-","")
            #
            #     # Get the accumulation rain raster for the selected cyclone
            #     cumul_day_file <- Sys.glob(paste0("./data/GPM_netcdf/*",date_event,"*.nc4.nc"))
            #     cumul_day_raster <- raster(cumul_day_file, crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
            #     cumul_day_raster <-  flip(t(cumul_day_raster), direction = "x")
            #
            #     proxy %>% addRasterImage(cumul_day_raster,layerId = "raster2")
            #
            #
            #
            #     })

            #Add plot of rain cumul evolution in panel
            observeEvent(input$map_custom_shape_click,{
                event <- req(input$map_custom_shape_click)
                values$clicked <- event

                # Get the selected province
                province_selected <- mada_admin[mada_admin$ADM2_PCODE== event$id,]
                pluie_province <- merge(province_selected,time_series,by.x = "ADM2_EN",by.y="ADM2_EN" )
                pluie_province_df <- as.data.frame(pluie_province)
                pluie_province_df$time2 <- as.POSIXct( pluie_province_df$time, tz = "UTC" )
                pluie_province_df <- pluie_province_df[order(pluie_province_df$time),]
                cumul_pluie =sum(pluie_province_df$precipitationCal)
                message <- HTML(paste("Selected District: ",  province_selected$ADM2_EN,"<br> <br> (",province_selected$ADM1_EN,")<br> <br>","Mean cumul : ",round(cumul_pluie,1), " mm" ))
                output$province <- renderText(message)

                ay <- list(tickfont = list(color = "red",size=16),
                           overlaying = "y",
                           side = "right",
                           title=list(text="Cumulative Precipitation (mm)", font=list(size=20, color= 'red')),
                           zeroline=FALSE,
                            range = c(0,200)
                           # ticktext = list(0,
                           #                 100,
                           #                 200),
                           # tickvals = list(ceiling(-max(cumsum(pluie_province_df$precipitationCal))),
                           #                 ceiling(-max(cumsum(pluie_province_df$precipitationCal))/2),
                           #                 "test")
                )

                output$plot_pluie <- renderPlotly({plot_ly()%>% add_trace(data = pluie_province_df ,x = pluie_province_df$time, y = -pluie_province_df$precipitationCal,
                                                                          type = 'bar',
                                                                          marker = list(color = 'rgba(70,130,180, 0.8)',
                                                                                        line = list(color = 'rgb(70,130,180)')),
                                                                          meta = abs(-pluie_province_df$precipitationCal),
                                                                          hovertemplate = paste('<i>Time</i>: %{x}','<br><b>Rainfall</b>: %{meta:.2f} mm<br><extra></extra>'))%>%
                                                                add_trace(data = pluie_province_df ,
                                                                          yaxis = "y2",
                                                                          x = pluie_province_df$time,
                                                                          y = cumsum(pluie_province_df$precipitationCal),
                                                                          line = list(color = 'rgb(205, 12, 24)'),
                                                                          marker = list(color = 'rgb(205, 12, 24)'),
                                                                          type = 'scatter', mode = 'lines+markers',
                                                                          meta = cumsum(pluie_province_df$precipitationCal),
                                                                          hovertemplate = paste('<i>Time</i>: %{x}','<br><b>Cumul</b>: %{meta:.2f} mm<br><extra></extra>'))%>%
                                                                add_segments(x = values$p_selected$ISO_TIME, xend = values$p_selected$ISO_TIME,
                                                                             y = 0, yend = -200,
                                                                             line = list(color ="black", dash="dot", size=5),
                                                                             hovertemplate = paste('<i>Time</i>: %{x}')) %>%
                                                                layout(title = " " ,
                                                                       yaxis2 = ay,
                                                                       xaxis = list(title = " ",
                                                                                    zeroline = TRUE,showline=TRUE,
                                                                                    showticklabels = FALSE, showgrid = TRUE),
                                                                       yaxis = list(title=list(text="Daily Rain (mm)", font=list(size=20, color= 'rgb(70,130,180)')),
                                                                                    tickfont = list(size=16, color= 'rgb(70,130,180)'),
                                                                                    side="left",fixedrange = TRUE, range = c(-40,0),
                                                                                    ticktext = list(0,10,
                                                                                                    20,30,40
                                                                                    ),
                                                                                    tickvals = list(0,-10,
                                                                                                    -20,-30,
                                                                                                    -40)),
                                                                       margin = list(l = 10, r=60),
                                                                       showlegend = FALSE)%>%
                                                                config(displayModeBar = FALSE)})



            })


        }
    }
})

###################################################

        output$years <- renderUI({
                    if (length(st_geometry(values$point_cyclone)) !=0){
                        values$min_time <- as.POSIXct(min(values$point_cyclone$ISO_TIME), tz="UTC")
                        values$max_time <- as.POSIXct(max(values$point_cyclone$ISO_TIME),tz="UTC")
                    shiny::sliderInput('years2', label=NULL, min = values$min_time, max = values$max_time,value = values$min_time,
                                       step=10800,timezone="+0000", width = "100%",
                                       ticks = FALSE, animate = shiny::animationOptions(interval = 1000, loop = FALSE))
                    } })

        map_df <- reactive({
                date_event <- str_replace_all(substr(req(input$years2), 1,10),"-","")
                hour_event <- str_replace_all(substr(req(input$years2), 12,13),"-","")
                hour_file <- Sys.glob(paste0("/home/florent/PycharmProjects/ShinyApp/data/GPM_hourly/*", date_event,"-S",hour_event,"*.tif"))
                raster_hour_file <- raster::raster(hour_file)
                return(raster_hour_file)
            })

        observeEvent(map_df(),{
        if (nchar(format(input$years2))==10){
            date_selected <- paste0(format(input$years2), " 00:00:00")
        }else{
            date_selected <- format(input$years2)}

        point_selected <- values$point_cyclone[values$point_cyclone$ISO_TIME == date_selected,]
        other_points <- values$point_cyclone[values$point_cyclone$ISO_TIME != date_selected, ]
        values$p_selected <- point_selected

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


        #
        proxy %>%removeControl("rain2")%>%removeControl("rain")%>%removeImage(layerId = c("raster3","raster2"))%>%clearGroup("rain_mark")
        proxy %>%
            addMarkers(data = other_points, layerId = paste(substr(other_points$ISO_TIME, 1,10),substr(other_points$ISO_TIME, 12,19)),
                       icon = values$icon_leaf,label= values$lab_cycl)%>%
            addMarkers(data = point_selected, group="rain_mark",layerId = paste(substr(point_selected$ISO_TIME, 1,10),substr(point_selected$ISO_TIME, 12,19)),
                       icon = leafIcons_selected,label=values$lab_cycl)%>%
            addRasterImage(map_df(),layerId = "raster3",colors = palh)%>%
            addLegendNumeric(layerId = 'rain',pal=palh, values = values(map_df()),
                             title = "Precipitation (mm/hr)", width = 25, height = 180,position = 'bottomright',group="legend")

            })

        observeEvent(input$map_custom_marker_click,{
        event <- input$map_custom_marker_click
        value_point <- as.POSIXct(event$id, tz="UTC")
        updateSliderInput(session, "years2", value = value_point,
                          min = values$min_time, max = values$max_time,timezone="+0000")})
        ###############################################################################

proxy_custom <- leafletProxy("map_custom2")

observeEvent(input$map_custom2_shape_click,{
        values$event2 <- input$map_custom2_shape_click


        # if(is.null(values$event))
        #     return()

            values$tiles_selected <- mada_s_tile[mada_s_tile$Name== values$event2$id,]
            values$Clicks_tile<-unlist(c(values$Clicks_tile,values$tiles_selected$Name), recursive = FALSE)

            if(grepl("Selected",values$event2$id)==TRUE){
                proxy_custom  %>% removeShape(layerId = values$event2$id)
                id_without_text2 <- str_replace_all(values$event2$id, "Selected ", "")
                values$Clicks_tile <- values$Clicks_tile [values$Clicks_tile != id_without_text2]
                values$df <- values$df[values$df$Tile!= id_without_text2,]
            }
            else {
                proxy_custom  %>% addPolygons(data = values$tiles_selected,
                                              fillColor = "#198754",
                                              fillOpacity = 0.25,
                                              color = "white",
                                              weight = 2,
                                              stroke = T, group= "test",
                                              layerId = paste("Selected",values$event2$id),
                                              label=values$event2$id,
                                              highlightOptions =highlightOptions(color = "#CC0000", weight = 3, bringToFront = TRUE))
            }

            values$tiles_showed <- mada_s_tile[mada_s_tile$Name %in% unique(values$Clicks_tile ),]
            values$order_tiles <- values$tiles_showed [order(values$tiles_showed$Name),]

            values$tiles_intersection <- values$order_tiles

            if (length(values$Clicks_tile)==0 & values$ine ==2){
                values$df <- data.frame() }

    })


#------------------------------------------------------------------------------
# CLICK ON MAP (add row with geom selected on leaflet map) --------------------
#------------------------------------------------------------------------------
observeEvent(values$Clicks_tile,{
    #Create first row of dataframe
    if (length(values$df)==0 & values$ine==1){
        test <- data.frame(`Tile`=unique(values$Clicks_tile), `Event Date` = "Select a date", `Before Date` = "-", `Before CC` = "-" ,`After Date`= "-",`After CC` = "-",check.names = FALSE)
        values$df <-    test%>%
            dplyr::bind_cols(tibble("Buttons" =  create_btns(1:lengths(list(unique(values$Clicks_tile))))))
        values$ine <-2
    }else {
        #Add new row in dataframe when other geom selected
        new_row<- values$Clicks_tile[!values$Clicks_tile %in% c(values$df$Tile)]
        add_row <- dplyr::tibble(`Tile` = new_row, `Event Date` = "Select a date", `Before Date` = "-",`Before CC` = "-",
                                 `After Date`= "-",`After CC` = "-", Buttons = create_btns(values$keep_track_id))
        values$df <- add_row %>% dplyr::bind_rows(values$df)
        values$keep_track_id <- values$keep_track_id + 1
    }

    values$keep_track_id = nrow(values$df) + 1
    #Plot dataframe
    output$dt_table <- DT::renderDT(
        datatable(shiny::isolate(values$df),
                  class = 'cell-border stripe',
                  escape = F,
                  rownames = FALSE,
                  extensions = 'Scroller',
                  options = list(processing = FALSE,
                                 dom = 't',
                                 deferRender = TRUE,
                                 scrollY = 300,
                                 scroller = TRUE,
                                 autoWidth = TRUE,
                                 columnDefs = list(list(width = '100px', targets = c(0,1,6)),
                                                   list(className = 'dt-center', targets = "_all"),
                                                   list(className = "align-middle", targets = "_all"),
                                                   list(visible=FALSE, targets=c(3,5))),
                                 initComplete = JS("function(settings, json) {",
                                                   "$(this.api().table().header()).css({'font-size': '85%'});",
                                                   "}"))
        ) %>%
            formatStyle(columns = c(0,1,2,4),fontSize = '85%')%>%
            formatStyle(columns ='Tile',
                        fontWeight = 'bold')%>%
            formatStyle(columns ='Event Date',
                        backgroundColor ='rgba(47, 79, 79, 0.4)',
                        fontWeight = 'bold')%>%
            formatStyle(columns ='Before Date',
                        valueColumns = 4,
                        fontSize = '85%',
                        fontWeight = 'bold',
                        backgroundColor = styleInterval(c(20,40,60,80), c("#73a942","#aad576","#f3c053","#f9a03f","#eb5e28")) )%>%
            formatStyle(columns ='After Date',
                        valueColumns = 6,
                        fontWeight = 'bold',
                        fontSize = '85%',
                        backgroundColor = styleInterval(c(20,40,60,80), c("#73a942","#aad576","#f3c053","#f9a03f","#eb5e28")) )
    )
})



#------------------------------------------------------------------------------
# UPDATE DATAFRAME ------------------------------------------------------------
#------------------------------------------------------------------------------
proxy_dt <- DT::dataTableProxy("dt_table")
shiny::observe({ DT::replaceData(proxy_dt, values$df, resetPaging = FALSE, rownames = FALSE) })


#------------------------------------------------------------------------------
# DELETE ROW ------------------------------------------------------------------
#------------------------------------------------------------------------------
observeEvent(input$current_id, {
    shiny::req(!is.null(input$current_id) & stringr::str_detect(input$current_id, pattern = "delete"))
    # Select row of the button delete is using
    values$dt_row <- which(stringr::str_detect(values$df$Buttons, pattern = paste0("\\b", input$current_id, "\\b")))
    # Remove geom in the list of geom selected
    loc <- values$df[values$dt_row, ]
    values$Clicks_tile <- values$Clicks_tile[values$Clicks_tile != loc$Tile]
    # Remove row in the datatable
    values$df <- values$df[-values$dt_row, ]
    # Remove geom in leaflet map
    proxy_custom <- leafletProxy("map_custom2")
    proxy_custom  %>% removeShape(layerId = paste("Selected",loc$Tile))
})

#------------------------------------------------------------------------------
# when edit button is clicked, modal dialog shows current editable row filled out
#------------------------------------------------------------------------------
observeEvent(input$current_id, {
    shiny::req(!is.null(input$current_id) & stringr::str_detect(input$current_id, pattern = "edit"))
    # Select row of the button edit is using
    values$dt_row <- which(stringr::str_detect(values$df$Buttons, pattern = paste0("\\b", input$current_id, "\\b")))
    # Remove row in the datatable
    df <- values$df[values$dt_row, ]
    # Stock Geom value
    values$tile_clicked_o2 <- df$Tile


    modal_dialog(
      tile = df$Tile, date_event = as.character(df["Event Date"]), before_date = df["Before Date"], after_date = df["After Date"],
      edit = TRUE , fade_option = TRUE)

    values$add_or_edit <- NULL
})

#------------------------------------------------------------------------------
# VALIDATE DATE EVENT ---------------------------------------------------------
#------------------------------------------------------------------------------
observeEvent(input$valid_event,{
    # When validate_event button is activate, show list of image with date nearest of date event
    images_folder<- paste0("/home/florent/sen2chain_data/data/L1C/",values$tile_clicked_o2)
    list_images <- list.files(path = images_folder)
    list_date_images <- unique(substr(list_images,12,19))
    datetime_x <- strftime(as.POSIXct(list_date_images,format="%Y%m%d"))
    df_image_time <- data.frame(name = list_images,
                                date = datetime_x,
                                cloud_cover = NA)

    for(i in 1:nrow(df_image_time )) {
      df_image_time[i,3 ] <- xml_double(xml_find_all(read_xml(paste(images_folder,"/",df_image_time[i,1],"/MTD_MSIL1C.xml",sep='')),".//Cloud_Coverage_Assessment"))
    }

    df_image_order <- df_image_time[order(df_image_time$cloud_cover),]

    image_before <- head(df_image_order[df_image_order$date < input$date_e,],5)
    image_after <- head(df_image_order[df_image_order$date > input$date_e,],5)

    modal_dialog(
      tile = values$tile_clicked_o2, date_event = as.character(input$date_e),
      before_date = paste0(image_before$date," ( cc : ",round(image_before$cloud_cover,1),"% )"),
      after_date = paste0(image_after$date," ( cc : ",round(image_after$cloud_cover,1),"% )"),
      edit = TRUE, fade_option=FALSE
    )
})


#------------------------------------------------------------------------------
# when final edit button is clicked, table will be changed---------------------
#------------------------------------------------------------------------------
observeEvent(input$final_edit, {
    shiny::req(!is.null(input$current_id) & stringr::str_detect(input$current_id, pattern = "edit") & is.null(values$add_or_edit))
    # Fill the row edited with new informations
    values$edited_row <- dplyr::tibble(
      `Tile` = values$tile_clicked_o2, `Event Date` = as.character(input$date_e),
      `Before Date` = input$date_b, `Before CC` = gsub('%','',substr(input$date_b,start = 18, stop = 21)),
      `After Date`= input$date_a, `After CC` = gsub('%','',substr(input$date_a,start = 18, stop = 21)),
      Buttons = values$df$Buttons[values$dt_row])
    # Fill de datatable in application
    values$df[values$dt_row, ] <- values$edited_row
})

#------------------------------------------------------------------------------
#remove edit modal when close button is clicked or submit button---------------
#------------------------------------------------------------------------------
observeEvent(input$dismiss_modal, {
    shiny::removeModal()
})

observeEvent(input$final_edit, {
    shiny::removeModal()
})












