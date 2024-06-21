pMiss <- function(x) {
  sum(is.na(x)) / length(x) * 100}

shinyServer(function(input, output, session) {
  onSessionEnded(function() {
    stopApp()})
  
  output$SummaryA1 <- renderPrint({
    skim(covid_dat)
  })
  
  output$SummaryA2 <- renderPrint({
    str(as.data.frame(covid_dat))
  })
  
  output$tableplot <- renderPlot({
    selected_columns <- input$TabVar
    tab_data <- covid_dat[, selected_columns]
    
    tabplot::tableplot(tab_data,
                       sortCol = input$TabGroup,
                       decreasing = FALSE)
    
  })
  output$Missing <- renderPlot({
    miss_chart <- vis_miss(covid_dat, cluster = input$cluster) +
      labs(title = "Missingness of data")
    miss_chart + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))+
      scale_fill_manual(values = c("#83AF9B","#C8C8A9"), labels = "Not NA", "Missingness:", "NA")
  })
  
  output$Rising <- renderPlot({
    selected_sensors <- input$selected_sensor
    d <- covid_dat[, selected_sensors]
    
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
  
  output$Pairs <- renderPlot({
    GGally::ggpairs(data = pairs_data, title = "Pairs of data", 
                    columns = input$PairsVar, mapping = aes_string(colour=input$PairsColor))
  })
  
  output$Corrgram <- renderPlot({
    corrgram(covid_dat[, input$CorrVar], 
             abs = input$abs,
             cor.method = input$CorrMeth,
             order = input$Group,
             main = paste("Correlation of Data using", input$CorrMeth, "correlation method"))
  })
  
  observeEvent(input$selected_vars, {
    updateCorrgram(outputId = "corrgramPlot", 
                   data = covid_dat[, input$CorrVar],
                   abs = input$abs,
                   cor.method = input$CorrMeth,
                   order = input$Group,
                   main = paste("Correlation of Data using", input$CorrMeth, "correlation method"))
  }) 
  
  output$Mosaic <- renderPlot({
    formula <- as.formula(paste("~",paste(input$MosaicVar, collapse = " + ")))
    vcd::mosaic(formula, data = categorical_vars,
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
    box_data <- covid_dat[, box_vars]
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
      main = paste("Boxplot of COVID-19 Data"),
      #sub = paste("Uni-variable boxplots at IQR multiplier of", input$range),
      id = ifelse(input$outliers, list(n = Inf, location = "avoid"), FALSE),
      las = 2
    )
    title(sub = sub_text, line = -20, cex.main=1, cex.sub=0.8)
    
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
  
  output$datatable <- DT::renderDataTable({
    DT::datatable(data = as.data.frame(covid_dat))
  })
  
  #### processing
  
  getCleanData1 <- reactive({
    # remove excessively missing Vars
    data <- covid_dat
    vRatio <- apply(X = data, MARGIN = 2, FUN = pMiss)
    data[, vRatio < input$VarThreshold]
  })  
  
  getCleanData2 <- reactive({
    # remove excessively missing Obs
    data <- getCleanData1()
    oRatio <- apply(X = data, MARGIN = 1, FUN = pMiss)
    data[oRatio < input$ObsThreshold, ]
  })  
  
  modified_missing_data <- reactive({
    data <- getCleanData2()
    if (input$show_shadow_vars) {
      data <- covid_dat_shadow
    }
    
    if (input$impute_pols) {
      levels(data$POLITICS) <- c(levels(data$POLITICS), "NONE")
      data$POLITICS[is.na(data$POLITICS)] <- "NONE"
    }
    
    if (input$impute_Hcost) {
      data$HEALTHCARE_COST <- ifelse(data$HEALTHCARE_BASIS == "FREE",
                                     0,
                                     data$HEALTHCARE_COST)
    }
    return(data)
  })
  
  
  output$Missing_processed <- renderPlot({
    visdat::vis_dat(modified_missing_data()) +
      labs(title = paste("Thresholds Variables Missing:", input$VarThreshold, "Observations Missing:", input$ObsThreshold))
  })

  
  #patterns in missingness 
  
  output$tree_plot <- renderPlot({
    
    covid_dat <- covid_dat[order(covid_dat$CODE),]
    covid_dat$CODE <- 1:nrow(covid_dat)
    
    covid_dat$MISSINGNESS <- apply(X = is.na(covid_dat), MARGIN = 1, FUN = sum)
    
    tree <- train(MISSINGNESS ~ . -CODE -OBS_TYPE, data = covid_dat, method = "rpart", na.action = na.rpart)
    rpart.plot(tree$finalModel, main = "RPART: Predicting the number of missing variables in an observation",
               roundint = TRUE, clip.facs = TRUE)
  })
  
  # Modified data table
  modified_data <- reactive({
    data <- covid_dat
    if (input$show_shadow_vars) {
      data <- covid_dat_shadow
    }
    
    if (input$impute_pols) {
      levels(data$POLITICS) <- c(levels(data$POLITICS), "NONE")
      data$POLITICS[is.na(data$POLITICS)] <- "NONE"
    }
    
    if (input$impute_Hcost) {
      data$HEALTHCARE_COST <- ifelse(data$HEALTHCARE_BASIS == "FREE",
                                                 0,
                                                 data$HEALTHCARE_COST)
    }
    return(data)
  })
  # Render the modified datatable
  output$mod_datatable <- DT::renderDataTable({
    DT::datatable(data = as.data.frame(modified_data()))
  })
  
  
  ########## glmnet
  
  modified_missing_train_data <- reactive({   
    d <- modified_missing_data()
    d[d$OBS_TYPE == "Train",]
  })

  getRecipe <- reactive({
    rec <- recipe(DEATH_RATE ~ .,modified_missing_train_data()) %>%
      update_role("CODE", new_role = "id") %>%
      update_role("OBS_TYPE", new_role = "split")
    rec <- step_indicate_na(rec, all_predictors())
    rec <- step_zv(rec, all_predictors())
    rec <- step_dummy(rec, all_nominal_predictors())
    
    if (input$ImpMethod == "KNN") {
      rec <- step_impute_knn(rec, all_predictors(), neighbors = 5)
    } else if (input$ImpMethod == "Average") {
      rec <- step_impute_median(rec, all_numeric_predictors())
      rec <- step_impute_mode(rec, all_nominal_predictors())
    } else if (input$ImpMethod == "Bag Impute") {
      rec <- step_impute_bag(rec, all_predictors()) 
    } else if (input$ImpMethod == "Partial Del") {
      rec <- step_naomit(rec, all_predictors(), skip = TRUE)
    }
    
    
    print(rec)
    rec
  })
  
  getModel <- reactive({caret::train(getRecipe(), 
                          data = modified_missing_train_data(), 
                          method = "glmnet", 
                          trControl = trainControl(method = "cv", number = 10, savePredictions = "all"))
    })
  
  

  output$Summary_processed <- renderPrint({
    model <- getModel()
    req(model)
    print(model)
  })

  observeEvent(input$Vis_Imp_Go, {
    output$vis_importance <- renderPlot({
      model <- getModel()
      req(model)
      plot(caret::varImp(model))
    })
  })
  #test rmse
  test_rmse <- reactive({
    req(getModel(), test_data)
    predictions <- test_predictions()
    sqrt(mean((test_data$DEATH_RATE - predictions)^2))
  })
  
  output$test_rmse_output <- renderText({
    paste("RMSE:", round(test_rmse(), 4))
  })

  test_predictions <- reactive({
    req(getModel()) 
    predict(getModel(), newdata = test_data)
  })
  
  observeEvent(input$Test_go, {
    output$test_processed <- renderPlotly({
      rang <- range(c(test_data$DEATH_RATE, test_predictions()))
      test_plot <- ggplot(data = test_data, aes(x = DEATH_RATE, y = test_predictions())) +
        geom_point(mapping = aes(x = DEATH_RATE, y = test_predictions())) +
        geom_abline(slope = 1, col = "blue")+
        labs(x = "Actual DEATH_RATE", y = "Predicted DEATH_RATE") +
        ggtitle("Actual vs. Predicted DEATH_RATE")+
        coord_fixed(ratio = 1, xlim = rang, ylim = rang, expand = TRUE)
      plotly::ggplotly(test_plot, width = rang, height = rang)
    })
    
    
  })
  
  ### residual box plot
  
  generate_residual_boxplots <- reactive({
    iqr_multiplier <- input$iqr_multiplier
    residual_type <- input$residual_type
    model <- getModel()  # Get the trained model here
    
    if (residual_type == "Training Data") {
      residuals <- train_data$DEATH_RATE - predict(model, newdata = train_data)
      ids <- train_data$CODE  # Get the CODE (id) for train_data
    } else if (residual_type == "Testing Data") {
      residuals <- test_data$DEATH_RATE - predict(model, newdata = test_data)
      ids <- test_data$CODE  # Get the CODE (id) for test_data
    } else if (residual_type == "Both Test and Train") {
      train_residuals <- train_data$DEATH_RATE - predict(model, newdata = train_data)
      test_residuals <- test_data$DEATH_RATE - predict(model, newdata = test_data)
      residuals <- c(train_residuals, test_residuals)
      ids <- c(train_data$CODE, test_data$CODE)  # Combine CODE (id) from both datasets
    }
    
    # Create a vector of labels for each residual value
    labels <- ifelse(abs(residuals) > iqr_multiplier * IQR(residuals), as.character(ids), "")
    
    residual_df <- data.frame(Residuals = residuals, Label = labels)
    p <- ggplot(residual_df, mapping = aes(x = Residuals, y = 0)) +
      geom_boxplot(coef = iqr_multiplier, outlier.color = "red") +
      geom_text_repel(data = residual_df %>% filter(Label != ""), aes(label = Label), max.overlaps = 30) +
      labs(title = paste("Residual Box Plot for", residual_type, "with Outliers Labeled"),
           x = "", y = "Residuals") +
      theme_minimal()
    
    p
  })
  
  # Render the residual box plots
  output$residual_boxplot <- renderPlot({
    generate_residual_boxplots()
  })
  
})
