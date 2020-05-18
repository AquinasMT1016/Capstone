
# Downloading the data
# The data was downloaded from the CourseRA website and unzipped into the working directory.
# That is our starting place for this project.

# 1. Establish filepaths in the working directory.

path<-paste(getwd(),"/final/en_US", sep="")
files<-list.files(path)
print(files)

blogs.path <- paste(path,"/", files[1],sep="")
news.path <- paste(path,"/", files[2],sep="")
twitter.path <- paste(path,"/", files[3],sep="")

# 2. Read lines of data from the files and store them in objects called
# "blog", "news", and "twit"

con <- file(blogs.path, open="rb")
blog<-readLines(con, skipNul = TRUE, encoding = "UTF-8")
close(con)
con <- file(news.path, open="rb")
news<-readLines(con, skipNul = TRUE, encoding = "UTF-8")
close(con)
con <- file(twitter.path, open="rb")
twit<-readLines(con, skipNul = TRUE, encoding = "UTF-8")
close(con)

# 3. For exploratory purposes, let's get some basic file information

# 3.1. Determine the file sizes of each and convert them to MB

blogB <- file.info(blogs.path)$size
newsB <- file.info(news.path)$size
twitB <- file.info(twitter.path)$size
blogMB <- blogB / 1024 ^ 2
newsMB <- newsB / 1024 ^ 2
twitMB <- twitB / 1024 ^ 2

# 3.2. Determine the length of each file

blogLines <- length(count.fields(blogs.path, sep="\n"))
newsLines <- length(count.fields(news.path, sep="\n"))
twitLines <- length(count.fields(twitter.path, sep="\n"))

# 3.3 Determine the number of words per line

blog.WPL<-sapply(gregexpr("[[:alpha:]]+", blog), function(x) sum(x > 0))
news.WPL<-sapply(gregexpr("[[:alpha:]]+", news), function(x) sum(x > 0))
twit.WPL<-sapply(gregexpr("[[:alpha:]]+", twit), function(x) sum(x > 0))

# 3.4 Sum the number of words in each line to get total words

blog.words.total<-sum(blog.WPL)
news.words.total<-sum(news.WPL)
twit.words.total<-sum(twit.WPL)

# 3.5 Determine the number of characters

blog.Char<-nchar(blog, type = "chars")
news.Char<-nchar(news, type = "chars")
twit.Char<-nchar(twit, type = "chars")

# 3.6 Sum the character counts to get total number of characters

blog.char.total<-sum(blog.Char)
news.char.total<-sum(news.Char)
twit.char.total<-sum(twit.Char)

# 3.7 Display an overview summary of the data

summary_df<-data.frame(File=c("Blog Raw", "News Raw", "Twitter Raw"),
               fileSize = c(blogMB, newsMB, twitMB),
               lineCount = c(blogLines, newsLines, twitLines),
               wordCount = c(blog.words.total, news.words.total, twit.words.total),
               charCount = c(blog.char.total,news.char.total,twit.char.total),
               wordMean = c(mean(blog.WPL), mean(news.WPL), mean(twit.WPL)),
               charMean = c(mean(blog.Char), mean(news.Char), mean(twit.Char))
)
View(summary_df)

# 4. Now we need to take a sample, because this is (obviously) a huge file.

# 4.1 Set seed for reproducibility

set.seed(1132)

# 5.2 Take a 10% sample of the data

blog_sample <- sample(blog, size = length(blog) / 10, replace = FALSE)
news_sample <- sample(news, size = length(news)/10, replace = FALSE)
twit_sample <- sample(twit, size = length(twit) / 10, replace = FALSE)

# 5.3 Repeat summary process using samples, to see if there are any concerns

blog_sampleMB <- format(object.size(blog_sample), standard = "IEC", units = "MiB")
news_sampleMB <- format(object.size(news_sample), standard = "IEC", units = "MiB")
twit_sampleMB <- format(object.size(twit_sample), standard = "IEC", units = "MiB")

