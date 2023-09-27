#-------------------------------
#UI
#Page 2 : Historical Cyclones
#-------------------------------

shiny::tabPanel(title="Historical cyclones",
                value ="hist_cycl",
                icon = shiny::icon("hurricane"),
                leafletOutput('map' ),
                absolutePanel(id = "controls",
                              class = "panel panel-default",
                              top = 60, left = 50, width = 400,
                              fixed=TRUE, draggable = TRUE, height = "auto",
                              br(),
                              value_box(title = " ", value = "Historical cyclones",
                                         showcase = bs_icon("hurricane"),
                                         class = "bg-dark"),
                              hr(),
                              pickerInput(inputId = "picker_cyclone",
                                            label = NULL,
                                            width = "100%",
                                            choices = c(" ", df_name_cyclone$name),
                                            selected = " ",
                                            multiple = FALSE,
                                            choicesOpt = list(subtext = paste0(c(" ",df_name_cyclone$start)," : ",c(" ",df_name_cyclone$end))),
                                            options = pickerOptions(noneSelectedText = "Select a past cyclone")),
                              hr(),
                              conditionalPanel(condition = "input.picker_cyclone != ' '", span(p("Average rainfall (mm/day)", class="h1_onglet2")),
                                               span(h2("Select a district on the map to view rainfall trend")),
                                               h3(uiOutput("province")),
                                               plotlyOutput("plot_pluie")),
                              style="color:#333 ; padding: 0px 10px 10px 10px;"
                ))
