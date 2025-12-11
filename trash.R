


library(Matrix)

thr <- 0.2
PPI_matrix <- readRDS("ECdz_min.Rdata")

PPI_matrix[PPI_matrix < thr] <- 0
smat <- Matrix(PPI_matrix, sparse = TRUE)
smat_sym <- forceSymmetric(smat, uplo = "U")
saveRDS(smat_sym, "PPI_sparse_sym.rds", compress = "xz")

system("say done")


library(Matrix)

smat_sym <- readRDS("PPI_sparse_sym.rds")
PPI_matrix_full <- as.matrix(smat_sym)


selected <- c("TP53", "BRCA1", "MYC","POLR3A")   # example
idx <- match(selected, rownames(smat_sym))
submat_sparse <- smat_sym[, idx]
submat <- as.matrix(submat_sparse)




u=readRDS("~/Downloads/FLOW/MASTERTRIANGLE/multiBamSummary/u1.Rdata")
