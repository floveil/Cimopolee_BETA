observeEvent(input$help_historical,{
    updateTabsetPanel(session, "cimopolee",
                          selected = "Historical cyclones")
})

observeEvent(input$help_detection,{
    updateTabsetPanel(session, "cimopolee",
                          selected = "Change detection")
})

observeEvent(input$help_impact,{
    updateTabsetPanel(session, "cimopolee",
                          selected = "Flood impacts")
})
