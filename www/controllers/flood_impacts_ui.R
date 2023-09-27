#-------------------------------
#UI
#Page 3 : Change detection
#-------------------------------

shiny::tabPanel(title="Flood impacts",
                value = "sentinel1",
                icon=shiny::icon("cloud-showers-water"),
                useSweetAlert(),
                fluidRow(
                    column(2,
                           wellPanel(
                                value_box(title = " ", value = "Flood impacts",
                                         showcase = bs_icon("cloud-rain"), class = "bg-primary"),
                               hr(),
                               radioGroupButtons(inputId = "select_scale2",
                                                  label = h2("Choose a scale :"),
                                                  size = "normal",
                                                  width = "100%",
                                                  selected=NULL,
                                                  choices = c(`District <i class="fas fa-flag"></i>` = "district",
                                                              `Shapefile <i class="fas fa-vector-square"></i>` = "shapefile",
                                                              `Tiles <i class='fas fa-satellite''></i>` = "tiles"),
                                                  justified = TRUE,
                                                  checkIcon = list( yes = icon("ok", lib = "glyphicon")),
                                                  direction = "vertical",
                                                  status = "myClass2"),
                                     br(),
                                     p("Impacts",class="h1_onglet4"),
                                     hr(),
                                     h2(brighter::with_red_star("Select one or many impacts : ")),
                                     br(),
                                     awesomeCheckboxGroup(inputId = "change_choice2",
                                                          label = NULL,
                                                          choices = c("Flood extent",
                                                                      "Impacted infrastructures"),
                                                          selected = NULL),
                                     # br(),
                                     # h1("Contact informations"),
                                     # hr(),
                                     # textInput(inputId = "mail2",
                                     #           label= h2(brighter::with_red_star("Enter your email address : "))),
                                     br(),br(),
                                     hr(),
                                     actionBttn(inputId = "validation2",
                                                label = " Add to cart ",
                                                block = TRUE,
                                                icon= icon("cart-shopping"),
                                                style = "material-flat",
                                                color = "primary"),hr())),
                    column(width = 10,
                           leafletOutput('map_custom2',width="100%", height="65vh"),
                           DT::DTOutput(outputId = "dt_table2", width = "100%"),
                           br(),
                           shiny::includeScript("./www/script/flood_impacts.js")
                    )

)



)
