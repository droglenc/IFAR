# User must set working directory appropriately.

library(FSA)
library(dplyr)
library(Rcapture)

gs.M <- read.table("Zehfussetal_1985_mod.INP",header=FALSE,
                   colClasses=c("character","character"))
names(gs.M) <- c("ch","freq")
headtail(gs.M)

gs.I <- capHistConvert(gs.M,in.type="MARK",freq="freq",
                       out.type="individual",include.id=TRUE,
                       var.lbls.pre="e")
headtail(gs.I)

gs.ch <- capHistSum(gs.I,cols2use=-1)

gs.ch$caphist[1:8]  # only first eight shown

sl1 <- mrClosed(2555,274,92,method="Chapman")
summary(sl1,incl.SE=TRUE)
confint(sl1,verbose=TRUE)

gs.ch56 <- capHistSum(gs.I,cols2use=5:6)
gs.mr56 <- mrClosed(gs.ch56,method="Chapman")
cbind(summary(gs.mr56,incl.SE=TRUE),confint(gs.mr56))

group <- c("305-380","381+")
M <- c(1929,626)
n <- c( 222, 52)
m <- c(  77, 15)
sl2 <- mrClosed(M,n,m,labels=group,method="Chapman")
cbind(summary(sl2,incl.SE=TRUE),confint(sl2,incl.all=TRUE))

headtail(gs.ch$sum)  # only first & last 3 rows (events) shown

gs.mr1 <- mrClosed(gs.ch,method="Schnabel")
cbind(summary(gs.mr1),confint(gs.mr1,verbose=TRUE))

plot(gs.ch)

gs.cp <- closedp.t(gs.I[,-1])   # be patient

gs.cp$results

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ======
# Remove last column of results and rounds to two decimals
round(gs.cp$results[,-ncol(gs.cp$results)],2)
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

( gs.ci <- closedpCI.t(gs.I[,-1],m="Mt") )

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ======
# required because default printing for closedpCI.t objects
# was too wide for the book margins.  The code below shortens
# "confidence" to "conf." in the output and reduces some of
# the vertical spacing when compared to the default.
cat("Number of captured units:", gs.ci$n, "\n\n")
cat("\nPoisson estimation and model fit:\n")
Rcapture:::tabprint(tab=gs.ci$results,digits=c(1,1,3,0,3,3,NA),warn=gs.ci$fit.warn)
cat("\nMultinomial estimation,",paste0((1-gs.ci$alpha)*100,"%"),
    "profile likelihood conf. interval:\n")
Rcapture:::tabprint(tab=gs.ci$CI,digits=c(1,1,1,NA),warn=gs.ci$CI.warn)
cat("\n")
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

gs.cp$parameters$M0
gs.cp$parameters$Mt

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ======
gs.Mt <- gs.cp$parameters$Mt
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

plot(gs.mr1,loess=TRUE)

plot(1:12,gs.cp$parameters$Mt[2:13],type="l",ylim=c(0,0.24),
     xlab="Sampling event",ylab="Probability of Capture")
abline(h=gs.cp$parameters$M0[,"p"],lty=2)

cutty <- read.csv("CutthroatAL.csv")
headtail(cutty,n=2)

cut.ch <- capHistSum(cutty,cols2use=-1)
cut.ch$methodB.top

cut.ch$methodB.bot

cut.mr <- mrOpen(cut.ch)
summary(cut.mr,parm=c("M","N"))

confint(cut.mr,parm="N")

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ======
cut6 <- cut.mr$df["i=6",]
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

cut.op <- openp(cutty[,-1])
cut.op$model.fit

cut.op$trap.fit

cut.op$N

cut.op$capture.prob

conf.level <- 0.95
z <- qnorm(.5+conf.level/2)
with(cut.op,cbind(N.LCI=N[,"estimate"]-z*N[,"stderr"],
                  N.UCI=N[,"estimate"]+z*N[,"stderr"]))

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ======
NCI <- with(cut.op,cbind(N.LCI=N[,"estimate"]-z*N[,"stderr"],
                         N.UCI=N[,"estimate"]+z*N[,"stderr"]))
pCI <- with(cut.op,cbind(p.LCI=capture.prob[,"estimate"]-z*capture.prob[,"stderr"],
                         p.UCI=capture.prob[,"estimate"]+z*capture.prob[,"stderr"]))
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

plot(cut.op,main="",pch=19,col=rgb(0,0,0,1/6))


# Script created at 2015-11-02 12:54:58
