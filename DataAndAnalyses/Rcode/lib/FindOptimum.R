FindOptimum = function(fun,ROCdata,Lmin,maximum,lower,upper) {
    # Towards the top of the range of dprime (or R), there is often no value of R (or dprime)
    # within the confidence contour. The value of DprimeMax etc is therefore NA.
    # If I ask the function optimize to find the optimum within the range lower-upper, but
    # the function to be optimised returns NAs at either bound, it can often fail to find the true optimum
    #
    # So, I start by checking if the function "fun" evaluated at "lower" is NA. If so, I
    # try higher values until I get one that is non-NA:
    points = seq(from=lower,to=upper,length.out = 50)
    val = NA
    j=1
    while (is.na(val)) {
        lowerpoint = points[j]
        val = fun(lowerpoint,ROCdata,Lmin)
        j=j+1
    }
    # Ditto in reverse for the upper bound:
    val = NA
    j=length(points)
    while (is.na(val)) {
        upperpoint = points[j]
        val = fun(upperpoint,ROCdata,Lmin)
        j=j-1
    }
    if (lowerpoint==upperpoint)
    {
        # There's at least one data-set where empirically dprime<0. So the fit only allows dprime=0.
        # This means lowerpoint=upperpoint=0. The maxdprime is just whatever the value is at this point:
        find_max = list(objective = fun(lowerpoint,ROCdata,Lmin))
    } else
        find_max = optimize( fun,ROCdata=ROCdata,Lmin=Lmin,maximum=maximum,lower=lowerpoint,upper=upperpoint )
    return(find_max)
}