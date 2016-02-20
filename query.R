#!/usr/bin/Rscript --restore --save
library("rmongodb")
library("tm")


# read full text from mongo
mgl=mongo.create()
data<-mongo.find.all(mgl, "test_database.test_collection", "{}", sort=list(timestamp=-1), limit=100L)
data2<-subset(x=data, select="content")
ds <- DataframeSource(data2)

# read negative words from csv
negative_words<-read.table("dictionary/negative.csv")

#Corpus Transformation
SAcorpus<-VCorpus(ds)
SAcorpus<-tm_map(SAcorpus, stripWhitespace)
SAcorpus<-tm_map(SAcorpus, removePunctuation)
SAcorpus<-tm_map(SAcorpus, removeNumbers)
SAcorpus<-tm_map(SAcorpus, content_transformer(tolower))
SAcorpus<-tm_map(SAcorpus, removeWords, stopwords("english"))
#SAcorpus<-tm_map(SAcorpus, stemDocument)

negative_words<-as.vector(t(negative_words))
negative_words<-tolower(negative_words)
negative_words

# Document Term Matrix
dtm_raw<-DocumentTermMatrix(SAcorpus)
dtm<-DocumentTermMatrix(SAcorpus,list(dictionary=negative_words))
dtm<-removeSparseTerms(dtm, 0.98)
findFreqTerms(dtm, 50)
dtm<-weightTfIdf(dtm)

tdm <- as.TermDocumentMatrix(dtm)
#inspect(tdm)
term_score<-tm_term_score(tdm, negative_words)
head(term_score)
