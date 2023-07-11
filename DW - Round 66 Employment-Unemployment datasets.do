********************************************************************************
********************************************************************************
********************************************************************************
*** Employment datasets ***

*** Block 3 - Household characteristics ***
use "Block_3_Household characteristics.dta",clear

ren *,l
unique hhid
sort hhid

tab nic_2004
gen nic_3 = substr(nic_2004,1,3)
tab nic_3

tab hh_type
tab hh_type if sector=="1"

count if land_cultivated==.
summ land_cultivated

unique state
unique district

keep hhid hh_type nic_3 hh_size land_cultivated social_group weight sector state district

save "Round 66 EU hh_char.dta",replace
********************************************************************************
*** Block 4 - Demographic details of households ***
use "Block_4_Demographic particulars of household members.dta",clear

ren *,l
unique hhid

order hhid pid person_serial_no
sort hhid pid person_serial_no

drop if age<18

tab vocational_training
by hhid: gen voc_training_1 = 1 if inlist(vocational_training,"1","2","3","4","5","6")
by hhid: gen voc_training_2 = sum(voc_training_1) 
by hhid: egen voc_training = max(voc_training_2)

by hhid: gen no_voc_training_1 = 1 if vocational_training=="7"
by hhid: gen no_voc_training_2 = sum(no_voc_training_1) 
by hhid: egen no_voc_training = max(no_voc_training_2)

drop voc_training_1 no_voc_training_1 voc_training_2 no_voc_training_2

by hhid: gen hh_size=_N
by hhid: gen voc_training_prop = voc_training/hh_size
by hhid: gen no_voc_training_prop = no_voc_training/hh_size

by hhid: gen voc_training_binary=1 if voc_training>0
by hhid: replace voc_training_binary=0 if voc_training==0

sum hhid voc_training no_voc_training voc_training_prop no_voc_training_prop voc_training_binary
keep hhid voc_training no_voc_training voc_training_prop no_voc_training_prop voc_training_binary

duplicates drop
unique hhid

save "Round 66 EU empl_demo.dta",replace
********************************************************************************
*** Block 5.1 - Usual principal activity of households ***
use "Block_5_1_Usual principal activity particulars of household members.dta",clear

ren *,l
unique hhid

order hhid pid
sort hhid pid

*** HH size ***
by hhid:gen hh_size=_N
by hhid:gen hh_size_adult_1=1 if age>17
by hhid:gen hh_size_adult_2=sum(hh_size_adult_1)
by hhid:egen hh_size_adult=max(hh_size_adult_2)
drop hh_size_adult_1 hh_size_adult_2

drop if age<18

*** total hh count for not working ***
by hhid:gen not_empl_1=1 if inlist(usual_principal_activity_status,"81")
by hhid:gen not_empl_2=sum(not_empl_1) 
by hhid:egen not_empl_tot=max(not_empl_2)
drop not_empl_1 not_empl_2
*** total hh count for self-employed/hh enterprise ***
by hhid:gen self_empl_1=1 if inlist(usual_principal_activity_status,"11","12","21")
by hhid:gen self_empl_2=sum(self_empl_1) 
by hhid:egen self_empl_tot=max(self_empl_2)
drop self_empl_1 self_empl_2
*** total hh count for wage/salaried employment ***
by hhid:gen wage_1=1 if inlist(usual_principal_activity_status,"31")
by hhid:gen wage_2=sum(wage_1) 
by hhid:egen wage_tot=max(wage_2)
drop wage_1 wage_2
*** total hh count for casual wage labor ***
by hhid:gen casual_1=1 if inlist(usual_principal_activity_status,"41","51")
by hhid:gen casual_2=sum(casual_1) 
by hhid:egen casual_tot=max(casual_2) 
drop casual_1 casual_2
*** total hh count for other hh work ***
by hhid:gen oth_1=1 if inlist(usual_principal_activity_status,"93","97")
by hhid:gen oth_2=sum(oth_1)
by hhid:egen oth_tot=max(oth_2)
drop oth_1 oth_2

by hhid: gen not_empl_prop=not_empl_tot/hh_size
by hhid: gen self_empl_prop=self_empl_tot/hh_size
by hhid: gen wage_prop=wage_tot/hh_size
by hhid: gen casual_prop=casual_tot/hh_size
by hhid: gen oth_prop=oth_tot/hh_size

sum not_empl_prop self_empl_prop wage_prop casual_prop oth_prop

keep hhid not_empl_tot self_empl_tot wage_tot casual_tot oth_tot hh_size_adult not_empl_prop self_empl_prop wage_prop casual_prop oth_prop
duplicates drop
unique hhid

save "Round 66 EU empl_activity.dta",replace
********************************************************************************
*** Time disposition dataset ***
use "Block_5_3_Time disposition during the week ended on ...............dta",clear

ren *,l
unique hhid

order hhid person_serial_no
sort hhid person_serial_no

drop if age<18

*** intensity based on status of work ***
sort hhid
by hhid: gen notempl_intensity_1=sum(total_no_days_in_each_activity) if inlist(status,"81")
by hhid: egen notempl_intensity=max(notempl_intensity_1)
replace notempl_intensity=0 if notempl_intensity==.

