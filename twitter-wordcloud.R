## This script basically fetchs tweets found from Twitter for a given user 
## and applies some text clearing on it and then plots a wordcloud.
## In order to try it, enter your app&user credentials and the user whose tweets 
## will be used to make a wordcloud.

# Get helper functions.
source('twitter-wordcloud-helper.R')

# Load the required R libraries.
ListOfLibraries <- c('RColorBrewer', 'wordcloud', 'tm', 'twitteR', 
                     'ROAuth', 'plyr', 'stringr', 'base64enc', 'SnowballC')

loadListOfLibraries(ListOfLibraries)


# Make a Twitter API connection with app&user credentials.
consumerKey       <- 'xxx'
consumerSecret    <- 'xxx'
accessToken       <- 'xxx'
accessTokenSecret <- 'xxx'

prepareTwitter(consumerKey, consumerSecret, accessToken, accessTokenSecret)


## Fetching tweets from API.


# Declare search parameters.
user <- '@thomyorke'
maxNumberOfTweets <- 100

# Fetch given user's tweets. 
tweets <- userTimeline(user, n=maxNumberOfTweets)


## Preparing tweets for text processing.


# Identiy & create text files to turn into a cloud.
tweetsText <- sapply(tweets, function(x) x$getText())

# Create a corpus from the collection of text files.
tweetsTextCorpus <- Corpus(VectorSource(tweetsText))


## Data Cleaning on the text files.


# Remove punctuation.
tweetsTextCorpus <- tm_map(tweetsTextCorpus, removePunctuation)

# Transform text to lower case.
tweetsTextCorpus <- tm_map(tweetsTextCorpus, content_transformer(tolower))

# To remove stopwords.
tweetsTextCorpus <- tm_map(tweetsTextCorpus, function(x)removeWords(x,stopwords()))

# Remove URL’s from text.
removeURL <- function(x) gsub('http[[:alnum:]]*', '', x)
tweetsTextCorpus <- tm_map(tweetsTextCorpus, content_transformer(removeURL))


# Build a term-document matrix.
tweetsMatrix <- TermDocumentMatrix(tweetsTextCorpus)
tweetsMatrix <- as.matrix(tweetsMatrix)
tweetsMatrix <- sort(rowSums(tweetsMatrix), decreasing=TRUE)

# Converting words to dataframe.
tweetsMatrix <- data.frame(word = names(tweetsMatrix), freq=tweetsMatrix)


# Plot word frequencies.
barplot(tweetsMatrix[1:10,]$freq, las = 2, names.arg = tweetsMatrix[1:10,]$word,
        col ='yellow', main ='Most frequent words',
        ylab = 'Word frequencies')


# Generate the Word cloud.
set.seed(1234)
wordcloud(tweetsTextCorpus, min.freq=1, max.words=80, scale=c(2.2,1), 
          colors=brewer.pal(8, 'Dark2'), random.color=T, random.order=F)

