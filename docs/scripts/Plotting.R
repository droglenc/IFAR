# User must set working directory appropriately.

library(FSA)
library(FSAdata)
library(magrittr)
library(dplyr)
library(plotrix)

# ############################################################
# Load some internal data
data(BullTroutRML1)
head(BullTroutRML1,n=3)

data(BullTroutRML2)
BullTroutRML2 %<>% filterD(lake=="Harrison")
head(BullTroutRML2,n=3)

data(BloaterLH)
head(BloaterLH,n=3)
# ############################################################

plot(mass~fl,data=BullTroutRML1,ylim=c(0,1600),xlim=c(0,500),
     ylab="Weight (g)",xlab="Fork Length (mm)",pch=19)

plot(mass~fl,data=BullTroutRML1,ylim=c(0,1600),xlim=c(0,500),
     ylab="Weight (g)",xlab="Fork Length (mm)",pch=19)
# ############################################################
# == BEGIN -- REDUNDANT CODE, FOR BOOK PRINTING ONLY =========
plot(mass~fl,data=BullTroutRML1,ylim=c(0,1600),xlim=c(0,500),
     ylab="Weight (g)",xlab="Fork Length (mm)",
     pch=19,col=rgb(0,0,0,1/4))
# == END -- REDUNDANT CODE, FOR BOOK PRINTING ONLY ===========
# ############################################################

plot(mass~fl,data=BullTroutRML1,ylim=c(0,1600),xlim=c(0,500),
     ylab="Weight (g)",xlab="Fork Length (mm)",
     pch=19,col=rgb(0,0,0,1/4))

# select 6 individuals to illustrate the underlying process
( tmp <- BullTroutRML1[c(1:3,31:33),] )

pchs <- c(3,4)
cols <- c("black","gray60")

tmp$era

as.numeric(tmp$era)

cols[c(1,1,1,2,2,2)]
cols[as.numeric(tmp$era)]
cols[tmp$era]

plot(mass~fl,data=BullTroutRML1,ylim=c(0,1600),xlim=c(0,500),
     ylab="Weight (g)",xlab="Fork Length (mm)",
     pch=pchs[era],col=cols[era])

# ############################################################
# This code is a repeat of the code immediately above and
# below and is only used to efficiently produce the plot for
# the book.
plot(mass~fl,data=BullTroutRML1,ylim=c(0,1600),xlim=c(0,500),
     ylab="Weight (g)",xlab="Fork Length (mm)",
     pch=pchs[era],col=cols[era])
legend("topleft",inset=0.05,legend=levels(BullTroutRML1$era),
        pch=pchs,col=cols,bty="n",cex=0.75)
# ############################################################

plot(eggs~year,data=BloaterLH,type="l",lwd=2,xlab="Year",
     xlim=c(1980,1996),ylab="Number of Eggs (Millions)")

plot(eggs~year,data=BloaterLH,type="l",lwd=2,xlab="Year",
     xlim=c(1980,1996),ylab="Number of Eggs (Millions)")
# ############################################################
# == BEGIN -- REDUNDANT CODE, FOR BOOK PRINTING ONLY =========
plot(eggs~year,data=BloaterLH,type="l",lwd=2,col="gray70",
     ylab="Number of Eggs (Millions)",xlab="Year",
     xlim=c(1980,1996))
points(eggs~year,data=BloaterLH,pch=19,cex=0.75)
# == END -- REDUNDANT CODE, FOR BOOK PRINTING ONLY ===========
# ############################################################

plot(eggs~year,data=BloaterLH,type="l",lwd=2,col="gray70",
     ylab="Number of Eggs (Millions)",xlab="Year",
     xlim=c(1980,1996))
points(eggs~year,data=BloaterLH,pch=19,cex=0.75)

sumBT <- BullTroutRML2 %>% group_by(age) %>%
  summarize(n=validn(fl),mnlen=mean(fl,na.rm=TRUE),
            selen=se(fl,na.rm=TRUE)) %>%
  as.data.frame()
head(sumBT,n=3)

plot(fl~age,data=BullTroutRML2,pch=19,col=rgb(0,0,0,1/3),
     ylab="Fork Length (mm)",xlab="Age (yrs)")
