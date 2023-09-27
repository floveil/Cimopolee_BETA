library(rhandsontable)
library(shiny)
library(shinyjs)
library(xml2)
library(XML)


# #
# #
# ui <- fluidPage(
#     useShinyjs(),
#   mainPanel(
#         actionButton('addCol', 'Add'),
#         rHandsontableOutput("hot")
#   )
# )
#
# server <- function(input, output, session){
#
#     values <- reactiveValues()
#     x <- format(seq(from =as.Date("2018-01-01"),by = "day", length.out = 1), "%Y-%m-%d")
#
#     images_folder<- "/home/florent/sen2chain_data/data/L1C/38KND/"
#       list_images <- list.files(path = images_folder)
#       list_date_images <- unique(substr(list_images,12,19))
#       datetime_x <- strftime(as.POSIXct(list_date_images,format="%Y%m%d"))
#       df_image_time <- data.frame(name = list_images,
#                                     date = datetime_x,
#                                     cloud_cover = NA)
#
#
#       for(i in 1:nrow(df_image_time )) {
#           df_image_time[i,3 ] <- xml_double(xml_find_all(read_xml(paste(images_folder,df_image_time[i,1],"/MTD_MSIL1C.xml",sep='')),".//Cloud_Coverage_Assessment"))
#         }
#
#
#         df_image_order <- df_image_time[order(df_image_time$cloud_cover),]
#         df_image_order$color <- ifelse(df_image_order$cloud_cover<=20, "#73a942",
#                                        ifelse(df_image_order$cloud_cover>20 & df_image_order$cloud_cover<=40,"#aad576",
#                                               ifelse(df_image_order$cloud_cover>40 & df_image_order$cloud_cover<=60,"#f3c053",
#                                                      ifelse(df_image_order$cloud_cover>60 & df_image_order$cloud_cover<=80,"#f9a03f",
#                                                             ifelse(df_image_order$cloud_cover>80,"#eb5e28",0
#                                                             )))))
#
#
#         image_before <- head(df_image_order[df_image_order$date < as.character(x),],5)
#         image_after <- head(df_image_order[df_image_order$date > as.character(x),],5)
#       print(image_after)
#
#
#     df<- data.frame(tile = "38KND",
#                       date = as.character(x),
#                       before_date =paste(image_before$date[1], image_before$cloud_cover[1]),
#                       after_date =paste(image_after$date[1], image_after$cloud_cover[1]),
#                     stringsAsFactors = FALSE)
#       values$data <- df
#
#
#
#   output$hot <- renderRHandsontable({
#
#       rhandsontable(values$data,rowHeaders = NULL,width = 600, height = 600) %>%
#       hot_col(col = "tile",
#                 halign="htCenter",
#                 valign="htMiddle",
#                 readOnly = TRUE)%>%
#       hot_col(col = "date",
#                 dateFormat = "YYYY-MM-DD",
#                 halign="htCenter",
#                 valign="htMiddle",
#                 type="date",
#                 datePickerConfig=c(numberOfMonths=3,
#                                    todayHighlight=TRUE,
#                                    firstDay= 1))%>%
#       hot_col(col = "before_date",
#               type = "dropdown",
#               halign="htCenter",
#               valign="htMiddle",
#               source = paste(image_before$date,image_before$cloud_cover),strict = TRUE)%>%
#       hot_col(col = "after_date",
#               type = "dropdown",
#               halign="htCenter",
#               valign="htMiddle",
#               source = paste(image_after$date,image_after$cloud_cover),strict = TRUE)%>%
#       hot_cols(colWidths = 100) %>%
#       hot_rows(rowHeights = 50)%>%
#           hot_cols(renderer = "
#            function (instance, td, row, col, prop, value, cellProperties) {
#            Handsontable.renderers.NumericRenderer.apply(this, arguments);
#
#            if(instance.getData()[row][2] < 10 | instance.getData()[row][3] <10){
#                 td.style.background = 'pink';
#            } else if(instance.getData()[row][2] > 10| instance.getData()[row][3] >10) {
#                 td.style.background = 'lightgreen';
#            }
#         }")
#   })
#
#
#     observeEvent(input$addCol, {
#         newCol <- data.frame(tile="38KCB",date = input$hot$params$data[[1]][[2]],before_date = NA,after_date =NA)
#         values$data <- rbind(values$data, newCol)
#
#     })
#
# }

