library(ggplot2)
library(RColorBrewer)
library(ggridges)

salsa <- read.csv(file="~/constantentropy/memory/allWordsTogether.csv", header=T)
#salsa <- subset(salsa, WorkerType == "turker")
salsa <- subset(salsa, Age != "")
salsa <- subset(salsa, Age != "unknown")
salsa <- subset(salsa, Clump.Even != "")
salsa <- subset(salsa, TimeToCompletion != "NA")
salsa <- droplevels(salsa)

part <- read.csv(file="CurrentLx/newcastleModules/MRes/salsabila/0A_ParticipantInfo.csv", header=T)

salsa$Age <- as.numeric(as.character(salsa$Age))
salsa$TimeToCompletion <- as.numeric(as.character(salsa$TimeToCompletion))
salsa$R <- as.numeric(as.character(salsa$R))
salsa$dprime <- as.numeric(as.character(salsa$dprime))
salsa$AUROC <- as.numeric(as.character(salsa$AUROC))

salsa$Condition <- ifelse(salsa$Clump.Even == "Clump", "Clumped","Smooth")

'partInfo <- data.frame(salsa$ParticipantIdentifier,salsa$Age,salsa$Gender,salsa$Low.Start.High.Start,salsa$Clump.Even,salsa$NativeSpeaker,salsa$EngAoA,salsa$Bilingual,salsa$WorkerType,salsa$TimeToCompletion)

colnames(partInfo) <- c("Participant","Age","Sex","LowOrHighStart","ClumpedOrEven","NativeSpeaker","EngAoA","Bilingual","WorkerType","TimeToCompletion")

highlowrun <- read.csv(file="~/constantentropy/memory/highlowFull.csv", header=T)

highlowrun$File <- as.character(highlowrun$File)

#make another column for whether the run is on high or low freq words
pattern <- "^(.*)_responses_((low)|(high)).xlsx"
highlowrun$Frequency <- gsub(pattern,"\\2",highlowrun$File)

#make another column for participant id
highlowrun$Participant <- gsub(pattern,"\\1",highlowrun$File)

#merge the participant info from salsa with the highlowrun data
highlowFull <- merge(highlowrun, partInfo, by=c("Participant"))

salsa <- subset(salsa, Age != "" && Age != "unknown")

#salsa <- subset(salsa, Clump.Even != "")
#salsa <- droplevels(salsa)
highlowFull <- subset(highlowFull, Age != "unknown")
highlowFull <- subset(highlowFull, Age != "")
highlowFull <- subset(highlowFull, ClumpedOrEven != "")
highlowFull <- droplevels(highlowFull)


#salsa$Age <- as.numeric(as.character(salsa$Age))
#salsa$TimeToCompletion <- as.numeric(as.character(salsa$TimeToCompletion))
highlowFull$Age <- as.numeric(as.character(highlowFull$Age))
highlowFull$TimeToCompletion <- as.numeric(as.character(highlowFull$TimeToCompletion))
highlowFull$Frequency <- as.factor(highlowFull$Frequency)

write.csv(highlowFull, file="/Documents/highlowFull.csv", row.names = F)'

highlowFull <- read.csv(file="~/constantentropy/memory/highlowFull.csv", header=T)

####box plots
foo <- ggplot(highlowFull, aes(ClumpedOrEven, R, group=ClumpedOrEven)) + 
  scale_y_continuous(name = "Recollection Parameter") + 
  scale_x_discrete(name = "\nExperimental Condition") + 
  geom_point(alpha = 1/25) + 
  geom_boxplot(fill=c("purple","green","purple","green")) +
  #geom_jitter(width = 0.3) +
  facet_wrap(~Frequency) +
  theme_bw() + 
  theme(panel.border = element_blank())

ggsave(foo, file = "~/CurrentLx/newcastleModules/MRes/salsabila/recolHighLow.pdf", width = 8.09, height = 5)

foo <- ggplot(highlowFull, aes(ClumpedOrEven, dprime, group=ClumpedOrEven)) + 
  scale_y_continuous(name = "Familiarity Parameter (d\')") + 
  scale_x_discrete(name = "\nExperimental Condition") + 
  geom_point(alpha = 1/25) + 
  geom_boxplot(fill=c("purple","green","purple","green")) +
  #geom_jitter(width = 0.3) +
  facet_wrap(~Frequency) +
  theme_bw() + 
  theme(panel.border = element_blank())

