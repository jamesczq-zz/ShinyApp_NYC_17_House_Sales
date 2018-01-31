function(input, output, session) {
  
  # Map rendering -----------------------------------------------------------------------------
  # Initializzation
  output$myMap = renderLeaflet({ leaflet() %>%
                                 addTiles() %>%
                                 setView(lng = -73.9969, lat = 40.7061, zoom = 12)
                                 # This is the location of Brooklyn bridge.
                                })
  
  
  # Reactively receive instructions from UI
  mapData = reactive({ 
    nyc2017 %>% filter(., Borough == input$mapBoro,
                          Month_Name == input$mapMonth) %>%
                group_by(., Zipcode) %>%
                summarise(., Long = Long[1],
                             Lat = Lat[1],
                          ## Critical data transform: 
                          ## Without normalizing Volume, pattern (heat intensity) is not clear at all!
                          ## Try a simplistic summarizing data:
                          #Volume = n())
                          ## Critical: to make pattern sharper, do Boro-wise Volume normalization
                          ## (This is the only part I feel particularly pround of in this project.)
                             Volume = ( n() - filter(volume_stats_by_month, 
                                                     Borough == input$mapBoro &
                                                     Month_Name == input$mapMonth)$Avg_Volume ) / 
                                      filter(volume_stats_by_month, 
                                             Borough == input$mapBoro &
                                             Month_Name == input$mapMonth)$Std_Volume)
                      })
  
  # Reactively update map with from received UI instruction 
  observe({
    if (input$showHeatMap) {
      leafletProxy( 'myMap',
                    data = mapData() ) %>% 
        clearWebGLHeatmap() %>%
        addProviderTiles( providers$CartoDB.DarkMatter ) %>%
                 # Other "providers" option avaiable
        addWebGLHeatmap( lng = ~Long, 
                         lat = ~Lat, 
                         intensity = ~Volume, 
                         size = 2000, units = 'm', opacity = 0.5 )
                         # Set the size to be about the avg. neighborhood radius in NYC
      } else {
      leafletProxy( 'myMap', 
                    data = mapData() ) %>% 
        clearWebGLHeatmap() %>%
        addProviderTiles( providers$OpenStreetMap.DE )
                 # Other "providers" option avaiable
    }
  })
  
  
  # Tab 2 (Time Pattern) Plot Rendering ---------------------------------------------------------
  output$wrt_Time = renderPlot({
    
    ggplot( data = nyc2017_Vol, aes(x = Month, y = Volume, color = Borough) ) + 
    # Note that we loaded the data "nyc2017_Vol" in global.R. 
    # Otherwise (without loading the already computed data), have to do App. run-time computation.
      geom_line() + 
      labs( title = 'House Sale Volumes per Month (2017)',
            x = 'Month', 
            y = 'Volume' ) + 
      coord_cartesian( xlim = c(1,12) ) + 
      scale_x_continuous( breaks = 1:12, 
                          labels = months ) +
                                # "months" is a vector of the 12 month names; generated in global.R 
      scale_color_brewer( palette='Set1' ) +
      theme_bw() +
      theme( legend.key = element_blank() )
    
  }) 
  
  # output$FFT_Volumes = Plot({
  #   
  #   tags$img(src = "FFT_Volumes.pdf", height = 640, width = 200)
  #   
  # }) 
  
  
  # Tab 3 (Spatial Pattern) Plot Rendering ---------------------------------------------------------
  output$wrt_Boro = renderPlot({
    
    ggplot( data = nyc2017_z, aes(x = zPrice) ) + 
    # Note that we loaded the data "nyc2017_z" in global.R. 
    # Otherwise (without loading the already computed data), have to do App. run-time computation.
      geom_density( color = 'blue' ) + 
      facet_grid( . ~ Borough ) + 
      labs( title = 'Distributions of Normalized House Price by Borough (2017)', 
            x = 'Normalized Price', 
            y = 'Density') +
      scale_color_brewer( palette='Set1' ) +
      theme_bw() +
      theme( legend.key=element_blank() )
  }) 

}