# library(shiny)
# library(DT)
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
#   "function(settings){",
#   "  $('#calendar').bsDatepicker({",
#   "    format: 'yyyy-mm-dd',",
#   "    todayHighlight: true",
#   "  });",
#   "}"
# ) # available options: https://bootstrap-datepicker.readthedocs.io/en/latest/
#
#
# server <- function(input, output, session){
#
#   output[["table"]] <- renderDT({
#     dat <- data.frame(
#       V1 = c("A","B"),
#       V2 = c("99","b"),
#       V3 = c('<input id="calendar" type="text" class="form-control" value = "2019-03-08"/>','<input id="calendar" type="text" class="form-control" value = "2019-03-08"/>'),
#       stringsAsFactors = FALSE
#     )
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
#


# ui <- basicPage(
#     tableOutput("My_table")
# )

# server <- function(input, output, session) {
#
#
#       # images_folder<- "/home/florent/sen2chain_data/data/L1C/38KND/"
#       # list_images <- list.files(path = images_folder)
#       # list_date_images <- unique(substr(list_images,12,19))
#       # datetime_x <- strftime(as.POSIXct(list_date_images,format="%Y%m%d"))
#       # df_image_time <- data.frame(name = list_images,
#       #                               date = datetime_x,
#       #                               cloud_cover = NA)
#       #
#       #
#       # for(i in 1:nrow(df_image_time )) {
#       #     df_image_time[i,3 ] <- xml_double(xml_find_all(read_xml(paste(images_folder,df_image_time[i,1],"/MTD_MSIL1C.xml",sep='')),".//Cloud_Coverage_Assessment"))
#       #   }
#       #
#       #
#       #   df_image_order <- df_image_time[order(df_image_time$cloud_cover),]
#       #   df_image_order$color <- ifelse(df_image_order$cloud_cover<=20, "#73a942",
#       #                                  ifelse(df_image_order$cloud_cover>20 & df_image_order$cloud_cover<=40,"#aad576",
#       #                                         ifelse(df_image_order$cloud_cover>40 & df_image_order$cloud_cover<=60,"#f3c053",
#       #                                                ifelse(df_image_order$cloud_cover>60 & df_image_order$cloud_cover<=80,"#f9a03f",
#       #                                                       ifelse(df_image_order$cloud_cover>80,"#eb5e28",0
#       #                                                       )))))
#
#
#         # image_before <- head(df_image_order[df_image_order$date < as.character(x),],5)
#         # image_after <- head(df_image_order[df_image_order$date > as.character(x),],5)
#     My_table = matrix()
#
#     output$My_table <- renderTable({
#         event_date <- paste0("<input type='date' id='date_input' min='2018-01-01' max='2018-12-31' >")
#         print(input$date_input)
#         i_before <- paste0( '<select id="single_select" style="width: 100%;">
#                                           <option value="A">O</option>
#                                           <option value="B">B</option>
#                                           <option value="C">C</option>
#                                         </select>')
#         print(input$single_select)
#
#         df <- cbind("38KCB",event_date,i_before)
#         return(df)
#     }, sanitize.text.function = function(x) x
#                                    )
#
#   }
#
#
#
# shinyApp(ui = ui, server = server,options = list(launch.browser = TRUE))


library(shiny)
library(shinyWidgets)
#
df_test <- list("38KND","39LTF")

