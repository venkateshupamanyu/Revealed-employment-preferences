********************************************************************************
********************************************************************************
********************************************************************************
*** IHDS II data ***
*** DS0002 - Household - Income & Social capital  ***
cd "C:\Users\venka\Box\Personal\Tufts PhD\Research work\IHDS data\ICPSR_36151-V6 - 2011-12 data\ICPSR_36151\DS0002"

*** DS0002 - Household ***
use "36151-0002-Data.dta",clear

ren *,l
ren idhh hh_id 
unique hh_id
sort hh_id

egen state_dist=group(stateid distid)
unique state_dist
tab state_dist if stateid==02
tab state_dist if stateid==33
*** Urban/Rural classification ***
tab urban2011
tab urban4_2011
count if urban2011==0
count if inlist(urban4_2011,2,3)
*** Main source of income - use it for identifying agricultural HH ***
tab id14

*** Land owned or cultivated?, Land unit, conversion factor to acres ***
tab fm1
tab fm2
tab fm3
*** Landholdings in Kharif-Rabi-Summer seasons ***
count if fm7a==fm7b
count if fm7b==fm7c
count if fm7a==fm7c
count if fm7a==fm7b & fm7b==fm7c & fm7c==fm7a & fm1==1
count if fm7a==fm7b==fm7c

*** Getting total landholding across 3 seasons in acres ***
summ fm7a fm7b fm7c
gen fm7ab=fm7a if fm7a==fm7b
gen total_land=fm7c if fm7ab==fm7c
summ fm7ab total_land if fm1==1

gen total_land_acre=total_land/fm3
summ total_land_acre

/*
gen fm2_acre=0
replace fm2_acre=1 if inlist(fm2,"1 ACRE","1AKED","AACRES","AAKAD","AAKED","AARE","ACAD","ACAE","ACAR")
replace fm2_acre=1 if inlist(fm2,"ACARAS","ACARE","ACARE.","ACARES","ACARES","ACARS","ACCA","ACCAR","ACCARA")
replace fm2_acre=1 if inlist(fm2,"ACCARE","ACCERE"," ACCRE","ACEK","ACER","ACERA","ACERE","ACERES","ACERS")
replace fm2_acre=1 if inlist(fm2,"ACER]","ACES","ACEVS","ACHORSE","ACHRE","ACKAR","ACORE","ACR","ACRA")
replace fm2_acre=1 if inlist(fm2,"ACRAD","ACRAE","ACRAS","ACRC","ACRE","ACREA","ACREAS","ACREDS","ACRER ")
replace fm2_acre=1 if inlist(fm2,"ACRERS ","ACRES","ACRESH","ACRESS","ACRI","ACRS","AECR","AEKAD","AEKAR")
replace fm2_acre=1 if inlist(fm2,"AEKARH","AKAAD","AKAD","AKAR","AKARALU","AKARD","AKED","AKER","AKKAD")
replace fm2_acre=1 if inlist(fm2,"AORE","ARCE","ARCES","ARKARH","EAKAD","EAKD","EAKR","ECARE","EIKD")
replace fm2_acre=1 if inlist(fm2,"EKAAD","EKAD","EKADA","EKDA","EKED","EKER","EKID","EKRAD","YAKAR")
tab fm2_acre
gen fm3_acre=fm3 if fm2_acre==1
*/

*** Non-farm business ***
tab nf1
*** Non-farm business 1 investments and net income ***
tab nf6
tab nf5
*** Non-farm business 2 investments and net income  ***
tab nf26
tab nf25
*** Non-farm business 3 investments and net income  ***
tab nf46
tab nf45
*** Total non-farm investments and net income (loss also present) ***
egen nf_inv=rowtotal(nf6 nf26 nf46) if nf6!=.
egen nf_netinc=rowtotal(nf5 nf25 nf45) if nf5!=.
summ nf6 nf26 nf46 nf_inv
summ nf5 nf25 nf45 nf_netinc

count if nf_inv<0
count if nf_netinc<0

