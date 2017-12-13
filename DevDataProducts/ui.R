#
# User-interface definition.
#

library(shiny)
library(plotly)

shinyUI(fluidPage(
  
  titlePanel("Coursera Developing Dataproducts Week 3 Assignment"),

  div(
    h3("Sky Distribution of Galaxies in the Atlas3D Survey"),
    
    h5("This data comes from the", a(href="http://www-astro.physics.ox.ac.uk/atlas3d/", 
      "Atlas3D survey", target="_blank"), "which included ~800 early- and late-type 
      galaxies."),
    
    h5("In the plot, the distribution of the galaxies in the sky can be seen. Sky 
       coordinates use right ascension and declination instead of longitude and 
       latitude."),
    
    h5("Galaxies can be classified according to their appearance or by parameters 
       such as the presence of a disk of stars, compactness of spiral arms, or 
       smoothness of the light distribution. In the Atlas3D survey, the galaxies 
       were classified into ellipticals and spirals by visual inspection. The color 
       of the markers in the plot shows the T-type, which is used to classify galaxies
       into elliptical (T <= -0.5, early-type) and spiral (T > -0.5, late-type)."),
    
    h5("With the slider you can select which galaxies to plot according to heliocentric 
       velocity relative to the", a(href="https://en.wikipedia.org/wiki/Barycenter", 
      "barycenter", target="_blank"), "of the Solar System. For example, to see the 
      center of the", a(href="https://en.wikipedia.org/wiki/Virgo_Cluster", "Virgo 
      cluster", target="_blank"), "set the minimum to -300 and the maximum to 200"),
    
    h5("Clicking on a marker shows the information for that galaxy below the plot.
       If the galaxy was observed by the", a(href="http://skyserver.sdss.org/dr14/en/home.aspx", 
      "Sloan Digital Sky Survey,", target="_blank"), "the URL will take you to its 
      Navigate section."),
    
    style = "border: solid #DCDCDC 1px; background: #f0f5f5; border-radius: 5px;"
  ),
  
  br(),
  
  # Sidebar with a slider input for minimum and maximum heliocentric velocity.
  sidebarLayout(
    sidebarPanel(
       sliderInput("vhel",
                   "Select galaxies by heliocentric velocity value (km/s).",
                   min = -300,#-5,
                   max = 3815,#10,
                   value = c(0, 3815), step=100),#c(-0.5, 10), step = 0.1),
       submitButton("Submit")
    ),
    
    # Show the plot
    mainPanel(
       div(
        plotlyOutput("distPlot"),
        style = "border: solid #DCDCDC 1px; border-radius: 5px;"
       ),
       
       br(),
       
       div(
         htmlOutput("click"),
         style = "border: solid #DCDCDC 1px; background: #f0f5f5; border-radius: 5px;"
       )
    )
  )
))
