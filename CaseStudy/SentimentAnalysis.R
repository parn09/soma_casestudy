###############################
#Chunk -3- Sentiment Function     
###############################

install.packages("plyr")
install.packages("stringr")
install.packages("ggplot2")

library (plyr)
library (stringr)
library (ggplot2)

convertToUTF8 = function(x) {
  return(iconv(x, to='UTF-8-MAC', sub = "byte"))
}

score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
  require(plyr)
  require(stringr)
  scores=laply(sentences, function(sentence, pos.words, neg.words){
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\\d+', '', sentence)
    sentence = convertToUTF8(sentence)
    sentence = tolower(sentence)
    
    word.list = str_split(sentence, '\\s+')
    words = unlist(word.list)
    
    pos.matches = match(words, pos.words)
    neg.matches = match(words, neg.words)
    
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    score = sum(pos.matches) - sum(neg.matches)
    return(score)
  }, pos.words, neg.words, .progress=.progress)
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}

############################################
#Chunk - 4 - Scoring Tweets &amp; Adding a column      
############################################

#Load sentiment word lists
hu.liu.pos = scan(paste(getwd(),'/positive-words.txt',sep=""), what='character', comment.char=';')
hu.liu.neg = scan(paste(getwd(),'/negative-words.txt',sep=""), what='character', comment.char=';')

#Add words to list
pos.words = hu.liu.pos
neg.words = hu.liu.neg

#Import 3 csv
DatasetAsus <- read.csv(paste(getwd(),'/AsusTweets.csv',sep=""))
DatasetAsus$text<-as.factor(DatasetAsus$text)

DatasetAcer <- read.csv(paste(getwd(),'/AcerTweets.csv',sep=""))
DatasetAcer$text<-as.factor(DatasetAcer$text)

#Score all tweets 
Asus.scores = score.sentiment(DatasetAsus$text, pos.words,neg.words, .progress='text')
Acer.scores = score.sentiment(DatasetAcer$text, pos.words,neg.words, .progress='text')

#Export scores to csv file, please take note, you need to submit  
#RangerScore.csv to OLIVE 
path<-getwd()
write.csv(Asus.scores,file=paste(path,"/AsusScores.csv",sep=""),row.names=TRUE)
write.csv(Acer.scores,file=paste(path,"/AcerScores.csv",sep=""),row.names=TRUE)

Asus.scores$Team = 'Asus'
Acer.scores$Team = 'Acer'

############################# 
#Chunk -5- Visualizing   	    
#############################

hist(Asus.scores$score)
qplot(Asus.scores$score)

hist(Acer.scores$score)
qplot(Acer.scores$score)


#################################
#Chunk -6- Comparing 3 data sets	              
#################################

all.scores = rbind(Asus.scores, Acer.scores)
ggplot(data=all.scores) + # ggplot works on data.frames, always
  geom_bar(mapping=aes(x=score, fill=Team), binwidth=1) +
  facet_grid(Team~.) + # make a separate plot for each hashtag
  theme_bw() + scale_fill_brewer() # plain display, nicer colors