*** NREGA job cards ***
tab in16
*** NREGA job cards application ***
tab in17

*** Food items ***
tab co1x
tab co1b
tab co1x if co1b==2
tab co2x
tab co2b
tab co2x if co2b==2
tab co3x
tab co3b
tab co3x if co3b==2
tab co4x
tab co4b
tab co4x if co4b==2
tab co5x
tab co5b
tab co5x if co5b==2
tab co6x
tab co6b
tab co6x if co6b==2
tab co9x
tab co9b
tab co9x if co9b==2
tab co10x
tab co10b
tab co10x if co10b==2
tab co11x
tab co11b
tab co11x if co11b==2
tab co12x
tab co12b
tab co12x if co12b==2
tab co13x
tab co13b
tab co13x if co13b==2
tab co14x
tab co14b
tab co14x if co14b==2

*** Debt details ***
*** Any loans in last 5 years ***
tab db1
tab db2
tab db1a
tab db1b
tab db1c
tab db1d
tab db1e
tab db1f

*** Largest loan details ***
tab db2a
tab db2c
tab db2e
tab db2f
tab db4b

*** Profits from various streams (loss also present) ***
summ fm22rshh inccrop incag incanimal incbus income incomepc incnonag incaglab incnrega incnonnrega

gen aginc_prop=incag/income
gen crop1inc_prop=inccrop/income
gen crop2inc_prop=fm22rshh/income

*** Farm labor cost ***
summ fm27brs fm27crs fm27rs fm27b
*** Agricultural loan repaid ***
summ fm33 fm33irs

*** Regression variables ***
count if total_land_acre==.
count if total_land_acre==0
count if total_land_acre!=. & total_land_acre!=0 & total_land_acre<=5
count if total_land_acre!=. & total_land_acre!=0 & total_land_acre>=5
count if total_land_acre!=. & total_land_acre!=0 & total_land_acre>5 & total_land_acre<=10
gen treat=0
replace treat=1 if total_land_acre!=. & total_land_acre>0 & total_land_acre<=5
tab treat
gen total_land_acresq=total_land_acre*total_land_acre
gen treat_totallandacre=treat*total_land_acre
gen treat_totallandacresq=treat*total_land_acre*total_land_acre
********************************************************************************
********************************************************************************
********************************************************************************
cd "C:\Users\venka\Box\Personal\Tufts PhD\Research work\Debt waiver and employment preference"

*** Non-farm business ***
areg nf1 treat treat_totallandacre treat_totallandacresq if urban2011==0 & ///
			  total_land_acre!=. & total_land_acre!=0 & total_land_acre<=10 & id14==1 ///
			  [pweight=wt],absorb(state_dist) cluster(state_dist)
est store nf1		  
logit nf1 treat treat_totallandacre treat_totallandacresq i.state_dist if urban2011==0 & ///
			  total_land_acre!=. & total_land_acre!=0 & total_land_acre<=10 & id14==1 ///
			  [pweight=wt],cluster(state_dist)			  
est store logit_nf1
outreg2 [nf1 logit_nf1] ///
using "IHDS_nonfarm.xls", drop(i.state_dist) label nocons dec(3) excel replace
erase "IHDS_nonfarm.txt"
********************************************************************************
*** Profits ***
global incomevar "incomepc income inccrop incag incanimal incbus incother incnonag incaglab incnrega incnonnrega"
foreach y in $incomevar {
gen ln_`y'=ln(`y')
}
label var ln_incomepc "Log of Income Per Capita"
label var ln_income "Log of Income"
label var ln_inccrop "Log of Net-Income from Crops"
label var ln_incag "Log of Net-Income from Agriculture"
label var ln_incanimal "Log of Net-Income from Livestock"
label var ln_incbus "Log of Net-Income from Businesses"
label var ln_incother "Log of Income from Others"
label var ln_incnonag "Log of Non-Agricultural Wages"
label var ln_incaglab "Log of Agricultural Wages"
label var ln_incnrega "Log of NREGA Wages"
label var ln_incnonnrega "Log of Non-NREGA & Non-Agricultural Wages"
label var assets "Number of Assets"

