# User must set working directory appropriately.

# Set random seed to keep alkIndivAge results constant
set.seed(14354454)

library(FSA)
library(magrittr)
library(dplyr)
library(nnet)

cc <- read.csv("CreekChub.csv")
headtail(cc)

cc %<>% mutate(lcat10=lencat(len,w=10))
headtail(cc)

is.na(headtail(cc)$age)        # demonstration purposes only

cc.unaged <- filter(cc,is.na(age))
headtail(cc.unaged)

cc.aged <- filter(cc,!is.na(age))
headtail(cc.aged)

all(is.na(cc.unaged$age))       # better be TRUE
any(is.na(cc.aged$age))         # better be FALSE

( alk.freq <- xtabs(~lcat10+age,data=cc.aged) )

rowSums(alk.freq)

alk <- prop.table(alk.freq,margin=1)
round(alk,3)    # rounded for display purposes only

cc.mlr <- multinom(age~lcat10,data=cc.aged,maxit=500)

lens <- seq(40,200,10)
alk.sm <- predict(cc.mlr,data.frame(lcat10=lens),type="probs")
row.names(alk.sm) <- lens   # for clarity
round(alk.sm,3)             # round for display purposes only

alkPlot(alk,type="area",pal="gray",showLegend=TRUE,
        leg.cex=0.7,xlab="Total Length (mm)")

alkPlot(alk,type="bubble",xlab="Total Length (mm)")

( len.n <- xtabs(~lcat10,data=cc) )

( tmp <- sweep(alk,MARGIN=1,FUN="*",STATS=len.n) )

( ad1 <- colSums(tmp) )

round(prop.table(ad1),3)   # rounded for display purposes only

# note: alk.freq and len.n were calculated previously
alkAgeDist(alk,lenA.n=rowSums(alk.freq),len.n=len.n)

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ======
tmp <- alkAgeDist(alk,lenA.n=rowSums(alk.freq),len.n=len.n)
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

alkMeanVar(alk,len~lcat10+age,data=cc.aged,len.n=len.n)

tmp <- alkMeanVar(alk,len~lcat10+age,data=cc.aged,len.n=len.n)

cc.unaged.mod <- alkIndivAge(alk,age~len,data=cc.unaged)
head(cc.unaged.mod)

cc.fnl <- rbind(cc.aged,cc.unaged.mod)

( ad3 <- xtabs(~age,data=cc.fnl) )
round(prop.table(ad3),3)   # rounded for display purposes only

cc.sumlen <- cc.fnl %>% group_by(age) %>%
  summarize(n=validn(len),mn=mean(len,na.rm=TRUE),
            sd=sd(len,na.rm=TRUE),se=se(len,na.rm=TRUE)) %>%
  as.data.frame()
cc.sumlen

plot(len~age,data=cc.fnl,pch=19,col=rgb(0,0,0,1/10),
     xlab="Age",ylab="Total Length (mm)",ylim=c(0,205))
lines(mn~age,data=cc.sumlen,lwd=2,lty=2)

sis <- read.csv("SiscowetMI2004.csv") %>%
  filter(!is.na(age),!is.na(sex)) %>%
  mutate(lcat=lencat(len,w=25))

mod1 <- multinom(age~lcat,data=sis,maxit=500)
mod2 <- multinom(age~lcat*sex,data=sis,maxit=500)

anova(mod1,mod2)

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ======
print(anova(mod1,mod2),digits=6)
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

lens <- seq(350,675,25)
dfF <- data.frame(lcat=lens,sex="F")
dfM <- data.frame(lcat=lens,sex="M")

alkF <- predict(mod2,dfF,type="probs")
rownames(alkF) <- lens
alkPlot(alkF,type="area",pal="gray",xlab="Total Length (mm)",
        showLegend=TRUE,leg.cex=0.7)

alkM <- predict(mod2,dfM,type="probs")
rownames(alkM) <- lens
alkPlot(alkM,type="area",pal="gray",xlab="Total Length (mm)",
        showLegend=TRUE,leg.cex=0.7)


# Script created at 2015-10-06 10:23:31
