#-------------------------------
#UI
#Page 3 : Change detection
#-------------------------------

shiny::tabPanel(title="Change detection",
                value = "sentinel2",
                icon=shiny::icon("earth-africa"),
                useSweetAlert(),
                fluidRow(
                    column(2,
                           wellPanel(
                               value_box(title = " ", value = "Change detection",
                                         showcase = bs_icon("globe-europe-africa"), class = "bg-success"),
                                hr(),
                               radioGroupButtons(inputId = "select_scale",
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
                                                  status = "myClass"),
                                     br(),
                                     p("Type of changes", class="h1_onglet3"),
                                     hr(),
                                     h2(brighter::with_red_star("Select one or many type of changes : ")),
                                     br(),
                                     awesomeCheckboxGroup(inputId = "change_choice",
                                                          label = NULL,
                                                          choices = c("Surface become flooded",
                                                                      "Vegetation variation",
                                                                      "Appearance of bare soil",
                                                                      "Burned area",
                                                                      "Dryness zone"
                                                          ),
                                                          selected = NULL),
                                     # br(),
                                     # h1("Contact informations"),
                                     # hr(),
                                     # textInput(inputId = "mail",
                                     #           label= h2(brighter::with_red_star("Enter your email address : "))),
                                     br(),br(),
                                     hr(),
                                     actionBttn(inputId = "validation",
                                                label = " Add to cart ",
                                                block = TRUE,
                                                icon= icon("cart-shopping"),
                                                style = "material-flat",
                                                color = "primary"),hr())),
                    column(width = 10,
                           leafletOutput('map_custom',width="100%", height="65vh"),
                           DT::DTOutput(outputId = "dt_table", width = "100%"),
                           br(),
                           shiny::includeScript("./www/script/change_detection.js")
                    )

)



)
