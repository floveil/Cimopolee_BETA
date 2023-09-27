# df_name_cyclone <- data.frame(read.table("/home/florent/PycharmProjects/Cyclone/ShinyApp/data/cyclones/liste_cyclones/name_date_cyclone.txt",
#                                          sep=',', header = TRUE
# ))
# print(df_name_cyclone)
# df_name_cyclone["name_dates"] <- paste(df_name_cyclone$name ,"/", df_name_cyclone$start ,"=>",df_name_cyclone$end)
# write.csv(df_name_cyclone, row.names = FALSE,file = "/home/florent/PycharmProjects/Cyclone/ShinyApp/data/cyclones/liste_cyclones/name_date_cyclone.txt")
# ##################################################################################################

# library(sf)
# library()
#
# noGeom <- data.frame(read.table("/home/florent/PycharmProjects/Cyclone/ShinyApp/data/Time_series/time_series_20200312_20200321_HEROLD.csv",
#                                          sep=',', header = TRUE))
# mada_admin <- st_read("/home/florent/PycharmProjects/Cyclone/ShinyApp/data/mada_shp/mdg_admbnda_adm2_BNGRC_OCHA_20181031.shp")
# final1 <- merge(mada_admin,df_name_time_serie,by.x = "ADM2_EN",by.y="ADM2_EN" )
#
# my_list <- list()
# for (i in unique(final1$ADM2_EN)) {
#       state<-final1[final1$ADM2_EN==i,]
#       plot<-ggplot(state, aes(x = time, y = precipitationCal)) +geom_line(group=1)
#     my_list[[i]] <- plot
# }
# print(my_list)
#       # plot<-ggplot(state, aes(x = time, y = precipitationCal)) +
#       #   geom_line(group=1)
#       # my_list[[i]] <- plot
#
# #plot avec popup
# my_list <- list()
#         for (i in unique(ts_merge$ADM2_EN)) {
#               state<-ts_merge[ts_merge$ADM2_EN==i,]
#               plot<-ggplot(state, aes(x = time, y = precipitationCal)) +geom_line(group=1)
#             my_list[[i]] <- plot
# }
#
# addPolygons(data=ts_merge,
#                                   weight = 1, fillOpacity = 0, color="black",
#                                   popup = popupGraph(my_list))

########################################################################################
#TO Make smooth buffer
# library(sf)
# library(smoothr)
# mada_cycl_l <- st_read("/home/florent/PycharmProjects/Cyclone/ShinyApp/data/cyclones/path_cyclone_l/IBTrACS_line_Mada.shp")
# liste_id <- unique(mada_cycl_l$NAME)
#
# m <-mada_cycl_l[mada_cycl_l$NAME==liste_id[1],]
# buffer <-st_buffer(m  , dist=0)
#
# buffer_list <- NULL
#
#
# for (i in liste_id){
#     m <-mada_cycl_l[mada_cycl_l$NAME==i,]
#     p <- m[m$bffr_vl >0,]
#     if(nrow(p)!=0){
#         print(unique(p$NAME))
#         buffer <-st_buffer(p  , dist=p$bffr_vl*p$WIND)
#         line_buffer <- st_union(buffer)
#         cone_area<-smooth(line_buffer, method ="ksmooth",smoothness =200)
#         st_write(cone_area, paste0("/home/florent/PycharmProjects/Cyclone/ShinyApp/data/cyclones/buffer_cyclone/cyclone_buffer_",unique(p$NAME),".shp"))
#
#     }
# }
########################################################################################
# library(sp)
# # noGeom <- data.frame(read.table("/home/florent/PycharmProjects/Cyclone/ShinyApp/data/Time_series/time_series_20200312_20200321_HEROLD.csv",
# #                                         sep=',', header = TRUE))
#  mada_admin <- st_read("/home/florent/PycharmProjects/Cyclone/ShinyApp/data/mada_shp/mdg_admbnda_adm2_BNGRC_OCHA_20181031.shp")
# # final1 <- merge(mada_admin,noGeom,by.x = "ADM2_EN",by.y="ADM2_EN" )
# # fnial <- final1[final1$ADM2_PCODE=="MG21205",]
# # str_split_1(fnial$time[1], " ")[1]
# # library(sf)
# # time_series <- read.csv("/home/florent/PycharmProjects/Cyclone/ShinyApp/data/Time_series/time_series_mean20220127_20220208_BATSIRAI.csv",sep=',', header = TRUE)
# # mada_admin <- st_read("/home/florent/PycharmProjects/Cyclone/ShinyApp/data/mada_shp/mdg_admbnda_adm2_BNGRC_OCHA_20181031.shp")
# # province_selected <- mada_admin[mada_admin$ADM2_EN== "Antsalova",]
# # pluie_province <- merge(province_selected ,time_series,by.x = "ADM2_EN",by.y="ADM2_EN" )
#
# x <- list("MG41403" "MG44402")


