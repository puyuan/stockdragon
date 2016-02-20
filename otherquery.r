require("tm")

dtm_raw<-removeSparseTerms(dtm_raw, 0.98)
tdm_raw <- as.TermDocumentMatrix(dtm_raw)
sink("tdm_raw")
inspect(tdm_raw)


