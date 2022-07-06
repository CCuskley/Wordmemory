# Goes through all data in the specified folder.
# It saves results to an Excel spreadsheet called RunAnalysisResults[timestamp].xlsx
# The timestamp means you don't have to worry about over-writing previous results.

# Clear all data
rm(list=ls())
# Load in settings
source("SetUp.R")

# Read in data about words:
wordlist = read.csv(wordinfo)
# NB due to R's dodgy scoping, this can be referred to from within function.
# It's actually referred to within ReadDataFromFile.R

#
outputfile = paste0("../output/RunAnalysisResults",str_replace_all(Sys.time(),c("[:-]"=""," "="T")),".csv")

datafiles = list.files(datadir,pattern="*.xlsx",full.names=TRUE)

# make a blank row with the columns in the desired order
blankrow = cbind(data.frame(File=NA,"WordFreq"=NA), data.frame("AUROCnofit"=NA,"R"=NA,"Rmin"=NA,"Rmax"=NA,"dprime"=NA,"dmin"=NA,"dmax"=NA,"AUROC"=NA,"logL"=NA))

for (file in datafiles){
    print(paste("Analysing file",file,"\n"))

    # Fit the file
    fits = FitExcelFile(file)

    # Write this into the output csv file (in a format consistent with earlier Matlab code)

    # Write each fit into a different row:
    for (fittype in names(fits)) {
        fit = fits[[fittype]]
        # Fill in the blank template with the values of this fit:
        thisrow = right_join(blankrow,fit)
        thisrow$WordFreq = fittype
        thisrow$File=file
        # Add this row to the output data frame:
        if (!exists("output"))
            output=thisrow
        else
            output=rbind(output,thisrow)
    }


    write.csv(output,file=outputfile,row.names=FALSE)

}

write.csv(output,"../output/RunAnalysisResults_MostRecent.csv",row.names=FALSE)


