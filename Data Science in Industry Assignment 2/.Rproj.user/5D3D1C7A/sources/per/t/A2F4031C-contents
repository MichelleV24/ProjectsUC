shinyUI(
  fluidPage(
    useShinyjs(),
    titlePanel("Assignment 2 - Michelle Visscher"),

    tabsetPanel(
      tabPanel("EDA",
tabsetPanel(
  tabPanel("Summary",
           h3("Dataset Overview"),
           withSpinner(verbatimTextOutput(outputId = "SummaryA1")),
           withSpinner(verbatimTextOutput(outputId = "SummaryA2"))
  ),
  tabPanel("Tabplot",
           h3("Dataset - Tabplot"),
           selectizeInput(inputId = "TabVar",
                          label = "Show variables:",
                          choices = choicesTab,
                          multiple = TRUE,
                          selected = choicesTab),
           selectizeInput(inputId = "TabGroup",
                          label = "Sort on:",
                          multiple = FALSE,
                          choices = choicesTab[c(2,12)],
                          selected = choicesTab[2]),
           withSpinner(
             plotOutput(outputId = "tableplot")
           )
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
  ),
  tabPanel("Pairs plot",
           h3("Dataset - Pairs Plot"),
           selectizeInput(inputId = "PairsVar",
                          label = "Show variables:",
                          choices = choicesPairs,
                          multiple = TRUE,
                          selected = choicesPairs[c(1,2,3,4)]),
           selectizeInput(inputId = "PairsColor",
                          label = "Group By:",
                          choices = choicesColor[c(2,3)],
                          multiple = FALSE,
                          selected = choicesColor[2]),
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
                                   selected = choicesMosaic),
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
                         value = TRUE),
           checkboxInput(inputId = "outliers",
                         label = "Show outliers",
                         value = TRUE),
           sliderInput(inputId = "range",
                       label = "IQR Multiplier",
                       min = 0,
                       max = 5,
                       step = 0.1,
                       value = 1.5)
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
  tabPanel("DataTable (Raw)",
           h3("Dataset - Data Table (Raw)"),
           DT::dataTableOutput(outputId = "datatable")
  )
)
),
    tabPanel("Data Processing",
             tabsetPanel(
               tabPanel("Missing Data",
                        h3("Missing Data Processing"),
                        
                        sliderInput(inputId = "VarThreshold", label = "Threshold of variable missingness",
                                    min = 1, max = 100, value = 50, post = "%"),
                        sliderInput(inputId = "ObsThreshold", label = "Threshold of observations missingness",
                                    min = 1, max = 100, value = 50, post = "%"),
                        
                        checkboxInput(inputId = "impute_pols", label = "Impute POLITICS variable", value = FALSE),
                        checkboxInput(inputId = "impute_Hcost", label = "Impute HEALTHCARE COST variable", value = FALSE),
                        
                        withSpinner(
                          plotOutput(outputId = "Missing_processed")
                        ),

               ),
               tabPanel("Patterns in missingness",
                        h3("Determining if there is a pattern in the missingness"),
                        withSpinner(
                          plotOutput("tree_plot")
                        ),
                        
               ),
               tabPanel("DataTable (processed)",
                        h3("Data Table with Processed variables"),
                        checkboxInput(inputId = "show_shadow_vars", label = "Show Shadow Variables", value = FALSE),
                        checkboxInput(inputId = "impute_pols", label = "Impute POLITICS variable", value = TRUE),
                        checkboxInput(inputId = "impute_Hcost", label = "Impute HEALTHCARE COST variable", value = TRUE),
                        DT::dataTableOutput(outputId = "mod_datatable")
               )

                        ),


  ),
  tabPanel("Data Modeling",
           tabsetPanel(
             tabPanel("Glmnet",
                      selectInput(inputId = "ImpMethod", label = "Imputation method",
                                  choices = c("None", "KNN", "Partial Del","Average", "Bag Impute"), selected = "KNN"),
                      actionButton(inputId = "Go", label = "Train Model", icon = icon("play")),
                      verbatimTextOutput(outputId = "Summary_processed"),
                      verbatimTextOutput("test_rmse_output"),
                      actionButton(inputId = "Vis_Imp_Go", label = "Visualise Variable Importance", icon = icon("play")),
                      plotOutput(outputId = "vis_importance")
                      
                      
             ),
             tabPanel("Model Performance",
                      actionButton(inputId = "Test_go", label = "Generate Plot", icon = icon("play")),
                      
                      plotlyOutput(outputId = "test_processed"),
                      
             ),
             tabPanel("Residual Box Plot",
                      sliderInput(inputId = "iqr_multiplier", 
                                  label = "IQR Multiplier for Outliers",
                                  min = 1, 
                                  max = 5, 
                                  value = 1.5, 
                                  step = 0.1),
                      selectInput(inputId = "residual_type", label = "Select Box Plots",
                                         choices = c("Testing Data", "Training Data", "Both Test and Train"),
                                         selected = "Both Test and Train"),
                      plotOutput(outputId = "residual_boxplot")
             )
             
           )
  )
    )
  )
)