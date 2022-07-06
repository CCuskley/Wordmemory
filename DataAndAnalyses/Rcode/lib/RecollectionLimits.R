RecollectionLimits = function(dprime,ROCdata,Lmin) {
    # For a given dprime, find the max and min values of R for which the logLikelihood exceeds the specified value Lmin.
    # If there are no such values, return NAs

    Rrange = list ("max" = NA,"min" = NA)

    # First of all, we find the best dprime available for this R:
    fit_bestR_forthisdprime = optimize(LogLikelihood_ROCR,halfdprime=0.5*dprime,ROCdata=ROCdata,maximum=TRUE,lower=0,upper=maxR )
    bestR_forthisdprime = fit_bestR_forthisdprime$maximum
    bestL_forthisdprime = fit_bestR_forthisdprime$objective

    if (bestL_forthisdprime > Lmin) {
        # We are above threshold: ie this value of R has at least one dprime that is within the
        # confidence contour we are seeking
        if (abs(bestR_forthisdprime)>0.99) {
            # The  best R for this dprime is already nearly 1 so since we are constraining R to be <1
            # we can't go above this:
            Rmax = bestR_forthisdprime
        } else {
            # Seek the upper bound on R: look for values greater than the best value that we have just found, that are still within the contour:
            fit_maxR_forthisdprime = optimize(DifferenceWithDesiredLogLikelihood_R,halfdprime=0.5*dprime,ROCdata=ROCdata,logLdesired=Lmin,maximum=FALSE,lower=bestR_forthisdprime , upper=maxR)
            Rmax = fit_maxR_forthisdprime$minimum
        }
        if (abs(bestR_forthisdprime)<1e-3) {
            # The  best R for this dprime is already near zero, so since we are constraining R to be positive
            # we can't go below this:
            Rmin = bestR_forthisdprime
        } else
        {
            # Seek the lower bound on dprime:
            fit_minhalfdprime_forthisR = optimize(DifferenceWithDesiredLogLikelihood_R,halfdprime=0.5*dprime,ROCdata=ROCdata,logLdesired=Lmin,maximum=FALSE,lower=0,upper=bestR_forthisdprime )
            Rmin = fit_minhalfdprime_forthisR$minimum
        }
        Rrange$max = Rmax
        Rrange$min = Rmin
    }

    return(Rrange)

}