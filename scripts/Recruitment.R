# User must set working directory appropriately.

library(FSA)
library(car)      # Before dplyr to reduce conflicts with MASS
library(dplyr)
library(magrittr)
library(plotrix)
library(nlstools)
library(lsmeans)

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, BOOK PRINTING ONLY ==========
# Construct plot that illustrates the variablility in natural
# # stock-recruit data.  All data are found in the FSAdata
# # package.
clr <- rgb(0,0,0,0.5)
library(FSAdata)
data(VendaceLP)
par(mar=c(3.05,3.05,0.65,0),mgp=c(1.9,0.3,0),tcl=-0.2,las=1,cex.lab=0.95,cex.axis=0.9)
plot(recruits~year,data=VendaceLP,type="l",lwd=1.5,xlab="Year",ylab="Age-0+ Fish per ha",yaxt="n")
axis(2,at=seq(0,3000,500),labels=c(0,NA,1000,NA,2000,NA,3000))
par(mar=c(3.05,1.05,0.65,2),pch=19)
plot(recruits~stock,data=VendaceLP,xlab="Age-1+ Fish Biomass (kg/ha)",ylab="",yaxt="n",cex=0.9,col=clr)
axis(2,seq(0,3000,500),NA)
axis(1,c(10,14)); axis(1,12)
text(15.8,1500,"Vendace",srt=270,xpd=TRUE,cex=1.05)

data(YPerchSB)
YPerchSB %<>% filter(!is.na(recruits),!is.na(stock))
par(mar=c(3.05,3.05,0.65,0))
plot(recruits~year,data=YPerchSB,type="l",lwd=1.5,xlab="Year",ylab="Recruits (Number per Set)",yaxt="n",ylim=c(0,50),xlim=c(1950,1981.4))
axis(2,at=seq(0,50,10))
par(mar=c(3.05,1.05,0.65,2),pch=19)
plot(recruits~stock,data=YPerchSB,xlab="Spawners (Number per Set)",yaxt="n",cex=0.9,col=clr,ylim=c(0,50))
axis(2,seq(0,50,10),NA)
text(108,25,"Yellow Perch",srt=270,xpd=TRUE,cex=1.05)

data(ChinookKR)
ChinookKR %<>% mutate(aspawners=spawners/1000,
                      arecruits=recruits/1000) %>%
  filter(brood.year<2001)
par(mar=c(3.05,3.05,0.65,0))
plot(arecruits~brood.year,data=ChinookKR,type="l",lwd=1.5,xlab="Year",ylab="Number of Recruits (1000s)",yaxt="n",ylim=c(0,400),xlim=c(1979,2001))
axis(2,at=seq(0,400,50),labels=c(0,NA,100,NA,200,NA,300,NA,400))
par(mar=c(3.05,1.05,0.65,2),pch=19)
plot(arecruits~aspawners,data=ChinookKR,xlab="Number of Spawners (1000s)",yaxt="n",ylim=c(0,400),xaxt="n",xlim=c(0,165),cex=0.9,col=clr)
axis(2,at=seq(0,400,50),labels=NA)
axis(1,at=seq(0,200,50),)
text(185,200,"Chinook Salmon",srt=270,xpd=TRUE,cex=1.05)
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

pinks <- read.csv("PSalmonAK.csv") %>%
  filter(!is.na(esc),!is.na(ret)) %>%
  mutate(esc=esc/1000,ret=ret/1000,logret=log(ret))
headtail(pinks)

clrs <- c("black","gray50","gray80")
S <- seq(0.1,5000,length.out=199)
a <- 1
b <- c(0.001,0.002,0.007)
R <- matrix(nrow=length(S),ncol=length(b))
for(i in 1:length(b)) R[,i] <- (a*S)/(1+b[i]*S)
plot(R[,1]~S,type="l",lwd=2,xlab="Spawners",ylab="Recruits",ylim=c(0,1000))
lines(R[,2]~S,lwd=2,col=clrs[2])
lines(R[,3]~S,lwd=2,col=clrs[3])
RperS <- R/S
plot(RperS[,1]~S,type="l",lwd=2,xlab="Spawners",ylab="Recruits per Spawner",ylim=c(0,max(RperS)))
lines(RperS[,2]~S,lwd=2,col=clrs[2])
lines(RperS[,3]~S,lwd=2,col=clrs[3])
legend("topright",legend="Beverton-Holt",bty="n",cex=1.1)