#
# library(shiny)
# library(leaflet)
# library(tigris)
# library(dplyr)
# Sys.Date()
# dat <- data.frame(long = rnorm(40) * 2 + 13, lat = rnorm(40) + 48)
#
# #Read life table
# life <- read.table("life.txt",sep="\t", header=TRUE)
#
# #lnd@data <- left_join(lnd@data, life, by = c('NAME' = 'county'))
# lnd@data <- cbind(lnd@data, male = rnorm(nrow(lnd@data), 50, 10), female = rnorm(nrow(lnd@data), 40, 5))
#
#
# popup <- paste0("County name: ", lnd$NAME, "<br>", "Life Expectancy: ", round(lnd$male,2))
# popup2 <- paste0("County name: ", lnd$NAME, "<br>", "Life Expectancy: ", round(lnd$female,2))
#
#
# ui <- shinyUI(fluidPage(#theme = "bootstrap.css",
#
#   titlePanel("Life Exptectancy in Indiana Counties: "),
#   h3("A Spatial Analysis Project"),
#   br(),
#   sidebarLayout(position = "right",
#
#                 sidebarPanel(
#                   tags$b("Life Expectancy in Indiana, U.S.A."),
#                   hr(),
#                   radioButtons("gender",     "Gender:",c("Male"="Male","Female"="Female")),
#
#                   hr()
#                 ),
#                 mainPanel(
#                   leafletOutput("map")
#                 )
#   )
# ))
#
# server <- function(input, output) {
#   output$map <- renderLeaflet({
#     leaflet(lnd) %>%
#       addPolygons() %>%
#       addProviderTiles(providers$CartoDB.Positron)
#   })
#   observeEvent (input$gender , {
#     if(input$gender == "Male"){
#       leafletProxy("map", data=lnd) %>%
#         clearShapes() %>%
#         addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1, popup = popup)
#     }else
#     {
#       leafletProxy("map", data=lnd) %>%
#         clearShapes() %>%
#         addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1, popup = popup2)
#     }
#
#   })
#
# }
# shinyApp(ui, server)
#
# library(reticulate)
# use_python("/usr/bin/python3.10")
# source_python("/home/florent/PycharmProjects/Cyclone/ShinyApp/www/script/run_s2chain.py")
#
# x <- list("38KPB","38KME")
# y <- list("NDVI","NDWIGAO","BIGR")
#
# for(i in x){
#     print(i)
#     # run_sen2chain(tiles=toString(i),
#     #               start = toString("2022-10-02"),
#     #               end = toString("2022-11-26"),
#     #               indices =toString(y))
# }

# library(devtools)
# devtools::install_github("rsbivand/sp@evolution",force = TRUE)
# Sys.setenv("_SP_EVOLUTION_STATUS_"=2)
# options("sp_evolution_status"=2)
# library(sp)







