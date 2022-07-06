LogLikelihood_ROCpoint = function(C,params,ROCdata){
    # Given an ROC curve specified by R,dprime, moves along the curve by adjusting the decision criterion C.
    # ROCdata is a dataframe giving nHit, nFA etc.

    # Read off the current values of R and dprime from the parameter vector:
    R = params[1]
    halfdprime = params[2]

    Phiplus = pnorm(halfdprime+C)
    Phiminus = pnorm(halfdprime-C)

    logL = ROCdata$nHit * log(R+(1-R)*Phiminus) +
        ROCdata$nMiss * log((1-R)*(1-Phiminus)) +
        ROCdata$nFalseAlarm * log(1-Phiplus) +
        ROCdata$nCorrectReject * log(Phiplus)

    if (is.nan(logL))
        logL=Inf;

    return(logL)
}