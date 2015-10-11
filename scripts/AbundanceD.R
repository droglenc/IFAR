# User must set working directory appropriately.

library(FSA)
library(dplyr)

# ############################################################
# == BEGIN -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ======
# Creates the plot that demonstrates Leslie and DeLury models.
# Set up hypothetical data
num <- 6                      # number of sampling times
t <- seq(1:num)               # sampling times
q <- 0.3                      # catchability coefficient
f <- rnorm(num,1,0.05)        # effort per sampling times -- slightly random for now
E <- c(0,cumsum(f)[-num])     # cumulative effort
N <- rep(6,num)               # population size
C <- rep(q*f[1]*N[1],num)     # catch in the time period
for (i in 2:num) {            # fill the vectors
  N[i] <- N[i-1] - C[i-1]     # population declines by catch
  C[i] <- q*f[i]*N[i]         # catch for period i
}
K <- c(0,cumsum(C)[-num])
K1 <- K + C/2
df <- data.frame(N=N,C=C,f=f,CPE=C/f,K=K,K1=K1,E=E)     # make a conglomerative data.frame
rm(N); rm(C); rm(f); rm(K); rm(K1); rm(E); rm(t); rm(q)

# Leslie Model
lm.leslie1 <- lm(CPE~K,data=df)  # Traditional Method
q <- -coef(lm.leslie1)[2]
qN0 <- coef(lm.leslie1)[1]
N0 <- qN0/q
plot(CPE~K,data=df,ylim=c(0,1.1*max(df$CPE)),xlim=c(0,1.1*N0),ylab="CPE",
     xlab="Cumulative Catch",col="white",
     xaxt="n",yaxt="n",xaxs="i",yaxs="i")
abline(lm.leslie1,lwd=1,col="gray70")
points(CPE~K,data=df,pch=19,xpd=TRUE)
axis(2,c(0,max(df$CPE)),c(0,expression(qN[0])))
axis(1,c(0,N0),c(0,expression(N[0])))
pK <- c(1,2)
pC <- predict(lm.leslie1,data.frame(K=pK))
lines(c(pK[2],pK[1]),c(pC[1],pC[1]),lty=2)
lines(c(pK[2],pK[2]),c(pC[1],pC[2]),lty=2)
text(mean(pK),pC[1],"1",pos=3,offset=0.25)
text(pK[2],pC[2]-diff(pC)/2,"q",offset=0.25,pos=4)

# DeLury Model
lm.delury1 <- lm(log(CPE)~E,data=df)  # Traditional Method
q <- -coef(lm.delury1)[2]
qN0 <- exp(coef(lm.delury1)[1])
N0 <- qN0/q
plot(log(CPE)~E,data=df,ylab="log(CPE)",xlab="Cumulative Effort",
     col="white",xaxt="n",yaxt="n",xaxs="i",yaxs="i")
abline(lm.delury1,lwd=1,col="gray70")
points(log(CPE)~E,data=df,pch=19,xpd=TRUE)
axis(2,c(0,max(log(df$CPE))),c(0,expression(paste("log(",q,N[0],")"))))
axis(1,0)
pE <- c(1,2)
pC <- predict(lm.delury1,data.frame(E=pE))
lines(c(pE[2],pE[1]),c(pC[1],pC[1]),lty=2)
lines(c(pE[2],pE[2]),c(pC[1],pC[2]),lty=2)
text(mean(pE),pC[1],"1",pos=3,offset=0.25)
text(pE[2],pC[2]-diff(pC)/2,"q",offset=0.25,pos=4)
# == END -- NOT SHOWN IN BOOK, FOR BOOK PRINTING ONLY ========
# ############################################################

mac <- data.frame(catch=c(7,7,4,1,2,1),
                  effort=c(10,10,10,10,6,10)) %>%
  mutate(cpe=catch/effort,K=pcumsum(catch),
         logcpe=log(cpe),E=pcumsum(effort))
mac

lm1 <- lm(cpe~K,data=mac)
( cf1 <- coef(lm1) )
( q.hat1 <- -cf1[["K"]] )
( N0.hat1 <- cf1[["(Intercept)"]]/q.hat1 )

lm2 <- lm(logcpe~E,data=mac)
( cf2 <- coef(lm2) )
( q.hat2 <- -cf2[["E"]] )
( N0.hat2 <- exp(cf2[["(Intercept)"]])/q.hat2 )

d2 <- depletion(mac$catch,mac$effort)

cbind(summary(d2),confint(d2))

plot(d2)

ct <- c(187,77,35)

pr1 <- removal(ct)
cbind(summary(pr1),confint(pr1))

(df <- data.frame(sta=c("MU10","MU13","MU27"),
                  p1=c(19,75,20),p2=c(14,19,11),p3=c(9,5,3)) )

res <- apply(df[,-1],MARGIN=1,FUN=removal,just.ests=TRUE)

( res <- data.frame(sta=df$sta,t(res)) )

 M1 <- removal(ct,method="Moran")
 S1 <- removal(ct,method="Schnute")
( teststat <- 2*(M1$min.nlogLH-S1$min.nlogLH) )
pchisq(teststat,df=1,lower.tail=FALSE)


# Script created at 2015-10-11 12:35:17