#
# library(shiny)
# library(DT)
# library(shinyjs)
#
#
#
#
# ui <- fluidPage(
#     tags$head(
#         tags$link(rel="stylesheet", href="//code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css"),
#         tags$link(rel="stylesheet", href="/resources/demos/style.css"),
#         tags$script(src= "/home/florent/PycharmProjects/Cyclone/ShinyApp/www/script/jquery-3.6.0.js"),
#         tags$script(src = "https://code.jquery.com/ui/1.13.2/jquery-ui.js"),
#         tags$script(' $( function() {
#             $( "#datepicker" ).datepicker({
#                 dateFormat: "yy-mm-dd",
#                   maxDate: "0",
#                   minDate: "2015-07-01",
#                   showAnim: "slideDown",
#                   changeMonth: true,
#                   changeYear: true
#                 });
#             } )')
#     ),
#
#     fluidRow(uiOutput("table")),
#     actionButton("add_btn", "Add"),
#     actionButton("delete_btn", "Delete")
#     # tags$p('Date:'),
#     #input$date <- tags$input(type="text" ,id="datepicker")
# )
#
# server <- function(input, output, session) {
#
#   output$table <- renderUI({
#     data <- data.frame(Tile = 1:5,
#                        BEFORE_DATE = '<select id="single_select" style="width: 100%;">
#                                           <option value="A">O</option>
#                                           <option value="B">B</option>
#                                           <option value="C">C</option>
#                                         </select>',
#                        TEXT = '<input id="calendar" type="text" class="form-control" value = "2019-03-08"/>',
#                        AFTER_DATE = '<select id="single_select" style="width: 100%;">
#                                           <option value="" selected></option>
#                                           <option value="A">A</option>
#                                           <option value="B">B</option>
#                                           <option value="C">C</option>
#                                         </select>',
#                        stringsAsFactors = FALSE)
#
#
#
#     datatable(data = data,
#               selection = "none",
#               escape = FALSE,
#               rownames = FALSE)
#   })
#
# }
#
# library(shiny)
# library(DT)
# library(xml2)
# library(XML)
#
# ui <- fluidPage(
#
#   # define a hidden dateInput in order that Shiny loads the dependencies
#   div(style = "display: none;",
#     dateInput("x", label = NULL)
#   ),
#
#   DTOutput("table")
# )
#
#
# js <- c(
#   "function(){",
#   "  $('#calendar').bsDatepicker({",
#   "    format: 'yyyy-mm-dd',",
#   "    todayHighlight: true,",
#   "    autoclose: true,",
#   "    endDate: '0d',",
#   "    startDate: '2015-07-01',",
#  " });",
#   "}"
# ) # available options: https://bootstrap-datepicker.readthedocs.io/en/latest/
#

# server <- function(input, output, session){



  # output[["table"]] <- renderDT({
  #
  #     dat <- data.frame(
  #     V1 = "38KND",
  #     Event_DATE = '<input id="calendar" type="text" class="form-control;">',
  #     BEFORE_DATE = '<select id="single_select" style="width: 100%;">
  #                      <option value="" selected></option>
  #                      <option value="A">A</option>
  #                      <option value="B">B</option>
  #                      <option value="C">C</option>
  #                      </select>',
  #     AFTER_DATE = '<select id="single_select" style="width: 100%;">
  #                      <option value="" selected></option>
  #                      <option value="A">A</option>
  #                      <option value="B">B</option>
  #                      <option value="C">C</option>
  #                      </select>',
  #     stringsAsFactors = FALSE
  #   )


      # images_folder<- "/home/florent/sen2chain_data/data/L1C/38KND/"
      # list_images <- list.files(path = images_folder)
      # list_date_images <- unique(substr(list_images,12,19))
      # datetime_x <- strftime(as.POSIXct(list_date_images,format="%Y%m%d"))
      # df_image_time <- data.frame(name = list_images,
      #                               date = datetime_x,
      #                               cloud_cover = NA)
      #
      #
      # for(i in 1:nrow(df_image_time )) {
      #     df_image_time[i,3 ] <- xml_double(xml_find_all(read_xml(paste(images_folder,df_image_time[i,1],"/MTD_MSIL1C.xml",sep='')),".//Cloud_Coverage_Assessment"))
      #   }
      #
      #
      #   df_image_order <- df_image_time[order(df_image_time$cloud_cover),]
      #   df_image_order$color <- ifelse(df_image_order$cloud_cover<=20, "#73a942",
      #                                  ifelse(df_image_order$cloud_cover>20 & df_image_order$cloud_cover<=40,"#aad576",
      #                                         ifelse(df_image_order$cloud_cover>40 & df_image_order$cloud_cover<=60,"#f3c053",
      #                                                ifelse(df_image_order$cloud_cover>60 & df_image_order$cloud_cover<=80,"#f9a03f",
      #                                                       ifelse(df_image_order$cloud_cover>80,"#eb5e28",0
      #                                                       )))))
      #
      #
      #   print(input$calendar)
      #   image_before <- head(df_image_order[df_image_order$date < dat$Event_DATE,],5)
      #   image_after <- head(df_image_order[df_image_order$date > dat$Event_DATE,],5)
      # print(image_before)


