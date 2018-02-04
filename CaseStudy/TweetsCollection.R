#Pull tweets from twitter and store in CSV files via dataframe using hashtag.

install.packages("twitteR", dependencies=T)
install.packages("ROAuth")
install.packages("RCurl")
install.packages("httr")

library(twitteR)
library(ROAuth)
library(RCurl)
library(httr)

# Direct Access Method to get by proxy
# Only replace the word, double quote is necessary for as the key are String Value

consumer_key <- "fxC9D5bjpdRvIdt2RYAjCWjrS"
consumer_secret <- "BvGXr8U1q71THGmMB5tBSaYelx5WVy8aAoZehaSyibJ34Xz8VR"
access_token <- "57904561-RtWaemwKZiAVYZmQ5BG04BCvXzz0TDA1dFDVaSXGD"
access_secret <- "86B9jAKYRxeDvRvEFFazvWlnbXR4VXpWKbtlZ76YtVhPI"

# Uncomment this if using this behind TP proxy
# set_config(use_proxy(url='proxy.tp.edu.sg',80))

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

setwd("~/CaseStudy")

Asus.list <- searchTwitter('#asus', n=500)
Asus.df = twListToDF(Asus.list)
write.csv(Asus.df, file=paste(getwd(),'/AsusTweets.csv',sep=""), row.names=FALSE)

Acer.list <- searchTwitter('#acer', n=500)
Acer.df = twListToDF(Acer.list)
write.csv(Acer.df, file=paste(getwd(),'/AcerTweets.csv',sep=""), row.names=FALSE)
