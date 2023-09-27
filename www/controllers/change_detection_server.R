#-------------------------------
#SERVER
#Page 3 : Change detection
#-------------------------------

output$map_custom <- renderLeaflet({
        map_custom
        })


#------------------------------------------------------------------------------
# Error message if user doesn't select informations ---------------------------
#------------------------------------------------------------------------------
observeEvent(input$validation, {
    if (input$mail=="" & is.null(input$change_choice) ){
        sendSweetAlert(session = session,
                       title = "Error...",
                       text = "A lot of information is missing",
                       type = "error")
    }
    else if ((input$mail!="" & is.null(input$change_choice) )){
        sendSweetAlert(session = session,
                       title = "Error...",
                       text = "No type of change is selected",
                       type = "error")
    }
    else if ((input$mail=="" & !is.null(input$change_choice) )){
        sendSweetAlert(session = session,
                       title = "Error...",
                       text = "The email address is missing",
                       type = "error")
    }
})

#------------------------------------------------------------------------------
# DISTRICT CHOICE -------------------------------------------------------------
#------------------------------------------------------------------------------
observeEvent(input$select_scale,{

            #------------------------------------------------------------------
            # When district is selected
            #------------------------------------------------------------------
            if(input$select_scale=="district"){
                proxy_custom <- leafletProxy("map_custom")
                #Clear all variables when other scale is selected before
                proxy_custom %>% clearGroup(c("Tiles","test","shapefile"))
                values$event<-NULL
                values$Clicks_tile <-NULL
                values$event2<-NULL
                values$tiles_selected<-NULL
                output$scale_s <- NULL
                output$scale_s2 <- NULL
                values$tiles_intersection <- NULL
                values$df <- data.frame()

                if (is.null(input$map_custom_shape_click)){
                    observeEvent(input$map_custom_shape_click,{
                        values$event <- input$map_custom_shape_click

                        if(is.null(values$event))
                            return()

                            if(input$select_scale=="district"){
                                values$disctict_selected <- mada_admin[mada_admin$ADM2_PCODE== values$event$id,]
                                values$Clicks_tile<-unlist(c(values$Clicks_tile,values$disctict_selected$ADM2_PCODE), recursive = FALSE)

                                if(grepl("Selected",values$event$id)==TRUE){
                                    proxy_custom  %>% removeShape(layerId = values$event$id)
                                    id_without_text <- str_replace_all(values$event$id, "Selected ", "")
                                    values$Clicks_tile <- values$Clicks_tile [values$Clicks_tile != id_without_text]
                                }else {
                                    proxy_custom  %>% addPolygons(data = values$disctict_selected,
                                                                  fillColor = "#16FF00",
                                                                  fillOpacity = 0.25,
                                                                  color = "white",
                                                                  weight = 2,
                                                                  stroke = T, group= "test",
                                                                  layerId = paste("Selected",values$event$id),
                                                                  label = paste("District :",values$disctict_selected$ADM2_EN," - Region :" ,values$disctict_selected$ADM1_EN),
                                                                  highlightOptions =highlightOptions(color = "#CC0000", weight = 3, bringToFront = TRUE))
                                    values$disctict_selected<-NULL
                              }

                            values$district_showed <- mada_admin[mada_admin$ADM2_PCODE %in% unique(values$Clicks_tile),]
                            values$order_district  <- values$district_showed [order(values$district_showed$ADM1_EN, values$district_showed$ADM2_EN),]

                            values$tiles_intersection <- st_intersection(mada_s_tile, values$district_showed )
                                if (lengths(list(values$tiles_intersection$Name))==0){
                            values$df <- data.frame()
                                }
                            }
                    })
                }
            }

            #------------------------------------------------------------------
            # When tile is selected
            #------------------------------------------------------------------
            if(input$select_scale=="tiles"){
                values$Clicks_district<-NULL
                values$event<-NULL
                values$disctict_selected<-NULL
                output$scale_s <- NULL
                output$scale_s2 <- NULL
                values$tiles_intersection <- NULL
                values$df <- data.frame()


                proxy_custom <- leafletProxy("map_custom")
                proxy_custom %>% clearGroup(c("Tiles","test","shapefile"))%>%
                    addPolygons(data=mada_s_tile, color =  "grey", weight = 1, fillOpacity = 0.2,group="Tiles", label = ~Name,layerId = ~Name,
                                highlightOptions =highlightOptions(color = "#CC0000", weight = 3, bringToFront = TRUE))

                observeEvent(input$map_custom_shape_click,{
                    values$event2 <- input$map_custom_shape_click

                    if(is.null(values$event))
                        return()

                    if(input$select_scale=="tiles"){
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
                    }
                })
            }

            #------------------------------------------------------------------
            # When shapefile is selected
            #------------------------------------------------------------------
            if (input$select_scale=="shapefile"){
                proxy_custom <- leafletProxy("map_custom")
                proxy_custom %>% clearGroup(c("Tiles","test"))
                values$event<-NULL
                values$Clicks_tile <-NULL
                values$event2<-NULL
                values$tiles_selected<-NULL
                values$Clicks_district<-NULL
                values$event<-NULL
                values$disctict_selected<-NULL
                output$scale_s <- NULL
                output$scale_s2 <- NULL
                values$tiles_intersection <- NULL
                values$df <- data.frame()

                observeEvent(input$zip, {
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

                                  values$data <- st_as_sf(data)
                                  values$tiles_intersection <- st_intersection(mada_s_tile, req(values$data ))
                              }
                            }
                })
            }
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
proxy <- DT::dataTableProxy("dt_table")
shiny::observe({ DT::replaceData(proxy, values$df, resetPaging = FALSE, rownames = FALSE) })


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
    proxy_custom <- leafletProxy("map_custom")
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
      before_date = paste0(image_before$date," ( cloud cover : ",round(image_before$cloud_cover,1),"% )"),
      after_date = paste0(image_after$date," ( cloud cover : ",round(image_after$cloud_cover,1),"% )"),
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
      `Before Date` = input$date_b, `Before CC` = gsub('%','',substr(input$date_b,start = 28, stop = 31)),
      `After Date`= input$date_a, `After CC` = gsub('%','',substr(input$date_a,start = 28, stop = 31)),
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