# 5.4 Number Lines

blog_sampleLines <- length(blog_sample)
news_sampleLines <- length(news_sample)
twit_sampleLines <- length(twit_sample)

# 5.5 Number Words per line

blog_sampleWords<-sapply(gregexpr("[[:alpha:]]+", blog_sample), function(x) sum(x > 0))
news_sampleWords<-sapply(gregexpr("[[:alpha:]]+", news_sample), function(x) sum(x > 0))
twit_sampleWords<-sapply(gregexpr("[[:alpha:]]+", twit_sample), function(x) sum(x > 0))

# 5.6 Total words

blog_sample.words.total<-sum(blog_sampleWords)
news_sample.words.total<-sum(news_sampleWords)
twit_sample.words.total<-sum(twit_sampleWords)

# 5.7 Number Characters

blog_sample.Char<-nchar(blog_sample, type = "chars")
news_sample.Char<-nchar(news_sample, type = "chars")
twit_sample.Char<-nchar(twit_sample, type = "chars")

# 5.8 Total characters

blog_sample.Char.total<-sum(blog_sample.Char)
news_sample.Char.total<-sum(news_sample.Char)
twit_sample.Char.total<-sum(twit_sample.Char)

# 5.9 Summary Table

summary_sample <- data.frame(File=c("Blogs Sample", "News Sample", "Twitter Sample"),
                   fileSize = c(blog_sampleMB, news_sampleMB, twit_sampleMB),
                   lineCount = c(blog_sampleLines, news_sampleLines, twit_sampleLines),
                   wordCount = c(blog_sample.words.total, news_sample.words.total, twit_sample.words.total),
                   charCount = c(blog_sample.Char.total,news_sample.Char.total,twit_sample.Char.total),
                   wordMean = c(mean(blog_sampleWords), mean(news_sampleWords), mean(twit_sampleWords)),
                   charMean = c(mean(blog_sample.Char), mean(news_sample.Char), mean(twit_sample.Char))
)
View(summary_sample)

# 6.0 Data cleaning

library(tm)

# 6.1 Combine into a single table
data_sample<- c(blog_sample,news_sample,twit_sample)

# 6.2 Remove punctuation
data_sampleNoPunc<- removePunctuation(data_sample)

# 6.3 Remove white spaces
data_sampleNoWS<- stripWhitespace(data_sampleNoPunc)

# 6.4 Remove stop words - these are words like "a", "an", etc.
data_sampleNoStop <- removeWords(data_sampleNoWS, stopwords("english"))

# 6.5 Remove profanity; I chose a list from github
download.file("https://raw.githubusercontent.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en", 
              destfile = paste(getwd(),"/profanity.csv", sep=""))
profanity<- as.character(read.csv("profanity.csv", header=FALSE))
profanity<-profanity[-1]
profanity<-profanity[-length(profanity)]
data_sampleNoProfan <- removeWords(data_sampleNoStop, profanity)

# 6.6 Let's see how much information we cleansed from the data

object.size(data_sampleNoPunc)
object.size(data_sampleNoProfan)
object.size(data_sampleNoPunc)-object.size(data_sampleNoProfan)

# 6.7 Take data to lowercase
data_sampleLower<- tolower(data_sampleNoStop)

#data_sampleazONLY <- gsub("ð|â|???|T|o|'|³|¾|ñ|f|.|º|°|»|²|¼|>|<|¹|·|¸|¦|~|~", "", data_sampleLower) 

# 6.8 Remove whitespace again in case any new has been created
data_sampleNoWS2<- stripWhitespace(data_sampleLower)

# 7.0 Tokenization

## Note: I was attempting to tokenize using Data Science Dojo, but continued to 
## have thrown errors that I could not fix, and StackOverflow was not much help.
## I looked around at others who have worked on this problem, and found that 
## github user mjdata (a former graduate of this program) recommended a tokenizer
## snipper created by Maciej Szymkiewicz, aka zero323 on Github. So I used this.
## Works very well, I highly recommend.

