shinyUI(
  fluidPage(
    useShinyjs(),
    titlePanel("Assignment 1 - Michelle Visscher"),
    
    tabsetPanel(
      tabPanel("Summary",
               h3("Dataset Overview"),
               verbatimTextOutput(outputId = "SummaryA1"),
               verbatimTextOutput(outputId = "SummaryA2")
      ),
      tabPanel("DataTable",
               h3("Dataset - Data Table"),
               DT::dataTableOutput(outputId = "datatable")
      ),
      tabPanel("Pairs plot",
               h3("Dataset - Pairs Plot"),
               selectizeInput(inputId = "PairsVar", 
                              label = "Show variables:", 
                              choices = choicesPairs, 
                              multiple = TRUE, 
                              selected = choicesPairs[c(14,21,24,27,33,34,36)]),
               
               selectizeInput(inputId = "PairsColor", 
                              label = "Group By:", 
                              choices = choicesPairs[2:12], 
                              multiple = FALSE, 
                              selected = choicesPairs[1]),
               withSpinner(
                 plotOutput(outputId = 'Pairs')
               )
      ),
      tabPanel("Correlation",
               h3("Dataset - Corrgram"),
               selectizeInput(inputId = "CorrVar", 
                              label = "Show variables:", 
                              choices = choicesCorr, 
                              multiple = TRUE, 
                              selected = choicesCorr),
               withSpinner(
                 plotOutput(outputId = 'Corrgram')
               ),
               checkboxInput(inputId = "abs", 
                             label = "Uses absolute correlation", 
                             value = TRUE),
               
               selectInput(inputId = "CorrMeth", 
                           label = "Correlation method", 
                           choices = c("pearson","spearman","kendall"), 
                           selected = "pearson"),
               
               selectInput(inputId = "Group", 
                           label = "Grouping method", 
                           choices = list("none" = FALSE,"OLO" = "OLO","GW" = "GW","HC" = "HC"), 
                           selected = "OLO")
      ),
      tabPanel("Mosaic",
               h3("Mosaic Plot - Categorical Variables"),
               tabPanel("Visualisation",
                        selectizeInput(inputId = "MosaicVar", 
                                       label = "Show variables:", 
                                       choices = choicesMosaic, 
                                       multiple = TRUE, 
                                       selected = choicesMosaic[c(1,2,5)]),
                        withSpinner(
                          plotOutput(outputId = "Mosaic")
                        )
               )
      ),
      tabPanel("Box Plot",
               h3("Dataset - Box Plot"),
               selectizeInput(inputId = "BoxVar", 
                              label = "Show variables:", 
                              choices = choicesBox, 
                              multiple = TRUE, 
                              selected = choicesBox),
               withSpinner(
                 plotOutput(outputId = 'Boxplot')
               ),
               checkboxInput(inputId = "standardise", 
                             label = "Show standardized", 
                             value = FALSE),
               
               checkboxInput(inputId = "outliers", 
                             label = "Show outliers", 
                             value = FALSE),
               
               sliderInput(inputId = "range", 
                           label = "IQR Multiplier", 
                           min = 0, 
                           max = 5, 
                           step = 0.1, 
                           value = 1.5)
      ),
      tabPanel("Tabplot",
               h3("Dataset - Tabplot"),
               selectizeInput(inputId = "TabVar", 
                              label = "Show variables:", 
                              choices = choicesTab, 
                              multiple = TRUE, 
                              selected = choicesTab[c(1,2,3,4,5,16,23,26,29,35,36,38)]),
               
               selectizeInput(inputId = "TabGroup",
                              label = "Sort on:",
                              multiple = FALSE,
                              choices = c("ID", "Date", "Y"), 
                              selected = "Date"),  
               withSpinner(
                 plotOutput(outputId = "tableplot")
               ),
      ),
      tabPanel("Matplot",
               h3("Dataset Homogeneity"),
              withSpinner(
                plotOutput(outputId = "Matplot")
              ),
              checkboxInput(inputId = "center", 
                            label = "Show center", 
                            value = FALSE),
              
              checkboxInput(inputId = "scale", 
                            label = "Show scale", 
                            value = FALSE),
              checkboxInput(inputId = "legend",
                            label = "Display Legend",
                            value = TRUE)
      ),
      tabPanel("Missing Data",
               h3("Visualising Missing Data"),
               withSpinner(
                 plotOutput(outputId = "Missing")
               ),
               checkboxInput(inputId = "cluster", 
                             label = "Cluster missingness", 
                             value = FALSE)
      ),         
      tabPanel("Data Gaps",
              h3("Rising Value Chart"),
              selectizeInput(inputId = "selected_sensor",
                             label = "Select Sensors:",
                             choices = choicesRising,
                             multiple = TRUE,
                             selected = choicesRising
              ),
              withSpinner(
                plotOutput(outputId = "Rising")
              )
      )
    )
  )
)
