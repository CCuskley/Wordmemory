FindBestCriteria = function (params,ROCdata){
    # See how many points on the curve there are
    npts = nrow(ROCdata)

    LROC = 0;
    # Find the best criterion C for each data-point, given the ROC curve
    for (j in 1:npts) {
        fit = optimize(LogLikelihood_ROCpoint,params=params,ROCdata=ROCdata[j,],maximum=TRUE,lower=-maxC,upper=maxC )
        ROCdata$FittedCriterion[j] = fit$maximum
        ROCdata$logLikelihood[j] =  fit$objective
    }
    return(ROCdata)
}