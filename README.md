# PPI_CCI 3D Viewer

This repository contains an R Shiny app to interactively explore:

- **PPI mode** – Protein–Protein Interaction (PPI) matrix  
- **CCI mode** – Complex–Complex Interaction (CCI) matrix  

The app lets you select up to **four proteins/complexes** at a time and visualizes their relationships in 3D (tetrahedron / triangle), along with a table of underlying values.

---

## Modes

### 1. PPI Mode

- Uses a **protein–protein interaction matrix** (`PPI_sparse_sym.rds`, loaded as a sparse symmetric matrix).
- Columns/rows correspond to protein names.
- A special `NULL` option is added so you can work with triangles (3 vertices) instead of full tetrahedra (4 vertices).

### 2. CCI Mode

- Uses a **complex–complex interaction matrix** (`CIM_only3Ksubunits.Rdata`).
- Columns/rows correspond to protein complexes.
- Also has a `NULL` option to allow triangle plots when the 4th vertex is not needed.

---

## Requirements

You need:

- **R** (version ≥ 4.3 recommended)
- The following R packages:

```r
install.packages(c(
  "shiny",
  "plotly",
  "Matrix"
))
