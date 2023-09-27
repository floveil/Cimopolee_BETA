output$map<- renderLeaflet({
        map
        })

# Create Proxy for update the leaflet map
proxy <- leafletProxy("map")


observeEvent(input$map_shape_click,{
    event <- req(input$map_shape_click)
    #proxy %>%  removeShape(layerId = paste(values$district_selected,"1") )

    values$district_selected <- event$id

    district_clicked <- mada_admin[mada_admin$ADM2_EN == values$district_selected,]

    proxy%>%clearGroup("select")
    proxy %>% addPolygons(data = district_clicked,
                          fillColor = "#164B60",
                          fillOpacity = 0.25,
                          color = "black",
                          weight = 2,
                          stroke = T,
                          group= "select" )

    message <- HTML(paste("District Séléctionné: ",  values$district_selected,"<br>"))
    output$province <- renderText(message)

    density_selected <- df_density_district[df_density_district$ADM2_EN == values$district_selected,]
    mean_density_district <- density_selected$X_mean
    df_density_district <- df_density_district[df_density_district$ADM2_EN != density_selected$ADM2_EN, ]


    time_series_selected <- time_serie_disctict[time_serie_disctict$ADM2_EN==values$district_selected ,]
    time_series_selected["month"] <- substr(time_series_selected$time3, 1, 2)
    time_series_selected["year"] <- substr(time_series_selected$time2, 1, 4)

    seq = as.list(unique(time_series_selected["year"]))$year
    palette <- colorRampPalette(colors=c("#F8F6F4", "#2E4F4F"))
    cols <- palette(length(seq))

    mean_ts <- aggregate(time_series_selected["mean"], list(time_series_selected$month), FUN=mean)



    output$plot_pluie <- renderPlotly({
        plot_ly()%>%
            add_trace(data = time_series_selected ,x = time_series_selected$time2, y = time_series_selected$mean, type = 'scatter',  mode = 'lines',visible =TRUE,line=list(color="#164B60"))%>%
            add_trace(data = time_series_selected ,x = time_series_selected$month, y = time_series_selected$mean, type = 'scatter', mode = 'lines',visible=FALSE, name =" ",
                      transforms= list(list(type="groupby",groups = time_series_selected$year,
                                            styles = list(
                      list(target = seq[1], value = list(line =list(color = cols[1]))),
                      list(target = seq[2], value = list(line =list(color = cols[2]))),
                      list(target = seq[3], value = list(line =list(color = cols[3]))),
                      list(target = seq[4], value = list(line =list(color = cols[4]))),
                      list(target = seq[5], value = list(line =list(color = cols[5]))),
                      list(target = seq[6], value = list(line =list(color = cols[6]))),
                      list(target = seq[7], value = list(line =list(color = cols[7]))),
                      list(target = seq[8], value = list(line =list(color = cols[8]))),
                      list(target = seq[9], value = list(line =list(color = cols[9]))),
                      list(target = seq[10], value = list(line =list(color = cols[10]))),
                      list(target = seq[11], value = list(line =list(color = cols[11]))),
                      list(target = seq[12], value = list(line =list(color = cols[12]))),
                      list(target = seq[13], value = list(line =list(color = cols[13]))),
                      list(target = seq[14], value = list(line =list(color = cols[14]))),
                      list(target = seq[15], value = list(line =list(color = cols[15]))),
                      list(target = seq[16], value = list(line =list(color = cols[16]))),
                      list(target = seq[17], value = list(line =list(color = cols[17]))),
                      list(target = seq[18], value = list(line =list(color = cols[18]))),
                      list(target = seq[19], value = list(line =list(color = cols[19]))),
                      list(target = seq[20], value = list(line =list(color = cols[20]))),
                      list(target = seq[21], value = list(line =list(color = cols[21]))),
                      list(target = seq[22], value = list(line =list(color = cols[22]))),
                      list(target = seq[23], value = list(line =list(color = cols[23]))),
                      list(target = seq[24], value = list(line =list(color = cols[24]))),
                      list(target = seq[25], value = list(line =list(color = cols[25]))),
                      list(target = seq[26], value = list(line =list(color = cols[26]))),
                      list(target = seq[27], value = list(line =list(color = cols[27]))),
                      list(target = seq[28], value = list(line =list(color = cols[28]))),
                      list(target = seq[29], value = list(line =list(color = cols[29]))),
                      list(target = seq[30], value = list(line =list(color = cols[30]))),
                      list(target = seq[31], value = list(line =list(color = cols[31]))),
                      list(target = seq[32], value = list(line =list(color = cols[32]))),
                      list(target = seq[33], value = list(line =list(color = cols[33]))),
                      list(target = seq[34], value = list(line =list(color = cols[34]))),
                      list(target = seq[35], value = list(line =list(color = cols[35]))),
                      list(target = seq[36], value = list(line =list(color = cols[36]))),
                      list(target = seq[37], value = list(line =list(color = cols[37]))),
                      list(target = seq[38], value = list(line =list(color = cols[38]))),
                      list(target = seq[39], value = list(line =list(color = cols[39]))),
                      list(target = seq[40], value = list(line =list(color = cols[40]))),
                      list(target = seq[41], value = list(line =list(color = cols[41]))),
                      list(target = seq[42], value = list(line =list(color = cols[42])))
                    )) )
            )%>%
            add_trace(data = time_series_selected ,x = time_series_selected$month, y = time_series_selected$mean, type = 'scatter', mode = 'lines',visible =FALSE,line=list(color="red"),name="Moyenne",
                      transforms= list(list(type="aggregate",groups = time_series_selected$month,
                                            aggregations = list(list(target = 'y', func = 'avg', enabled = T)))
      ))%>%
            layout(showlegend=FALSE,
                   xaxis = list(tickvals= list("1980-01-01","1985-01-01","1990-01-01","1995-01-01","2000-01-01","2005-01-01","2010-01-01","2015-01-01","2020-01-01"),
                                ticktext  = list("1980","1985","1990","1995","2000","2005","2010","2015","2020"),
                                rangeslider = list(visible = T,tickformatstops = list(
                                    list(dtickrange=list(NULL, 1000), value="%H:%M:%S.%L ms"),
                                    list(dtickrange=list(1000, 60000), value="%H:%M:%S s"),
                                    list(dtickrange=list(60000, 3600000), value="%H:%M m"),
                                    list(dtickrange=list(3600000, 86400000), value="%H:%M h"),
                                    list(dtickrange=list(86400000, 604800000), value="%e. %b d"),
                                    list(dtickrange=list(604800000, "M1"), value="%e. %b w"),
                                    list(dtickrange=list("M1", "M12"), value="%b '%y M"),
                                    list(dtickrange=list("M12", NULL), value="%Y Y")
                                ))),
                   updatemenus = list(
                       list(type="buttons",
                            direction = "right",
                            xanchor="center",
                            yanchor = "top",
                            x= 0.1,
                            y = 1.27,
                            buttons = list(list(method = "update",
                                                args = list(list(visible= list(T,F,F),
                                                                 x=list(time_series_selected$time2)),
                                                            list(xaxis=list(tickvals= list("1980-01-01","1985-01-01","1990-01-01","1995-01-01","2000-01-01","2005-01-01","2010-01-01","2015-01-01","2020-01-01"),
                                                                            ticktext  = list("1980","1985","1990","1995","2000","2005","2010","2015","2020"),
                                                                            rangeslider = list(visible = T)),
                                                                showlegend = FALSE)
                                                ),
                                                label = "Annuel"),
                                          list(method = "update",
                                               args = list(list(visible= list(F,T,T),
                                                                x=list(time_series_selected$month)),
                                                           list(xaxis=list(showgrid = F,
                                                                           tickvals= list(1,2,3,4,5,6,7,8,9,10,11,11.9),
                                                                           ticktext  = list("Jan","Fév","Mar","Avr","Mai","Jui","Jui","Aou","Sep","Oct","Nov","Déc")),
                                                                showlegend = TRUE,
                                                                legend = list(orientation = 'h'))
                                               ),
                                               label = "Mensuel"))),
                       list(type="buttons",
                            direction = "right",
                            xanchor="center",
                            yanchor = "top",
                            x= 0.4,
                            y = 1.27,
                            buttons = list(list(method = "restyle", args = list("y", list(time_series_selected$mean)), label = "Moyenne"),
                                           list(method = "restyle", args = list("y", list(time_series_selected$min)), label = "Mininmum"),
                                           list(method = "restyle", args = list("y", list(time_series_selected$max)), label = "Maximum")))
                   ))
    })

    message_density <- HTML(paste("Densité de population pour le district de ",  values$district_selected,"<br>", round(mean_density_district,1), " habitants/km2" ))
    output$density <- renderText(message_density)


    output$density_plot <- renderPlotly({
        plot_ly()%>%
            add_trace(data =df_density_district ,x = df_density_district$ADM2_EN, y = df_density_district$X_mean, type = 'bar',  mode = 'lines',visible =TRUE)%>%
            add_trace(data =density_selected ,x = density_selected$ADM2_EN, y = density_selected$X_mean, type = 'bar',  mode = 'lines',visible =TRUE)%>%
            layout(yaxis = list(type = "log"),
                   xaxis = list(categoryorder = "total ascending"))

    })

})

observeEvent(input$no_cyclone,{
     ask_confirmation(
      inputId = "myconfirmation1",
      type = "warning",
      title = "Absence de cyclone actuellement",
      btn_labels = c("Aller quand meme sur l'onglet", "Aller sur l'onglet des cyclones historiques")
    )
})

observeEvent(input$myconfirmation1,{
     if (input$myconfirmation1==TRUE){
         updateNavbarPage(session, "cimopolee",selected = "test")

     }
})
