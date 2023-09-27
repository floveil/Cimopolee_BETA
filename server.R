library(shiny)

server <- function(session, input, output) {

    values <- reactiveValues(Clicks_district=list(),
                             dt_row = NULL,
                             add_or_edit = NULL,
                             edit_button = NULL,
                             df = NULL,
                             ine = 1,
                             district_clicked = "0",
                             Clicks_district11=list(),
                             dt_row1 = NULL,
                             add_or_edit1 = NULL,
                             edit_button1 = NULL,
                             df1 = NULL,
                             ine1 = 1,
                            ite_1 = 1)

    # Server file of page 2 : historical cyclones + change
    source(file.path("www/controllers/actual_situation_server.R"), local = TRUE)$value
     # # UI file of page 2 : historical cyclones + change
    source(file.path("www/controllers/demonstrateur_server.R"), local = TRUE)$value
    # # UI file of page 2 : historical cyclones + change
    #source(file.path("www/controllers/cyclones_historiques_server.R"), local = TRUE)$value,
    # Server file of page 1 : About/Help
    source(file.path("www/controllers/about_help_server.R"), local = TRUE)$value
    # Server file of page 2 : historical cyclones + flood
    #source(file.path("www/controllers/onglet2_hist_flood_server.R"), local = TRUE)$value
    # Server file of page 3 : cart
    #source(file.path("www/controllers/onglet3_cart_server.R"), local = TRUE)$value

    # # Server file of page 3 : change detection
    # source(file.path("www/controllers/change_detection_server.R"), local = TRUE)$value
    # # Server file of page 4 : flood impacts
    # source(file.path("www/controllers/flood_impacts_server.R"), local = TRUE)$value
    # # Server file of page 4 : flood impacts
    # source(file.path("www/controllers/cart_server.R"), local = TRUE)$value

}
