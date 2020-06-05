
library(doParallel)
registerDoParallel(makeCluster(4))
library(stringr)
library(plyr)
library(dplyr)
library(caret)
library(tau)
library(data.table)

unzipped_folder <- "C:/Users/mikeb/Documents/R/CourseRA R Projects/Capstone/final/en_US/"
unzipped_blogs_file <- paste(unzipped_folder, "en_US.blogs.txt", sep = "")
unzipped_twitter_file <- paste(unzipped_folder, "en_US.twitter.txt", sep = "")
unzipped_news_file <- paste(unzipped_folder, "en_US.news.txt", sep = "")


bfile <- file(unzipped_blogs_file, open = "rb")
b <- readLines(bfile, encoding= "UTF-8", warn = F)
close(bfile)

b <- iconv(b, from="UTF-8", to="latin1", sub=" ")
b <- tolower(b)
bc <- str_replace_all(b, "([iu]n)-([a-z])", "\\1\\2")
bc <- str_replace_all(bc, "([0-9])(st|nd|rd|th)", "\\1")
bc <- str_replace_all(bc, " \\'|\\' ", " ")
bc <- str_replace_all(bc, "[^a-z.' ]", " ")
bc <- str_replace_all(bc, "([abiep])\\.([cdegm])\\.", "\\1\\2")
bc <- str_replace_all(bc, "([a-z])\\.([a-z])", "\\1 \\2")
bc <- str_replace_all(bc, "( [a-z])\\. ", "\\1 ")
bc <- str_replace_all(bc, " (m[rs]|mrs)\\.", " \\1 ")
bc <- str_replace_all(bc, " (dr|st|rd|av|ave|blvd|ct)\\.", " \\1 ")
bc <- str_replace_all(bc, "\\.$", "")
bc <- str_replace_all(bc, "^ +| +$|", "")
bc <- str_replace_all(bc, " {2,}", " ")
bc <- str_replace_all(bc, " *\\. *","\\.")
bl <- str_split(bc, "\\.")
bl <- unlist(bl)
bl <- bl[bl != ""]

tfile <- file(unzipped_twitter_file, open = "rb")
t <- readLines(tfile, encoding= "UTF-8", warn = F)
close(tfile)

t <- iconv(t, from="UTF-8", to="latin1", sub=" ")
t <- tolower(t)
tc <- str_replace_all(t, "([iu]n)-([a-z])", "\\1\\2")
tc <- str_replace_all(tc, "([0-9])(st|nd|rd|th)", "\\1")
tc <- str_replace_all(tc, " \\'|\\' ", " ")
tc <- str_replace_all(tc, "[^a-z.' ]", " ")
tc <- str_replace_all(tc, "([abiep])\\.([cdegm])\\.", "\\1\\2")
tc <- str_replace_all(tc, "([a-z])\\.([a-z])", "\\1 \\2")
tc <- str_replace_all(tc, "( [a-z])\\. ", "\\1 ")
tc <- str_replace_all(tc, " (m[rs]|mrs)\\.", " \\1 ")
tc <- str_replace_all(tc, " (dr|st|rd|av|ave|blvd|ct)\\.", " \\1 ")
tc <- str_replace_all(tc, "\\.$", "")
tc <- str_replace_all(tc, "^ +| +$|", "")
tc <- str_replace_all(tc, " {2,}", " ")
tc <- str_replace_all(tc, " *\\. *","\\.")
tl <- str_split(tc, "\\.")
tl <- unlist(tl)
tl <- tl[tl != ""]

nfile <- file(unzipped_news_file, open = "rb")
n <- readLines(nfile, encoding= "UTF-8", warn = F)
close(nfile)

n <- iconv(n, from="UTF-8", to="latin1", sub=" ")
n <- tolower(n)
nc <- str_replace_all(n, "([iu]n)-([a-z])", "\\1\\2")
nc <- str_replace_all(nc, "([0-9])(st|nd|rd|th)", "\\1")
nc <- str_replace_all(nc, " \\'|\\' ", " ")
nc <- str_replace_all(nc, "[^a-z.' ]", " ")
nc <- str_replace_all(nc, "([abiep])\\.([cdegm])\\.", "\\1\\2")
nc <- str_replace_all(nc, "([a-z])\\.([a-z])", "\\1 \\2")
nc <- str_replace_all(nc, "( [a-z])\\. ", "\\1 ")
nc <- str_replace_all(nc, " (m[rs]|mrs)\\.", " \\1 ")
nc <- str_replace_all(nc, " (dr|st|rd|av|ave|blvd|ct)\\.", " \\1 ")
nc <- str_replace_all(nc, "\\.$", "")
nc <- str_replace_all(nc, "^ +| +$|", "")
nc <- str_replace_all(nc, " {2,}", " ")
nc <- str_replace_all(nc, " *\\. *","\\.")
nl <- str_split(nc, "\\.")
nl <- unlist(nl)
nl <- nl[nl != ""]

