# User must set working directory appropriately.

library(FSA)
library(car)      # Before dplyr to reduce conflicts with MASS
library(dplyr)
library(magrittr)
library(Rcapture)

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
# Constructs plot of idealized catch curve.
No <- 500
S <- 0.7
z <- -log(S)
v <- 0.1
t <- 0:10
Nt.d <- No*exp(-z*t)              #deterministic population
Ct.d <- v*Nt.d                    #deterministic catch
lnCt.d <- log(Ct.d)
q <- c(0.1,0.35,0.75,0.9,0.95,1,1,1,1,1,1)
Ct.d.q <- q*Ct.d
lnCt.d.q <- log(Ct.d.q)
plot(t,lnCt.d,type="l",xlab="Age",ylab="log(Catch)",lwd=2,col="gray70",lty="dashed",ylim=c(0,4),yaxt="n")
axis(2,0:4)
lines(t,lnCt.d.q,lwd=2)
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

bkt <- data.frame(age=0:6,ct=c(39,93,112,45,58,12,8))
plot(log(ct)~age,data=bkt,
     xlab="Age (yrs)",ylab="Log Catch",pch=19)

thcr <- chapmanRobson(ct~age,data=bkt,ages2use=2:6)

cbind(summary(thcr),confint(thcr))

plot(thcr)

tmp <- filter(bkt,age>=2) %>% mutate(lnct=log(ct))
lm1 <- lm(lnct~age,data=tmp)
coef(lm1)

tmp %<>% mutate(wts=predict(lm1))
lm2 <- lm(lnct~age,data=tmp,weights=wts)
coef(lm2)

confint(lm2)

thcc <- catchCurve(ct~age,data=bkt,ages2use=2:6,weighted=TRUE)
cbind(summary(thcc),confint(thcc))

plot(thcc,pos.est="bottomleft")

d <- read.csv("CCatfishNB.csv") %>% mutate(lnct=log(catch))
d3 <- filter(d,age>=3)
lmCC <- lm(lnct~age*loc,data=d3)
Anova(lmCC)

(tmp <- coef(lmCC) )
-1*tmp[["age"]]                          # Z for Central sect
-1*(tmp[["age"]]+tmp[["age:locLower"]])  # Z for Lower sect

clrs <- c("black","gray70")
plot(lnct~age,data=d,pch=19,col=clrs[loc],
     xlab="Age",ylab="log(Catch)")
axis(1,12)        # to put 12 on the x-axis
xs <- 3:13
ysc <- predict(lmCC,data.frame(age=xs,loc="Central"))
lines(ysc~xs,lwd=2,col=clrs[1])
ysl <- predict(lmCC,data.frame(age=xs,loc="Lower"))
lines(ysl~xs,lwd=2,col=clrs[2])
legend("topright",levels(d3$loc),pch=19,col=clrs,
       cex=0.9,bty="n")

cutty <- read.csv("CutthroatAL.csv")
headtail(cutty)
cut.ch <- capHistSum(cutty,cols2use=-1)
cut.ch$methodB.top
cut.ch$methodB.bot

cut.mr <- mrOpen(cut.ch)

cbind(summary(cut.mr,parm="phi"),confint(cut.mr,parm="phi"))

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
cut6 <- cut.mr$df["i=6",]
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

cut.op <- openp(cutty[,-1])
cut.op$model.fit
cut.op$trap.fit

conf.level <- 0.95
z <- qnorm(.5+conf.level/2)
survs <- data.frame(cut.op$survivals) %>%
  mutate(phi.LCI=estimate-z*stderr,
         phi.UCI=estimate+z*stderr)
survs

metaM("PaulyL",Linf=12.93,K=0.23,T=17)
tmp <- c("PaulyL","HoenigO","HoenigOF","tmax","PaulyLNoT")
metaM(tmp,Linf=12.93,K=0.23,T=17,tmax=3)


# Script created at 2015-11-02 12:54:58