#
#     datatable(dat, escape = FALSE,
#               options =
#                 list(
#                   initComplete = JS(js),
#                   preDrawCallback = JS('function() { Shiny.unbindAll(this.api().table().node()); }'),
#                   drawCallback = JS('function() { Shiny.bindAll(this.api().table().node()); } ')
#                 )
#     )
#   })
#
# }



# library(shiny)
# library(DT)
#
# this_table <- data.frame(bins = '<select id="single_select" style="width: 100%;">
#                        <option value="" selected></option>
#                        <option value="A">A</option>
#                        <option value="B">B</option>
#                        <option value="C">C</option>
#                        </select>',
#                          cb = '<select id="single_select" style="width: 100%;">
#                        <option value="" selected></option>
#                        <option value="E">E</option>
#                        <option value="F">F</option>
#                        <option value="G">G</option>
#                        </select>',
#                         stringsAsFactors = FALSE)
#
#
#
# ui <- fluidPage(
#
#   sidebarLayout(
#     sidebarPanel(
#       actionButton("add_btn", "Add"),
#       actionButton("delete_btn", "Delete")
#     ),
#
#     mainPanel(
#       DTOutput("shiny_table")
#     )
#   )
# )
#
# server <- function(input, output) {
#
#   this_table <- reactiveVal(this_table)
#
#   observeEvent(input$add_btn, {
#     this_table = rbind(data.frame(bins = '<select id="single_select" style="width: 100%;">
#                        <option value="A">A</option>
#                        <option value="B">B</option>
#                        <option value="C">C</option>
#                        </select>',
#                          cb = '<select id="single_select" style="width: 100%;">
#                        <option value="A">A</option>
#                        <option value="B">B</option>
#                        <option value="C">C</option>
#                        </select>'), this_table())
#     this_table(t)
#   })
#
#   observeEvent(input$delete_btn, {
#     t = this_table()
#     print(nrow(t))
#     if (!is.null(input$shiny_table_rows_selected)) {
#       t <- t[-as.numeric(input$shiny_table_rows_selected),]
#     }
#     this_table(t)
#   })
#
#
#   output$shiny_table <- renderDT({
#    datatable(this_table(), selection = 'single',escape = FALSE, options =
#                 list(
#                   preDrawCallback = JS('function() { Shiny.unbindAll(this.api().table().node()); }'),
#                   drawCallback = JS('function() { Shiny.bindAll(this.api().table().node()); } ')
#                 ))
#   })
# }
# library(shiny)
# library(rhandsontable)
# ui <- fluidPage(
#   titlePanel("Ttile"),
#   sidebarLayout(
#     sidebarPanel(
#       actionButton("runButton","Change Dataframes")
#     ),
#     mainPanel(
#       tabsetPanel(
#         tabPanel("OldIrisTab", rHandsontableOutput('OldIris')),
#         tabPanel("NewIrisTab", DT::dataTableOutput("NewIris"))
#         ))))
#
# server <- function(input,output,session)({
#   values <- reactiveValues()
#   output$OldIris <- renderRHandsontable({
#     rhandsontable(iris)
#   })
#
#   observeEvent(input$runButton, {
#     values$data <-  hot_to_r(input$OldIris)
#   })
#
#   output$NewIris <- DT::renderDataTable({
#     values$data
#   })
#
# })
# Run p(ui, server)the application

