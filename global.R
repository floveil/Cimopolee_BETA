Sys.setenv("_SP_EVOLUTION_STATUS_"=2)
library(sp)
library(leaflet)
library(shiny)
library(shinythemes)
library(tidyverse)
library(shinyWidgets)
library(shinyjs)
#library(rgdal)
library(sf)
library(raster)
library(leafpop)
library(leafem)
library(smoothr)
library(dplyr)
library(ggplot2)
library(tibble)
library(leaflegend)
library(plotly)
library(shinydashboard)
library(shinyalert)
library(reticulate)
library(xml2)
library(XML)
library(DT)
library(brighter)
library(shinycssloaders)
library(bsicons)
library(ncdf4)
library(RColorBrewer)

#To skip use of rgdal => retirement of rgdal in 2023
# Now use SP with this line
Sys.setenv("_SP_EVOLUTION_STATUS_"=2)

# Python source
# reticulate::use_python("/usr/bin/python3.10")
# reticulate::source_python("./www/script/run_s2chain.py")

# Source code
source("./www/script/mapin.R")
source("./www/script/modal_dialog.R")

# Data source
df_name_cyclone <- read.csv("./data/cyclones/name_date_cyclone.txt",sep=',', header = TRUE )
df_name_cyclone <- df_name_cyclone[df_name_cyclone$name !=  "NOT_NAMED",]
df_name_cyclone <- df_name_cyclone[order(as.Date(df_name_cyclone$start),decreasing = TRUE),]
mada_cycl_p <- st_read("./data/cyclones/IBTrACS.SI.list.v04r00.points_Mada_2015_present.shp")
mada_cycl_l <- st_read("./data/cyclones/IBTrACS.SI.list.v04r00.lines_Mada_2015_present.shp")
# mada_s_tile <-st_zm(st_read("./data/mada_Sentinel_tiles/Tile_mada.shp"))
mada_admin <- st_read("./data/mada_shp/mdg_admbnda_adm2_BNGRC_OCHA_20181031.shp")
#DEMO : FREDDY
freddy_p <- st_read("./data/cyclones/IBTrACS.SI.list.v04r00.points_Freddy.shp")
freddy_l <- st_read("./data/cyclones/IBTrACS.SI.list.v04r00.lines_Freddy.shp")

time_serie_disctict <- read.csv("./data/MSWEP/time_serie_district.csv",sep=',', header = TRUE )
#import density by district
df_density_district <- read.csv("./data/density/density_district.csv", header = TRUE )

# Functions

#Create buttons for modification and removing in DF Table
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

create_btns2 <- function(x) {
  x %>%
    purrr::map_chr(~
    paste0(
      '<div class = "btn-group">
                   <button class="btn btn-default action-button btn-info action_button" id="edi_',
      .x, '" type="button" onclick=get_id1(this.id)><i class="fas fa-edit"></i></button>
                   <button class="btn btn-default action-button btn-danger action_button" id="delet_',
      .x, '" type="button" onclick=get_id1(this.id)><i class="fa fa-trash-alt"></i></button></div>'
    ))
}

# Create dialog box when I click on edit button
modal_dialog <- function(tile, date_event, before_date, after_date, edit, fade_option) {

  if (edit) {
    x <- "Submit Edits"
  } else {
    x <- "Add New Car"
  }

  if (fade_option){
      y <- TRUE
  }  else{
      y <- FALSE
  }

  shiny::modalDialog(
      title=tile,
    div(class = "text-center",
            div(style = "display: inline-block;",
      shiny::dateInput(inputId = "date_e",label = h1("Event date"),min = '2015-07-01',
                           max= Sys.Date(), value = as.character(date_event), format = "yyyy-mm-dd",width = "300px")),
             div(style = "display: inline-block;",
      shiny::actionButton(inputId = "valid_event",label = "Select event date",
                           icon = shiny::icon("filter"), class = "btn-warning",width = "300px"))
            ),
    br(),
    div(class = "text-center",
            div(style = "display: inline-block;",
      shiny::selectInput(inputId = "date_b", label = h1("Date before event"),
                         choices = before_date, width = "300px")),
             div(style = "display: inline-block;",
      shiny::selectInput(inputId = "date_a", label = h1("Date after event"),
                             choices = after_date, width = "300px"))
            ),
    size = "l",
    easyClose = TRUE,
    fade = y,
    footer = shiny::div(
        class = "pull-right container",
        shiny::actionButton(inputId = "final_edit", label = x,
                            icon = shiny::icon("edit"), class = "btn-info"),
        shiny::actionButton(inputId = "dismiss_modal", label = "Close", class = "btn-danger")
    )
  ) %>% shiny::showModal()
}