lines <- c(bl, tl, nl)

set.seed(1650)
inFrame <- createDataPartition(y = 1:length(lines), p = 0.40, list = F)
train <- lines[inFrame]

base <- str_replace_all(train, "www [a-z]+ [a-z]+", "")
base <- str_replace_all(base, " ([a-z])\\1+ |^([a-z])\\1+ | ([a-z])\\1+$|^([a-z])\\1+$", " ")
base <- str_replace_all(base, "([a-z])\\1{2,}", "\\1\\1")
base <- str_replace_all(base, "\\'+([a-z]+)\\'+", "\\1")
base <- str_replace_all(base, "\\'+ \\'+", " ")
base <- str_replace_all(base, "(\\'+ )+|( \\'+)+|^\\'+|\\'+$", " ")
base <- str_replace_all(base, "^[a-z]+$", "")
base <- str_replace_all(base, "( [^ai])+ |^([^ai] )+|( [^ai])+$", " ")
base <- str_replace_all(base, "^ +| +$|", "")
base <- str_replace_all(base, " {2,}", " ")
base <- str_replace_all(base, " +$|^ +", "")
base <- base[base != ""]


base1 <- textcnt(base, method = "string", split = "[[:space:]]", n = 1L, decreasing = T)
base2 <- textcnt(base, method = "string", split = "[[:space:]]", n = 2L, decreasing = T)
base3 <- textcnt(base, method = "string", split = "[[:space:]]", n = 3L, decreasing = T)


unigram_dt <- data.table(text = names(base1), as.matrix(base1))
setnames(unigram_dt, "V1", "count")
setnames(unigram_dt, "text", "n0")
tot <- sum(unigram_dt$count)
unigram_dt <- mutate(unigram_dt, freq = round(count/tot, 7))
unigram_dt$count <- NULL
unigram_dt <- as.data.table(unigram_dt)
setkeyv(unigram_dt, c("n0", "freq"))
saveRDS(unigram_dt, "./unigram_dt.rds")


bibase_dt <- data.table(text = names(base2), as.matrix(base2))
setnames(bibase_dt, "V1", "count")
bigram_dt <- bibase_dt
bigram_dt[, c("n1", "n0")  := do.call(Map, c(f = c, strsplit(text, " ")))]
bigram_dt <- mutate(bigram_dt, freq = round(count/base1[n1][[1]], 7))
bigram_dt$text <- NULL
bigram_dt$count <- NULL
bigram_dt <- as.data.table(bigram_dt)
setkey(bigram_dt, n1)
bigram_dt <- bigram_dt[,lapply(.SD, function(x) head(x, 5)), by = key(bigram_dt)]
setkeyv(bigram_dt, c("n1", "freq", "n0"))
saveRDS(bigram_dt, "./bigram_dt.rds")

tribase_dt <- data.table(text = names(base3), as.matrix(base3))
setnames(tribase_dt, "V1", "count")
trigram_dt <- subset(tribase_dt, count > 1)
trigram_dt[, c("n2", "n1", "n0")  := do.call(Map, c(f = c, strsplit(text, " ")))]
trigram_dt <- mutate(trigram_dt, freq = round(count/base2[paste(n2, n1)][[1]], 7))
trigram_dt$text <- NULL
trigram_dt$count <- NULL
trigram_dt <- as.data.table(trigram_dt)
setkeyv(trigram_dt, c("n2", "n1"))
trigram_dt <- trigram_dt[,lapply(.SD, function(x) head(x, 5)),by = key(trigram_dt)]
setkeyv(trigram_dt, c("n2", "n1", "freq", "n0"))
saveRDS(trigram_dt, "./trigram_dt.rds")

badwords <- read.csv(file = "C:/Users/mikeb/Documents/R/CourseRA R Projects/Capstone/Archive/profanity.csv")
badwords <- tolower(badwords)
badwords <- str_replace_all(badwords, "\\(", "\\\\(")
saveRDS(badwords, "./badwords.rds")

