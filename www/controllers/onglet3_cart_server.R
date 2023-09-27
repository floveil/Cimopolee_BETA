observeEvent(input$validation,{

    output$cart_s2 <- renderUI(
        DT::renderDT(
        datatable(shiny::isolate(values$df),
                  class = 'cell-border stripe',
                  escape = F,
                  rownames = FALSE,
                  extensions = 'Scroller',
                  options = list(processing = FALSE,
                                 dom = 't',
                                 deferRender = TRUE,
                                 scrollY = 300,
                                 scroller = TRUE,
                                 autoWidth = TRUE,
                                 columnDefs = list(list(width = '100px', targets = c(0,1,6)),
                                                   list(className = 'dt-center', targets = "_all"),
                                                   list(className = "align-middle", targets = "_all"),
                                                   list(visible=FALSE, targets=c(3,5,6))),
                                 initComplete = JS("function(settings, json) {",
                                                   "$(this.api().table().header()).css({'font-size': '85%'});",
                                                   "}"))
        ) %>%
            formatStyle(columns = c(0,1,2,4),fontSize = '85%')%>%
            formatStyle(columns ='Tile',
                        fontWeight = 'bold')%>%
            formatStyle(columns ='Event Date',
                        backgroundColor ='rgba(47, 79, 79, 0.4)',
                        fontWeight = 'bold')%>%
            formatStyle(columns ='Before Date',
                        valueColumns = 4,
                        fontSize = '85%',
                        fontWeight = 'bold',
                        backgroundColor = styleInterval(c(20,40,60,80), c("#73a942","#aad576","#f3c053","#f9a03f","#eb5e28")) )%>%
            formatStyle(columns ='After Date',
                        valueColumns = 6,
                        fontWeight = 'bold',
                        fontSize = '85%',
                        backgroundColor = styleInterval(c(20,40,60,80), c("#73a942","#aad576","#f3c053","#f9a03f","#eb5e28")) )
    ))

    output$select_s2 <- renderUI({
         HTML(paste(icon('fas fa-check-circle'),"<b>",input$change_choice,"</b>","<br>")) })


        output$osm_s2 <- renderUI({
         HTML(paste(icon('fas fa-check-circle'),"<b>",input$osm_choice,"</b>","<br>")) })
})


observeEvent(input$validation2,{

    output$cart_s <- renderUI(
        DT::renderDT(
        datatable(shiny::isolate(values$df1),
                  class = 'cell-border stripe',
                  escape = F,
                  rownames = FALSE,
                  extensions = 'Scroller',
                  options = list(processing = FALSE,
                                 dom = 't',
                                 deferRender = TRUE,
                                 scrollY = 300,
                                 scroller = TRUE,
                                 autoWidth = TRUE,
                                 columnDefs = list(list(width = '100px', targets = c(0,1,6)),
                                                   list(className = 'dt-center', targets = "_all"),
                                                   list(className = "align-middle", targets = "_all"),
                                                   list(visible=FALSE, targets=c(3,5,6))),
                                 initComplete = JS("function(settings, json) {",
                                                   "$(this.api().table().header()).css({'font-size': '85%'});",
                                                   "}"))
        ) %>%
            formatStyle(columns = c(0,1,2,4),fontSize = '85%')%>%
            formatStyle(columns ='Tile',
                        fontWeight = 'bold')%>%
            formatStyle(columns ='Event Date',
                        backgroundColor ='rgba(47, 79, 79, 0.4)',
                        fontWeight = 'bold')%>%
            formatStyle(columns ='Before Date',
                        valueColumns = 4,
                        fontSize = '85%',
                        fontWeight = 'bold',
                        backgroundColor = styleInterval(c(20,40,60,80), c("#73a942","#aad576","#f3c053","#f9a03f","#eb5e28")) )%>%
            formatStyle(columns ='After Date',
                        valueColumns = 6,
                        fontWeight = 'bold',
                        fontSize = '85%',
                        backgroundColor = styleInterval(c(20,40,60,80), c("#73a942","#aad576","#f3c053","#f9a03f","#eb5e28")) )
    ))

    output$select_s <- renderUI({
         HTML(paste(icon('fas fa-check-circle'),"<b>",input$change_choice2,"</b>","<br>")) })

    output$osm_s <- renderUI({
         HTML(paste(icon('fas fa-check-circle'),"<b>",input$osm_choice2,"</b>","<br>")) })

})