# ui <- fluidPage(
#     tags$head(includeCSS("./www/css/styles.css")),
#     mainPanel(
#     tabsetPanel(
#       id = "tabs",
#         column(
#           2,
#           tableOutput("My_table")),
#         column(4,
#   tableOutput("My_table2")))),
#   shiny:::datePickerDependency()
# )
#
# server <- function(input, output, session) {
#
#   values <- reactiveValues()
#   My_table = matrix()
#   My_table2 = matrix()
#
#   output$My_table <- renderTable({
#       df <- data.frame(NULL)
#
#       for (tile in df_test){
#           id <- paste0("date_input_",tile)
#
#           event_date <- dateInput(inputId = id,
#                             label = NULL,
#                             min='2015-07-01' ,
#                             max=Sys.Date(), width = "110px" ) |> as.character()
#
#           tab <- cbind("Tile"=tile,"Event Date" = event_date)
#           df <- rbind(df,tab)
#       }
#
#     return(df)
#   }
#                                     ,
#       sanitize.text.function = function(x) x,align = "c"
#   )
#
#     output$My_table2 <- renderTable({
#         df <- data.frame()
#         for (tile in df_test){
#
#             images_folder<- paste0("/home/florent/sen2chain_data/data/L1C/",tile)
#             list_images <- list.files(path = images_folder)
#             list_date_images <- unique(substr(list_images,12,19))
#             datetime_x <- strftime(as.POSIXct(list_date_images,format="%Y%m%d"))
#             df_image_time <- data.frame(name = list_images,
#                                         date = datetime_x,
#                                         cloud_cover = NA)
#
#             for(i in 1:nrow(df_image_time )) {
#               df_image_time[i,3 ] <- xml_double(xml_find_all(read_xml(paste(images_folder,"/",df_image_time[i,1],"/MTD_MSIL1C.xml",sep='')),".//Cloud_Coverage_Assessment"))
#             }
#
#             df_image_order <- df_image_time[order(df_image_time$cloud_cover),]
#             df_image_order$color <- ifelse(df_image_order$cloud_cover<=20, "verygoodimage",
#                                            ifelse(df_image_order$cloud_cover>20 & df_image_order$cloud_cover<=40,"goodimage",
#                                                   ifelse(df_image_order$cloud_cover>40 & df_image_order$cloud_cover<=60,"okimage",
#                                                          ifelse(df_image_order$cloud_cover>60 & df_image_order$cloud_cover<=80,"badimage",
#                                                                 ifelse(df_image_order$cloud_cover>80,"verybadimage",0
#                                                                 )))))
#
#
#
#
#             image_before <- head(df_image_order[df_image_order$date < input[[paste0("date_input_",tile)]],],5)
#             image_after <- head(df_image_order[df_image_order$date > input[[paste0("date_input_",tile)]],],5)
#
#
#             i_before<-  paste0('<select id="date_before" onchange="this.className=this.options[this.selectedIndex].className" class=',image_before$color[1],'>
#             <option class=',image_before$color[1], ' value=',image_before$date[1], '>',image_before$date[1]," (",round(image_before$cloud_cover[1],1),'%)</option>
#             <option class=',image_before$color[2], ' value=',image_before$date[2], '>',image_before$date[2]," (",round(image_before$cloud_cover[2],1),'%)</option>
#             <option class=',image_before$color[3], ' value=',image_before$date[3], '>',image_before$date[3]," (",round(image_before$cloud_cover[3],1),'%)</option>
#             <option class=',image_before$color[4], ' value=',image_before$date[4], '>',image_before$date[4]," (",round(image_before$cloud_cover[4],1),'%)</option>
#             <option class=',image_before$color[5], ' value=',image_before$date[5], '>',image_before$date[5]," (",round(image_before$cloud_cover[5],1),'%)</option>
#             </select>')
#
#
#
#             i_after <-  paste0('<select id="date_after" onchange="this.className=this.options[this.selectedIndex].className" class=',image_after$color[1],'>
#             <option class=',image_after$color[1], ' value=',image_after$date[1], '>',image_after$date[1]," (",round(image_after$cloud_cover[1],1),'%)</option>
#             <option class=',image_after$color[2], ' value=',image_after$date[2], '>',image_after$date[2]," (",round(image_after$cloud_cover[2],1),'%)</option>
#             <option class=',image_after$color[3], ' value=',image_after$date[3], '>',image_after$date[3]," (",round(image_after$cloud_cover[3],1),'%)</option>
#             <option class=',image_after$color[4], ' value=',image_after$date[4], '>',image_after$date[4]," (",round(image_after$cloud_cover[4],1),'%)</option>
#             <option class=',image_after$color[5], ' value=',image_after$date[5], '>',image_after$date[5]," (",round(image_after$cloud_cover[5],1),'%)</option>
#             </select>')
#
#             button<- actionButton(inputId=paste0("button_",tile), "Remove")|> as.character()
#
#             tab<- cbind("Image before" = i_before,"Image after" = i_after, " "=button)
#             df <- rbind(df,tab)
#             print(df)
#             values$df <- df
#         }
#         return(df) }, sanitize.text.function = function(x) x,align = "c")
#
#         observeEvent(input$button_38KND,{
#
#             values$df <- values$df[-as.numeric(input$button_38KND),]
#             print(values$df)
#             output$My_table2
#             output$My_table2 <- renderTable({data.frame(values$df)})
#         })
#
#
#
#
#
#
#
#
# library(shiny)
# library(shinydashboard)
# library(shinydashboardPlus)
# library(DT)
# library(tidyverse)
#
#
#
#
# ui <- fluidPage(
#     fluidRow(actionButton(inputId="button", "Button"),
#              conditionalPanel(condition = "input.button == 1",
#                                      uiOutput("tile")),),
#     fluidRow(DTOutput(outputId = "table")))
#
#
# server <- function(input, output, session) {
#     values <- reactiveValues(df = data.frame(ROW=NA, TEXT=NA,SINGLE_SELECT=NA))
#
#    output$tile <- renderUI({selectInput("variable", "Variable:",
#                 c("38KND","39LTF"),multiple = TRUE)
#   })
#
#
#
#   output$table <- renderDT({
#
#     if(input$variable !=NULL ){
#
#     values$df <- values$df %>%
#           add_row(ROW = input$variable,
#                        TEXT =paste0('<input type="date" id="start" name="trip-start" value="2018-07-22" min="2018-01-01" max="2018-12-31"> '),
#                        SINGLE_SELECT = '<select id="single_select" style="width: 100%;">
#                        <option value="" selected></option>
#                        <option value="A">A</option>
#                        <option value="B">B</option>
#                        <option value="C">C</option>
#                        </select>')
#     }
#     return(values$df)
#   })
#
#
# }
# library(shiny)
# library(DT)
# x<- data.frame(
#     tile = NA,v1 = NA,
#                v2 = NA
#
# )
# ui = shinyUI(
#   fluidPage(
#     sidebarLayout(
#       sidebarPanel(
#         # Add button
#         actionButton(inputId = "add.button", label = "Add", icon =
#                        icon("plus")),
#         # Delete button
#         actionButton(inputId = "delete.button", label = "Delete", icon =
#                        icon("minus"))
#
#         ),
#       mainPanel(
#         dataTableOutput('table')
#       )
#     )
#   )
# )
# server = function(input, output, session) {
#   values <- reactiveValues()
#   values$df <- data.frame(
#     tile = "38KND",v1 = '<input type="date" id="start" name="trip-start" value="2018-07-22" min="2018-01-01" max="2018-12-31"> ',
#                v2 = '<select id="single_select" style="width: 100%;">
#                        <option value="" selected></option>
#                        <option value="A">A</option>
#                        <option value="B">B</option>
#                        <option value="C">C</option>
#                        </select>',
#     v3='<input type="checkbox" id="horns" name="horns">'
#
#
# )
#
#   observeEvent(input$add.button,{
#
#     newRow <- data.frame(tile="NA",
#                          v1= '<input type="date" id="start" name="trip-start" value="2018-07-22" min="2018-01-01" max="2018-12-31"> ',
#                          v2=
#                          '<select id="single_select" style="width: 100%;">
#                        <option value="" selected></option>
#                        <option value="A">A</option>
#                        <option value="B">B</option>
#                        <option value="C">C</option>
#                        </select>',
#                         v3='<input type="checkbox" id="horns" name="horns">')
#     colnames(newRow)<-colnames(values$df)
#     values$df <- rbind(values$df,newRow)
#     print(nrow(values$df))
#   })
#
#   observeEvent(input$delete.button,{
#     cat("deleteEntry\n")
#       print(input$row.selection)
#     if(is.null(input$row.selection)){
#       values$df <- values$df[-nrow(values$df), ]
#     } else {
#       values$df <- values$df[-input$row.selection, ]
#     }
#   })
#
#   output$table = renderDataTable({
#     datatable(values$df,escape = FALSE,selection = "none",
#               rownames = FALSE)
#   })
#
# }

