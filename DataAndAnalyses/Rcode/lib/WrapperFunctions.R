# Various wrapper functions:


# A wrapper function which enables us to vary dprime while keeping R fixed:
LogLikelihood_ROCdprime = function(halfdprime, R, ROCdata) LogLikelihood_ROCcurve(c(R,halfdprime),ROCdata)
# A wrapper function which enables us to vary R while keeping dprime fixed:
LogLikelihood_ROCR = function(R, halfdprime, ROCdata) LogLikelihood_ROCcurve(c(R,halfdprime),ROCdata)

# A wrapper function which enables us to look for a particular value of logLikelihood by varying dprime:
DifferenceWithDesiredLogLikelihood_dprime = function(halfdprime, R, ROCdata, logLdesired) { abs(LogLikelihood_ROCcurve(c(R,halfdprime),ROCdata) - logLdesired) }
# A wrapper function which enables us to look for a particular value of logLikelihood by varying R:
DifferenceWithDesiredLogLikelihood_R = function(R,halfdprime, ROCdata, logLdesired) { abs(LogLikelihood_ROCcurve(c(R,halfdprime),ROCdata) - logLdesired) }

# A wrapper function which returns the separation between max and min values of dprime within
# the likelihood contour for a given R:
DprimeMax = function(R,ROCdata,Lmin) {  x=DprimeLimits(R,ROCdata,Lmin); return(x$max)}
DprimeMin = function(R,ROCdata,Lmin) {  x=DprimeLimits(R,ROCdata,Lmin); return(x$min)}
RMax = function(dprime,ROCdata,Lmin) {  x=RecollectionLimits(dprime,ROCdata,Lmin); return(x$max)}
RMin = function(dprime,ROCdata,Lmin) {  x=RecollectionLimits(dprime,ROCdata,Lmin); return(x$min)}
# Replacing NaNs with 0 means: If for this value of dprime there were no values of R for which L>Lmin, we say that the maximum possible R is 0
