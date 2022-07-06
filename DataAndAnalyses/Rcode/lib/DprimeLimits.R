DprimeLimits = function(R,ROCdata,Lmin) {
    # For a given R, find the max and min values of dprime for which the logLikelihood exceeds the specified value Lmin.
    # If there are no such values, return NAs

    dprimerange = list ("max" = NA,"min" = NA)

    # First of all, we find the best dprime available for this R:
    fit_bestdprime_forthisR = optimize(LogLikelihood_ROCdprime,R=R,ROCdata=ROCdata,maximum=TRUE,lower=0,upper=maxdprime/2 )
    besthalfdprime_forthisR = fit_bestdprime_forthisR$maximum
    bestL_forthisR = fit_bestdprime_forthisR$objective

    if (bestL_forthisR > Lmin) {
        # We are above threshold: ie this value of R has at least one dprime that is within the
        # confidence contour we are seeking

        # Seek the upper bound on dprime:
        fit_maxhalfdprime_forthisR = optimize(DifferenceWithDesiredLogLikelihood_dprime,R=R,ROCdata=ROCdata,logLdesired=Lmin,maximum=FALSE,lower=besthalfdprime_forthisR , upper=maxdprime/2)
        dprimemax = 2*fit_maxhalfdprime_forthisR$minimum

        # if (abs(besthalfdprime_forthisR)<1e-6) {
        #     # The  best dprime for this R is already near zero, so since we are constraining dprime to be positive
        #     # we can't go below this:
        #     dprimemin = 2*besthalfdprime_forthisR
        # } else
        # {
            # Seek the lower bound on dprime:
            fit_minhalfdprime_forthisR = optimize(DifferenceWithDesiredLogLikelihood_dprime,R=R,ROCdata=ROCdata,logLdesired=Lmin,maximum=FALSE,lower=0,upper=besthalfdprime_forthisR )
            dprimemin = 2*fit_minhalfdprime_forthisR$minimum
    #    }
        dprimerange$max = dprimemax
        dprimerange$min = dprimemin
    }

    return(dprimerange)

}