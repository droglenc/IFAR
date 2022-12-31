# User must set working directory appropriately.

library(FSA)
library(car)      # Before dplyr to reduce conflicts with MASS
library(magrittr)
library(dplyr)

ruf <- read.csv("RuffeSLRH.csv") %>%
  filter(month==7) %>%
  mutate(logW=log10(wt),logL=log10(tl)) %>%
  select(-fishID,-day)
headtail(ruf)

ruf90 <- filterD(ruf,year==1990)
ruf9000 <- filterD(ruf,year %in% c(1990,2000))

plot(wt~tl,data=ruf90,pch=19,col=rgb(0,0,0,0.3),xlab="Total Length (mm)",ylab="Weight (g)")
plot(logW~logL,data=ruf90,pch=19,col=rgb(0,0,0,0.3),xlab="log Total Length",ylab="log Weight")

fit1 <- lm(logW~logL,data=ruf90)

coef(fit1)
confint(fit1)

Anova(fit1)

summary(fit1)

lens <- c(100,160)                  # vector of lengths
nd <- data.frame(logL=log10(lens))  # df of log(lengths)
( plogW <- predict(fit1,nd) )       # predicted log(weights)

( cf <- logbtcf(fit1,10) )  # correction factor

cf*(10^plogW)         # back-transforming with bias correction

mlogW <- predict(fit1,nd,interval="confidence")
cf*10^mlogW

plogW <- predict(fit1,nd,interval="prediction")
cf*10^plogW

plot(logW~logL,data=ruf90,pch=19,col=rgb(0,0,0,1/4),
     ylab="log Weight (g)",xlab="log Total Length (mm)")
tmp <- range(ruf90$logL)
xs <- seq(tmp[1],tmp[2],length.out=99)
ys <- predict(fit1,data.frame(logL=xs))
lines(ys~xs,lwd=2)
plot(wt~tl,data=ruf90,pch=19,col=rgb(0,0,0,1/4),
     ylab="Weight (g)",xlab="Total Length (mm)")
btxs <- 10^xs
btys <- cf*10^ys
lines(btys~btxs,lwd=2)

btys <- cf*10^predict(fit1,data.frame(logL=xs),
                      interval="prediction")
head(btys,n=3)

plot(wt~tl,data=ruf90,pch=19,col=rgb(0,0,0,1/4),
     ylab="Weight (g)",xlab="Total Length (mm)")
lines(btys[,"fit"]~btxs,col="gray20",lwd=2,lty="solid")
lines(btys[,"lwr"]~btxs,col="gray20",lwd=2,lty="dashed")
lines(btys[,"upr"]~btxs,col="gray20",lwd=2,lty="dashed")

r <- residuals(fit1)
fv <- fitted(fit1)

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
# Constructs example residual plots figure.
# set plotting parameters and constants
par(mar=c(2,3,3,2),mgp=c(0.5,0,0),mfrow=c(2,2),xaxt="n",yaxt="n")
# create some random data to illusrate the assumptions
set.seed(101)
n <- 100
mu <- 0
sigma <- 10
slp <- 1
int <- 0

# Assumptions met situation
x <- rnorm(n,mu,sigma)
e1 <- rnorm(n,mu,sigma)
y1 <- slp*x+int+e1
lm1 <- lm(y1~x)
residPlot(lm1,inclHist=FALSE)
mtext("Assumptions Met",line=0.25,cex=0.8)

# Linearity assumption not met
e2 <- ((x-mean(x))/5)^2 + rnorm(n,0,sigma/4)
y2 <- slp*x+int+e2
lm2 <- lm(y2~x)
residPlot(lm2,inclHist=FALSE)
mtext("Nonlinear",line=0.25,cex=0.8)

# Homoscedasticity assumption not met (with outliers)
x1 <- runif(n,min=0,max=10)
e3 <- rep(0,n)
for (i in 1:n) e3[i] <- rnorm(1,0,x1[i]/2)
y3 <- slp*x1+int+e3
lm3 <- lm(y3~x1)
residPlot(lm3,inclHist=FALSE)
mtext("Heteroscedastic",line=0.25,cex=0.8)

# Linearity and homoscedasticity assumptions not met (with outliers)
y4 <- 2*log(x1) + rnorm(n,0,0.4)
y4 <- exp(y4)
lm4 <- lm(y4~x1)
residPlot(lm4,inclHist=FALSE)
mtext("Nonlinear & Heteroscedastic",line=0.25,cex=0.8)
# == END -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ============
# ############################################################