ggsave(foo, file = "~/CurrentLx/newcastleModules/MRes/salsabila/dprimeHighLow.pdf", width = 8.09, height = 5)


foo <- ggplot(highlowFull, aes(ClumpedOrEven, AUROC, group=ClumpedOrEven)) + 
  scale_y_continuous(name = "Overall Performance (AUROC)") + 
  scale_x_discrete(name = "\nExperimental Condition") + 
  geom_point(alpha = 1/25) + 
  geom_boxplot(fill=c("purple","green","purple","green")) +
  #geom_jitter(width = 0.3) +
  facet_wrap(~Frequency) +
  theme_bw() + 
  theme(panel.border = element_blank())

ggsave(foo, file = "~/CurrentLx/newcastleModules/MRes/salsabila/aurocHighLow.pdf", width = 8.09, height = 5)


foo <- ggplot(salsa, aes(Condition, R, group=Condition)) + 
  scale_y_continuous(name = "Recollection Parameter") + 
  scale_x_discrete(name = "\nExperimental Condition") + 
  geom_point(alpha = 1/25) + 
  geom_boxplot(fill=c("purple","green")) +
  #geom_jitter(width = 0.3) +
  theme_bw() + 
  theme(panel.border = element_blank())

ggsave(foo, file = "~/CurrentLx/newcastleModules/MRes/salsabila/recol.pdf", width = 8.09, height = 5)

foo <- ggplot(salsa, aes(Condition, dprime, group=Condition)) + 
  scale_y_continuous(name = "Familiarity Parameter (d\')") + 
  scale_x_discrete(name = "\nExperimental Condition") + 
  geom_point(alpha = 1/25) + 
  geom_boxplot(fill=c("purple","green")) +
  #geom_jitter(width = 0.3) +
  theme_bw() + 
  theme(panel.border = element_blank())

ggsave(foo, file = "~/CurrentLx/newcastleModules/MRes/salsabila/dprime.pdf", width = 8.09, height = 5)

foo <- ggplot(salsa, aes(Condition, AUROC, group=Condition)) + 
  scale_y_continuous(name = "Overall Performance (AUROC)") + 
  scale_x_discrete(name = "\nExperimental Condition") + 
  geom_point(alpha = 1/25) + 
  geom_boxplot(fill=c("purple","green")) +
  #geom_jitter(width = 0.3) +
  theme_bw() + 
  theme(panel.border = element_blank())

ggsave(foo, file = "~/CurrentLx/newcastleModules/MRes/salsabila/auroc.pdf", width = 8.09, height = 5)

ggplot(salsa, aes(Clump.Even, TimeToCompletion, group=Clump.Even)) + 
  scale_y_continuous(name = "Time To Completion (mins)") + 
  scale_x_discrete(name = "\nExperimental Condition") + 
  geom_point(alpha = 1/25) + 
  geom_boxplot(fill=c("purple","green")) +
  #geom_jitter(width = 0.3) +
  theme_bw() + 
  theme(panel.border = element_blank())




ggplot(salsa, aes(Age, R, color=Clump.Even)) + 
  labs(y = "R", x = "\nAge") +
  #  geom_line() +
  geom_point() +
  stat_smooth()
scale_color_brewer(palette = "Set1") + 
  theme_bw() + theme(panel.border = element_blank())

ggplot(salsa, aes(Age, dprime, color=Clump.Even)) + 
  labs(y = "dprime", x = "\nAge") +
  #  geom_line() +
  geom_point() +
  stat_smooth()
scale_color_brewer(palette = "Set1") + 
  theme_bw() + theme(panel.border = element_blank())

ggplot(salsa, aes(Age, TimeToCompletion, color=Clump.Even)) + 
  labs(y = "Time To Completion", x = "\nAge") +
  #  geom_line() +
  geom_point() +
  stat_smooth()
scale_color_brewer(palette = "Set1") + 
  theme_bw() + theme(panel.border = element_blank())


####ridge plots
ggplot(salsa, aes(R, Clump.Even)) + 
  labs(y = "Condition", x = "\nR") +
  theme_bw() + theme(panel.border = element_blank())