download.file("https://raw.githubusercontent.com/zero323/r-snippets/master/R/ngram_tokenizer.R", 
              destfile = paste(getwd(),"/ngram_tokenizer.R", sep=""))
source("ngram_Tokenizer.R")
unigram_tokenizer <- ngram_tokenizer(1)
uniList <- unigram_tokenizer(data_sampleNoWS2)
freqNames <- as.vector(names(table(unlist(uniList))))
freqCount <- as.numeric(table(unlist(uniList)))
dfUni <- data.frame(Word = freqNames,
                    Count = freqCount)
attach(dfUni)
dfUniSort<-dfUni[order(-Count),]
detach(dfUni)
bigram_tokenizer <- ngram_tokenizer(2)
biList <- bigram_tokenizer(data_sampleNoShort)
freqNames <- as.vector(names(table(unlist(biList))))
freqCount <- as.numeric(table(unlist(biList)))
dfBi <- data.frame(Word = freqNames,
                   Count = freqCount)
attach(dfBi)
dfBiSort<-dfBi[order(-Count),]
detach(dfBi)
trigram_tokenizer <- ngram_tokenizer(3)
triList <- trigram_tokenizer(data_sampleNoShort)
freqNames <- as.vector(names(table(unlist(triList))))
freqCount <- as.numeric(table(unlist(triList)))
dfTri <- data.frame(Word = freqNames,
                    Count = freqCount)
attach(dfTri)
dfTriSort<-dfTri[order(-Count),]
detach(dfTri)

# 8.0 Exploratory analysis of tokens

library(ggplot2)

# 8.1 Unigram Frequency

top_20_unigrams <- dfUniSort[1:20, ]

g <- ggplot(top_20_unigrams, aes(x = reorder(Word, -Count), y = Count))
g <- g + geom_bar(stat = "identity", fill = I("grey50"))
g <- g + geom_text(aes(label = Count ), vjust = -0.20, size = 1)
g <- g + xlab("")
g <- g + ylab("Frequency")
g <- g + theme(plot.title = element_text(size = 6, hjust = 0.5, vjust = 0.5),
               axis.text.x = element_text(hjust = 1.0, angle = 45),
               axis.text.y = element_text(hjust = 0.5, vjust = 0.5))
g <- g + ggtitle("20 Most Common Unigrams")

ggsave("unigrams.png",width=5,height=5)


# 8.2 Bigrams Frequency

top_20_bigrams <- dfBiSort[1:20, ]

g <- ggplot(top_20_bigrams, aes(x = reorder(Word, -Count), y = Count))
g <- g + geom_bar(stat = "identity", fill = I("grey50"))
g <- g + geom_text(aes(label = Count ), vjust = -0.20, size = 1)
g <- g + xlab("")
g <- g + ylab("Frequency")
g <- g + theme(plot.title = element_text(size = 6, hjust = 0.5, vjust = 0.5),
               axis.text.x = element_text(hjust = 1.0, angle = 45),
               axis.text.y = element_text(hjust = 0.5, vjust = 0.5))
g <- g + ggtitle("20 Most Common Unigrams")



ggsave("bigrams.png",width=5,height=5)


top_20_trigrams <- dfTriSort[1:20, ]

g <- ggplot(top_20_trigrams, aes(x = reorder(Word, -Count), y = Count))
g <- g + geom_bar(stat = "identity", fill = I("grey50"))
g <- g + geom_text(aes(label = Count ), vjust = -0.20, size = 1)
g <- g + xlab("")
g <- g + ylab("Frequency")
g <- g + theme(plot.title = element_text(size = 6, hjust = 0.5, vjust = 0.5),
               axis.text.x = element_text(hjust = 1.0, angle = 45),
               axis.text.y = element_text(hjust = 0.5, vjust = 0.5))
g <- g + ggtitle("20 Most Common Unigrams")



ggsave("trigrams.png",width=5,height=5)