library(shiny)
library(tidyverse)
library(DT)
library(shinyjs)




modal_dialog <- function(tile, date_event, before_date, after_date, edit, fade_option) {
  if (edit) {
    x <- "Submit Edits"
  } else {
    x <- "Add New Car"
  }

  if (fade_option){
      y = TRUE
  }  else{
      y = FALSE
  }


  shiny::modalDialog(
    title = "Edit Car",
    div(
      class = "text-center",
      div(
        style = "display: inline-block;",
        shiny::textInput(
          inputId = "tile_id",
          label = "Tile",
          value = tile,
          width = "200px"
        )
      ),
      div(
        style = "display: inline-block;",
        shiny::dateInput(
          inputId = "date_e",
          label = "Event date",
          min = '2015-07-01',
          max= Sys.Date(),
          value = date_event,
          format = "yyyy-mm-dd",
          width="200px"
        ),
      shiny::actionButton(
        inputId = "valid_event",
        label = "Select event date",
        icon = shiny::icon("filter"),
        class = "btn-warning"
      ))
      ,
      div(
        style = "display: inline-block;",
        shiny::selectInput(
          inputId = "date_b",
          label = "Date before event",
          choices = before_date,
          width = "200px"
        )
      ),
      div(
        style = "display: inline-block;",
        shiny::selectInput(
          inputId = "date_a",
          label = "Date after event",
          choices = after_date,
          width = "200px"
        )
      )
    ),
    size = "m",
    easyClose = TRUE,
    fade = y,
    footer = div(
      class = "pull-right container",
      shiny::actionButton(
        inputId = "final_edit",
        label = x,
        icon = shiny::icon("edit"),
        class = "btn-info"
      ),
      shiny::actionButton(
        inputId = "dismiss_modal",
        label = "Close",
        class = "btn-danger"
      )
    )
  ) %>% shiny::showModal()
}





