FitExcelFile = function(file){
    # This function fits an ROC curve, using the participant's own confidence score as recorded in the Excel file supplied.
    # Returns a list called "results" containing R and dprime.


    #Read in Excel file
    data = ReadDataFromFile(file)

    # First fit all the data together
    ROCdata = GetROCpoints(data)
    fit_all = FitMemoryParameters(ROCdata)

    # Now fit only low-freq targets (and the medium-frequency distractors)
    ROCdata_lo = GetROCpoints( filter(data,Category != "High") )
    fit_lo = FitMemoryParameters(ROCdata_lo)

    # Now fit only hi-freq targets (and the medium-frequency distractors)
    ROCdata_hi = GetROCpoints( filter(data,Category != "Low") )
    fit_hi = FitMemoryParameters(ROCdata_hi)


    fits = list(AllFreq=fit_all,LoFreq=fit_lo,HiFreq=fit_hi)

    return(fits)

}