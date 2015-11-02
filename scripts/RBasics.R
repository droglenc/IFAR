# User must set working directory appropriately.

library(FSA)

2*6

(3+2)*(5+4
 )

# This is a whole-line comment
3+2*7  # This is a post-line comment

tmp <- 2*6

tmp

( tmp <- 7+4*2 )

tmp*3

log10(1000)

log(1000)              # base= set by default (to exp(1))
log(1000,base=10)      # base= set explicitly, by name
log(1000,10)           # base= set explicitly, by position

num <- 123456789
format(num,scientific=TRUE,digits=4)
format(num,digits=4,scientific=TRUE)

( lens <- c(75,87,45,63,77,93) )
( wts <- c(13,14.2,7.8,9,10.1,10.1) )
( sex <- c("M","F","F","M","M","F"))
( mat <- c(TRUE,TRUE,FALSE,FALSE,FALSE,TRUE) )

class(lens)
class(wts)
class(sex)
class(mat)

( hab <- c(rocky=35,sandy=45,silty=20))

lens[3]

lens[c(1,3)]

lens[-c(1,3)]

hab[2]
hab["sandy"]

100-hab[2]       # old name is inappropriate
100-hab[[2]]     # no name

hab[[c(2,3)]]

lens/25.4
lens+10
lens^3

lens+wts
wts/(lens^3)*10000

lens + c(10,100)

lens + c(1,10,100,1000)

( sex1 <- factor(sex) )
class(sex1)

( sex2 <- factor(sex,levels=c("M","F")) )

as.numeric(sex1)
as.numeric(sex2)

rbind(lens,wts)
( lw <- cbind(lens,wts) )

rbind(lens,sex)
rbind(lens,mat)
rbind(sex,mat)

lw[[1,2]]          # 1st row, 2nd column (no name for element)
lw[c(1,3),2]       # 1st & 3rd rows, 2nd column
lw[-c(1,3),2]      # exclude 1st & 3rd rows, 2nd column

lw[1,]                            # 1st row
lw[,1]                            # 1st column
lw[,"wts"]                        # wts column

( df <- data.frame(lens,wts,sex,mat) )

df[1,2]                           # 1st row, 2nd column
df[1,]                            # 1st row/individual
df[,2]                            # 2nd column/variable
df[,"wts"]                        # wts column/variable

df$lens
df$sex

class(df$lens)
df$lens[c(1,3)]
df$lens/25.4

log10(df$lens)

lm1 <- lm(wts~lens,data=df)

coef(lm1)

residuals(lm1)

anova(lm1)

( int <- coef(lm1)[[1]] )
( slp <- coef(lm1)[[2]])

len <- 75                    # a chosen length
( pred.wt <- slp*len+int )   # the predicted weight

predY <- function(x,lmobj) {
  # get y-intercept and slope
  int <- coef(lmobj)[[1]]
  slp <- coef(lmobj)[[2]]
  # make the prediction
  pred.wt <- slp*x+int
  # return the prediction
  pred.wt
}

predY(75,lm1)        # single prediction (compare to previous)
predY(df$lens,lm1)   # vector of predictions

# create vector of values
tmp <- c(7,2,3,5,4)
# use loop to find the square of each value
res <- numeric(length(tmp))
for(i in 1:length(res)) {
  res[i] <- tmp[i]^2
  print(res)
}

# create a matrix
m <- rbind(c(15,6,2),c(30,15,5))
# find the sum of the rows of that matrix
res <- numeric(nrow(m))
for(i in 1:length(res)) res[i] <- sum(m[i,])
res

( res1 <- apply(m,MARGIN=1,FUN=sum) )  # by rows
( res2 <- apply(m,MARGIN=2,FUN=sum) )  # by columns

df <- data.frame(lens= c(75,87,45,63),
                 wts= c(13,14.2,7.8,9),
                 sex <- factor(c("M","F","F","M")),
                 mat <- c(TRUE,TRUE,FALSE,FALSE) )
mean(df$lens)
mean(df$wts)


# Script created at 2015-11-02 12:54:55
