#-------------------------------
#SERVER
#Page 3 : Change detection
#-------------------------------

output$map_custom2 <- renderLeaflet({
        map_custom2
        })


#------------------------------------------------------------------------------
# Error message if user doesn't select informations ---------------------------
#------------------------------------------------------------------------------
observeEvent(input$validation2, {
    if (input$mail2=="" & is.null(input$change_choice2) ){
        sendSweetAlert(session = session,
                       title = "Error...",
                       text = "A lot of information is missing",
                       type = "error")
    }
    else if ((input$mail2!="" & is.null(input$change_choice2) )){
        sendSweetAlert(session = session,
                       title = "Error...",
                       text = "No type of change is selected",
                       type = "error")
    }
    else if ((input$mail2=="" & !is.null(input$change_choice2) )){
        sendSweetAlert(session = session,
                       title = "Error...",
                       text = "The email address is missing",
                       type = "error")
    }
})

#------------------------------------------------------------------------------
# DISTRICT CHOICE -------------------------------------------------------------
#------------------------------------------------------------------------------
observeEvent(input$select_scale2,{

            #------------------------------------------------------------------
            # When district is selected
            #------------------------------------------------------------------
            if(input$select_scale2=="district"){
                proxy_custom11 <- leafletProxy("map_custom2")
                #Clear all variables when other scale is selected before
                proxy_custom11 %>% clearGroup(c("Tiles","test","shapefile"))
                values$event11<-NULL
                values$Clicks_tile11 <-NULL
                values$event211<-NULL
                values$tiles_selected11<-NULL
                output$scale_s11 <- NULL
                output$scale_s211 <- NULL
                values$tiles_intersection11 <- NULL
                values$df11 <- data.frame()

                if (is.null(input$map_custom2_shape_click)){
                    observeEvent(input$map_custom2_shape_click,{
                        values$event11 <- input$map_custom2_shape_click

                        if(is.null(values$event11))
                            return()

                            if(input$select_scale2=="district"){
                                values$disctict_selected11 <- mada_admin[mada_admin$ADM2_PCODE== values$event11$id,]
                                values$Clicks_tile11<-unlist(c(values$Clicks_tile11,values$disctict_selected11$ADM2_PCODE), recursive = FALSE)

                                if(grepl("Selected",values$event11$id)==TRUE){
                                    proxy_custom11  %>% removeShape(layerId = values$event11$id)
                                    id_without_text <- str_replace_all(values$event11$id, "Selected ", "")
                                    values$Clicks_tile11 <- values$Clicks_tile11 [values$Clicks_tile11 != id_without_text]
                                }else {
                                    proxy_custom11  %>% addPolygons(data = values$disctict_selected11,
                                                                  fillColor = "#16FF00",
                                                                  fillOpacity = 0.25,
                                                                  color = "white",
                                                                  weight = 2,
                                                                  stroke = T, group= "test",
                                                                  layerId = paste("Selected",values$event11$id),
                                                                  label = paste("District :",values$disctict_selected11$ADM2_EN," - Region :" ,values$disctict_selected11$ADM1_EN),
                                                                  highlightOptions =highlightOptions(color = "#CC0000", weight = 3, bringToFront = TRUE))
                                    values$disctict_selected11<-NULL
                              }

                            values$district_showed11 <- mada_admin[mada_admin$ADM2_PCODE %in% unique(values$Clicks_tile11),]
                            values$order_district11  <- values$district_showed11 [order(values$district_showed11$ADM1_EN, values$district_showed11$ADM2_EN),]

                            values$tiles_intersection11 <- st_intersection(mada_s_tile, values$district_showed11 )
                                if (lengths(list(values$tiles_intersection11$Name))==0){
                            values$df <- data.frame()
                                }
                            }
                    })
                }
            }

            #------------------------------------------------------------------
            # When tile is selected
            #------------------------------------------------------------------
            if(input$select_scale2=="tiles"){
                values$Clicks_district11<-NULL
                values$event11<-NULL
                values$disctict_selected11<-NULL
                output$scale_s11 <- NULL
                output$scale_s211 <- NULL
                values$tiles_intersection11 <- NULL
                values$df11 <- data.frame()


                proxy_custom11 <- leafletProxy("map_custom2")
                proxy_custom11 %>% clearGroup(c("Tiles","test","shapefile"))%>%
                    addPolygons(data=mada_s_tile, color =  "grey", weight = 1, fillOpacity = 0.2,group="Tiles", label = ~Name,layerId = ~Name,
                                highlightOptions =highlightOptions(color = "#CC0000", weight = 3, bringToFront = TRUE))

                observeEvent(input$map_custom2_shape_click,{
                    values$event211 <- input$map_custom2_shape_click

                    if(is.null(values$event11))
                        return()

                    if(input$select_scale2=="tiles"){
                        values$tiles_selected11 <- mada_s_tile[mada_s_tile$Name== values$event211$id,]
                        values$Clicks_tile11<-unlist(c(values$Clicks_tile11,values$tiles_selected11$Name), recursive = FALSE)

                        if(grepl("Selected",values$event211$id)==TRUE){
                            proxy_custom11  %>% removeShape(layerId = values$event211$id)
                            id_without_text2 <- str_replace_all(values$event211$id, "Selected ", "")
                            values$Clicks_tile11 <- values$Clicks_tile11 [values$Clicks_tile11 != id_without_text2]
                            values$df11 <- values$df11[values$df11$Tile!= id_without_text2,]
                        }
                        else {
                            proxy_custom11  %>% addPolygons(data = values$tiles_selected11,
                                                          fillColor = "#16FF00",
                                                          fillOpacity = 0.25,
                                                          color = "white",
                                                          weight = 2,
                                                          stroke = T, group= "test",
                                                          layerId = paste("Selected",values$event211$id),
                                                          label=values$event211$id,
                                                          highlightOptions =highlightOptions(color = "#CC0000", weight = 3, bringToFront = TRUE))
                        }

                        values$tiles_showed11 <- mada_s_tile[mada_s_tile$Name %in% unique(values$Clicks_tile11 ),]
                        values$order_tiles11 <- values$tiles_showed11 [order(values$tiles_showed11$Name),]

                        values$tiles_intersection11 <- values$order_tiles11

                        if (length(values$Clicks_tile11)==0 & values$ine11 ==2){
                            values$df11 <- data.frame() }
                    }
                })
            }

            #------------------------------------------------------------------
            # When shapefile is selected
            #------------------------------------------------------------------
            if (input$select_scale2=="shapefile"){
                proxy_custom11 <- leafletProxy("map_custom2")
                proxy_custom11 %>% clearGroup(c("Tiles","test"))
                values$event11<-NULL
                values$Clicks_tile11 <-NULL
                values$event211<-NULL
                values$tiles_selected11<-NULL
                values$Clicks_district11<-NULL
                values$event11<-NULL
                values$disctict_selected11<-NULL
                output$scale_s11 <- NULL
                output$scale_s211 <- NULL
                values$tiles_intersection11 <- NULL
                values$df11 <- data.frame()

                observeEvent(input$zip2, {
                            proxy_custom %>% clearGroup("shapefile")
                            data <- uploadShpfile()
                            toto <- extent(data)


                            if (!is.null(data)){
                              if(inherits(data, "SpatialPolygons")){
                                  toto <- extent(data)
                                  proxy_custom %>%
                                      addPolygons(data = data,
                                                  stroke = TRUE,
                                                  weight = 2,
                                                  group ="shapefile",
                                                  fillColor = "#16FF00",
                                                  fillOpacity = 0.25,
                                                  color = "white") %>%
                                      fitBounds(toto@xmin, toto@ymin, toto@xmax, toto@ymax)

                                  values$data11 <- st_as_sf(data)
                                  values$tiles_intersection11 <- st_intersection(mada_s_tile, req(values$data11 ))
                              }
                            }
                })
            }
})