sort hhid
by hhid: gen self_intensity_1=sum(total_no_days_in_each_activity) if inlist(status,"11","12","21")
by hhid: egen self_intensity=max(self_intensity_1)
replace self_intensity=0 if self_intensity==.

by hhid: gen wage_empl_intensity_1=sum(total_no_days_in_each_activity) if inlist(status,"31")
by hhid: egen wage_empl_intensity=max(wage_empl_intensity_1)
replace wage_empl_intensity=0 if wage_empl_intensity==.

by hhid: gen casual_intensity_1=sum(total_no_days_in_each_activity) if inlist(status,"41","51")
by hhid: egen casual_intensity=max(casual_intensity_1)
replace casual_intensity=0 if casual_intensity==.

by hhid: gen oth_intensity_1=sum(total_no_days_in_each_activity) if inlist(status,"93","97")
by hhid: egen oth_intensity=max(oth_intensity_1)
replace oth_intensity=0 if oth_intensity==.

by hhid: gen hh_intensity_1=sum(total_no_days_in_each_activity)
by hhid: egen hh_intensity=max(hh_intensity_1)
replace hh_intensity=0 if hh_intensity==.

drop notempl_intensity_1 self_intensity_1 wage_empl_intensity_1 casual_intensity_1 oth_intensity_1 hh_intensity_1

gen notempl_intensity_prop=notempl_intensity/hh_intensity
gen self_intensity_prop=self_intensity/hh_intensity
gen wage_empl_intensity_prop=wage_empl_intensity/hh_intensity
gen casual_intensity_prop=casual_intensity/hh_intensity
gen oth_intensity_prop=oth_intensity/hh_intensity

summ notempl_intensity self_intensity wage_empl_intensity casual_intensity oth_intensity hh_intensity ///
	 notempl_intensity_prop self_intensity_prop wage_empl_intensity_prop casual_intensity_prop oth_intensity_prop

********************************************************************************
*** Weekly wage in cash and kind ***
by hhid: gen self_wage_1=sum(wage_and_salary_earnings_total) if inlist(status,"11","12","21")
by hhid: egen self_wage=max(self_wage_1)
replace self_wage=0 if self_wage==.

by hhid: gen wage_empl_wage_1=sum(wage_and_salary_earnings_total) if inlist(status,"31")
by hhid: egen wage_empl_wage=max(wage_empl_wage_1)
replace wage_empl_wage=0 if wage_empl_wage==.

by hhid: gen casual_wage_1=sum(wage_and_salary_earnings_total) if inlist(status,"41","51")
by hhid: egen casual_wage=max(casual_wage_1)
replace casual_wage=0 if casual_wage==.

by hhid: gen oth_wage_1=sum(wage_and_salary_earnings_total) if inlist(status,"93","97")
by hhid: egen oth_wage=max(oth_wage_1)
replace oth_wage=0 if oth_wage==.

by hhid: gen hh_wage_1=sum(wage_and_salary_earnings_total)
by hhid: egen hh_wage=max(hh_wage_1)
replace hh_wage=0 if hh_wage==.

gen self_wage_prop=self_wage/hh_wage
replace self_wage_prop=0 if self_wage_prop==.
gen wage_empl_wage_prop=wage_empl_wage/hh_wage
replace wage_empl_wage_prop=0 if wage_empl_wage_prop==.
gen casual_wage_prop=casual_wage/hh_wage
replace casual_wage_prop=0 if casual_wage_prop==.
gen oth_wage_prop=oth_wage/hh_wage
replace oth_wage_prop=0 if oth_wage_prop==.

gen self_perday=self_wage/self_intensity
replace self_perday=0 if self_perday==.
gen wage_empl_perday=wage_empl_wage/wage_empl_intensity
replace wage_empl_perday=0 if wage_empl_perday==.
gen casual_perday=casual_wage/casual_intensity
replace casual_perday=0 if casual_perday==.
gen oth_perday=oth_wage/oth_intensity
replace oth_perday=0 if oth_perday==.
gen hh_perday=hh_wage/hh_intensity
replace hh_perday=0 if hh_perday==.

summ self_wage wage_empl_wage casual_wage oth_wage hh_wage ///
	 self_wage_prop wage_empl_wage_prop casual_wage_prop oth_wage_prop ///
	 self_perday wage_empl_perday casual_perday oth_perday

keep hhid notempl_intensity self_intensity wage_empl_intensity casual_intensity oth_intensity hh_intensity ///
		  notempl_intensity_prop self_intensity_prop wage_empl_intensity_prop casual_intensity_prop oth_intensity_prop ///
		  self_wage wage_empl_wage casual_wage oth_wage hh_wage ///
		  self_wage_prop wage_empl_wage_prop casual_wage_prop oth_wage_prop ///
		  self_perday wage_empl_perday casual_perday oth_perday hh_perday

duplicates drop
unique hhid

save "Round 66 EU empl_intensity.dta",replace
********************************************************************************
********************************************************************************
********************************************************************************
