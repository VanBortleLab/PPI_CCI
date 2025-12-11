# PPI_CCI 3D Viewer

This repository contains an R Shiny app for visualizing:
- **PPI (Protein–Protein Interactions)**
- **CCI (Complex–Complex Interactions)**

The app loads precomputed interaction matrices and lets users interactively
select proteins or complexes and generate 3D tetrahedron or triangle visualizations.

---

## 📦 Requirements

Install the necessary R packages:

```r
install.packages(c("shiny", "plotly", "Matrix"))
```

Additional packages used in `utils.R` may also be required depending on your environment.

---

## 🚀 How to Run the App

### **1. Clone this repository**

```bash
git clone https://github.com/VanBortleLab/PPI_CCI.git
cd PPI_CCI
```

### **2. Run the app from the terminal**

```bash
Rscript runApp.R
```

This will start a local Shiny server.  
You should see an output line such as:

```
Listening on http://127.0.0.1:XXXX
```

Your browser should automatically open at that address.  
If not, manually paste the URL into your browser.

---

### **Alternative: Run inside R or RStudio**

```r
shiny::runApp("path/to/PPI_CCI")
```

---

## 🎯 App Usage Notes

- The app has **two modes**:
  - **PPI mode** — protein–protein interaction visualization  
  - **CCI mode** — complex–complex interaction visualization  

- You may select up to **four proteins/complexes** from the dropdown menus.  
- Selecting **NULL** for the first selector switches the visualization to a **triangle** instead of a tetrahedron.
- A TSV summary table of all plotted values can be downloaded using the **Download TSV** button.
- PPI matrices are stored in a **compressed symmetric sparse format** for fast loading and small file size.
- Only the selected columns (up to 4) are converted to dense matrices during plotting, optimizing memory usage.

---

## 📁 Repository Contents

- `runApp.R` — script to launch the Shiny app  
- `app.R` — UI and server logic  
- `PPI_sparse_sym.rds` — sparse symmetric PPI interaction matrix  
- `CIM_only3Ksubunits.Rdata` — CCI interaction matrix  
- `utils.R` — helper functions including the 3D tetrahedron plotter

---

## 🙌 Notes

If you use this app in research or presentations, please consider citing the repository or related publications.  
For feature requests or issues, please open a GitHub issue.
