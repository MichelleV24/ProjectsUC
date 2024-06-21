shinyServer(function(input, output, session) {
  onSessionEnded(function() {
    stopApp()
  })
  
  output$SummaryA1 <- renderPrint({
    skim(factory_data)
  })
  
  output$SummaryA2 <- renderPrint({
    str(as.data.frame(factory_data))
  })
  
  output$datatable <- DT::renderDataTable({
    DT::datatable(data = as.data.frame(factory_data))
  })
  
  output$Pairs <- renderPlot({
    GGally::ggpairs(data = pairs_data, title = "Pairs of data", 
                    columns = input$PairsVar, mapping = aes_string(colour=input$PairsColor))
  })
  
  output$Corrgram <- renderPlot({
    corrgram(factory_data[, input$CorrVar], 
             abs = input$abs,
             cor.method = input$CorrMeth,
             order = input$Group,
             main = paste("Correlation of Data using", input$CorrMeth, "correlation method"))
  })
  
  observeEvent(input$selected_vars, {
    updateCorrgram(outputId = "corrgramPlot", 
                   data = factory_data[, input$CorrVar],
                   abs = input$abs,
                   cor.method = input$CorrMeth,
                   order = input$Group,
                   main = paste("Correlation of Data using", input$CorrMeth, "correlation method"))
  }) 
  
  output$Mosaic <- renderPlot({
    formula <- as.formula(paste("~",paste(input$MosaicVar, collapse = " + ")))
    vcd::mosaic(formula, data = categoric_vars,
                main = paste("Mosaic plot of", input$MosaicVar), 
                shade = TRUE, 
                legend = TRUE)
  })
  
  output$Boxplot <- renderPlot({
    sub_text = paste(paste("Uni-variable BoxPlot showing IQR multiplier of", input$range))
    if (input$outliers) {
      sub_text <- paste(sub_text, "(outliers shown)")
    }
    else{
      sub_text <- paste(sub_text, "(outliers hidden)")
    }
    if (input$standardise) {
      sub_text <- paste(sub_text, "(scaled and centered)")
    }
    
    
    box_vars <- input$BoxVar
    box_data <- factory_data[, box_vars]
    if (input$standardise) {
      box_data <- scale(box_data, center = TRUE, scale = TRUE)
    }
    
    BP <- car::Boxplot(
      y = box_data,
      ylab = NULL,
      use.cols = TRUE,
      notch = FALSE,
      varwidth = FALSE,
      horizontal = FALSE,
      outline = input$outliers,
      col = brewer.pal(n = length(box_vars), name = "RdBu"),
      range = input$range,
      main = paste("BoxPlot of Data"),
      #sub = paste("Uni-variable boxplots at IQR multiplier of", input$range),
      id = ifelse(input$outliers, list(n = Inf, location = "avoid"), FALSE),
      las = 2
    )
    title(sub = sub_text, line = -20, cex.main=1, cex.sub=0.8)
    
    
    #BP + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
    # d1 <- getData()
    # cols <- sapply(d1, FUN = is.numeric)
    # d <-  d1[, cols]
    # d <- scale(d, center = input$BCentre, scale = input$BScale)if (input$Label && input$ShowOutliers) {
    #   car::Boxplot(y = d, las = 2, range = input$Range, outline = TRUE,
    #                id = list(labels = d1$ID, n=10, col = "red", location = "avoid"),
    #                main = "Boxplots of numeric variables with outliers shown")
    # } else {
    #   car::Boxplot(y = d, las = 2, range = input$Range, outline = input$ShowOutliers,
    #                id = list(n=0), main = "Boxplots of numeric variables (hidden outliers)")
    # }
    
  })
  
    
  output$tableplot <- renderPlot({
    selected_columns <- input$TabVar
    tab_data <- factory_data2[, selected_columns]

    tabplot::tableplot(tab_data,
                       sortCol = input$TabGroup,
                       decreasing = FALSE)

  })
  
  output$Matplot <- renderPlot({
      
    numData <- scale(numeric_vars, center = input$center, scale = input$scale)
    mypalette <- rainbow(ncol(numData))
    matplot(numData, 
            type = "l", 
            col = mypalette, 
            xlab = paste("Observations in sequence"),
            ylab = "Value",
            main = "Dataset Homogeneity") 
    if (input$legend){
      plot_legend <-legend(
                      legend = colnames(numData),
                      x = "topleft",
                      y = "top",
                      lty = 1,
                      lwd = 1,
                      col = mypalette,
                      ncol = round(ncol(numData)^0.43),
                      cex = 0.8)
      plot_legend
      }
    
  })
  
  output$Missing <- renderPlot({
    miss_chart <- vis_miss(factory_data[-4], cluster = input$cluster) +
      labs(title = "Missingness of data")
    # Rotate x-axis labels vertically
    miss_chart + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))+
      scale_fill_manual(values = c("#83AF9B", "#C8C8A9"))
  })
  
  output$Rising <- renderPlot({
    selected_sensors <- input$selected_sensor
    d <- factory_data[, selected_sensors]
    
    for (col in 1:ncol(d)) {
      d[, col] <- d[order(d[, col]), col]  # sort each column in ascending order
    }
    
    mypalette <- rainbow(ncol(d))
    matplot(
      x = seq(1, 100, length.out = nrow(d)),
      y = d,
      type = "l",
      xlab = "Percentile",
      ylab = "Values",
      lty = 1,
      lwd = 1,
      col = mypalette,
      main = "Rising Value Chart"
    )
    legend(
      legend = colnames(d),
      x = "topleft",
      y = "top",
      lty = 1,
      lwd = 1,
      col = mypalette,
      cex = 0.8,
      ncol = round(ncol(d)^0.3)
    )
  })
 
})