lines(mnlen~age,data=sumBT,lwd=2)

hist(~mass,data=BullTroutRML1,xlab="Weight (g)",
     ylim=c(0,50),xlim=c(0,1600))

hist(~mass,data=BullTroutRML1,xlab="Weight (g)",
     ylim=c(0,50),xlim=c(0,1600))
# ############################################################
# == BEGIN -- REDUNDANT CODE, FOR BOOK PRINTING ONLY =========
range(BullTroutRML1$mass,na.rm=TRUE)
hist(~mass,data=BullTroutRML1,xlab="Weight (g)",
     xlim=c(0,1600),breaks=seq(0,1600,100))
# == END -- REDUNDANT CODE, FOR BOOK PRINTING ONLY ===========
# ############################################################

range(BullTroutRML1$mass,na.rm=TRUE)
hist(~mass,data=BullTroutRML1,xlab="Weight (g)",
     xlim=c(0,1600),breaks=seq(0,1600,100))

hist(mass~era,data=BullTroutRML1,xlab="Weight (g)",ymax=35,
     breaks=seq(0,1600,100),pre.main="Era = ",cex.main=0.9)

( eraBT <- xtabs(~era,BullTroutRML1) )

barplot(eraBT,ylab="Number of Fish",xlab="Era",ylim=c(0,120))

plotH(mnlen~age,data=sumBT,ylim=c(0,600),
      ylab="Mean Fork Length (mm)",xlab="Age (years)")

BullTroutRML1 %<>% mutate(logw=log(mass),logl=log(fl))
lm1 <- lm(logw~logl,data=BullTroutRML1)              # fit SLR

( rng <- range(BullTroutRML1$logl) )
xs <- seq(rng[1],rng[2],length.out=99)

( ps <- coef(lm1) )

ys <- ps[["(Intercept)"]]+ps[["logl"]]*xs

plot(logw~logl,data=BullTroutRML1,pch=19,col=rgb(0,0,0,1/4),
     ylab="Log Weight (g)",xlab="Log Length (mm)")
lines(ys~xs,lwd=2)
# ############################################################
# == BEGIN -- REDUNDANT CODE, FOR BOOK PRINTING ONLY =========
# range of observed fork lengths
rng <- range(BullTroutRML1$fl)
# vector of 99 fork lengths
xs <- seq(rng[1],rng[2],length.out=99)
# vector of 99 predicted weights at each fork length
ys <- exp(ps[["(Intercept)"]])*xs^ps[["logl"]]
# plot the points
plot(mass~fl,data=BullTroutRML1,pch=19,col=rgb(0,0,0,1/4),
     ylab="Weight (g)",xlab="Length (mm)")
# superimpose the curve
lines(ys~xs,lwd=2)
# == END -- REDUNDANT CODE, FOR BOOK PRINTING ONLY ===========
# ############################################################

# range of observed fork lengths
rng <- range(BullTroutRML1$fl)
# vector of 99 fork lengths
xs <- seq(rng[1],rng[2],length.out=99)
# vector of 99 predicted weights at each fork length
ys <- exp(ps[["(Intercept)"]])*xs^ps[["logl"]]
# plot the points
plot(mass~fl,data=BullTroutRML1,pch=19,col=rgb(0,0,0,1/4),
     ylab="Weight (g)",xlab="Length (mm)")
# superimpose the curve
lines(ys~xs,lwd=2)

plot(mass~fl,data=BullTroutRML1,pch=19,col=rgb(0,0,0,1/4),
     ylab="Weight (g)",xlab="Length (mm)")
curve(exp(ps[["(Intercept)"]])*x^ps[["logl"]],add=TRUE,
      from=rng[1],to=rng[2],lwd=2)

conf.level <- 0.95
tcrit <- qt(0.5+conf.level/2,df=sumBT$n-1)

sumBT %<>% mutate(LCI=mnlen-tcrit*selen,UCI=mnlen+tcrit*selen)
headtail(sumBT,n=2)

plotCI(sumBT$age,sumBT$mnlen,
       li=sumBT$LCI,ui=sumBT$UCI,pch=19,cex=0.7,
       xlab="Age (yrs)",ylab="Fork Length (mm)")

