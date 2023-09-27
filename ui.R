library(shiny)
library(bslib)



ui <- shiny::navbarPage(inverse = TRUE,
                        tags$head(includeCSS("./www/css/styles.css")),
                        theme = bslib::bs_theme("navbar-dark-bg" = "darkslategray",
                                          base_font = bslib::font_google("Nunito Sans")),
                        title = stringr::str_to_upper("cimopolee"),
                        id="cimopolee",
                        # # UI file of page 2 : historical cyclones + change
                        source(file.path("./www/controllers/actual_situation_ui.R"), local = TRUE)$value,
                        # # UI file of page 2 : historical cyclones + change
                        source(file.path("./www/controllers/demonstrateur_ui.R"), local = TRUE)$value,
                        # # UI file of page 2 : historical cyclones + change
                        #source(file.path("www/controllers/cyclones_historiques_ui.R"), local = TRUE)$value,
                        # UI file of page  : About/Help
                        source(file.path("./www/controllers/about_help_ui.R"), local = TRUE)$value,
                        # # UI file of page  : historical cyclones + flood
                        #source(file.path("www/controllers/onglet2_hist_flood_ui.R"), local = TRUE)$value,
                         # # UI file of page  : cart
                        #source(file.path("www/controllers/onglet3_cart_ui.R"), local = TRUE)$value,
                        tags$a(div("", img(src = "espace_dev.png", title = "UMR Espace-Dev",id = "espace_dev", height = "30px",width = "110px",style = "position: fixed;right: 560px;top: 10px;")),
                               href="https://www.espace-dev.fr", class = "dropdown", target="_blank"),
                        tags$a(div("", img(src = "ird.png", title = "IRD",id = "ird", height = "25px",width = "90px",style = "position: fixed;right: 460px;top:17px;")),
                               href="https://en.ird.fr/", class = "dropdown", target="_blank"),
                        tags$a(div("", img(src = "universite_reunion.png", title = "University of La Reunion",id = "unif", height = "30px",width = "120px",style = "position: fixed;right: 340px;top:14px;")),
                               href="https://www.univ-reunion.fr/", class = "dropdown", target="_blank"),
                        tags$a(div("", img(src = "ioga2.png", title = "Institut Supérieur de Technologie d'Antananarivo",id = "ioga", height = "40px",width = "90px",style = "position: fixed;right: 250px;top: 11px; ")),
                               href="http://ioga.univ-antananarivo.mg/", class = "dropdown", target="_blank"),
                        tags$a(div("", img(src = "bngrc2.png", title = "Bureau National de Gestion des Risques et des Catastrophes",id = "bngrc", height = "50px",width = "50px",style = "position: fixed;right: 190px;top: 5px; ")),
                               href="https://bngrc.gov.mg/", class = "dropdown", target="_blank"),
                         tags$a(div("", img(src = "ist2.png", title = "IST Institut des Sciences et Technologies de Madagascar",id = "ist", height = "40px",width = "40px",style = "position: fixed;right: 150px;top: 11px; ")),
                               href="http://www.ist-tana.mg/", class = "dropdown", target="_blank"),
                        tags$a(div("", img(src = "Logo_SCO2.png", title = "Space Climate Observatory",id = "SCO", height = "50px",width = "60px",style = "position: fixed;right: 60px;top: 5px;")),
                               href="https://www.spaceclimateobservatory.org/", class = "dropdown", target="_blank"),
                        tags$a(div("", img(src = "CNES.png", title = "CNES",id = "cnes", height = "50px",width = "50px",style = "position: fixed;right: 10px;top: 5px;")),
                               href="https://cnes.fr/en", class = "dropdown", target="_blank"),



                        # # UI file of page 3 : change detection
                        # source(file.path("www/controllers/change_detection_ui.R"), local = TRUE)$value,
                        # # UI file of page 4 : flood impacts
                        # source(file.path("www/controllers/flood_impacts_ui.R"), local = TRUE)$value,
                        # # UI file of page 5 : cart
                        # source(file.path("www/controllers/cart_ui.R"), local = TRUE)$value
)