ui <- fluidPage(

  # div(style = "display: none;", icon("refresh")),
  div(
    class = "container",
    div(
      style = "margin-top: 50px;",
      shiny::selectInput("variable", "Variable:",
                 c("38KND","39LTF","38KNE","38KNF"),multiple = TRUE)
    )
  ),
  div(
    class = "container",
    style = "margin-top: 50px;",
    DT::DTOutput(outputId = "dt_table", width = "100%")
  ),

  shiny::includeScript("change_detection.js")
)





create_btns <- function(x) {
  x %>%
    purrr::map_chr(~
    paste0(
      '<div class = "btn-group">
                   <button class="btn btn-default action-button btn-info action_button" id="edit_',
      .x, '" type="button" onclick=get_id(this.id)><i class="fas fa-edit"></i></button>
                   <button class="btn btn-default action-button btn-danger action_button" id="delete_',
      .x, '" type="button" onclick=get_id(this.id)><i class="fa fa-trash-alt"></i></button></div>'
    ))
}


# Define server logic required to draw a histogram
server <- function(input, output, session) {
    rv <- shiny::reactiveValues(dt_row = NULL,
    add_or_edit = NULL,
    edit_button = NULL, df=NULL)

    observeEvent(input$variable,{

    if (is.null(rv$df)){
        test <- data.frame(tile = input$variable, date_event = NA, before_date = NA, after_date = NA)
            rv$df <-    test%>%
      dplyr::bind_cols(tibble("Buttons" =  create_btns(1:lengths(list(test$tile)))))

    }else {

        new_row<- input$variable[!input$variable %in% c(rv$df$tile)]

    add_row <- dplyr::tibble(
      tile = new_row, date_event = NA, before_date = NA, after_date = NA,
      Buttons = create_btns(rv$keep_track_id)
    )
    rv$df <- add_row %>%
      dplyr::bind_rows(rv$df)
    rv$keep_track_id <- rv$keep_track_id + 1

    }
    rv$keep_track_id = nrow(rv$df) + 1






        output$dt_table <- DT::renderDT(
    {
      shiny::isolate(rv$df)
    },
    escape = F,
    rownames = FALSE,
    options = list(processing = FALSE)
  )
    })






  proxy <- DT::dataTableProxy("dt_table")
  shiny::observe({
    DT::replaceData(proxy, rv$df, resetPaging = FALSE, rownames = FALSE)
  })

  ### delete row
  shiny::observeEvent(input$current_id, {
    shiny::req(!is.null(input$current_id) & stringr::str_detect(input$current_id, pattern = "delete"))
    rv$dt_row <- which(stringr::str_detect(rv$df$Buttons, pattern = paste0("\\b", input$current_id, "\\b")))
      print(rv$df)
      print("Buttons")
      print(rv$df$Buttons)
      rv$df <- rv$df[-rv$dt_row, ]




  })

  # when edit button is clicked, modal dialog shows current editable row filled out
  shiny::observeEvent(input$current_id, {

    shiny::req(!is.null(input$current_id) & stringr::str_detect(input$current_id, pattern = "edit"))
    rv$dt_row <- which(stringr::str_detect(rv$df$Buttons, pattern = paste0("\\b", input$current_id, "\\b")))
    df <- rv$df[rv$dt_row, ]

    modal_dialog(
      tile = df$tile, date_event = df$date_event, before_date = NA, after_date = NA, edit = TRUE , fade_option = TRUE
    )
    rv$add_or_edit <- NULL

  })

    #paste0(image_before$date," ( cc : ",round(image_before$cloud_cover,1),"% )")
   shiny::observeEvent(input$valid_event,{
    images_folder<- paste0("/home/florent/sen2chain_data/data/L1C/",input$tile_id)
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
    df_image_order$color <- ifelse(df_image_order$cloud_cover<=20, "#73a942",
                                   ifelse(df_image_order$cloud_cover>20 & df_image_order$cloud_cover<=40,"#aad576",
                                          ifelse(df_image_order$cloud_cover>40 & df_image_order$cloud_cover<=60,"#f3c053",
                                                 ifelse(df_image_order$cloud_cover>60 & df_image_order$cloud_cover<=80,"#f9a03f",
                                                        ifelse(df_image_order$cloud_cover>80,"#eb5e28",0
                                                        )))))



    image_before <- head(df_image_order[df_image_order$date < input$date_e,],5)
    image_after <- head(df_image_order[df_image_order$date > input$date_e,],5)
    modal_dialog(
      tile = input$tile_id, date_event = as.character(input$date_e), before_date = paste0(image_before$date," ( cc : ",round(image_before$cloud_cover,1),"% )"),
      after_date = paste0(image_after$date," ( cc : ",round(image_after$cloud_cover,1),"% )"), edit = TRUE, fade_option=FALSE
    )

    })



  # when final edit button is clicked, table will be changed
  shiny::observeEvent(input$final_edit, {
    shiny::req(!is.null(input$current_id) & stringr::str_detect(input$current_id, pattern = "edit") & is.null(rv$add_or_edit))

    rv$edited_row <- dplyr::tibble(
      tile = input$tile_id, date_event = as.character(input$date_e), before_date = input$date_b, after_date = input$date_a,
      Buttons = rv$df$Buttons[rv$dt_row]
    )
    rv$df[rv$dt_row, ] <- rv$edited_row

  })



  shiny::observeEvent(input$final_edit, {
    shiny::req(rv$add_or_edit == 1)
    add_row <- dplyr::tibble(
      tile = "X", date_event = "X", before_date = "X", after_date = "X",
      Buttons = create_btns(rv$keep_track_id)
    )
    rv$df <- add_row %>%
      dplyr::bind_rows(rv$df)
      print(rv$df)
    rv$keep_track_id <- rv$keep_track_id + 1

  })


  ### remove edit modal when close button is clicked or submit button
  shiny::observeEvent(input$dismiss_modal, {
    shiny::removeModal()
  })
  shiny::observeEvent(input$final_edit, {
    shiny::removeModal()
  })

}



