### plot 3: plot all temperatures, one plot
RPlot3 <- function (data, Seq=NA, panl=1, ...) { 
  # This only finds 'renderPlot' for a call from the 'display' in shiny.
  # For a call from savePDF this will be FALSE.
  shinyDisplay <- any(grepl('renderPlot', sys.calls()))
  
  panel11 <- function (data) {
    ylb <- expression (paste ("temperature  ATy  [", degree, "C]"))
    plotWAC (data[, c("Time", VRPlot[[3]])],
      ylab=ylb, lty=c(1,1,1,2), lwd=c(2,1.5,1,2,1),
      legend.position='bottomleft', 
      ylim=YLMF (1, range (as.matrix (data[, VRPlot[[3]]]), finite=TRUE)))
    # Report T differences in plot title
    # Configuration.R convention is that the first in VRPlot[[3]] is the reference.
    labl <- VRPlot[[3]]
    labl <- sub("AT", "", labl)
    titl <- "Mean diff. in AT: "
    for (i in 2:length(labl)) {
      titl <- sprintf("%s%s-%s: %.2f; ", titl, labl[i],labl[1],
        mean(data[, VRPlot[[3]][i]] -
            data[, VRPlot[[3]][1]], na.rm=TRUE))
    }
    title(titl, cex.main = cexmain)   
  }
  
  panel12 <- function (data) {
    # Plot the differences:
    labl <- VRPlot[[3]]
    DF <- data[, c('Time', labl[-1])]
    DF <- DF - data[, labl[1]]
    plotWAC(DF, ylab=expression(paste (Delta,' [', degree, ']')), ylim = YLMF (2, c(-2, 2)))
    hline (-0.3, col = 'darkorange'); hline (0.3, col = 'darkorange')
    title (sprintf ('differences vs %s', labl[1]), cex.main = cexmain)
  }
  
  #####################################################
  if (shinyDisplay) {
    switch(panl,
      {
        setMargins (2)
        panel11 (data)
      },
      {
        setMargins (3)
        panel12 (data)
        AddFooter ()
      }
    )
    
    #####################################################
  } else {
    layout(matrix(1:2, ncol = 1), widths = c(5,5.5))
    setMargins (4)
    panel11 (data)
    setMargins (5)
    panel12 (data)
    AddFooter ()
  }
}

