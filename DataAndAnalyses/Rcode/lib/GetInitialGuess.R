GetInitialGuess = function(ROCdata){
    npts = nrow(ROCdata)
    jmid = ceiling(npts/2)
    PHit = (ROCdata$nHit[jmid])/(sum(ROCdata$nHit[jmid])+sum(ROCdata$nMiss[jmid]))
    PCorrectReject = (ROCdata$nCorrectReject[jmid])/(sum(ROCdata$nFalseAlarm[jmid])+sum(ROCdata$nCorrectReject[jmid]))
    # Initial guess at d':
    if (qnorm(PCorrectReject)<0) {
        init_halfdprime = 0;
        init_C = qnorm(PCorrectReject)
    } else {
        init_halfdprime = qnorm(PCorrectReject);
        init_C = 0
    }
    # Check dprime does not exceed bounds:
    if (init_halfdprime>maxdprime/2){
        init_halfdprime=maxdprime/2
        init_C =0
    }

    # Check C does not exceed bounds:
    if (init_C<-maxC)
        init_C=-maxC
    if (init_C>maxC)
        init_C=maxC


    # Initial guess at R:
    Phi = pnorm(init_halfdprime-init_C)
    init_R = (PHit-Phi)/(1-Phi)
    # Check R does not exceed bounds
    if (init_R<0)
        init_R=0
    if (init_R>maxR)
        init_R=maxR

    init_params = c(init_R,init_halfdprime)
    return(init_params)
}