shinyApp(ui = ui, server = server,options = list(launch.browser = TRUE))




 # images_folder<- "/home/florent/sen2chain_data/data/L1C/38KND"
 #        list_images <- list.files(path = images_folder)
 #        list_date_images <- unique(substr(list_images,12,19))
 #        datetime_x <- strftime(as.POSIXct(list_date_images,format="%Y%m%d"))
 #        df_image_time <- data.frame(name = list_images,
 #                                    date = datetime_x,
 #                                    cloud_cover = NA)
 #
 #        for(i in 1:nrow(df_image_time )) {
 #          df_image_time[i,3 ] <- xml_double(xml_find_all(read_xml(paste(images_folder,"/",df_image_time[i,1],"/MTD_MSIL1C.xml",sep='')),".//Cloud_Coverage_Assessment"))
 #        }
 #
 #        df_image_order <- df_image_time[order(df_image_time$cloud_cover),]
 #        df_image_order$color <- ifelse(df_image_order$cloud_cover<=20, "#73a942",
 #                                       ifelse(df_image_order$cloud_cover>20 & df_image_order$cloud_cover<=40,"#aad576",
 #                                              ifelse(df_image_order$cloud_cover>40 & df_image_order$cloud_cover<=60,"#f3c053",
 #                                                     ifelse(df_image_order$cloud_cover>60 & df_image_order$cloud_cover<=80,"#f9a03f",
 #                                                            ifelse(df_image_order$cloud_cover>80,"#eb5e28",0
 #                                                            )))))
 #
 #
 #
 #        values$image_before <- head(df_image_order[df_image_order$date < input$date_input,],5)
 #        image_after <- head(df_image_order[df_image_order$date > input$date_input,],5)
 #
 #
 #
 #
 #    i_after<-  selectInput(inputId = 'date_after',
 #                             label=NULL,
 #                             choices = values$image_before[1,2])|> as.character()
