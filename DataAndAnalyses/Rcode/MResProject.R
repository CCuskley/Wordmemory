library(ggplot2)
library(ggbeeswarm)
library(lme4)
library(tidyr)
library(lmerTest)
theme_set(theme_classic())


data =  read.csv('data/resultsWordsSept2021.csv')
data$StartCondition = as.factor(data$StartCondition )
data$ClumpCondition = as.factor(data$ClumpCondition )
data$WordFreq = as.factor(data$WordFreq )
data$OrderCondition = as.factor(data$OrderCondition )


mresresults = data

columns2use = c("ParticipantIdentifier", "Age","Condition"   ,
                "NativeSpeaker"   ,
                "Bilingual",            "Gender"  , "TimeToCompletion"  ,
                "CompletionDate"    ,    "File"  ,
                 "WordFreq"    ,          "AUROCnofit"   ,         "R"  ,
                "Rmin"   ,               "Rmax"     ,             "dprime" ,
                "dmin"      ,            "dmax"        ,          "AUROC" ,
                "logL"     ,             "StartCondition"  ,
                "OrderCondition" )
allresults = rbind(results[,columns2use],mresresults[,columns2use])

results_AllFreq = dplyr::filter(allresults,WordFreq=="AllFreq")
results_ByFreq = dplyr::filter(allresults,WordFreq!="AllFreq")

ggplot(data=results_AllFreq,aes(x=OrderCondition,y=AUROC))+ geom_boxplot(outlier.shape=NA)+ geom_quasirandom(aes(color=StartCondition) )
ggplot(data=results_AllFreq,aes(x=OrderCondition,y=dprime))+ geom_boxplot(outlier.shape=NA)+ geom_quasirandom(aes(color=StartCondition) )
ggplot(data=results_AllFreq,aes(x=OrderCondition,y=R))+ geom_boxplot(outlier.shape=NA)+ geom_quasirandom(aes(color=StartCondition) )


ggplot(data=results_ByFreq,aes(x=OrderCondition,y=AUROC,color=WordFreq))+ geom_boxplot(outlier.shape=NA)+ geom_quasirandom()
ggplot(data=results_ByFreq,aes(x=OrderCondition,y=R,color=WordFreq))+ geom_boxplot(outlier.shape=NA)+ geom_quasirandom()
ggplot(data=results_ByFreq,aes(x=OrderCondition,y=dprime,color=WordFreq))+ geom_boxplot(outlier.shape=NA)+ geom_quasirandom()


ggplot()+geom_freqpoly(data=results_AllFreq,
                       aes(x=R,y=..density..,color=OrderCondition),bins=30)

ggplot()+geom_freqpoly(data=results_ByFreq,
                       aes(x=R,y=..density..,color=WordFreq),bins=30)

m = lme4::glmer(AUROC ~ WordFreq + OrderCondition  + (1|ParticipantIdentifier),  data = results_ByFreq, family = Gamma(link=log))
print(summary(m))

m = lme4::glmer(R ~ WordFreq  + (1|ParticipantIdentifier),  data = results_ByFreq, family = Gamma(link=log))
print(summary(m))