# library(tidyverse)
# library(shiny)
# library(sf)
# library(leaflet)
# library(raster)
# library(leaflegend)
# library(shinyWidgets)
#
# # min_time <- as.POSIXct("2022-01-27 00:00:00", tz="UTC")
# # max_time <- as.POSIXct("2022-02-08 06:00:00",tz="UTC")
# point_batsirai <- st_read("/home/florent/PycharmProjects/ShinyApp/data/GPM_hourly/bastrirai_ava_points.shp")
# mada_admin2 <- st_read("./data/mada_shp/mdg_admbnda_adm0_BNGRC_OCHA_20181031.shp")
#
# # Make vector of colors for the accumulation rain raster
# rc1 <- colorRampPalette(colors = c("#3c74a0", "#3c74a0"), space = "Lab")(0.6)
# rc2 <- colorRampPalette(colors = c("#3ba1a1", "#3ba1a1"), space = "Lab")(6)
# rc3 <- colorRampPalette(colors = c("#3ba13d", "#3ba13d"), space = "Lab")(8)
# rc4 <- colorRampPalette(colors = c("#82a13b", "#82a13b"), space = "Lab")(10)
# rc5 <- colorRampPalette(colors = c("#a1a13b", "#a1a13b"), space = "Lab")(15)
# rc6 <- colorRampPalette(colors = c("#a13b3b", "#a13b3b"), space = "Lab")(20)
# rc7 <- colorRampPalette(colors = c("#a13ba1", "#a13ba1"), space = "Lab")(30)
# rc8 <- colorRampPalette(colors = c( "#a8a8a8","#a8a8a8"), space = "Lab")(50)
# rc9 <- colorRampPalette(colors = c("#041033","#041033"), space = "Lab")(200)
# # rc10 <- colorRampPalette(colors = c("#081d58","#041033"), space = "Lab")(200)
# # Combine the color palettes
# rampcols <- c(rc1, rc2,rc3,rc4,rc5,rc6,rc7,rc8,rc9)
# # Create a sum color palette
# pal <- colorNumeric(palette = rampcols, domain = c(0,200),na.color = "transparent")
#
#
# ui = fluidPage(
#
#   titlePanel("BATSIRAI"),
#
#   sidebarLayout(
#
#     sidebarPanel = sidebarPanel(
#         pickerInput(inputId = "picker_cyclone2",
#                                             label = NULL,
#                                             width = "100%",
#                                             choices = c(" ", unique(point_batsirai$NAME)),
#                                             selected = " ",
#                                             multiple = FALSE,
#                                             #choicesOpt = list(subtext = paste0(c(" ",min(point_batsirai$ISO_TIME))," : ",c(" ",max(point_batsirai$ISO_TIME)))),
#                                             options = pickerOptions(noneSelectedText = "Select a past cyclone")),
#         p("Precipitation"),
#         conditionalPanel(condition = "input.picker_cyclone2 != ' '",
#                                                 uiOutput("years"))),
#     mainPanel = mainPanel(
#
#       leafletOutput(outputId = 'map',width="100%", height="85vh")
#
#     )
#   )
#
# )
#
# server = function(input, output, session){
#     values <- reactiveValues()
#
#     output$years <- renderUI({
#         values$cyclone_select <- point_batsirai[point_batsirai$NAME == input$picker_cyclone2,]
#         if (length(st_geometry(values$cyclone_select)) !=0){
#         values$min_time <- as.POSIXct(min(values$cyclone_select $ISO_TIME), tz="UTC")
#         values$max_time <- as.POSIXct(max(values$cyclone_select $ISO_TIME),tz="UTC")
#   shiny::sliderInput('years2', 'Time', min = values$min_time, max = values$max_time,value = values$min_time,step=10800,timezone="+0000",ticks = FALSE,
#                     animate = shiny::animationOptions(interval = 1000, loop = FALSE))
#         }
# })
#
#
#     output$map = renderLeaflet({
#     leaflet() %>%
#       addTiles() %>%
#         addPolygons(data=mada_admin2,weight = 1, fillOpacity = 0, color="black", layerId = "mada")
#   })
#
#
#     proxy <- leafletProxy("map")
#
#
#     map_df <- reactive({
#         date_event <- str_replace_all(substr(req(input$years2), 1,10),"-","")
#         hour_event <- str_replace_all(substr(req(input$years2), 12,13),"-","")
#         hour_file <- Sys.glob(paste0("/home/florent/PycharmProjects/ShinyApp/data/GPM_hourly/*", date_event,"-S",hour_event,"*.tif"))
#         raster_hour_file <- raster::raster(hour_file)
#         print(raster_hour_file)
#         return(raster_hour_file)
#
#
#
#   })
#
#     observeEvent(map_df(),{
#         if (nchar(format(input$years2))==10){
#             date_selected <- paste0(format(input$years2), " 00:00:00")
#         }else{
#             date_selected <- format(input$years2)}
#
#         point_selected <- values$cyclone_select[values$cyclone_select $ISO_TIME == date_selected,]
#         other_points <- values$cyclone_select[values$cyclone_select $ISO_TIME != date_selected, ]
#
#
#         greenLeafIcon <- makeIcon(
#   iconUrl = "https://leafletjs.com/examples/custom-icons/leaf-green.png",
#   iconWidth = 38, iconHeight = 95,
#   iconAnchorX = 22, iconAnchorY = 94,
#   shadowUrl = "https://leafletjs.com/examples/custom-icons/leaf-shadow.png",
#   shadowWidth = 50, shadowHeight = 64,
#   shadowAnchorX = 4, shadowAnchorY = 62
# )
#
#         proxy %>%removeControl("rain2")%>%removeControl("rain")%>%removeImage(layerId = c("raster","raster2"))%>% clearMarkers()
#         proxy %>%
#             addMarkers(data = other_points, layerId = paste(substr(other_points$ISO_TIME, 1,10),substr(other_points$ISO_TIME, 12,19)))%>%
#             addMarkers(data = point_selected, layerId = paste(substr(point_selected$ISO_TIME, 1,10),substr(point_selected$ISO_TIME, 12,19)),icon = greenLeafIcon)%>%
#             addRasterImage(map_df(),layerId = "raster",colors = pal)%>%
#             addLegendNumeric(layerId = 'rain',pal=pal, values = values(map_df()),
#                              title = "Precipitation (mm/hr)", width = 25, height = 180,position = 'bottomright',group="legend")
#
#             })
#
#
#
#
#     #
#     #
#     #
#     #
#     observeEvent(input$map_marker_click,{
#         event <- input$map_marker_click
#         print(event)
#         value_point <- as.POSIXct(event$id, tz="UTC")
#         updateSliderInput(session, "years2", value = value_point,
#                           min = values$min_time, max = values$max_time,timezone="+0000")
#
#
#
#     #     proxy %>%removeControl("rain2")%>%removeControl("rain")%>%removeImage(layerId = c("raster","raster2"))
#     #
#     #     date_event <- str_replace_all(substr(event$id, 1,10),"-","")
#     #     hour_event <- str_replace_all(substr(event$id, 12,13),"-","")
#     #
#     #     #Get the accumulation rain raster for the selected cyclone
#     #     hour_file <- Sys.glob(paste0("/home/florent/PycharmProjects/ShinyApp/data/GPM_hourly/*", date_event,"-S",hour_event,"*.tif"))
#     #     raster_hour_file <- raster::raster(hour_file)
#     #     proxy %>% addRasterImage(raster_hour_file,colors = pal,layerId = "raster2")%>%
#     #         addLegendNumeric(layerId = 'rain2',pal=pal, values = values(raster_hour_file),
#     #                          title = "Precipitation (mm/hr)", width = 25, height = 180,position = 'bottomright',group="legend")
#     #
#         })
#
#
# }
library(shiny)
library(leaflet)



tile_s <- raster("/home/florent/sen2change_data/data/CVA/38KND/S2B_MSIL2A_20171225T071209_N0206_R020_T38KND_20171225T102551/S2A_MSIL2A_20180129T071211_N0206_R020_T38KND_20180129T104706/output_cog.tif")

t <- projectRaster(tile_s,crs = "+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs ")
# print(t)

ui <- fluidPage(
  leafletOutput("mymap")

)

server <- function(input, output, session) {



  output$mymap <- renderLeaflet({
    leaflet() %>%
        addRasterImage(x = tile_s)%>%
        addProviderTiles(providers$OpenStreetMap.DE)
  })
}




shinyApp(ui = ui, server = server,options = list(launch.browser = TRUE))