foreach y in $incomevar {			  
areg ln_`y' treat treat_totallandacre treat_totallandacresq if urban2011==0 & ///
			  total_land_acre!=. & total_land_acre!=0 & total_land_acre<=10 & id14==1 ///
			  [pweight=wt],absorb(state_dist) cluster(state_dist)
est store a_`y'
}
outreg2 [a_incomepc a_income a_inccrop a_incag a_incanimal a_incbus a_incother a_incnonag a_incaglab a_incnrega a_incnonnrega] ///
using "IHDS_income.xls", drop(i.state_dist) label nocons dec(3) excel replace
erase "IHDS_income.txt"
*** Assets indicate no. of assets (0 to 33 assets) and not value of assets ***			  
areg assets treat treat_totallandacre treat_totallandacresq if urban2011==0 & ///
			  total_land_acre!=. & total_land_acre!=0 & total_land_acre<=10 & id14==1  ///
			  [pweight=wt],absorb(state_dist) cluster(state_dist)
est store assets
outreg2 [assets] ///
using "IHDS_assets.xls", drop(i.state_dist) label nocons dec(3) excel replace
erase "IHDS_assets.txt"	
********************************************************************************
*** Following produces no output due to no observations, hence we remove the db2a condition ***
*** db2a should be 1,2 (or) 3 as it puts largest loan taken in years 2009,2010 and 2011 respectively ***
*** Following regression has no observations, as db1 is having value 1 for db2a==1,2,3 ***
summ db1 if urban2011==0 & total_land_acre!=. & total_land_acre!=0 & total_land_acre>5 & total_land_acre<=10 & id14==1

areg db1 treat treat_totallandacre treat_totallandacresq if urban2011==0 & ///
			  total_land_acre!=. & total_land_acre!=0 & total_land_acre<=10 & id14==1 & inlist(db2a,1,2,3) ///
			  [pweight=wt],absorb(state_dist) cluster(state_dist)
areg db1 treat treat_totallandacre treat_totallandacresq if urban2011==0 & ///
			  total_land_acre!=. & total_land_acre!=0 & total_land_acre<=10 & id14==1 ///
			  [pweight=wt],absorb(state_dist) cluster(state_dist)	  
est store db1
logit db1 treat treat_totallandacre treat_totallandacresq i.state_dist if urban2011==0 & ///
			  total_land_acre!=. & total_land_acre!=0 & total_land_acre<=10 & id14==1 ///
			  [pweight=wt],cluster(state_dist)
est store logit_db1
outreg2 [db1 logit_db1] ///
using "IHDS_loan5years.xls", drop(i.state_dist) label nocons dec(3) excel replace
erase "IHDS_loan5years.txt"	

*** No. of loans using 1,2,3 years ago (from year 2011, 1-2 years will be 2009,2010) ***
gen ln_db2b=ln(db2b)  
label var db2 	  "Number of loans taken in past 3 years"
label var ln_db2b "Log value of largest loan taken"

summ db2 ln_db2b if urban2011==0 & total_land_acre!=. & total_land_acre!=0 & total_land_acre>5 & total_land_acre<=10 & id14==1 & inlist(db2a,1,2,3)

areg db2 treat treat_totallandacre treat_totallandacresq if urban2011==0 & ///
			  total_land_acre!=. & total_land_acre!=0 & total_land_acre<=10 & id14==1 & inlist(db2a,1,2,3) ///
			  [pweight=wt],absorb(state_dist) cluster(state_dist)
est store db2
*** Largest loan taken value *** 
areg ln_db2b treat treat_totallandacre treat_totallandacresq if urban2011==0 & ///
			  total_land_acre!=. & total_land_acre!=0 & total_land_acre<=10 & id14==1 & inlist(db2a,1,2,3) ///
			  [pweight=wt],absorb(state_dist) cluster(state_dist)