###model fitting
salsa.Rfit.Gender.Age.Start.Clump.ClumpAge <- glm(R~Gender+Age+Bilingual+Low.Start.High.Start+Clump.Even+Clump.Even:Age, family = gaussian, data=salsa)

salsa.dprimefit.Gender.Age.Start.Clump.ClumpAge <- glm(dprime~Gender+Age+Bilingual+Low.Start.High.Start+Clump.Even+Clump.Even:Age, family = gaussian, data=salsa)

salsa.timefit.Gender.Age.Start.Clump.ClumpAge <- glm(TimeToCompletion~Gender+Age+Bilingual+Low.Start.High.Start+Clump.Even+Clump.Even:Age, family = gaussian, data=salsa)


salsa.Rfit.Gender.Age.Start.Clump <- glm(R~Gender+Age+Bilingual+Low.Start.High.Start+Clump.Even, family = gaussian, data=salsa)
summary(salsa.Rfit.Gender.Age.Start.Clump)
salsa.Rfit.Gender.Age.Start <- glm(R~Gender+Age+Bilingual+Low.Start.High.Start, family = gaussian, data=salsa)

anova(salsa.Rfit.Gender.Age.Start.Clump.ClumpAge,salsa.Rfit.Gender.Age.Start.Clump, test="Chisq")
anova(salsa.Rfit.Gender.Age.Start.Clump,salsa.Rfit.Gender.Age.Start, test="Chisq")
AIC(salsa.Rfit.Gender.Age.Start)
BIC(salsa.Rfit.Gender.Age.Start)
AIC(salsa.Rfit.Gender.Age.Start.Clump)
BIC(salsa.Rfit.Gender.Age.Start.Clump)

salsa.auroc.Gender.Age.Start.Clump <- glm(AUROC~Gender+Age+Bilingual+Low.Start.High.Start+Clump.Even, family = gaussian, data=salsa)
summary(salsa.auroc.Gender.Age.Start.Clump)
salsa.auroc.Gender.Age.Start <- glm(AUROC~Gender+Age+Bilingual+Low.Start.High.Start, family = gaussian, data=salsa)
anova(salsa.auroc.Gender.Age.Start.Clump,salsa.auroc.Gender.Age.Start, test="Chisq")
AIC(salsa.auroc.Gender.Age.Start)
BIC(salsa.auroc.Gender.Age.Start)
AIC(salsa.auroc.Gender.Age.Start.Clump)
BIC(salsa.auroc.Gender.Age.Start.Clump)

salsa.dprime.Gender.Age.Start.Clump <- glm(dprime~Gender+Age+Bilingual+Low.Start.High.Start+Clump.Even, family = gaussian, data=salsa)
summary(salsa.dprime.Gender.Age.Start.Clump)
salsa.dprime.Gender.Age.Start <- glm(dprime~Gender+Age+Bilingual+Low.Start.High.Start, family = gaussian, data=salsa)
anova(salsa.dprime.Gender.Age.Start.Clump,salsa.dprime.Gender.Age.Start, test="Chisq")
AIC(salsa.dprime.Gender.Age.Start)
BIC(salsa.dprime.Gender.Age.Start)
AIC(salsa.dprime.Gender.Age.Start.Clump)
BIC(salsa.dprime.Gender.Age.Start.Clump)


salsa.timefit.Gender.Age.Start.Clump <- glm(TimeToCompletion~Gender+Age+Bilingual+Low.Start.High.Start+Clump.Even, family = gaussian, data=salsa)
salsa.timefit.Gender.Age.Start <- glm(TimeToCompletion~Gender+Age+Bilingual+Low.Start.High.Start, family = gaussian, data=salsa)

anova(salsa.timefit.Gender.Age.Start,salsa.timefit.Gender.Age.Start.Clump, test = "Chisq")
AIC(salsa.timefit.Gender.Age.Start)
AIC(salsa.timefit.Gender.Age.Start.Clump)


