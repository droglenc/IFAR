# User must set working directory appropriately.

##############################################################
# == BEGIN -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
# 
# Setup of knitr
source("../../rhelpers/knitr_setup.R")
# declare packages used
rqrd <- c("FSA","dplyr","car","captioner","knitr")
# setup figure, table, and equation captioning
library(captioner)
figcaps <- captioner(prefix="Figure")
figcaps("FullResidPlot","Modified residual plot (Left) and histogram of residuals (Right) from fitting a dummy variable regression to the log-transformed weights and lengths of Ruffe captured in 1990, 1995, and 2000.")

tabcaps <- captioner(prefix="Table")

eqncaps <- captioner(prefix="Equation")
eqncaps("FullModel")
# == END -- NOT SHOWN IN SUPPLEMENT, FOR PRINTING ONLY =====
##############################################################

library(FSA)
library(dplyr)
library(car)

ruf <- read.csv("RuffeSLRH.csv") %>%
  filterD(month==7, year %in% c(1990,1995,2000)) %>%
  mutate(fYear=factor(year),logW=log10(wt),logL=log10(tl)) %>%
  select(-fishID,-month,-day)
headtail(ruf)

fit1 <- lm(logW~logL*fYear,data=ruf)

residPlot(fit1,legend=FALSE)

Anova(fit1)


# Script created at 2015-10-07 12:54:30