a <- 1
b <- c(0.0012,0.0008,0.0005)
R <- matrix(nrow=length(S),ncol=length(b))
for(i in 1:length(b)) R[,i] <- (a*S)*exp(-b[i]*S)
plot(R[,1]~S,type="l",lwd=2,xlab="Spawners",ylab="Recruits",ylim=c(0,1000))
lines(R[,2]~S,lwd=2,col=clrs[2])
lines(R[,3]~S,lwd=2,col=clrs[3])
RperS <- R/S
plot(RperS[,1]~S,type="l",lwd=2,xlab="Spawners",ylab="Recruits per Spawner",ylim=c(0,max(RperS)))
lines(RperS[,2]~S,lwd=2,col=clrs[2])
lines(RperS[,3]~S,lwd=2,col=clrs[3])
legend("topright",legend="Ricker",bty="n",cex=1.1)

a <- 1
b <- 0.001
c <- c(0.85,1,2)
R <- matrix(nrow=length(S),ncol=length(c))
for(i in 1:length(c)) R[,i] <- (a*S)/(1+(b*S)^c[i])
plot(R[,1]~S,type="l",lwd=2,xlab="Spawners",ylab="Recruits",ylim=c(0,1000))
lines(R[,2]~S,lwd=2,col=clrs[2])
lines(R[,3]~S,lwd=2,col=clrs[3])
text(3000,950,"c<1")
text(4000,720,"c=1")
text(4000,330,"c>1")
RperS <- R/S
plot(RperS[,1]~S,type="l",lwd=2,xlab="Spawners",ylab="Recruits per Spawner",ylim=c(0,max(RperS)))
lines(RperS[,2]~S,lwd=2,col=clrs[2])
lines(RperS[,3]~S,lwd=2,col=clrs[3])
legend("topright",legend="Shepherd",bty="n",cex=1.1)

( svR <- srStarts(ret~esc,data=pinks,type="Ricker") )

rckr <- srFuns("Ricker")
rckr(S=2,a=2.8,b=0.6)      # parameters separate
rckr(S=2,a=c(2.8,0.6))     # parameters in one vector

srR <- nls(logret~log(rckr(esc,a,b)),data=pinks,start=svR)

cbind(estimates=coef(srR),confint(srR))

bootR <- nlsBoot(srR)
cbind(estimates=coef(srR),confint(bootR))

rckr(S=2,a=coef(srR))

pR <- apply(bootR$coefboot,MARGIN=1,FUN=rckr,S=2)
quantile(pR,c(0.025,0.975))

ind <- srFuns("independence")
svI <- srStarts(ret~esc,data=pinks,type="independence")
srI <- nls(logret~log(ind(esc,a)),data=pinks,start=svI)

extraSS(srI,com=srR)

cor(rckr(pinks$esc,a=coef(srR)),pinks$ret)^2

x <- seq(0,9,length.out=199)        # many S for prediction
pR <- rckr(x,a=coef(srR))           # predicted mean R
LCI <- UCI <- numeric(length(x))

for(i in 1:length(x)) {             # CIs for mean R @ each S
  tmp <- apply(bootR$coefboot,MARGIN=1,FUN=rckr,S=x[i])
  LCI[i] <- quantile(tmp,0.025)
  UCI[i] <- quantile(tmp,0.975)
}
ylmts <- range(c(pR,LCI,UCI,pinks$ret))
xlmts <- range(c(x,pinks$esc))

plot(ret~esc,data=pinks,xlim=xlmts,ylim=ylmts,col="white",
     ylab="Returners (millions)",
     xlab="Escapement (millions)")
polygon(c(x,rev(x)),c(LCI,rev(UCI)),col="gray80",border=NA)
points(ret~esc,data=pinks,pch=19,col=rgb(0,0,0,1/2))
lines(pR~x,lwd=2)

rckr2 <- function(S,X,a,b=NULL,c=NULL) {
  if (length(a)>1) { # all values in a argument
    c <- a[3]
    b <- a[2]
    a <- a[1]
  }
  a*S*exp(-b*S+c*X)
}

rckr2(2,12,c(0.003,0.09,0.6)) # Example calculation

tmp <- lm(log(ret/esc)~esc+SST,data=pinks)
tmp <- coef(tmp)
svR2 <- list(a=exp(tmp[[1]]),b=-tmp[[2]],c=tmp[[3]])

srR2 <- nls(logret~log(rckr2(esc,SST,a,b,c)),
            data=pinks,start=svR2)

extraSS(srI,srR,com=srR2)
cor(rckr2(pinks$esc,pinks$SST,a=coef(srR2)),pinks$ret)^2

coef(srR2)

max_age <- 10
pr_mat <- c(0,0.25,0.75,1,1,1,1,1,1,1)
fec <- c(0,31,53,106,160,213,266,319,373,426)

M <- 0.3
n_mort <- rep(M,max_age)
F <- 0
f_mort <- rep(0,max_age)

s_ann <- exp(-(n_mort+f_mort))

s_cum <- cumprod(s_ann)

P_noF_i <- pr_mat*fec*s_cum

round(cbind(age=1:max_age,pr_mat,fec,n_mort,f_mort,
            s_ann,s_cum,P_noF_i),3)

