library(shiny)
library(plotly)
source("utils.R")

###################################Improvements
##### Put species button : i) Human ii) Yeast iii) Drosophila
##### Correct the scale of the entropy 
##### Put a button for label : i) Always show , ii) Show when hover over
##### Make the plotting area bigger. Maybe make the button area smaller.
##### If possible make way for comparing 3 protein/complex. Maybe put a button : i) Triangle ii) Tetrahedron, or
############or may be put an option NONE in fourth drop down, and in that case, the plotly will not show the 4th vertex and neither it shows the lines of tetrahedron connecting the 4th vertex,

# --- Load matrices at startup ---
# PPI_matrix <- readRDS("ECdz_min_tinyfast_version.Rdata")
PPI_matrix <- readRDS("ECdz_min.Rdata")

PPI_matrix=cbind(PPI_matrix,NULL=rep(0,ncol(PPI_matrix)))
CCI_matrix <- readRDS("CIM_only3Ksubunits.Rdata")
CCI_matrix=cbind(CCI_matrix,NULL=rep(0,ncol(CCI_matrix)))
ppi_names <- colnames(PPI_matrix)
cci_names <- colnames(CCI_matrix)

# --- UI layout ---
ui <- fluidPage(
  titlePanel("PPI & CCI 3D Viewer"),
  sidebarLayout(
    sidebarPanel(
      selectInput("mode", "Choose Mode:", choices = c("PPI", "CCI")),
      selectInput("sel1", "Select 1 (Select NULL for Triangle plot):", choices = NULL),
      selectInput("sel2", "Select 2:", choices = NULL),
      selectInput("sel3", "Select 3:", choices = NULL),
      selectInput("sel4", "Select 4:", choices = NULL),
      
      sliderInput("entropy", "Entropy Min:", min = 0, max = 2, value = 0),
      sliderInput("entropyMax", "Entropy Max:", min = 0, max = 2, value = 1),
      sliderInput("maxvalue", "Max Value Min Threshold:", min = 0, max = 100, value = 20),
      
      fluidRow(
        column(6, actionButton("plotButton", "Plot")),
        column(6, downloadButton("downloadTSV", "Download TSV"))
      )
      
    )
    ,
    mainPanel(
      plotlyOutput("plot3D", height = "700px"),
      br(),  # adds space
      h4("Tetrahedron Info Table"),
      tableOutput("infoTable")
    )
    
  )
)

# --- Server logic ---
server <- function(input, output, session) {
  
  plot_data <- reactiveVal(NULL)
  
  
  # Update dropdowns based on mode
  observeEvent(input$mode, {
    choices <- if (input$mode == "PPI") ppi_names else cci_names
    
    updateSelectInput(session, "sel1", choices = choices, selected = choices[1])
    updateSelectInput(session, "sel2", choices = choices, selected = choices[2])
    updateSelectInput(session, "sel3", choices = choices, selected = choices[3])
    updateSelectInput(session, "sel4", choices = choices, selected = choices[4])
  })
  
  
  output$downloadTSV <- downloadHandler(
    filename = function() {
      paste0("tetrahedron_table_", Sys.Date(), ".tsv")
    },
    content = function(file) {
      write.table(plot_data(), file, sep = "\t", row.names = FALSE, quote = FALSE)
    }
  )
  
  
  # Generate plot when "Plot" is clicked
  observeEvent(input$plotButton, {
    mat <- if (input$mode == "PPI") PPI_matrix else CCI_matrix
    selected_cols <- mat[, c(input$sel1, input$sel2, input$sel3, input$sel4), drop = FALSE]
    
    result <- plotTetrahedron(
      data = selected_cols,
      entropyrange = c(input$entropy, input$entropyMax),
      maxvaluerange = c(input$maxvalue, Inf),
      output_table = TRUE
    )
    
    output$plot3D <- renderPlotly({ result$plot })
    
    output$infoTable <- renderTable({
      result$table
    }, striped = TRUE, bordered = TRUE, hover = TRUE)
    
    plot_data(result$table)  # 🔁 store the table for download
    
  })
  
  
  
}


# --- Launch app ---
shinyApp(ui, server)
