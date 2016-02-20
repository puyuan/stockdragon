#!/usr/bin/Rscript --restore --save
library("tm")


args=commandArgs(TRUE)

# read negative words from csv
undervalued_list<-read.table(args[1])
undervalued_list<-tolower(as.vector(t(undervalued_list)))
#undervalued_list=c("undervalued")

# Document Term Matrix
dtm_undervalued<-DocumentTermMatrix(SAcorpus,list(dictionary=undervalued_list))
dtm_undervalued<-removeSparseTerms(dtm_undervalued, 0.98)
dtm_undervalued<-weightTfIdf(dtm_undervalued)

tdm_undervalued <- as.TermDocumentMatrix(dtm_undervalued)
#inspect(tdm)
term_score<-tm_term_score(tdm_undervalued, undervalued_list)
rank_list<-head(sort(term_score, decreasing=TRUE), 200L)