####Models for the high/low separated data
library(lme4)
library(lmerTest)
highlowFull.Rfit.Sex.Age.Start.Clump.Freq.FreqClump <- lmer(R~(1|Participant)+Sex+Age+Bilingual+LowOrHighStart+ClumpedOrEven+Frequency+Frequency:ClumpedOrEven, data=highlowFull)
highlowFull.Rfit.Sex.Age.Start.Clump.Freq <- lmer(R~(1|Participant)+Sex+Age+Bilingual+LowOrHighStart+ClumpedOrEven+Frequency, data=highlowFull)
summary(highlowFull.Rfit.Sex.Age.Start.Clump.Freq)
anova(highlowFull.Rfit.Sex.Age.Start.Clump.Freq.FreqClump,highlowFull.Rfit.Sex.Age.Start.Clump.Freq, test="Chisq")
AIC(highlowFull.Rfit.Sex.Age.Start.Clump.Freq.FreqClump)
AIC(highlowFull.Rfit.Sex.Age.Start.Clump.Freq)
BIC(highlowFull.Rfit.Sex.Age.Start.Clump.Freq.FreqClump)
BIC(highlowFull.Rfit.Sex.Age.Start.Clump.Freq)

highlowFull.Rfit.Sex.Age.Start.Clump <- lmer(R~(1|Participant)+Sex+Age+Bilingual+LowOrHighStart+ClumpedOrEven, data=highlowFull)
highlowFull.Rfit.Sex.Age.Start.Freq <- lmer(R~(1|Participant)+Sex+Age+Bilingual+LowOrHighStart+Frequency, data=highlowFull)
anova(highlowFull.Rfit.Sex.Age.Start.Freq,highlowFull.Rfit.Sex.Age.Start.Clump.Freq, test="Chisq")
anova(highlowFull.Rfit.Sex.Age.Start.Clump,highlowFull.Rfit.Sex.Age.Start.Clump.Freq, test="Chisq")

#same for dprime, ie familiarity
highlowFull.dfit.Sex.Age.Start.Clump.Freq.FreqClump <- lmer(dprime~(1|Participant)+Sex+Age+Bilingual+LowOrHighStart+ClumpedOrEven+Frequency+Frequency:ClumpedOrEven, data=highlowFull)
highlowFull.dfit.Sex.Age.Start.Clump.Freq <- lmer(dprime~(1|Participant)+Sex+Age+Bilingual+LowOrHighStart+ClumpedOrEven+Frequency, data=highlowFull)
summary(highlowFull.dfit.Sex.Age.Start.Clump.Freq.FreqClump)
anova(highlowFull.dfit.Sex.Age.Start.Clump.Freq.FreqClump,highlowFull.dfit.Sex.Age.Start.Clump.Freq, test="Chisq")
AIC(highlowFull.dfit.Sex.Age.Start.Clump.Freq.FreqClump)
AIC(highlowFull.dfit.Sex.Age.Start.Clump.Freq)
BIC(highlowFull.dfit.Sex.Age.Start.Clump.Freq.FreqClump)
BIC(highlowFull.dfit.Sex.Age.Start.Clump.Freq)

#same for AUROC
highlowFull.auroc.Sex.Age.Start.Clump.Freq.FreqClump <- lmer(AUROC~(1|Participant)+Sex+Age+Bilingual+LowOrHighStart+ClumpedOrEven+Frequency+Frequency:ClumpedOrEven, data=highlowFull)
highlowFull.auroc.Sex.Age.Start.Clump.Freq <- lmer(AUROC~(1|Participant)+Sex+Age+Bilingual+LowOrHighStart+ClumpedOrEven+Frequency, data=highlowFull)
highlowFull.auroc.Sex.Age.Start.Freq <- lmer(AUROC~(1|Participant)+Sex+Age+Bilingual+LowOrHighStart+Frequency, data=highlowFull)
summary(highlowFull.auroc.Sex.Age.Start.Clump.Freq)
anova(highlowFull.auroc.Sex.Age.Start.Clump.Freq,highlowFull.auroc.Sex.Age.Start.Clump.Freq.FreqClump, test="Chisq")
AIC(highlowFull.auroc.Sex.Age.Start.Clump.Freq.FreqClump)
AIC(highlowFull.auroc.Sex.Age.Start.Clump.Freq)
BIC(highlowFull.auroc.Sex.Age.Start.Clump.Freq.FreqClump)
BIC(highlowFull.auroc.Sex.Age.Start.Clump.Freq)