modal_dialog2 <- function(tile1, date_event1, before_date1, after_date1, edit1, fade_option1) {

  if (edit1) {
    x1 <- "Submit Edits"
  } else {
    x1 <- "Add New Car"
  }

  if (fade_option1){
      y1 <- TRUE
  }  else{
      y1 <- FALSE
  }

  shiny::modalDialog(
      title=tile1,
    div(class = "text-center",
            div(style = "display: inline-block;",
      shiny::dateInput(inputId = "date_e2",label = h1("Event date"),min = '2015-07-01',
                           max= Sys.Date(), value = as.character(date_event1), format = "yyyy-mm-dd",width = "300px")),
             div(style = "display: inline-block;",
      shiny::actionButton(inputId = "valid_event2",label = "Select event date",
                           icon = shiny::icon("filter"), class = "btn-warning",width = "300px"))
            ),
    br(),
    div(class = "text-center",
            div(style = "display: inline-block;",
      shiny::selectInput(inputId = "date_b2", label = h1("Date before event"),
                         choices = before_date1, width = "300px")),
             div(style = "display: inline-block;",
      shiny::selectInput(inputId = "date_a2", label = h1("Date after event"),
                             choices = after_date1, width = "300px"))
            ),
    size = "l",
    easyClose = TRUE,
    fade = y1,
    footer = shiny::div(
        class = "pull-right container",
        shiny::actionButton(inputId = "final_edit2", label = x1,
                            icon = shiny::icon("edit"), class = "btn-info"),
        shiny::actionButton(inputId = "dismiss_modal2", label = "Close", class = "btn-danger")
    )
  ) %>% shiny::showModal()
}

#COLOR RAIN ACCUMULATION
 # Make vector of colors for the accumulation rain raster
rc1 <- colorRampPalette(colors = c("#595959", "#5a5865"), space = "Lab")(1)
rc2 <- colorRampPalette(colors = c("#5a5865", "#615884"), space = "Lab")(5)
rc3 <- colorRampPalette(colors = c("#615884", "#34758e"), space = "Lab")(10)
rc4 <- colorRampPalette(colors = c("#34758e", "#0b8c81"), space = "Lab")(30)
rc5 <- colorRampPalette(colors = c("#0b8c81", "#5c9964"), space = "Lab")(40)
rc6 <- colorRampPalette(colors = c("#5c9964", "#9f9d54"), space = "Lab")(80)
rc7 <- colorRampPalette(colors = c("#9f9d54", "#d39a78"), space = "Lab")(200)
rc8 <- colorRampPalette(colors = c( "#d39a78","#fa9dbe"), space = "Lab")(500)
rc9 <- colorRampPalette(colors = c("#fa9dbe","#dcdcdc"), space = "Lab")(800)
# Combine the color palettes
rampcols <- c(rc1, rc2,rc3,rc4,rc5,rc6,rc7,rc8,rc9)
# Create a sum color palette
pal <- colorNumeric(palette = rampcols, domain = c(0,800),na.color = rgb(0,0,0,0))

#COLOR RAIN HOURLY
# Make vector of colors for the accumulation rain raster
rch1 <- colorRampPalette(colors = c("#595959", "#5a5865"), space = "Lab")(1)
rch2 <- colorRampPalette(colors = c("#5a5865", "#615884"), space = "Lab")(5)
rch3 <- colorRampPalette(colors = c("#615884", "#34758e"), space = "Lab")(10)
rch4 <- colorRampPalette(colors = c("#34758e", "#0b8c81"), space = "Lab")(30)
rch5 <- colorRampPalette(colors = c("#0b8c81", "#5c9964"), space = "Lab")(40)
rch6 <- colorRampPalette(colors = c("#5c9964", "#9f9d54"), space = "Lab")(80)
rch7 <- colorRampPalette(colors = c("#9f9d54", "#d39a78"), space = "Lab")(200)
rch8 <- colorRampPalette(colors = c( "#d39a78","#fa9dbe"), space = "Lab")(500)
rch9 <- colorRampPalette(colors = c("#fa9dbe","#dcdcdc"), space = "Lab")(800)

# Combine the color palettes
rampcolsh <- c(rch1, rch2,rch3,rch4,rch5,rch6,rch7,rch8,rch9)
# Create a sum color palette
palh <- colorNumeric(palette = rampcolsh, domain = c(0,200),na.color = rgb(0,0,0,0))
