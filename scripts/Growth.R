# User must set working directory appropriately.

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
# Load required packages used only to produce the book
library(gdata)      # for upperTriangle()
library(fMultivar)  # for 3-D plotting
library(xtable)     # for xtable()

# Set random seed to keep bootstrap results constant
set.seed(14354454)
# == END -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ============
# ############################################################

library(FSA)
library(magrittr)
library(dplyr)
library(nlstools)

bdmf <- read.csv("BlackDrum2001.csv") %>%
  filterD(otoage<50,sex %in% c("male","female")) %>%
  select(-c(spname,day,weight))
headtail(bdmf,n=2)
bdm <- filterD(bdmf,sex=="male")

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
# Constructs the plot that shows the VBGF parameters.
# Typical parameterization
vbT <- vbFuns("typical",simple=FALSE)
fitT <- nls(tl~vbT(otoage,Linf,K,t0),data=bdm,start=vbStarts(tl~otoage,data=bdm,type="typical"))
sumT <- summary(fitT,correlation=TRUE)
coefT <- coef(fitT)

# set point transparency ... make light to make function and params more obvious
pclr <- rgb(0,0,0,1/3)
# set some plot limits
xlmts <- c(-2,25)
ylmts <- c(-200,1315)
# set some adjusted plot limits (for xaxs="r")
xlmts2 <- c(-5,30)
ylmts2 <- c(-300,1400)
# plot the points without axes
plot(tl~otoage,data=subset(bdm,otoage<=xlmts[2]),pch=19,col=pclr,
     ylab="Total Length (mm)",yaxt="n",ylim=ylmts,xlim=xlmts,
     xlab="Age",xaxt="n")
# add the fitted curve
curve(vbT(x,Linf=coef(fitT)),from=xlmts[1],to=xlmts[2],lwd=2,add=TRUE)
# add the axes
axis(1,at=seq(0,20,10))
axis(2,at=seq(0,1000,500))
# add reference lines at zero on both axes
lines(xlmts2,c(0,0),col="gray50",lty=3)
lines(c(0,0),ylmts2,col="gray50",lty=3)
# Mark Linf on plot
Linf <- coef(fitT)[1]
lines(xlmts2,c(Linf,Linf),lwd=1,lty=5)
axis(2,at=Linf,labels=expression(L[infinity]),family="serif")
# Mark t0 on plot
t0 <- coef(fitT)[3]
lines(c(t0,t0),c(ylmts2[1],0),lwd=1,lty=5)
axis(1,at=t0,labels=expression(t[0]),family="serif")
# == END -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ============
# ############################################################

# ############################################################
# This code was not shown in the book.  It is used to
# construct the plot that illustrates the iterative nonlinear
# regression algorithm.
cntrs <- seq(-1.01,0.04,0.05)
# Make 3-D data
x <- seq(-3.5,3.5,0.05)
X <- grid2d(x)
z <- dnorm2d(X$x,X$y,rho=-0.4)
# flip and rescale z so that the min is -1
z <- -(z/max(z))
# put in a matrix
z <- matrix(z,ncol=length(x))
# put in a list for plotting with persp
Z <- list(x=x,y=x,z=z)

# Draw the 3-D perspective
par(mar=c(0.5,0.5,0.5,0.5))

# set some perspectives and colors
theta <- 0 # no twist
phi <- 50  # looking down
d <- 1
clr <- "gray90"
# draw first perspective
persp(Z,theta=theta,phi=phi,col=clr,box=FALSE,axes=FALSE,shade=1,border=NA,
      xlim=c(-3.3,3.3),zlim=c(-0.32,0),d=d)
# draw first contour
contour(x,x,z,xlim=c(-2.85,2.85),ylim=c(-2.85,2.85),bty="n",xaxt="n",yaxt="n",
        drawlabels=FALSE,col="gray50",levels=cntrs)
# First trace
xs <- c(-1.7,-1.3,-0.9,-0.6,-0.2,0)
ys <- c(-0.9,-0.5,-0.2,-0.05,0.025,0)
lines(xs,ys,lwd=2)
points(xs[-length(xs)],ys[-length(xs)],pch=19)
text(xs[1],ys[1],"#1",adj=c(+1.25,-0.25))
# Second trace
xs <- c(1.25,0.75,0.35,0)
ys <- c(0.2,-0.06,-0.06,0)
lines(xs,ys,lwd=2)
points(xs[-length(xs)],ys[-length(xs)],pch=19,col="white")
points(xs[-length(xs)],ys[-length(xs)],pch=1)
text(xs[1],ys[1],"#2",pos=4)
# Global minimum
points(0,0,pch=8,cex=1.25)
# ############################################################

( svTyp <- vbStarts(tl~otoage,data=bdm) )

# ############################################################
# This code is commented in the script because it requires
# interaction from the user.  Uncomment and run in an
# interactive session.

