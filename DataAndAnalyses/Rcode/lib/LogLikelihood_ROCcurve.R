LogLikelihood_ROCcurve = function(params,ROCdata){
    # Find the ROC curve (specified by R,dprime) that best fits the data
    # The "params" array is [R,halfdprime]

    # Find the best criterion for each point in the ROCdata dataframe, given the R and dprime described in params:
    ROCdata = FindBestCriteria(params,ROCdata)
    # Return the total log likelihood
    LROC = sum(ROCdata$logLikelihood)


    return(LROC)

}