residPlot(fit1)

ruf9000 %<>% mutate(fYear=factor(year))
str(ruf9000)

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
# Constructs plot that shows the two submodels.
cex.lbl <- 0.95
cex.pt <- 0.7
col2 <- "gray50"
lwd <- 1.
lty <- "dashed"
a <- 2; b1 <- 0.4; d1 <- -1.6; g1 <- 0.45
max.x <- 4.2
plot(0,0,col="white",ylim=c(0,max.x),xlim=c(-1.55,max.x),
     xlab="log Length",ylab="log Weight",xaxt="n",yaxt="n")
# the line
lines(c(0,max.x),c(a,a+max.x*b1),lwd=2)
# intercept (alpha)
points(0,a,pch=19,cex=cex.pt)
text(0,a,expression(alpha),pos=2,cex=cex.lbl,family="serif")
# slope (beta)
lines(c(0,1,1),c(a,a,a+b1),lty=lty,lwd=lwd)
text(1,a+b1/2,expression(beta),pos=4,cex=cex.lbl,family="serif")

lines(c(0,max.x),c(a+d1,a+d1+(b1+g1)*max.x),lwd=2,col=col2)
# Second intercept (alpha + delta)
points(0,a+d1,pch=19,cex=cex.pt,col=col2)
text(0,a+d1,expression(alpha+delta),pos=2,cex=cex.lbl,col=col2,family="serif")
# Second slope (beta + gamma)
# X coord for other second slope
x <- -d1/(b1+g1)
# X coord for other second slope
lines(c(x,x+1,x+1),c(a,a,a+b1+g1),lty=lty,lwd=lwd,col=col2)
text(x+1,a+(b1+g1)/2,expression(beta+gamma),pos=4,cex=cex.lbl,col=col2,family="serif")

# label x=0
axis(1,0,0,cex=cex.lbl,family="serif")
# add legend
legend("topleft",c("1990","2000"),col=c("black",col2),lwd=2,cex=0.75,bty="n")
# == END -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ============
# ############################################################

fit2 <- lm(logW~logL*fYear,data=ruf9000)

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK ==============================
residPlot(fit2)
# == END -- NOT SHOWN IN BOOK ================================
# ############################################################

Anova(fit2)

cbind(coef=coef(fit2),confint(fit2))

# plot points with different symbols for each year
symbs <- c(1,16)
plot(wt~tl,data=ruf9000,pch=symbs[ruf9000$fYear],
     ylab="Weight (g)",xlab="Total Length (mm)",cex=0.6)
# find range of tl values in each year
tmp <- ruf9000 %>% group_by(fYear) %>%
  summarize(min=min(tl,na.rm=TRUE),
            max=max(tl,na.rm=TRUE))
# plot line for 1990
tmpx <- seq(tmp$min[1],tmp$max[1],length.out=99)
tmpy <- 10^(predict(fit2,
           data.frame(logL=log10(tmpx),fYear=factor(1990))))
lines(tmpy~tmpx,col="gray60",lwd=2)
# plot line for 2000
tmpx <- seq(tmp$min[2],tmp$max[2],length.out=99)
tmpy <- 10^(predict(fit2,
           data.frame(logL=log10(tmpx),fYear=factor(2000))))
lines(tmpy~tmpx,col="gray90",lwd=2)
# add a legend
legend("topleft",c("1990","2000"),pch=symbs,cex=0.9,bty="n")

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
par(mar=c(3.5,3.5,1,1),mgp=c(1.8,0.4,0),tcl=-0.2,las=1,cex.lab=0.95,cex.axis=0.9)
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################
lwCompPreds(fit2,base=10,xlab="Year",main.pre="TL=")

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
# Constructs plot that demonstates comparing predicted weights
# for more than two groups.
ruf %<>% mutate(fYear=factor(year))
par(mar=c(3.5,3.5,1,1),mgp=c(1.8,0.4,0),tcl=-0.2,las=1,cex.lab=0.95,cex.axis=0.9)
fit3 <- lm(logW~logL*fYear,data=ruf)
lwCompPreds(fit3,base=10,xlab="Year",main.pre="TL=")
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################


# Script created at 2015-11-02 12:54:57
