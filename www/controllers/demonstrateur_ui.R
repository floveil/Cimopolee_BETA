shiny::tabPanel(title="Demonstrateur",
                value = "demo",
                icon=shiny::icon("desktop"),
                useSweetAlert(),
                leafletOutput('map_demo',width="100%"),

                absolutePanel(id ="input_demo",top = 50, right = 0, draggable = FALSE, width = "30%", style = "z-index:1000; min-width: 700px;", class = "panel panel-default",
                            height = "100vh",
                              br(),
                              fluidRow(column(1),
                                       column(10,
                                              img(src="freddy.png", width =680, height=140),
                                              br(),br(),
                                              layout_columns(
                                              value_box(tags$p("2023", style = "font-weight: bold;"),tags$p("06 février au 14 mars", style = "font-size: 20px;"),showcase=bsicons::bs_icon("Calendar4 week",size="30px"),height = "90px",class="bg-dark"),
                                              value_box(tags$p("Rafales maximales", style = "font-weight: bold;"),tags$p("256 km/h", style = "font-size: 20px;"),showcase=bsicons::bs_icon("wind",size="30px"),height = "90px",class = "bg-secondary")
                                                )),
                                       column(1)),
                              fluidRow(column(1),
                                       column(10,
                               navset_card_tab(
                                                title = " ",
                                                nav_panel("Impacts",
                                                          value_box(tags$p("Superficie zones en eau", style = "font-weight: bold; color: #3085C3;"),tags$p("50396244 m2 = 5039,6244 ha", style = "font-size: 20px; color: #3085C3;"),showcase=bsicons::bs_icon("water",size="30px", color="#3085C3"),height = "90px",class="bg-white"),
                                                          br(),
                                                          hr(),
                                                          br(),
                                                          layout_columns(
                                              value_box(tags$p("Batiments touchés", style = "font-weight: bold; color: #E55604;"),tags$p("285 batiments - 67864 m2", style = "font-size: 20px;color: #E55604;"),showcase=bsicons::bs_icon("building-fill-exclamation",size="30px", color="#E55604"),height = "90px",class="bg-white"),
                                              value_box(tags$p("Infrastructures routières touchées", style = "font-weight: bold; color: #662549;"),tags$p("22.3 km", style = "font-size: 20px;color: #662549;"),showcase=bsicons::bs_icon("sign-no-right-turn-fill",size="30px",color= "#662549"),height = "90px",class = "bg-white")
                                                ),
                                                                  br(),hr(),br(),
                                              actionButton("rapport", "Télécharger le rapport", icon=icon("file")),
                                              actionButton("folder", "Télécharger les données (zones en eau, batiments et routes impactés (.shp))", icon=icon("database")),


                                             ),
                                                nav_panel("Contexte",
                                                          h3("Naviguez pour afficher les produits de précipitations :"),
                                                          sliderInput('years', label=NULL, min = as.POSIXct("2023-02-06 00:00:00", tz="UTC"), max = as.POSIXct("2023-03-14 21:00:00", tz="UTC"),
                                                                      width = "100%", value=as.POSIXct("2023-02-06 00:00:00", tz="UTC") ,step=10800,timezone="+0000",ticks = FALSE, animate = shiny::animationOptions(interval = 4000, loop = FALSE)),
                                                          h3("Cliquez sur un district pour voir l'évolution des précipitations :"),
                                                          h1(uiOutput("province2")),
                                                          plotlyOutput("plot_pluie5"),hr(),
                                                          actionButton("data_pluie", "Télécharger les données de pluie pour le district séléctionné", icon=icon("database"))

                                                ))),
                                              column(1))
                )
                #               # fluidRow(column(width = 2,
                #                        #        knobInput(inputId = "Knob_years", label = "Année",width = "210px",height = "210px", value = 1980,
                #                        #                  min = 1980, max=2022, step=1, displayPrevious = TRUE, fgColor = "#428BCA", inputColor = "#428BCA")),
                #                        # column(width=2,
                #                        #        knobInput(inputId = "Knob_months", label = "Mois",width = "210px", height = "210px",value = 6,
                #                        #           min = 1, max=12, step=1, displayPrevious = TRUE, fgColor = "#428BCA", inputColor = "#428BCA"))),
                #               h1(uiOutput("province")),
                #               plotlyOutput("plot_pluie"),
                #               br(),br(),br(),br(),
                #               h1(uiOutput("density")),
                #                 plotlyOutput("density_plot"),
                #               br(),br(),
                #               actionBttn(inputId = "no_cyclone", label = "Pas de cyclone", style = "stretch", color = "warning"),
                #               actionBttn(inputId = "cyclone", label = "Présence de cyclone", style = "stretch", color = "danger")
                #
                #
                # )

)

