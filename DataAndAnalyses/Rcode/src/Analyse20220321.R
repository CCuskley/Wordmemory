   rm(list=ls())
library(ggplot2)
library(ggbeeswarm)
library(lme4)
library(tidyr)
library(lmerTest)
library(dplyr)

theme_set(theme_classic())

# Load in MRes data: SampleB
SampleB =  read.csv('../data/resultsWordsSept2021.csv')
SampleB$Sample = "B"
SampleB$ClumpCondition = NULL # duplicates OrderCondition

# Load in original dataset:
SampleA = read.csv("../output/results.csv")
SampleA$Sample = "A"
SampleA$WorkerType = NULL # not present in B

# Combine
results = rbind(SampleA,SampleB)

# Decided not to filter in this way:
##results = filter(results,NativeSpeaker=="TRUE")
##results = filter(results,TimeToCompletion>15)

# Pre-processing
# Make unknown things NA for easier exclusion
results[results=="unknown"]=NA
results[results=="other"]=NA
# Make things factors that need to be:
results$Gender = as.factor(results$Gender )
results$StartCondition = as.factor(results$StartCondition )
results$Bilingual = as.factor(results$Bilingual )
results$NativeSpeaker = as.factor(results$NativeSpeaker )
results$WordFreq = as.factor(results$WordFreq )
results$OrderCondition = as.factor(results$OrderCondition )
results$Sample = as.factor(results$Sample )

# Some initial processing. First of all, logs can't cope with 0s so replace these:
cutoff = 1e-2
results$dprime[results$dprime<cutoff] = cutoff
results$R[results$R<cutoff] = cutoff



# Make a normalised AUROC
results$AUROCnorm = 2*(results$AUROC-0.5)
results$AUROCnorm[results$AUROCnorm<0]=0.1
# Our fitted AUROC should of course already be positive, but it ends up being -6.3342e-05 for some fits,
# I'm assuming due to rounding error etc.
# We will also be fitting separately for fits done using all data vs using subsets
results_AllFreq = results[results$WordFreq=="AllFreq",]
results_ByFreq = results[results$WordFreq!="AllFreq",]

results_ByFreq$WordFreq = factor(results_ByFreq$WordFreq,levels=c("HiFreq","LoFreq"),labels=c("High-frequency words","Low-frequency words"))


######################################################################
results_AllFreq %>% dplyr::group_by(Sample) %>%
    dplyr::summarise(n=n(),pFemale = sum(Gender=="female",na.rm=TRUE)/n(),meanAge = mean(Age,na.rm=TRUE) ,
                     meantime=mean(TimeToCompletion),mintime=min(TimeToCompletion),maxtime=max(TimeToCompletion),
                     pBi = sum(Bilingual=="TRUE",na.rm=TRUE)/n(),pNonNat=sum(NativeSpeaker!="TRUE",na.rm=TRUE)/n())

results_AllFreq %>% dplyr::group_by(Sample,OrderCondition) %>%
    dplyr::summarise(n=n(),pFemale = sum(Gender=="female",na.rm=TRUE)/n(),meanAge = mean(Age,na.rm=TRUE) ,
                     meantime=mean(TimeToCompletion),mintime=min(TimeToCompletion),maxtime=max(TimeToCompletion),
                     pBi = sum(Bilingual=="TRUE",na.rm=TRUE)/n(),pNonNat=sum(NativeSpeaker!="TRUE",na.rm=TRUE)/n())

# NSD in gender (amongst those for whom we know it)
chisq.test(results_AllFreq$Sample,results_AllFreq$Gender)
chisq.test(results_AllFreq$Sample,results_AllFreq$Bilingual)
chisq.test(results_AllFreq$Sample,results_AllFreq$NativeSpeaker)
# NSD in age
t.test(results_AllFreq$Age~results_AllFreq$Sample)

wilcox.test(results_AllFreq$TimeToCompletion~results_AllFreq$Sample)
t.test(results_AllFreq$TimeToCompletion~results_AllFreq$OrderCondition)

################################################################
# Look at results

g = ggplot(data=results_ByFreq,
       aes(y=log(dprime),x=OrderCondition,fill=Sample,shape=Sample))  +
    facet_wrap(~ WordFreq) +
    geom_violin(bw=0.2,position = "dodge",draw_quantiles = c(0.25,0.5,0.75)) +
    geom_quasirandom(position = "dodge",dodge.width = 0.8) +
    labs(x="Order Condition",y="Log Familiarity, dprime")
g
ggsave("DprimevsFreqByOrderSample.png",plot=g)
ggsave("DprimevsFreqByOrderSample.tiff",plot=g)

g = ggplot(data=results_ByFreq,
       aes(y=log(R),x=OrderCondition,fill=Sample,shape=Sample))  +
    facet_wrap(~ WordFreq) +
    geom_violin(bw=0.2,position = "dodge",draw_quantiles = c(0.25,0.5,0.75)) +
    geom_quasirandom(position = "dodge",dodge.width = 0.8) +
    labs(x="Order Condition",y="Log Recollection, log(R)")
g
ggsave("logRvsFreqByOrderSample.png",plot=g)
ggsave("logRvsFreqByOrderSample.tiff",plot=g)

# Stats:
# AUROC:
m = lme4::glmer(AUROC ~ WordFreq  + (1|ParticipantIdentifier),  data = results_ByFreq, family = Gamma(link=log))
print(summary(m))
# dprime:
m = lme4::glmer(dprime ~ WordFreq  + (1|ParticipantIdentifier),  data = results_ByFreq, family = Gamma(link=log))
print(summary(m))
# R:
m = lme4::glmer(R ~ WordFreq  + (1|ParticipantIdentifier),  data = results_ByFreq, family = Gamma(link=log))
print(summary(m))




m = glm(AUROC ~  TimeToCompletion , data = filter(results_AllFreq,TimeToCompletion<45), family = Gamma(link=log))
print(summary(m))