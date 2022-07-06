

This folder contains data and analysis code for the paper
"The effect of information content distributions onword recollection and familiarity"
Joel C. Wallenberg, Christine Cuskley, Salsabila Fadhilah, Jenny C. A. Read and Tom V. Smulders

_______DATA___________
Data is in folder "Data"

The file 0A_ParticipantInfo.csv contains participant info, with the first column being their ID code, e.g 0byyJjFw7xaS6bv4Xbbl.

The remaining files, with names like 0byyJjFw7xaS6bv4Xbbl_responses.xlsx, contain results for one participant.

The results .xlsx files each have one worksheet, 140 data rows after the header row, and 5 columns:
"Word" - the word in questions
"Seen/Unseen" - whether or not  the word was present in the list of 70 words shown to participants. 
	O=old means that the word was present; N=new means that it was not.
"Order" - for "seen" words, its order in the list (1=first, 70=last)
"O/N" - the participant's report about or not  the word was present in the list previously shown to them, i.e. their answer to the question "Did you see it?". 
	O=old means that they think the word was present; N=new means that they think it was not.
"S/P/G" - the participant's self-reported confidence, i.e. their answer to the question "How sure are you?":
	S = sure ("Very")
	P = perhaps ("sort of")
	G = guess ("not at all")
	
	
	
_______ANALYSIS CODE___________
Folder "RCode" contains code in R (https://www.r-project.org/). See the README in that folder for details of how to run this.
