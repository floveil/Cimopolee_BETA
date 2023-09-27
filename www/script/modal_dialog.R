modal_dialog <- function(tile, date_event, before_date, after_date, edit, fade_option) {
  if (edit) {
    x <- "Submit Edits"
  } else {
    x <- "Add New Car"
  }

  if (fade_option){
      y = TRUE
  }  else{
      y = FALSE
  }


  shiny::modalDialog(
    title = "Edit Car",
    div(
      class = "text-center",
      div(
        style = "display: inline-block;",
        shiny::textInput(
          inputId = "tile_id",
          label = "Tile",
          value = tile,
          width = "200px"
        )
      ),
      div(
        style = "display: inline-block;",
        shiny::dateInput(
          inputId = "date_e",
          label = "Event date",
          min = '2015-07-01',
          max= Sys.Date(),
          value = as.character(date_event),
          format = "yyyy-mm-dd",
          width="200px"
        ),
      shiny::actionButton(
        inputId = "valid_event",
        label = "Select event date",
        icon = shiny::icon("filter"),
        class = "btn-warning"
      ))
      ,
      div(
        style = "display: inline-block;",
        shiny::selectInput(
          inputId = "date_b",
          label = "Date before event",
          choices = before_date,
          width = "200px"
        )
      ),
      div(
        style = "display: inline-block;",
        shiny::selectInput(
          inputId = "date_a",
          label = "Date after event",
          choices = after_date,
          width = "200px"
        )
      )
    ),
    size = "m",
    easyClose = TRUE,
    fade = y,
    footer = div(
      class = "pull-right container",
      shiny::actionButton(
        inputId = "final_edit",
        label = x,
        icon = shiny::icon("edit"),
        class = "btn-info"
      ),
      shiny::actionButton(
        inputId = "dismiss_modal",
        label = "Close",
        class = "btn-danger"
      )
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
      y1 = TRUE
  }  else{
      y1 = FALSE
  }


  shiny::modalDialog(
    title = "Edit Car2",
    div(
      class = "text-center",
      div(
        style = "display: inline-block;",
        shiny::textInput(
          inputId = "tile_id1",
          label = "Tile",
          value = tile1,
          width = "200px"
        )
      ),
      div(
        style = "display: inline-block;",
        shiny::dateInput(
          inputId = "date_e1",
          label = "Event date",
          min = '2015-07-01',
          max= Sys.Date(),
          value = as.character(date_event1),
          format = "yyyy-mm-dd",
          width="200px"
        ),
      shiny::actionButton(
        inputId = "valid_event1",
        label = "Select event date",
        icon = shiny::icon("filter"),
        class = "btn-warning"
      ))
      ,
      div(
        style = "display: inline-block;",
        shiny::selectInput(
          inputId = "date_b1",
          label = "Date before event",
          choices = before_date1,
          width = "200px"
        )
      ),
      div(
        style = "display: inline-block;",
        shiny::selectInput(
          inputId = "date_a1",
          label = "Date after event",
          choices = after_date1,
          width = "200px"
        )
      )
    ),
    size = "m",
    easyClose = TRUE,
    fade = y1,
    footer = div(
      class = "pull-right container",
      shiny::actionButton(
        inputId = "final_edit1",
        label = x1,
        icon = shiny::icon("edit"),
        class = "btn-info"
      ),
      shiny::actionButton(
        inputId = "dismiss_modal1",
        label = "Close",
        class = "btn-danger"
      )
    )
  ) %>% shiny::showModal()
}