par()[1:4]  # only 4 to save space (remove [1:4] to see all)

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
# Constructs the plot of par options
op <- par(mar=c(5.1,4.1,4.1,2.1),mgp=c(3,1,0),oma=c(0,0,0,0),
          tcl=-0.5,las=0,cex.lab=1,cex.axis=1)

X <- Y <- 0:8
plot(Y~X,type="n",xaxt="n",yaxt="n")
box("plot", col="black",lwd=2)

txtclr <- "gray20"
text(4,4,"Plot Area",col="gray20",cex=2)
mtext(paste("line =",0:4),side=1,adj=0,line=0:4,col=txtclr)
axis(1,at=2:8)
mtext(paste("line =",0:3),side=2,adj=0,line=0:3,col=txtclr)
axis(2,at=3:8)
axis(2,at=c(4,6,8))
mtext(paste("line =",0:3),side=3,adj=1,line=0:3,col=txtclr)
mtext(paste("line =",0:1),side=4,adj=1,line=0:1,col=txtclr)

par(op)
# == END -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ============
# ############################################################

par(xaxs="i",yaxs="i",xpd=TRUE)
plot(mass~fl,data=BullTroutRML1,pch=19,col=rgb(0,0,0,1/4),
     ylab="Weight (g)",xlab="Length (mm)")

par(font.lab=2,font.axis=4,family="sans")
plot(mass~fl,data=BullTroutRML1,
     ylab="Mass (g)",xlab="Fork Length (mm)",
     ylim=c(0,1600),xlim=c(0,500),pch=19,col=rgb(0,0,0,1/4))

par(font.lab=2,font.axis=4,family="sans")
plot(mass~fl,data=BullTroutRML1,
     ylab="Mass (g)",xlab="Fork Length (mm)",
     ylim=c(0,1600),xlim=c(0,500),pch=19,col=rgb(0,0,0,1/4))
axis(1,c(200,400))

plot(selen~mnlen,data=sumBT,pch=19,col=rgb(0,0,0,1/2),
     ylab="SE Fork Length (mm)",xlab="Mean Fork Length (mm)",
     xlim=c(0,500),ylim=c(0,40))
text(c(225,300),c(35,3),c("Parabolic Shape?","Why Low?"))

plot(selen~mnlen,data=sumBT,pch=19,col="white",
     ylab="SE Fork Length (mm)",xlab="Mean Fork Length (mm)",
     xlim=c(0,500),ylim=c(0,40))
text(sumBT$mnlen,sumBT$selen,sumBT$age,cex=0.8)

plot(selen~mnlen,data=sumBT,pch=19,col=rgb(0,0,0,1/2),
     ylab="SE Fork Length (mm)",xlab="Mean Fork Length (mm)",
     xlim=c(0,500),ylim=c(0,40))
text(sumBT$mnlen,sumBT$selen,sumBT$age,pos=3,cex=0.8)

# ############################################################
# This code is repeated from above and is only needed when
# producing the book.
plot(selen~mnlen,data=sumBT,pch=19,col="white",
     ylab="SE Fork Length (mm)",xlab="Mean Fork Length (mm)",
     xlim=c(0,500),ylim=c(0,40))
text(sumBT$mnlen,sumBT$selen,sumBT$age,cex=0.8)
plot(selen~mnlen,data=sumBT,pch=19,col=rgb(0,0,0,1/2),
     ylab="SE Fork Length (mm)",xlab="Mean Fork Length (mm)",
     xlim=c(0,500),ylim=c(0,40))
text(sumBT$mnlen,sumBT$selen,sumBT$age,pos=3,cex=0.8)
# ############################################################

par(mfrow=c(1,2))
plot(mass~fl,data=BullTroutRML1,
     ylab="Mass (g)",xlab="Fork Length (mm)",
     ylim=c(0,1600),xlim=c(80,500),pch=19,col=rgb(0,0,0,1/4))
hist(~fl,data=BullTroutRML1,xlab="Fork Length (mm)",
     breaks=seq(80,500,10))


# Script created at 2015-11-02 12:54:56