est store ln_db2b
outreg2 [db2 ln_db2b] ///
using "IHDS_largeloan.xls", drop(i.state_dist) label nocons dec(3) excel replace
erase "IHDS_largeloan.txt"	

*** Loan source of the largest loan ***			  
gen db2d_bank=0
replace db2d_bank=1 if db2d==5
gen db2d_ml=0
replace db2d_ml=1 if db2d==2
gen db2d_informal=0
replace db2d_informal=1 if inlist(db2d,1,3,4)
gen db2d_fi=0
replace db2d_fi=1 if inlist(db2d,6,7,8,9)

*gen outstanding_debt=db5/db2b
*summ outstanding_debt
label var db2d_bank "Obtained largest loan from Bank"
label var db2d_ml "Obtained largest loan from Money Lenders"
label var db2d_informal "Obtained largest loan from Individuals"
label var db2d_fi "Obtained largest loan from Other institutions"

global largeloan_source "db2d_bank db2d_ml db2d_informal db2d_fi"

summ $largeloan_source if urban2011==0 & total_land_acre!=. & total_land_acre!=0 & total_land_acre>5 & total_land_acre<=10 & id14==1 & inlist(db2a,1,2,3) 

foreach y in $largeloan_source {
areg `y' treat treat_totallandacre treat_totallandacresq if urban2011==0 & ///
			   total_land_acre!=. & total_land_acre!=0 & total_land_acre<=10 & id14==1 & inlist(db2a,1,2,3) ///
			   [pweight=wt],absorb(state_dist) cluster(state_dist)
est store b_`y'			   

logit `y' treat treat_totallandacre treat_totallandacresq i.state_dist if urban2011==0 & ///
			   total_land_acre!=. & total_land_acre!=0 & total_land_acre<=10 & id14==1 & inlist(db2a,1,2,3) ///
			   [pweight=wt],cluster(state_dist)			   
est store c_`y'			   
}
outreg2 [b_db2d_bank b_db2d_ml b_db2d_informal b_db2d_fi c_db2d_bank c_db2d_ml c_db2d_informal c_db2d_fi] ///
using "IHDS_largeloan_source.xls", drop(i.state_dist) label nocons dec(3) excel replace
erase "IHDS_largeloan_source.txt"	

*** Interest rates for the largest loan ***
gen db2e_monthly=db2f/12
summ db2e db2e_monthly db2f
tab db2f if db2e==.
tab db2e_monthly if db2e==.
summ db2e

gen db2e_new=db2e
replace db2e_new=db2e_monthly if db2e_new==.
summ db2e db2e_new db2f
count if db2e==.
count if db2e!=.
count if db2f!=. & db2e==.
count if db2e_new!=.

gen db2f_annual=db2e*12
gen db2f_new=db2f
replace db2f_new=db2f_annual if db2f_new==.
summ db2e db2e_new db2f db2f_new
count if db2f==.
count if db2f!=.
count if db2e!=. & db2f==.
count if db2f_new!=.

label var db2e_new "Monthly Interest rate of largest loan"
label var db2f_new "Annual Interest rate of largest loan"

global largeloan_rate "db2e db2f db2e_new db2f_new"

summ $largeloan_rate if urban2011==0 & total_land_acre!=. & total_land_acre!=0 & total_land_acre>5 & total_land_acre<=10 & id14==1 & inlist(db2a,1,2,3) 

foreach y in $largeloan_rate {
areg `y' treat treat_totallandacre treat_totallandacresq if urban2011==0 & ///
			  total_land_acre!=. & total_land_acre!=0 & total_land_acre<=10 & id14==1 & inlist(db2a,1,2,3) ///
			  [pweight=wt],absorb(state_dist) cluster(state_dist)
est store d_`y'
}
outreg2 [d_db2e d_db2f d_db2e_new d_db2f_new] ///
using "IHDS_largeloan_rate.xls", drop(i.state_dist) label nocons dec(3) excel replace
erase "IHDS_largeloan_rate.txt"
********************************************************************************