# vbStarts(tl~otoage,data=bdm,dynamicPlot=TRUE)
# ############################################################
svTyp <- list(Linf=1200,K=0.13,t0=-2.0)

# ############################################################
# This code was used only to demonstrate another method for
# identifying starting values.
svTyp <- list(Linf=max(bdm$tl,na.rm=TRUE),K=0.3,t0=0)
# ############################################################

vbTyp <- function(age,Linf,K,t0) Linf*(1-exp(-K*(age-t0)))

vbTyp(3,Linf=1200,K=0.13,t0=-2.0)

vbTyp <- vbFuns()
vbTyp(3,Linf=1200,K=0.13,t0=-2.0)    # this still works
vbTyp(3,Linf=c(1200,0.13,-2.0))      # but, now, so does this

fitTyp <- nls(tl~vbTyp(otoage,Linf,K,t0),data=bdm,start=svTyp)

coef(fitTyp)

confint(fitTyp)

bootTyp <- nlsBoot(fitTyp)
headtail(bootTyp$coefboot,n=2)

confint(bootTyp,plot=TRUE)

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
# Slight modification of the code above to control the color
# and "array" of plots.
confint(bootTyp,plot=TRUE,err.col="black",rows=1,cols=3)
# == END -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ============
# ############################################################

summary(fitTyp,correlation=TRUE)

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
sumT <- summary(fitTyp,correlation=TRUE)
# == END -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ============
# ############################################################

nd <- data.frame(otoage=c(3,10,20,30,40,42))
predict(fitTyp,nd)

vbTyp(c(3,10,20,30,40,42),coef(fitTyp))

vbTyp(3,bootTyp$coefboot[1,])

p3Typ <- apply(bootTyp$coefboot,MARGIN=1,FUN=vbTyp,t=3)
p3Typ[1:6]    # show predictions for first 6 bootstrap samples

quantile(p3Typ,c(0.025,0.975))

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
ci3Typ <- quantile(p3Typ,c(0.025,0.975))
# == END -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ============
# ############################################################

x <- seq(0,42,length.out=199)        # ages for prediction
pTyp <- vbTyp(x,Linf=coef(fitTyp))   # predicted lengths
xlmts <- range(c(x,bdm$age))
ylmts <- range(c(pTyp,bdm$tl))
plot(tl~otoage,data=bdm,xlab="Age",ylab="Total Length (mm)",
     xlim=xlmts,ylim=ylmts,pch=19,col=rgb(0,0,0,1/3))
lines(pTyp~x,lwd=2)

LCI <- UCI <- numeric(length(x))

for(i in 1:length(x)) {
  tmp <- apply(bootTyp$coefboot,MARGIN=1,FUN=vbTyp,t=x[i])
  LCI[i] <- quantile(tmp,0.025)
  UCI[i] <- quantile(tmp,0.975)
}

ylmts <- range(c(pTyp,LCI,UCI,bdm$tl))
plot(tl~otoage,data=bdm,xlab="Age",ylab="Total Length (mm)",
     xlim=xlmts,ylim=ylmts,pch=19,col=rgb(0,0,0,1/3))
lines(pTyp~x,lwd=2)
lines(UCI~x,lwd=2,lty="dashed")
lines(LCI~x,lwd=2,lty="dashed")

residPlot(fitTyp)

bdm %<>% mutate(logTL=log(tl))    # add log TL variable to bdm
fitTypM <- nls(logTL~log(vbTyp(otoage,Linf,K,t0)),
               data=bdm,start=svTyp)
residPlot(fitTypM)

vbLKt <- tl~Linf[sex]*(1-exp(-K[sex]*(otoage-t0[sex])))
vbLK  <- tl~Linf[sex]*(1-exp(-K[sex]*(otoage-t0)))
vbLt  <- tl~Linf[sex]*(1-exp(-K*(otoage-t0[sex])))
vbKt  <- tl~Linf*(1-exp(-K[sex]*(otoage-t0[sex])))
vbL   <- tl~Linf[sex]*(1-exp(-K*(otoage-t0)))
vbK   <- tl~Linf*(1-exp(-K[sex]*(otoage-t0)))
vbt   <- tl~Linf*(1-exp(-K*(otoage-t0[sex])))
vbO   <- tl~Linf*(1-exp(-K*(otoage-t0)))

( svO <- vbStarts(tl~otoage,data=bdmf) )

( svLKt <- Map(rep,svO,c(2,2,2)) )

fitLKt <- nls(vbLKt,data=bdmf,start=svLKt)
residPlot(fitLKt,col=rgb(0,0,0,1/3))

fitO <- nls(vbO,data=bdmf,start=svO)

lrt(fitO,com=fitLKt,com.name="All param differ",
    sim.names="No params differ")

extraSS(fitO,com=fitLKt,com.name="All param diff",
    sim.names="No param diff")

