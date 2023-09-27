shiny::tabPanel(title="Radar",
                value = "sentinel1",
                icon=shiny::icon("cloud-showers-water"),
                useSweetAlert(),
                tabsetPanel(id= "subnav1",
                               tabPanel(title= p(bs_icon("hurricane", size="20px"),"Historical cyclones",class="h1_onglet4"),
                                        fluidRow(
                                            column(3,
                                        br(),
                                        pickerInput(inputId = "picker_cyclone2",
                                            label = NULL,
                                            width = "100%",
                                            choices = c(" ", df_name_cyclone$name),
                                            selected = " ",
                                            multiple = FALSE,
                                            choicesOpt = list(subtext = paste0(c(" ",df_name_cyclone$start)," : ",c(" ",df_name_cyclone$end))),
                                            options = pickerOptions(noneSelectedText = "Select a past cyclone")),

                              conditionalPanel(condition = "input.picker_cyclone2 != ' '",
                                               hr(),
                                               span(p("Precipitation evolution", class="h1_onglet2")),
                                               span(h2("Select a district on the map to view rainfall trend")),
                                               fluidRow(column(1),
                                                        column(10,
                                                               h1(uiOutput("years3")),
                                                               column(1))),
                                               plotlyOutput("plot_pluie2"),
                                               h1(uiOutput("province2"))
                                               )),
                               column(width = 9, leafletOutput('map_custom1',width="100%", height="85vh")))),




                               tabPanel(title= p(bs_icon("sliders2-vertical", size="20px"),"Customize",class="h1_onglet4"),
                                        fluidRow(
                                            column(3,
                                        br(),
                                        p(brighter::with_red_star("Select one or many type of changes"),class="h1_onglet4"),
                                        br(),
                                     awesomeCheckboxGroup(inputId = "change_choice2",
                                                          label = NULL,
                                                          choices = c("Flood extent",
                                                                      "Impacted infrastructures"),
                                                          selected = NULL),
                                        hr(),
                                        p(brighter::with_red_star("Select one or more types of infrastructure affected by the event"),class="h1_onglet4"),
                                        br(),
                                     awesomeCheckboxGroup(inputId = "osm_choice2",
                                                          label = NULL,
                                                          choices = c("Buildings",
                                                                      "Roads"),
                                                          selected = NULL),
                                        hr(),
                                        br(),
                                        p(brighter::with_red_star("Click on tile for cusomize"),class="h1_onglet4"),
                                        br(),
                                        DT::DTOutput(outputId = "dt_table1", width = "100%"),
                                        shiny::includeScript("./www/script/flood_impacts.js"),
                                        br(),
                                        br(),
                                        hr(),
                                     actionBttn(inputId = "validation2",
                                                label = " Add to cart ",
                                                block = TRUE,
                                                icon= icon("cart-shopping"),
                                                style = "material-flat",
                                                color = "primary")
                           ),



                    column(width = 9,
                           leafletOutput('map_custom3',width="100%", height="85vh")))
                    )
                )
)
