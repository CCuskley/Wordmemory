GetROCpoints = function (data) {
    # Take a list of words and judgments. Convert this into a series of points on an ROC curve

    # There are 6 different confidence levels. Imagine different observers who placed their decision criterion at 1,2,3,4,5
    nCriterion = 5 # there are 5 (=6-1) possible decision criteria
    ROCdata = data.frame(ConfidenceCriterion=seq(nCriterion,1,-1),nHit=NA,nFalseAlarm=NA,nMiss=NA,nCorrectReject=NA)
    for (jcon in seq(1,nCriterion)){
        C = ROCdata$ConfidenceCriterion[jcon]
        ROCdata$nHit[jcon] = sum(data$ConfidenceSignal>C & data$Stimulus=="O" )
        ROCdata$nFalseAlarm[jcon] = sum(data$ConfidenceSignal>C & data$Stimulus=="N" )
        ROCdata$nMiss[jcon] = sum(data$ConfidenceSignal<=C & data$Stimulus=="O" )
        ROCdata$nCorrectReject[jcon] = sum(data$ConfidenceSignal<=C & data$Stimulus=="N" )
    }

    ROCdata$pFalseAlarm = ROCdata$nFalseAlarm/(ROCdata$nFalseAlarm+ROCdata$nCorrectReject)
    ROCdata$pHit = ROCdata$nHit/(ROCdata$nHit+ROCdata$nMiss)

    return(ROCdata)
}