#-------------------------------
#UI
#Page 1 : About/Help
#-------------------------------

navbarMenu(title="About/Help", icon = shiny::icon("circle-info"),
           tabPanel(title= "About",
                    value ="test",
                    icon=shiny::icon("circle-info"),
                    htmltools::includeHTML("www/markdown/about.html"),
                    br(),
                    br(),
                    fluidRow(
                        column(width=3),
                        column(width = 3,
                               value_box(title = " ", value = "Historical cyclones",
                                         showcase = bs_icon("hurricane"),
                                         class = "bg-dark", height = "290px",
                                         p(bs_icon("geo"),"Visualization of historical cyclones", class="h1modif"),
                                         p( bs_icon("cloud-rain"),"Identification of areas affected by heavy rainfall", class="h1modif"),
                                         br(),
                                         actionBttn(inputId = "help_historical", label = "More info",
                                                    style = "stretch", color = "warning"))),
                        column(width = 3,
                               value_box(title = " ", value = "Optical and Radar detection",
                                         showcase = bs_icon("globe-europe-africa"), class = "bg-success",height = "290px",
                                         p(bs_icon("zoom-in"),"Detects changes following a given event", class="h1modif"),
                                         p( bs_icon("sliders"),"Customize searches", class="h1modif"),
                                         p(bs_icon("water"),"Flood detection", class="h1modif"),
                                         p( bs_icon("buildings"),"Identifies and accounts affected infrastructures", class="h1modif"),
                                         actionBttn(inputId = "help_detection", label = "More info",
                                                    style = "stretch", color = "warning"))),

                    ),
                    fluidRow(
                        column(width=4),
                        column(width = 3,
                               tags$a(img(src = "logo_partenaire_true.png", title = "IRD",id = "ird2", height = "1000px",width = "1500px")))
                    )
           ),

           tabPanel("Historical cyclones",icon=shiny::icon("hurricane"),
                    fluidRow(
                        column(width=3),
                        column(width=6,
                    value_box(title = " ", value = "Historical cyclones",
                                         showcase = bs_icon("hurricane"),
                                         class = "bg-dark", height = "130px"))),
                    htmltools::includeHTML("www/markdown/historic_cyclones.html")
           ),

           tabPanel("Optical", icon=shiny::icon("earth-africa"),
                    fluidRow(
                        column(width=3),
                        column(width=6,
                    value_box(title = " ", value = "Change detection",
                              showcase = bs_icon("globe-europe-africa"),
                              class = "bg-success",height = "130px"))),
                    htmltools::includeHTML("www/markdown/change_detection.html")
           ),

           tabPanel("Radar",icon=shiny::icon("cloud-showers-water"),
                    fluidRow(
                        column(width=3),
                        column(width=6,
                    value_box(title = " ", value = "Flood impacts",
                              showcase = bs_icon("cloud-rain"),
                              class = "bg-primary",height = "130px"))),
                    htmltools::includeHTML("www/markdown/flood_impacts.html")
           ),
           tabPanel("Cart",icon=shiny::icon("cart-shopping")))