#------------------------------------------------------------------------------
# CLICK ON MAP (add row with geom selected on leaflet map) --------------------
#------------------------------------------------------------------------------
observeEvent(values$Clicks_tile11,{
    #Create first row of dataframe
    if (length(values$df11)==0 & values$ine11==1){
        test <- data.frame(`Tile`=unique(values$Clicks_tile11), `Event Date` = "Select a date", `Before Date` = "-", `Before CC` = "-" ,`After Date`= "-",`After CC` = "-",check.names = FALSE)
        values$df11 <-    test%>%
            dplyr::bind_cols(tibble("Buttons" =  create_btns(1:lengths(list(unique(values$Clicks_tile11))))))
        values$ine11 <-2
    }else {
        #Add new row in dataframe when other geom selected
        new_row<- values$Clicks_tile11[!values$Clicks_tile11 %in% c(values$df11$Tile)]
        add_row <- dplyr::tibble(`Tile` = new_row, `Event Date` = "Select a date", `Before Date` = "-",`Before CC` = "-",
                                 `After Date`= "-",`After CC` = "-", Buttons = create_btns(values$keep_track_id11))
        values$df11 <- add_row %>% dplyr::bind_rows(values$df11)
        values$keep_track_id11 <- values$keep_track_id11 + 1
    }

    values$keep_track_id11 = nrow(values$df11) + 1
    #Plot dataframe
    output$dt_table2 <- DT::renderDT(
        datatable(shiny::isolate(values$df11),
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
                                                   "$(this.api().table().header()).css({'font-size': '120%'});",
                                                   "}"))
        ) %>%
            formatStyle(columns = c(0,1,2,4),fontSize = '120%')%>%
            formatStyle(columns ='Event Date',
                        backgroundColor ='rgba(47, 79, 79, 0.4)',
                        fontWeight = 'bold')%>%
            formatStyle(columns ='Before Date',
                        valueColumns = 4,
                        fontWeight = 'bold',
                        backgroundColor = styleInterval(c(20,40,60,80), c("#73a942","#aad576","#f3c053","#f9a03f","#eb5e28")) )%>%
            formatStyle(columns ='After Date',
                        valueColumns = 6,
                        fontWeight = 'bold',
                        backgroundColor = styleInterval(c(20,40,60,80), c("#73a942","#aad576","#f3c053","#f9a03f","#eb5e28")) )
    )
})


