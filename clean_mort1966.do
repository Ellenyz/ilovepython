clear all
capture log close
log using clean1966.log,replace
* Input data
cd "/Users/ellenyz/OneDrive - UW-Madison/DrGreen'sLab/Todo Feb12/Mort1966-2972/datafiles"
use mort1966

* Recode datayear to year
rename datayear year


/* Eliminate Irrelavant Variables */
* Drop variables with values all missing
 * shipno has 1,863,149 obs (all) missing
*drop shipno
*drop rectype 
*drop sexdup
*drop whoflag
*drop cdcflag
/* Recode missing values */


/* Labels */
lab var year      "Year of death data available"
lab var monthdth  "The month of death"
lab var daydth    "date of death"
lab var reparea   "Reporting area"
lab var restatus  "Residence Status of death"
lab var countyrs  "County of Residents"
lab var staters   "State of Residents"
lab var cityrs    "City of Residents"
lab var popsize   "Population size of City of Residents"
lab var rectype   "Record Type of Residents"
lab var smsares   "Standard Metropolitan Statistical Areas"
lab var metro     "Metropolitan-Nonmetropolitan County of Residence"
lab var stateoc   "State of Occurrence"
lab var countyoc  "County of Occurrence"
lab var sex       "Gender"
lab var race      "Detailed Race"
lab var racer2    "Recoded Race: white/other"
lab var racer3    "Recoded Race: white, black and all other races"
lab var racer6    "Recoded Race: white, black, indian, chinese, japanese, other"
lab var age       "Detailed age of death"
lab var ager12    "Age at death: recoded into 12 groups"
lab var ager14    "Age at death: recoded into 14 groups"
lab var ager22    "Death Age of Infant: in 22 groups"
lab var ager27    "Age at death: recoded into 17 groups"
lab var divstres  "Division and state subcode of residenc"
lab var divstoc   "State by more granular geographic regions"
lab var region    "Major Geographical Region of Death"
lab var exstatoc  "Expanded State of Occurrence"
lab var divstoc   "State by more granular geographic regions"
lab var accident  "Accident at Work"
lab var regnres   "Major Geographical Region of Recidence"
lab var exstares  "Expanded State of Residence"
lab var ucod      "Underlying Cause of Death"
lab var ucod4     "Underlying Cause of Death Recode"
lab var ccr60     "60 Cause Recode"
lab var ccr55     "55 Infant Cause Recode"
lab var ccr258    "C258 Cause Recode"
lab var ucr258s   "258 Cause Recode Subcode"
lab var ucr258    "258 Cause Line Recode"
lab var ucr60     "60 Cause Line Recode"

/* Label value */
label define sex 1 "male" 2 "female"
label value sex sex

* In 1966, race ranges from 1 to 7
label define race 1 "White" 2 "Black" 3 "Indian" 4 "Chinese" ///
5 "Japanese" 6 "Hawaiian" 7 "All other races"
label value race race


/* New Variables */
egen countystate=concat(stateoc countyoc)
lab var countystate  "Unique identifier" 

* since initial race uniquely identified Filipino and Guamian in 1969-72
* want to define a unified indicator
rename race race_0
gen race = race_0
replace race = 7 if race_0 == 0|race_0==8
lab var race "Newly generated detailed race"

/* rename */
rename monthdth month
rename daydth day 
rename stateoc state
rename countyoc county
 
/* Check on Missing Values */
* Variables with missing value: 
* whoflag cdcflag ucr258s accident sexdup ager14 ager22 racer6
* 1,660,006 missing in whoflag
replace whoflag=0 if whoflag==. 
* 1,462,128 missing in cdcflag 
replace cdcflag=0 if cdcflag==.  
* 1,811,505 missing in ucr258s
replace ucr258s=9 if ucr258s==.
* 1,716,625 out of 1,863,149 are missing in accident, 
* whose causes are outside E800-E962
replace accident=99 if accident==.
* sexdup all missing
*drop sexdup
* ager14 all missing
*drop ager14
* 1,777,633 out of 1,863,149 are missing in ager22
* They age 1 year and over or not stated
replace ager22=99 if ager22==.
* racer6 all missing
*drop racer6



save "mort1966_cleaned.dta", replace
log close