( P_noF <- sum(P_noF_i) )

F <- 0.6
sel <- c(0,0,0.5,1,1,1,1,1,1,1)
( f_mort <- F*sel )

s_ann <- exp(-(n_mort+f_mort))
s_cum <- cumprod(s_ann)
( P_F <- sum(pr_mat*fec*s_cum) )

SPR <- function(M,F,E,mu,sel) {
  # vector of mortality rates
  M <- rep(M,length(E))
  # P for the fished and unfished scenarioes
  P_fish <- sum(mu*E*cumprod(exp(-(M+sel*F))))
  P_unfish <- sum(mu*E*cumprod(exp(-M)))
  # Compute and return SPR value
  P_fish/P_unfish
}

# check function with same values used in previous section
SPR(M=0.3,F=0.6,E=fec,mu=pr_mat,sel=sel)

Ms <- seq(0.01,1,0.01)
Fs <- seq(0.01,1,0.01)

SPRs <- matrix(nrow=length(Ms),ncol=length(Fs),
               dimnames=list(Ms,Fs))

for(i in 1:length(Ms))
  for(j in 1:length(Fs))
    SPRs[i,j] <- SPR(M=Ms[i],F=Fs[j],E=fec,mu=pr_mat,sel=sel)

SPRs[1:5,1:5]

contour(x=Ms,y=Fs,z=SPRs,levels=seq(0,1,0.1),lwd=2,
        method="edge",labcex=0.7,
        xlim=c(0,1),ylim=c(0,1),xlab="Natural Mortality (M)",
        ylab="Fishing Mortality (F)")

contour(x=Ms,y=Fs,z=SPRs,levels=seq(0,1,0.1),lwd=2,
        method="edge",labcex=0.7,
        xlim=c(0,1),ylim=c(0,1),xlab="Natural Mortality (M)",
        ylab="Fishing Mortality (F)")
abline(v=0.3,lwd=2,lty="dashed",col="gray50")

tmp <- SPRs["0.3",]

tmp>=0.4   # only first three rows shown

tmp2 <- tmp>=0.4
tmp2[1:30]

pos <- which.min(tmp>=0.4)
colnames(SPRs)[pos-1]

wae1yr <- read.csv("WalleyeWyrlng.csv") %>%
  mutate(cpe=yearlings/tows,scpe=scale(cpe))
headtail(wae1yr)

plot(scpe~yrclass,data=wae1yr,type="h",lwd=4,lend=1,
     xaxt="n",xlab="Year-Class",ylab="Standardized CPE")
axis(1,at=wae1yr$yrclass,labels=NA,tcl=-0.1)
axis(1,at=seq(1985,2005,5),las=2)
abline(h=0)

wae <- read.csv("WalleyeWad.csv")
headtail(wae)

cc1 <- catchCurve(numF~age,data=wae,ages2use=5:19,
                  weighted=TRUE)

res <- data.frame(age=cc1$age.e,yrclass=2010-cc1$age.e,
                  ycs=rstudent(cc1$lm))
headtail(res,n=2)

( critres <- qt(c(0.20,0.80),df=length(res$ycs)-1) )

plot(ycs~yrclass,data=res,type="h",lwd=4,lend=1,xaxt="n",
     xlab="Year Class",ylab="Studentized Residual")
axis(1,at=res$yrclass[!is.na(res$ycs)],labels=NA,tcl=-0.1)
axis(1,at=c(1991,1996,2000,2004),las=2)
abline(h=0)
abline(h=critres,lty="dashed")

d <- read.csv("SturgeonGB.csv") %>%
  group_by(year,age) %>%
  summarize(catch=n()) %>%
  as.data.frame() %>%
  mutate(yrclass=year-age)
headtail(d)

print(xtabs(~yrclass+age,data=d),zero.print="-")

d %<>% rbind(c(2012,11,0,2001),c(2010,2,0,2008))
tail(d,n=3)

eff <- data.frame(year=c(2010,2011,2012),effort=c(23,22,27))
d %<>% left_join(eff,by="year")
headtail(d)

d %<>% mutate(cpe=(catch+1)/effort,logcpe=log(cpe))
headtail(d)

d %<>% mutate(age=as.factor(age),yrclass=as.factor(yrclass))

lm1 <- lm(logcpe~age+yrclass,data=d)
Anova(lm1)

yc.lsm <- lsmeans(lm1,~yrclass)
( yce <- summary(yc.lsm) )

with(yce,plotCI(fact2num(yrclass),lsmean,
                li=lower.CL,ui=upper.CL,pch=19,cex=0.7,
                xlab="Year-Class",ylab="Strength Index"))
with(yce,lines(fact2num(yrclass),lsmean))

residPlot(lm1,bp=FALSE)


# Script created at 2015-11-02 12:54:59
