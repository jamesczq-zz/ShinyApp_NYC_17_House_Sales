navbarPage('NYC House Sales (2017, NYC Gov Data). James Chen', theme = shinytheme("cerulean"),

# Map View --------------------------------------------------------
tabPanel('Map',
         div( class='outer', 
              tags$head(includeCSS('styles.css')),
              leafletOutput('myMap', width = '100%', height = '100%')
            ),
         
         # Control Panel -----------------------------------------------------------------------------------
         # This will generate an interactive map as
         # Tab 1 or Tab "Map"
         #
                       # Control Panel Options: 
         absolutePanel(id = 'controls', class = 'panel panel-default', 
                       fixed = TRUE, draggable = TRUE, 
                       top = 50, left = 50, right = 'auto', bottom = 'auto', width = 320,  height = 'auto',
                       #
                       # Control Panel (Upper Part):
                       h4('Selection'), 
                       fluidRow( column(6, selectInput(inputId = 'mapMonth',
                                                       label = h4('Month'),
                                                       choices = months,
                                                       selected = 'Mar')),
                                 column(6, selectInput(inputId = 'mapBoro',
                                                       label = h4('Borough'),
                                                       choices = boros,
                                                       selected = 'Brooklyn'))
                                 ),
                       # 
                       # Control Panel (Lower Part):
                       h4('Heat Map (Intensity = Transaction Volume Normalized Boro-Wide)'),
                       fluidRow( column(6, checkboxInput('showHeatMap', 
                                                         label = h4('Show'), 
                                                         value = TRUE))
                                 )
                       )

           ),

           # Tab 2 (next to Tab "Map") of Main Body ---------------------------------------------------
           tabPanel( 'Time Pattern (wrt. Month)',
                     wellPanel( fluidRow( column(6, imageOutput('wrt_Time')),
                                          column(6, img(src = 'FFT_Vol.jpg',
                                                        width="100%", height="500px"))  )
                    )),
           
           # Tab 3 (next to Tab 2) of Main Body ---------------------------------------------------
           tabPanel( 'Spatial Pattern (wrt. Borough)', 
                     wellPanel( fluidRow( column(6, imageOutput('wrt_Boro')),
                                          column(6, img(src = 'Planck_Price.jpg',
                                                        width="100%", height="500px"))) )
                     )
# End
)