#------------------------------------------------------------------------------
# UPDATE DATAFRAME ------------------------------------------------------------
#------------------------------------------------------------------------------
proxy2 <- DT::dataTableProxy("dt_table2")
shiny::observe({ DT::replaceData(proxy2, values$df11, resetPaging = FALSE, rownames = FALSE) })


#------------------------------------------------------------------------------
# DELETE ROW ------------------------------------------------------------------
#------------------------------------------------------------------------------
observeEvent(input$current_id2, {
    shiny::req(!is.null(input$current_id2) & stringr::str_detect(input$current_id2, pattern = "delete"))
    # Select row of the button delete is using
    values$dt_row11 <- which(stringr::str_detect(values$df11$Buttons, pattern = paste0("\\b", input$current_id2, "\\b")))
    # Remove geom in the list of geom selected
    loc <- values$df11[values$dt_row11, ]
    values$Clicks_tile11 <- values$Clicks_tile11[values$Clicks_tile11 != loc$Tile]
    # Remove row in the datatable
    values$df11 <- values$df11[-values$dt_row11, ]
    # Remove geom in leaflet map
    proxy_custom2 <- leafletProxy("map_custom2")
    proxy_custom2  %>% removeShape(layerId = paste("Selected",loc$Tile))
})

#------------------------------------------------------------------------------
# when edit button is clicked, modal dialog shows current editable row filled out
#------------------------------------------------------------------------------
observeEvent(input$current_id2, {
    shiny::req(!is.null(input$current_id2) & stringr::str_detect(input$current_id2, pattern = "edit"))
    # Select row of the button edit is using
    values$dt_row11 <- which(stringr::str_detect(values$df11$Buttons, pattern = paste0("\\b", input$current_id2, "\\b")))
    # Remove row in the datatable
    df <- values$df11[values$dt_row11, ]
    # Stock Geom value
    values$tile_clicked_o211 <- df$Tile

    modal_dialog2(
      tile1 = df$Tile, date_event1 = as.character(df["Event Date"]), before_date1 = df["Before Date"], after_date1 = df["After Date"],
      edit1 = TRUE , fade_option1 = TRUE)

    values$add_or_edit11 <- NULL
})

#------------------------------------------------------------------------------
# VALIDATE DATE EVENT ---------------------------------------------------------
#------------------------------------------------------------------------------
observeEvent(input$valid_event2,{
    # When validate_event button is activate, show list of image with date nearest of date event
    images_folder<- paste0("/home/florent/sen2chain_data/data/L1C/",values$tile_clicked_o211)
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

    image_before <- head(df_image_order[df_image_order$date < input$date_e2,],5)
    image_after <- head(df_image_order[df_image_order$date > input$date_e2,],5)

    modal_dialog2(
      tile1 = values$tile_clicked_o211, date_event1 = as.character(input$date_e2),
      before_date1 = paste0(image_before$date," ( cloud cover : ",round(image_before$cloud_cover,1),"% )"),
      after_date1 = paste0(image_after$date," ( cloud cover : ",round(image_after$cloud_cover,1),"% )"),
      edit1 = TRUE, fade_option1=FALSE
    )
})


#------------------------------------------------------------------------------
# when final edit button is clicked, table will be changed---------------------
#------------------------------------------------------------------------------
observeEvent(input$final_edit2, {
    shiny::req(!is.null(input$current_id2) & stringr::str_detect(input$current_id2, pattern = "edit") & is.null(values$add_or_edit11))
    # Fill the row edited with new informations
    values$edited_row11 <- dplyr::tibble(
      `Tile` = values$tile_clicked_o211, `Event Date` = as.character(input$date_e2),
      `Before Date` = input$date_b2, `Before CC` = gsub('%','',substr(input$date_b2,start = 28, stop = 31)),
      `After Date`= input$date_a2, `After CC` = gsub('%','',substr(input$date_a2,start = 28, stop = 31)),
      Buttons = values$df11$Buttons[values$dt_row11])
    # Fill de datatable in application
    values$df11[values$dt_row11, ] <- values$edited_row11
})

#------------------------------------------------------------------------------
#remove edit modal when close button is clicked or submit button---------------
#------------------------------------------------------------------------------
observeEvent(input$dismiss_modal2, {
    shiny::removeModal()
})

observeEvent(input$final_edit2, {
    shiny::removeModal()
})
