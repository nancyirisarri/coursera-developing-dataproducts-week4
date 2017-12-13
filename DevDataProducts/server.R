#
# Server logic.
#

library(shiny)
library(plotly)

shinyServer(function(input, output) {
  
  # Read the data, format it and keep in a data.frame.
  dataFrame <- data.frame()
  table3 <- readLines("Table3.txt")
  table4 <- readLines("Table4.txt")
  for (i in seq(2, length(table3))) {
    dataFrame <- rbind(dataFrame, strsplit(gsub("\\s+", "\t", table3[i]), "\t")[[1]])
    
    for (j in seq(1, ncol(dataFrame))) {
      dataFrame[,j] <- as.character(dataFrame[,j])
    }
  }
  
  colnames(dataFrame) <- c("Galaxy", "RA", "DEC", "SBF", "NEDD", "Virgo", "VHel", 
                           "D", "M_K", "A_B", "ttype", "logRe")
  
  for (i in seq(2, length(table4))) {
    dataFrame <- rbind(dataFrame, strsplit(gsub("\\s+", "\t", table4[i]), "\t")[[1]])
    
    for (j in seq(1, ncol(dataFrame))) {
      dataFrame[,j] <- as.character(dataFrame[,j])
    }
  }
  
  # Convert to numeric the columns that will be plotted.
  dataFrame$RA <- as.numeric(dataFrame$RA)
  dataFrame$DEC <- as.numeric(dataFrame$DEC)
  dataFrame$ttype <- as.numeric(dataFrame$ttype)
  dataFrame$VHel <- as.numeric(dataFrame$VHel)
  
  output$distPlot <- renderPlotly({
    
    # Generate min and max heliocentric velocity based on input from ui.R
    minVhel = input$vhel[1]
    maxVhel = input$vhel[2]
    
    # Get the subset to plot.
    dataFrame = filter(dataFrame, VHel >= minVhel & VHel <= maxVhel)
    
    # Build the axes labels.
    f <- list(family = "Courier New, monospace", size = 18, color = "#7f7f7f")
    x <- list(title = "Right Ascension [degrees]", titlefont = f)
    y <- list(title = "Declination [degrees]", titlefont = f)
    
    plot_ly(dataFrame, x=~RA, y=~DEC, color=~ttype, alpha=0.5, type = "scatter",
            mode="markers", marker=list(color=~ttype, colorbar=list(title='T-type'))
    ) %>% layout(xaxis = x, yaxis = y)
  })
  
  # React to mouse clicks on plot markers.
  output$click <- renderUI({
    d <- event_data("plotly_click")
    if (is.null(d)) {
      "Click on a point to see the galaxy's information."
    } else {
      ra <- d$x
      dec <- d$y
      
      # Extract the row from the data.frame.
      row <- dataFrame[dataFrame$RA == ra & dataFrame$DEC == dec, ]
      row <- paste("Name: ", row$Galaxy, ", RA: ", row$RA, ", DEC: ", row$DEC, 
                   ", SBF: ", row$SBF, ", NED-D: ", row$NEDD, ", Virgo: ", row$Virgo, 
                   ", VHel: ", row$VHel, ", D: ", row$D, ", MK: ", row$M_K, 
                   ", AB: ", row$A_B, ", T-type:", row$ttype, ", log(Re): ", 
                   row$logRe, sep="")
      
      # Build a URL to access the galaxy in the Sloan Digital Sky Server.
      url <- paste("<a href=\"http://skyserver.sdss.org/dr14/en/tools/chart/navi.aspx?ra=", 
                   ra, "&dec=", dec, "\" target=\"_blank\">", 
                   "See picture and info in the Sloan Digital Sky Survey (if available).", 
                   "</a>", sep="")
      
      HTML(paste(row, url, sep="<br/> "))
    }
  })
  
})
