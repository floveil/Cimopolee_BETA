shiny::tabPanel(title="Situation en cours",
                value = "sentinel2",
                icon=shiny::icon("clock"),
                useSweetAlert(),
                leafletOutput('map',width="100%"),

                absolutePanel(id ="input_date_control",top = 50, right = 0, draggable = FALSE, width = "30%", style = "z-index:1000; min-width: 700px;", class = "panel panel-default",
                            height = "100vh",
                              # fluidRow(column(width = 2,
                                       #        knobInput(inputId = "Knob_years", label = "Année",width = "210px",height = "210px", value = 1980,
                                       #                  min = 1980, max=2022, step=1, displayPrevious = TRUE, fgColor = "#428BCA", inputColor = "#428BCA")),
                                       # column(width=2,
                                       #        knobInput(inputId = "Knob_months", label = "Mois",width = "210px", height = "210px",value = 6,
                                       #           min = 1, max=12, step=1, displayPrevious = TRUE, fgColor = "#428BCA", inputColor = "#428BCA"))),
                              h1(uiOutput("province")),
                              plotlyOutput("plot_pluie"),
                              br(),br(),br(),br(),
                              h1(uiOutput("density")),
                                plotlyOutput("density_plot"),
                              br(),br(),
                              actionBttn(inputId = "no_cyclone", label = "Pas de cyclone", style = "stretch", color = "warning"),
                              actionBttn(inputId = "cyclone", label = "Présence de cyclone", style = "stretch", color = "danger")


                )

)
