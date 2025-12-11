library(shiny)
library(plotly)
library(Matrix)
source("utils.R")

# --- Load matrices at startup ---

## PPI: load sparse symmetric matrix instead of huge dense one
smat_sym <- readRDS("PPI_sparse_sym.rds")   # 20k x 20k, sparse

## add a NULL column of zeros (like before)
PPI_matrix <- cbind(smat_sym, NULL = 0)

## CCI: keep as before
CCI_matrix <- readRDS("CIM_only3Ksubunits.Rdata")
CCI_matrix <- cbind(CCI_matrix, NULL = rep(0, ncol(CCI_matrix)))

ppi_names <- colnames(PPI_matrix)
cci_names <- colnames(CCI_matrix)

# --- UI layout ---
ui <- fluidPage(
  titlePanel("PPI & CCI 3D Viewer"),
  sidebarLayout(
    sidebarPanel(
      selectizeInput("mode", "Choose Mode:", choices = c("PPI", "CCI")),
      selectizeInput("sel1", "Select 1 (Select NULL for Triangle plot):", choices = NULL,options = list(maxOptions = 10)),
      selectizeInput("sel2", "Select 2:", choices = NULL,options = list(maxOptions = 10)),
      selectizeInput("sel3", "Select 3:", choices = NULL,options = list(maxOptions = 10)),
      selectizeInput("sel4", "Select 4:", choices = NULL,options = list(maxOptions = 10)),
      
      sliderInput("entropy",    "Entropy Min:",            min = 0, max = 2,   value = 0),
      sliderInput("entropyMax", "Entropy Max:",            min = 0, max = 2,   value = 1),
      sliderInput("maxvalue",   "Max Value Min Threshold:",min = 0, max = 100, value = 20),
      
      fluidRow(
        column(6, actionButton("plotButton", "Plot")),
        column(6, downloadButton("downloadTSV", "Download TSV"))
      )
    ),
    mainPanel(
      plotlyOutput("plot3D", height = "700px"),
      br(),
      h4("Tetrahedron Info Table"),
      tableOutput("infoTable")
    )
  )
)

# --- Server logic ---
server <- function(input, output, session) {
  
  plot_data <- reactiveVal(NULL)
  
  # update dropdowns based on mode
  observeEvent(input$mode, {
    choices <- if (input$mode == "PPI") ppi_names else cci_names
    
    updateSelectizeInput(session, "sel1", choices = choices, selected = choices[1],server=T)
    updateSelectizeInput(session, "sel2", choices = choices, selected = choices[2],server=T)
    updateSelectizeInput(session, "sel3", choices = choices, selected = choices[3],server=T)
    updateSelectizeInput(session, "sel4", choices = choices, selected = choices[4],server=T)
  })
  
  output$downloadTSV <- downloadHandler(
    filename = function() {
      paste0("tetrahedron_table_", Sys.Date(), ".tsv")
    },
    content = function(file) {
      write.table(plot_data(), file, sep = "\t", row.names = FALSE, quote = FALSE)
    }
  )
  
  observeEvent(input$plotButton, {
    mat <- if (input$mode == "PPI") PPI_matrix else CCI_matrix
    
    selected_cols <- mat[, c(input$sel1, input$sel2, input$sel3, input$sel4), drop = FALSE]
    
    # make sure plotTetrahedron gets a base R matrix (not a Matrix object)
    if (inherits(selected_cols, "Matrix")) {
      selected_cols <- as.matrix(selected_cols)
    }
    
    result <- plotTetrahedron(
      data          = selected_cols,
      entropyrange  = c(input$entropy, input$entropyMax),
      maxvaluerange = c(input$maxvalue, Inf),
      output_table  = TRUE
    )
    
    output$plot3D <- renderPlotly(result$plot)
    
    output$infoTable <- renderTable(
      result$table,
      striped = TRUE, bordered = TRUE, hover = TRUE
    )
    
    plot_data(result$table)
  })
}

shinyApp(ui, server)
