## This script works as a helper for simplifying main twitter-wordcloud code.

loadListOfLibraries <- function(ListOfLibraries){
  lapply(ListOfLibraries, function(x){
      library(x,character.only=TRUE)
    }
  )
}

prepareTwitter <- function(consumerKey, consumerSecret, accessToken, accessTokenSecret) {
  # Download the curl certificate and save it in the folder of your choice.
  download.file(url="http://curl.haxx.se/ca/cacert.pem",destfile="cacert.pem")
  
  # Set constant requestURL.
  requestURL <- "https://api.twitter.com/oauth/request_token"
  
  # Set constant accessURL.
  accessURL <- "https://api.twitter.com/oauth/access_token"
  
  # Set constant authURL.
  authURL <- "https://api.twitter.com/oauth/authorize"
  
  # Authorization for the Twitter account.
  setup_twitter_oauth(consumerKey, consumerSecret, accessToken, accessTokenSecret)
}