# ############################################################
# == BEGIN -- REDUNDANT CODE, FOR BOOK PRINTING ONLY =========
lrCG <- lrt(fitO ,com=fitLKt)
fCG <- extraSS(fitO ,com=fitLKt)
# == END -- REDUNDANT CODE, FOR BOOK PRINTING ONLY ===========
# ############################################################

( svLK <- Map(rep,svO,c(2,2,1)) )

svLt <- Map(rep,svO,c(2,1,2))
svKt <- Map(rep,svO,c(1,2,2))

fitLK <- nls(vbLK,data=bdmf,start=svLK)
fitLt <- nls(vbLt,data=bdmf,start=svLt)
fitKt <- nls(vbKt,data=bdmf,start=svKt)

lrt(fitLK,fitLt,fitKt,com=fitLKt,com.name="All param diff",
    sim.names=c("Linf,K diff","Linf,t0 diff","K,t0 diff"))

# ############################################################
# == BEGIN -- REDUNDANT CODE, FOR BOOK PRINTING ONLY =========
lrt2 <- lrt(fitLK,fitLt,fitKt,com=fitLKt,com.name="All param diff",
    sim.names=c("Linf,K diff","Linf,t0 diff","K,t0 diff"))
print(lrt2,digits=4,dig.tst=4)
# == END -- REDUNDANT CODE, FOR BOOK PRINTING ONLY ===========
# ############################################################

svL <- Map(rep,svO,c(2,1,1))
svt <- Map(rep,svO,c(1,1,2))
fitL <- nls(vbL,data=bdmf,start=svL)
fitt <- nls(vbt,data=bdmf,start=svt)
lrt(fitL,fitt,com=fitLt,com.name="Linf,t0 dif",
    sim.names=c("Linf dif","t0 dif"))

# ############################################################
# == BEGIN -- REDUNDANT CODE, FOR BOOK PRINTING ONLY =========
lrt1 <- lrt(fitL,fitt,com=fitLt)
# == END -- REDUNDANT CODE, FOR BOOK PRINTING ONLY ===========
# ############################################################

lrt(fitO,com=fitL,com.name="Linf dif",sim.names="No param dif")

svK <- Map(rep,svO,c(1,2,1))
fitK <- nls(vbK,data=bdmf,start=svK)

cbind(AIC(fitLKt,fitLK,fitLt,fitKt,fitL,fitK,fitt,fitO),
      BIC(fitLKt,fitLK,fitLt,fitKt,fitL,fitK,fitt,fitO))

vbTyp <- vbFuns("typical")
bdf <- filterD(bdmf,sex=="female")
fitf <- nls(tl~vbTyp(otoage,Linf,K,t0),data=bdf,start=svO)
bcf <- nlsBoot(fitf)
cbind(coef(fitf),confint(bcf))

bdm <- filterD(bdmf,sex=="male")
fitm <- nls(tl~vbTyp(otoage,Linf,K,t0),data=bdm,start=svO)
bcm <- nlsBoot(fitm)
cbind(coef=coef(fitm),confint(bcm))

# predictions for females
xf <- seq(min(bdf$otoage),max(bdf$otoage),length.out=199)
pf <- vbTyp(xf,Linf=coef(fitf))
# predictions for males
xm <- seq(min(bdm$otoage),max(bdm$otoage),length.out=199)
pm <- vbTyp(xm,Linf=coef(fitm))
xlmts <- range(c(xf,xm))
ylmts <- range(c(bdf$tl,bdm$tl))

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
# Needed in the script to get back to ungridded plots.
par(mfrow=c(1,1))
# == REDUNDANT FROM ABOVE ====================================
plot(tl~otoage,data=bdmf,xlab="Age",ylab="Total Length (mm)",
     xlim=xlmts,ylim=ylmts,col="white")
points(tl~otoage,data=bdf,pch=1,col=rgb(0,0,0,1/2),cex=0.8)
points(tl~otoage,data=bdm,pch=8,col=rgb(0,0,0,1/2),cex=0.8)
lines(pf~xf,lwd=2,lty="solid")
lines(pm~xm,lwd=2,lty="dashed")
legend("bottomright",c("Female","Male"),pch=c(1,8),
       lwd=2,lty=c("solid","dashed"),bty="n",cex=0.8)
# == END -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ============
# ############################################################

fitTyp <- nls(tl~vbTyp(otoage,Linf,K,t0),data=bdm,start=svTyp,
              control=list(maxiter=100,minFactor=1/5000))

fitTypP <- nls(tl~vbTyp(otoage,Linf,K,t0),data=bdm,
               start=svTyp,algorithm="port",
               lower=list(Linf=1000,K=0.05,t0=-4),
               upper=list(Linf=1400,K=0.30,t0=1))


# Script created at 2015-09-16 10:22:36
