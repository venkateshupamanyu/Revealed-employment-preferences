********************************************************************************
*** Merging work ***
cd "C:\Users\venka\Box\Personal\Tufts PhD\Research work\Debt waiver and employment preference"

use "Round 66 T1 id.dta",clear
merge 1:1 hhid using "Round 66 T1 consum_summary.dta"
ren _merge _merge_type1_id_summary
tab _merge_type1_id_summary

merge 1:1 hhid using "Round 66 T1 hh_char.dta"
ren _merge _merge_type1_id_summary_land
tab _merge_type1_id_summary_land

merge 1:1 hhid using "Round 66 T1 Jewelry.dta"
ren _merge _merge_type1_id_summary_landj
tab _merge_type1_id_summary_landj

merge 1:1 hhid using "Round 66 T1 Food.dta"
ren _merge _merge_type1_id_summary_landjf
tab _merge_type1_id_summary_landjf

save "Round 66 T1 id_consum_char_jewelry_food.dta",replace

********************************************************************************
********************************************************************************
********************************************************************************
*** Merging with Employment dataset ***
cd "C:\Users\venka\Box\Personal\Tufts PhD\Research work\Debt waiver and employment preference"

use "Round 66 T1 id_consum_char_jewelry_food.dta",clear
merge 1:1 hhid using "Round 66 EU empl_demo.dta"
tab _merge
ren _merge _mergeempldemo
merge 1:1 hhid using "Round 66 EU empl_activity.dta"
tab _merge
ren _merge _mergeempldemoactiv
merge 1:1 hhid using "Round 66 EU empl_intensity.dta"
tab _merge
ren _merge _mergeempldemoactivintensity

unique hhid
unique hhid if _mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3

egen district_code=group(district)

*** Remember we don't need inflation-adjusted values as we use only 1-year cross-section data of Round 66 ***
global consumvar "mpce_urp mpce_mrp monthly_consum_type1 monthly_consum_type2 monthly_percap_type1 monthly_percap_type2 minordurable durable non_durable"
global consumvar_nonhp "basicfood_hp basicfood_nonhp basicfood_tot luxfood_hp luxfood_nonhp luxfood_tot intox_hp intox_nonhp intox_tot fuellight_hp fuellight_nonhp fuellight_tot"

foreach y in $consumvar $consumvar_nonhp {
gen ln_`y'=ln(`y')
}

gen season=1 if inlist(month,"01","02","03","04","05","06")
replace season=2 if inlist(month,"07","08","09","10","11","12")
destring month,gen(month_1)

tab soc_grp
count if soc_grp=="N"
replace soc_grp="" if soc_grp=="N"
destring soc_grp,gen(soc_grp_1)

gen dry=0 if month!=""
replace dry=1 if season==1
gen rainy=0 if month!=""
replace rainy=1 if season==2

gen st=0 if soc_grp!=""
replace st=1 if soc_grp=="1"
gen sc=0 if soc_grp!=""
replace sc=1 if soc_grp=="2"
gen obc=0 if soc_grp!=""
replace obc=1 if soc_grp=="3"

gen star_state=0
replace star_state=1 if inlist(state,"28","22","02","23","33","08","05")		

*** Low rainfall districts ***
*** Method 1 ***
gen lowrain1=0
replace lowrain1=1 if inlist(district,"2821","2811","2813","1808","1806","1819","1810","1820","2402")
replace lowrain1=1 if inlist(district,"2410","2416","2401","2404","2417","2405","2419")
replace lowrain1=1 if inlist(district,"0201","0203","2212","2211","2912","2903","2913","2917","2909")
replace lowrain1=1 if inlist(district,"2925","2919","2922","2926","2906","2918")
replace lowrain1=1 if inlist(district,"3208","3211","3202","3210","3213","3205","3206","3207")
replace lowrain1=1 if inlist(district,"2335","2343","2345","2323","2325","2326","2337","2324","2327")
replace lowrain1=1 if inlist(district,"2319","2340","2310","2330","2334","2320","2314","2311","2313")
replace lowrain1=1 if inlist(district,"2333","2316","2344","2317","2322","2321")
replace lowrain1=1 if inlist(district,"2705","2707","2702","2704","2710","2703","2709","2715","2717")
replace lowrain1=1 if inlist(district,"2731","2732","2708","2714")
replace lowrain1=1 if inlist(district,"2129","2121","0817","0828","0824","0827","0818","0832","0819")
replace lowrain1=1 if inlist(district,"0820","0830")
replace lowrain1=1 if inlist(district,"3301","3304","2801","2807","0902","0907","0504","0506","1903")
replace lowrain1=1 if inlist(district,"1908","1907")
*** Method 2 ***
gen lowrain2=0
replace lowrain2=1 if inlist(district,"2401","0618","0609","0612","0606","0614","0616","0201","0203")
replace lowrain2=1 if inlist(district,"2903","2303","2305","2302","2304","2306","2308","2309","2310")
replace lowrain2=1 if inlist(district,"2719","2726","2702","2727","2703","2715","2729")
replace lowrain2=1 if inlist(district,"0302","0314","0305","0311","0303","0304","0309","0317","0316")
replace lowrain2=1 if inlist(district,"0806","0821","0807","0817","0824","0803","0823","0829","0804")
replace lowrain2=1 if inlist(district,"0801","0812","0816","0818","0805","0814","0815","0813","0820")
replace lowrain2=1 if inlist(district,"0810","0822","0826")
replace lowrain2=1 if inlist(district,"0912","0915","0940","0946","0919","0955","0911","0917","0931")
replace lowrain2=1 if inlist(district,"0929","0942","0925","0938","0935","0936","0914","0918","0907")
replace lowrain2=1 if inlist(district,"0902","0905","0921","0507")
*replace lowrain2=1 if inlist(district,"")
*replace lowrain2=1 if inlist(district,")
*replace lowrain2=1 if inlist(district,")
*replace lowrain2=1 if inlist(district,")

/*
gen lowrain_1=0
replace lowrain_1=1 if inlist(district,"1808","0201","2925","2926","3208","3202","3213","3205","3210")
replace lowrain_1=1 if inlist(district,"3206","3207","2323","2337","2310","2327","2313","2333")
replace lowrain_1=1 if inlist(district,"2710","2715","2717","2732","2708","2731")
replace lowrain_1=1 if inlist(district,"0817","0828","0827","0819","3304","0902")
replace lowrain_1=1 if inlist(district,"0506","1907")

unique district if lowrain1==1
unique district if lowrain1==1 & sector=="1"
unique district if lowrain2==1
unique district if lowrain2==1 & sector=="1"
*/

*** Low yield districts ***
*gen lowyield=0
*replace lowyield=1 if inlist(district,"") 

gen treat=0 if land_cultivated!=. & land_cultivated!=0
replace treat=1 if land_cultivated!=. & land_cultivated>0 & land_cultivated<=2
gen land_cultivatedsq=land_cultivated*land_cultivated
gen treat_land_cultivated=treat*land_cultivated
gen treat_land_cultivatedsq=treat*land_cultivated*land_cultivated
gen treat_land_cultivatedcu=treat*land_cultivated*land_cultivated*land_cultivated
gen treat_dry=treat*dry
gen treat_rainy=treat*rainy
*gen treat_lowrain1=treat*lowrain1
*gen treat_lowrain2=treat*lowrain2
*gen treat_lowrain_1=treat*lowrain_1
gen treat_st=treat*st
gen treat_sc=treat*sc
gen treat_obc=treat*obc
gen treat_starstate=treat*star_state

/*
gen land_cultivated_t=(land_cultivated-2)*-1
summ land_cultivated if land_cultivated<2
summ land_cultivated_t if land_cultivated<2
summ land_cultivated_t if land_cultivated<4
summ land_cultivated if land_cultivated>2 & land_cultivated<4
summ land_cultivated_t if land_cultivated>2 & land_cultivated<4
summ land_cultivated if land_cultivated_t==0
summ land_cultivated if land_cultivated_t<0 & land_cultivated<4
summ land_cultivated if land_cultivated_t>0


gen treat_1=0 if land_cultivated!=. & land_cultivated!=0
replace treat_1=1 if land_cultivated_t>=0 & land_cultivated_t<2
gen land_cultivated_tsq=land_cultivated_t*land_cultivated_t
gen treat1_land_cultivated_t=treat_1*land_cultivated_t
gen treat1_land_cultivated_tsq=treat_1*land_cultivated_t*land_cultivated_t
gen treat1_land_cultivated_tcu=treat_1*land_cultivated_t*land_cultivated_t*land_cultivated_t
*/
*** False-cutoff values ***
gen treat_f1=0 if land_cultivated!=. & land_cultivated!=0
replace treat_f1=1 if land_cultivated!=. & land_cultivated>0 & land_cultivated<=1
gen treat_f3=0 if land_cultivated!=. & land_cultivated!=0
replace treat_f3=1 if land_cultivated!=. & land_cultivated>0 & land_cultivated<=3
gen treat_f4=0 if land_cultivated!=. & land_cultivated!=0
replace treat_f4=1 if land_cultivated!=. & land_cultivated>0 & land_cultivated<=4
gen treatf1_land_cultivated=treat_f1*land_cultivated
gen treatf1_land_cultivatedsq=treat_f1*land_cultivated*land_cultivated
gen treatf3_land_cultivated=treat_f3*land_cultivated
gen treatf3_land_cultivatedsq=treat_f3*land_cultivated*land_cultivated
gen treatf4_land_cultivated=treat_f4*land_cultivated
gen treatf4_land_cultivatedsq=treat_f4*land_cultivated*land_cultivated

summ land_cultivated if treat_f1==0
summ land_cultivated if treat_f1==1

summ land_cultivated if treat_f3==0
summ land_cultivated if treat_f3==1

summ land_cultivated if treat_f4==0
summ land_cultivated if treat_f4==1

*** Summary of land cultivated land cultivated_t ***
summ land_cultivated if treat==0
summ land_cultivated if treat==1
*summ land_cultivated_t if treat_1==0
*summ land_cultivated_t if treat_1==1

/*
gen treat_1=0 if land_cultivated!=. & land_cultivated!=0 & hh_type=="14"
replace treat_1=1 if land_cultivated!=. & land_cultivated!=0 & land_cultivated>0 & land_cultivated<=2 & hh_type=="14"
gen treat1_land_cultivated=treat_1*land_cultivated
gen treat1_land_cultivatedsq=treat_1*land_cultivated*land_cultivated
gen treat1_land_cultivatedcu=treat_1*land_cultivated*land_cultivated*land_cultivated
*/
********************************************************************************
*** RD specifications *** 
global lnconsumvar "ln_mpce_urp ln_mpce_mrp ln_monthly_percap_type1 ln_monthly_percap_type2 ln_monthly_consum_type1 ln_monthly_consum_type2 ln_minordurable ln_durable ln_non_durable"
global lnconsumvar_nonhp "ln_basicfood_nonhp ln_luxfood_nonhp ln_intox_nonhp ln_fuellight_nonhp"
global activity "self_empl_tot wage_tot casual_tot oth_tot hh_size_adult self_empl_prop wage_prop casual_prop oth_prop"
global intensity "self_intensity wage_empl_intensity casual_intensity oth_intensity hh_intensity self_intensity_prop wage_empl_intensity_prop casual_intensity_prop oth_intensity_prop"
global earning "self_wage wage_empl_wage casual_wage oth_wage hh_wage self_wage_prop wage_empl_wage_prop casual_wage_prop oth_wage_prop"
global dailyearning "self_perday wage_empl_perday casual_perday oth_perday hh_perday"
global vocation "voc_training_binary voc_training no_voc_training voc_training_prop no_voc_training_prop"
global jewelry "jewelry ln_jewelry"

*** Specification 1 - Linear ***
*** Y = a + bT + cX - not working ***
foreach y in $intensity_prop {
areg `y' treat land_cultivated if ///
		_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0 & land_cultivated<=4 [pweight=multiplier], ///
		absorb(district) cluster(district)
}
*** Specification 2 - Linear (with interaction) ***
*** Y = a + bT + cX + d(T*X) - working (not working for perday) ***
foreach y in $intensity_prop {
areg `y' treat land_cultivated treat_land_cultivated if ///
		_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0 & land_cultivated<=4 [pweight=multiplier], ///
		absorb(district) cluster(district)
}
*** Specification 3 - Linear (with interaction) and Quadratic ***
*** Y = a + bT + cX + d(T*X) + e(X^2) +  f(T*X^2) - not working ***
foreach y in $intensity {
areg `y' treat land_cultivated treat_land_cultivated land_cultivatedsq treat_land_cultivatedsq if ///
		_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0 & land_cultivated<=4 & nic_3=="011" [pweight=multiplier], ///
		absorb(district) cluster(district)
}		
*** Specification 4 - Linear (with interaction) and Quadratic interaction ***
*** Y = a + bT + cX + d(T*X) + e(T*X^2) - working ***
foreach y in $activity {
areg `y' treat land_cultivated treat_land_cultivated treat_land_cultivatedsq if ///
		_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0 & land_cultivated<=4 [pweight=multiplier], ///
		absorb(district) cluster(district)
}
*** Specification 5 - Linear (only interaction) and Quadratic interaction ***
*** Y = a + bT + c(T*X) + f(T*X^2) - working ***
foreach y in $activity {
areg `y' treat treat_land_cultivated treat_land_cultivatedsq if ///
		_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0 & land_cultivated<=4 [pweight=multiplier], ///
		absorb(district) cluster(district)
}

********************************************************************************	
********************************************************************************
********************************************************************************		
*** Regressions - full sample ***
cd "C:\Users\venka\Box\Personal\Tufts PhD\Research work\Debt waiver and employment preference"
*** Consumption vars ***
label var ln_mpce_urp "Log Monthly Per Capita Expenditure"
label var ln_mpce_mrp "Log Monthly Per Capita Expenditure"
label var ln_monthly_percap_type1 "Log Monthly Per Capita Expenditure"
label var ln_monthly_percap_type2 "Log Monthly Per Capita Expenditure"
label var ln_monthly_consum_type1 "Log Monthly Expenditure"
label var ln_monthly_consum_type2 "Log Monthly Expenditure"
*label var ln_basic_food "Log Basic Food"
*label var ln_lux_food "Log Luxury Food"
*label var ln_intox "Log Intoxicants"
label var ln_minordurable "Log Minor Durable Goods"
label var ln_durable "Log Durable Goods"
label var ln_non_durable "Log Non-Durable Goods"
label var ln_basicfood_hp "Log Basic Food - Home Produced"
label var ln_basicfood_nonhp "Log Basic Food"
label var ln_basicfood_tot "Log Basic Food - Total"
label var ln_luxfood_hp "Log Luxury Food - Home Produced"
label var ln_luxfood_nonhp "Log Luxury Food"
label var ln_luxfood_tot "Log Luxury Food - Total"
label var ln_intox_hp "Log Intoxicants - Home Produced"
label var ln_intox_nonhp "Log Intoxicants"
label var ln_intox_tot "Log Intoxicants - Total"
label var ln_fuellight_hp "Log Fuel & Light - Home Produced"
label var ln_fuellight_nonhp "Log Fuel & Light"
label var ln_fuellight_tot "Log Fuel & Light - Total"
*** Activity vars ***
label var not_empl_tot "Number of HH members Seeking/Available for Employment"
label var self_empl_tot "Number of HH members in Self-Employment"
label var wage_tot "Number of HH members in Wage Employment"
label var casual_tot "Number of HH members in Casual Employment"
label var oth_tot "Number of HH members in Other Employment"
label var hh_size_adult "Number of Adult Household Members"
label var not_empl_prop "Proportion of HH members Seeking/Available for Employment"
label var self_empl_prop "Proportion in Self-Employment"
label var wage_prop "Proportion in Wage Employment"
label var casual_prop "Proportion in Casual Employment"
label var oth_prop "Proportion in Other Employment"
*** Intensity vars ***
label var notempl_intensity "No. of days Seeking/Available for Employment"
label var self_intensity "No. of days in Self-Employment"
label var wage_empl_intensity "No. of days in Wage Employment"
label var casual_intensity "No. of days in Casual Employment"
label var oth_intensity "No. of days in Other Employment"
label var hh_intensity "Total No. of days"
label var notempl_intensity_prop "Proportion of days Seeking/Available for Employment"
label var self_intensity_prop "Proportion of days in Self-Employment"
label var wage_empl_intensity_prop "Proportion of days in Wage Employment"
label var casual_intensity_prop "Proportion of days in Casual Employment"
label var oth_intensity_prop "Proportion of days in Other Employment"
*** Wage vars ***
label var self_wage "Income from Self-Employment"
label var wage_empl_wage "Income from Wage Employment"
label var casual_wage "Income from Casual Employment"
label var oth_wage "Income from Other Employment"
label var hh_wage "Total Household Income"
label var self_wage_prop "Proportion of income from Self-Employment"
label var wage_empl_wage_prop "Proportion of income from Wage Employment"
label var casual_wage_prop "Proportion of income from Casual Employment"
label var oth_wage_prop "Proportion of income from Other Employment"
*** perday vars ***
label var self_perday "Daily Earnings From Self-Employment"
label var wage_empl_perday "Daily Earnings From Wage Employment"
label var casual_perday "Daily Earnings From Casual Employment"
label var oth_perday "Daily Earnings From Other Employment"
label var hh_perday "Total Household Daily Earnings"
*** Vocation vars ***
label var voc_training_binary "Took Vocational Training (==1)"
label var voc_training "Number Took Vocational Training"
label var no_voc_training "Number Didn't Take Vocational Training"
label var voc_training_prop "Proportion Took Vocational Training"
label var no_voc_training_prop "Proportion Didn't Take Vocational Training"
*** Jewelry ***
label var jewelry "Jewelry Expenditure"
label var ln_jewelry "Log Jewelry Expenditure"
*** Treatment vars ***
label var treat "Treat"
label var treat_land_cultivated "Treat x Land cultivated"
label var treat_land_cultivatedsq "Treat x Land cultivated^2"
label var treat_starstate "Treat x Star State"
label var treat_dry "Treat x Dry"
label var treat_obc "Treat x OBC"
label var treat_sc "Treat x SC"

/*
global lnconsumvar "ln_mpce_urp ln_mpce_mrp ln_basic_food ln_lux_food ln_intox ln_durable ln_non_durable"
foreach y in $lnconsumvar {
areg `y' treat treat_land_cultivated treat_land_cultivatedsq  if ///
		_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0  & land_cultivated<=4 [pweight=multiplier], ///
		absorb(district) cluster(district)
est store r_`y'		
summ `y' if land_cultivated!=. & land_cultivated!=0  & land_cultivated>2 & land_cultivated<=4
di r(mean)		
estadd scalar `y'_mean = r(mean)
}
outreg2 [r_ln_mpce_urp r_ln_mpce_mrp r_ln_basic_food r_ln_lux_food r_ln_intox r_ln_durable r_ln_non_durable] ///
using "consumption_spec5_sample.xls", addstat(Control mean, r(ymean)) drop(i.district) label nocons dec(3) excel replace
erase "consumption_spec5_sample.txt"
*/


*global lnconsumvar_hp "ln_basicfood_hp ln_luxfood_hp ln_intox_hp ln_fuellight_hp"
*global lnconsumvar_nonhp "ln_basicfood_nonhp ln_luxfood_nonhp ln_intox_nonhp ln_fuellight_nonhp"
*global lnconsumvar_tot "ln_basicfood_tot ln_luxfood_tot ln_intox_tot ln_fuellight_tot"

global lnconsumvar "ln_mpce_urp ln_mpce_mrp ln_monthly_percap_type1 ln_monthly_percap_type2 ln_monthly_consum_type1 ln_monthly_consum_type2 ln_minordurable ln_durable ln_non_durable"
summ $lnconsumvar if _mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0  & land_cultivated>2 & land_cultivated<=4 & nic_3=="452"
foreach y in $lnconsumvar {
areg `y' treat treat_land_cultivated treat_land_cultivatedsq  if ///
		_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0  & land_cultivated<=4 & nic_3=="452" [pweight=multiplier], ///
		absorb(district) cluster(district)
est store r_`y'		
}
outreg2 [r_ln_mpce_urp r_ln_mpce_mrp r_ln_monthly_percap_type1 r_ln_monthly_percap_type2 r_ln_monthly_consum_type1 r_ln_monthly_consum_type2 r_ln_minordurable r_ln_durable r_ln_non_durable] ///
using "consumption_spec5_nic452.xls", drop(i.district) label nocons dec(3) excel replace
erase "consumption_spec5_nic452.txt"

global lnconsumvar_nonhp "ln_basicfood_nonhp ln_luxfood_nonhp ln_intox_nonhp ln_fuellight_nonhp"
summ $lnconsumvar_nonhp if _mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0  & land_cultivated>2 & land_cultivated<=4 & nic_3=="452"
foreach y in $lnconsumvar_nonhp {
areg `y' treat treat_land_cultivated treat_land_cultivatedsq  if ///
		_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0  & land_cultivated<=4 & nic_3=="452" [pweight=multiplier], ///
		absorb(district) cluster(district)
est store r_`y'		
}
outreg2 [r_ln_basicfood_nonhp r_ln_luxfood_nonhp r_ln_intox_nonhp r_ln_fuellight_nonhp] ///
using "consumption_spec5_nic452_nonhp.xls", drop(i.district) label nocons dec(3) excel replace
erase "consumption_spec5_nic452_nonhp.txt"

/*
foreach y in $lnconsumvar_tot {
areg `y' treat treat_land_cultivated treat_land_cultivatedsq  if ///
		_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0  & land_cultivated<=4 & nic_3=="011" [pweight=multiplier], ///
		absorb(district) cluster(district)
est store r_`y'		
}

global lnconsumvar "ln_mpce_urp ln_mpce_mrp ln_basic_food ln_lux_food ln_intox ln_durable ln_non_durable"
foreach y in $lnconsumvar {
winsor `y', gen(`y'_new) p(0.03)
}

global lnconsumvar "ln_mpce_urp ln_mpce_mrp ln_basic_food ln_lux_food ln_intox ln_durable ln_non_durable"
foreach y in $lnconsumvar {
areg `y'_new treat treat_land_cultivated treat_land_cultivatedsq  if ///
		_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0  & land_cultivated<=4 & nic_3=="011" [pweight=multiplier], ///
		absorb(district) cluster(district)
est store r_`y'		
}
outreg2 [r_ln_mpce_urp r_ln_mpce_mrp r_ln_basic_food r_ln_lux_food r_ln_intox r_ln_durable r_ln_non_durable] ///
using "consumption_spec5.xls", drop(i.district) label nocons dec(3) excel replace
erase "consumption_spec5.txt"
*/

global activity "self_empl_tot wage_tot casual_tot not_empl_tot oth_tot  self_empl_prop wage_prop casual_prop not_empl_prop oth_prop"
summ $activity if _mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0  & land_cultivated>2 & land_cultivated<=4 & nic_3=="452"
foreach a in $activity {
areg `a' treat treat_land_cultivated treat_land_cultivatedsq  if ///
		_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0 & land_cultivated<=5 & nic_3=="011" [pweight=multiplier], ///
		absorb(district) cluster(district)
est store a_`a'
}
outreg2 [a_self_empl_tot a_wage_tot a_casual_tot a_not_empl_tot a_oth_tot  a_self_empl_prop a_wage_prop a_casual_prop a_not_empl_prop a_oth_prop] ///
using "activity_spec5_nic011_false3.xls", drop(i.district) label nocons dec(3) excel replace
erase "activity_spec5_nic011_false3.txt"

global intensity "self_intensity wage_empl_intensity casual_intensity notempl_intensity oth_intensity hh_intensity  self_intensity_prop wage_empl_intensity_prop casual_intensity_prop notempl_intensity_prop oth_intensity_prop"
summ $intensity if _mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0  & land_cultivated>2 & land_cultivated<=4 & nic_3=="452"
foreach y in $intensity {
areg `y' treat land_cultivated treat_land_cultivated land_cultivatedsq treat_land_cultivatedsq  if ///
		_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0  & land_cultivated<=5 & land_cultivated>1 & nic_3=="011" [pweight=multiplier], ///
		absorb(district) cluster(district)
est store s_`y'
}
outreg2 [s_self_intensity s_wage_empl_intensity s_casual_intensity s_notempl_intensity s_oth_intensity  s_self_intensity_prop s_wage_empl_intensity_prop s_casual_intensity_prop s_notempl_intensity_prop s_oth_intensity_prop] ///
using "intensity_spec5_nic011_false3.xls", drop(i.district) label nocons dec(3) excel replace
erase "intensity_spec5_nic011_false3.txt"

global earning "self_wage wage_empl_wage casual_wage oth_wage hh_wage self_wage_prop wage_empl_wage_prop casual_wage_prop oth_wage_prop"
summ $earning if _mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0  & land_cultivated>2 & land_cultivated<=4 & nic_3=="452"
foreach y in $earning {
areg `y' treat land_cultivated treat_land_cultivated land_cultivatedsq treat_land_cultivatedsq  if ///
		_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0  & land_cultivated<=4 & nic_3=="011" [pweight=multiplier], ///
		absorb(district) cluster(district)
est store t_`y'
}
outreg2 [t_self_wage t_wage_empl_wage t_casual_wage t_oth_wage t_self_wage_prop t_wage_empl_wage_prop t_casual_wage_prop t_oth_wage_prop] ///
using "earning_spec4_nic011.xls", drop(i.district) label nocons dec(3) excel replace
erase "earning_spec4_nic011.txt"

global dailyearning "self_perday wage_empl_perday casual_perday oth_perday hh_perday"
summ $dailyearning if _mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0  & land_cultivated>2 & land_cultivated<=4 & nic_3=="452"
foreach y in $dailyearning {
areg `y' treat land_cultivated treat_land_cultivated land_cultivatedsq treat_land_cultivatedsq  if ///
		_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0  & land_cultivated<=4 & nic_3=="011" [pweight=multiplier], ///
		absorb(district) cluster(district)
est store u_`y'
}
outreg2 [u_self_perday u_wage_empl_perday u_casual_perday u_oth_perday] ///
using "dailyearning_spec4_nic011.xls", drop(i.district) label nocons dec(3) excel replace
erase "dailyearning_spec4_nic011.txt"

global vocation "voc_training_binary voc_training no_voc_training voc_training_prop no_voc_training_prop"
summ $vocation if _mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0  & land_cultivated>2 & land_cultivated<=4 & nic_3=="011"
foreach y in $vocation {
areg `y' treat land_cultivated treat_land_cultivated land_cultivatedsq treat_land_cultivatedsq  if ///
		_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0  & land_cultivated<=4 & nic_3=="011" [pweight=multiplier], ///
		absorb(district) cluster(district)
est store v_`y'
}
outreg2 [v_voc_training_binary v_voc_training v_no_voc_training v_voc_training_prop v_no_voc_training_prop] ///
using "vocation_spec4_nic011.xls", drop(i.district) label nocons dec(3) excel replace
erase "vocation_spec4_nic011.txt"

global jewelry "jewelry ln_jewelry"
foreach j in $jewelry {
areg `j' treat land_cultivated treat_land_cultivated land_cultivatedsq treat_land_cultivatedsq  if ///
		_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0  & land_cultivated<=4 & nic_3=="011" [pweight=multiplier], ///
		absorb(district) cluster(district)
est store j_`j'
}
outreg2 [j_jewelry j_ln_jewelry] ///
using "jewelry_spec4_nic011.xls", drop(i.district) label nocons dec(3) excel replace
erase "jewelry_spec4_nic011.txt"

********************************************************************************
*** Summary stats ***
unique hhid if _mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0 & land_cultivated<=4
unique hhid if _mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0 & land_cultivated<=4 & nic_3=="011"
summ $consumvar $consumvar_nonhp $activity $intensity $wage $perday if ///
	 _mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0 & land_cultivated<=4
summ $consumvar $consumvar_nonhp $activity $intensity $wage $perday if ///
	 _mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0 & land_cultivated<=4 & nic_3=="011"
********************************************************************************	
*** Graph by month ***
preserve
collapse (mean) casual_prop if ///
				_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
				treat==1 & nic_3=="011", by(month_1)
*graph twoway (line casual_intensity_prop month_1 if treat==0) (line casual_intensity_prop month_1 if treat==1),xlabel(#12)
*graph twoway (line self_empl_prop month_1,yaxis(1) ysc(range(.25 .35) axis(1))) (line casual_prop month_1,yaxis(2) ysc(range(0.05 .15) axis(2))),xlabel(#12)
graph twoway line casual_prop month_1,xlabel(#12)
restore

preserve
collapse (mean) casual_intensity_prop if ///
				_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
				nic_3=="011", by(month_1)
graph twoway line casual_intensity_prop month_1,xlabel(#12)
restore

*** Graph by land cultivated buckets ***
*** It may not be required, as we do RDplot which is similar to this ***
xtile ten=land_cultivated if land_cultivated!=. & land_cultivated!=0 & land_cultivated>1.5 & land_cultivated<=2.5,nq(10)

pctile pct = land_cultivated, nq(10)

preserve
collapse (mean) self_empl_prop if ///
				_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
				nic_3=="011", by(ten)
graph twoway line self_empl_prop ten,xlabel(#12)
restore
********************************************************************************
********************************************************************************
********************************************************************************
*** RD plots ***
global lnconsumvar "ln_mpce_urp ln_mpce_mrp ln_basic_food ln_lux_food ln_intox ln_durable ln_non_durable"
foreach y in $lnconsumvar {
rdplot `y' treat treat_land_cultivated treat_land_cultivatedsq
}		
rdplot casual_intensity_prop land_cultivated if ///
	   _mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1" & ///
		land_cultivated!=. & land_cultivated!=0 & land_cultivated<=4,c(2) p(2) ci(95) binselect(esmv)

********************************************************************************		
*** cmogram plots ***
cmogram self_intensity_prop land_cultivated if land_cultivated<=4, cut(2) scatter line(2) qfit
cmogram casual_intensity_prop land_cultivated if land_cultivated<=4, cut(2) scatter line(2) qfit
********************************************************************************
********************************************************************************		
*** rdrobust command ***
global perday "self_perday wage_empl_perday casual_perday oth_perday"
foreach y in $perday {
rdrobust `y' land_cultivated_t if land_cultivated!=0 & land_cultivated!=. & land_cultivated<=4 & ///
					_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1",c(0) all bwselect(mserd)
}
summ casual_perday if land_cultivated!=0 & land_cultivated!=. & land_cultivated<=2 & ///
					_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1"
summ casual_perday if land_cultivated!=0 & land_cultivated!=. & land_cultivated>2 & land_cultivated<=4 & ///
					_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1"
rdplot self_intensity_prop land_cultivated_t if land_cultivated!=0 & land_cultivated!=. & land_cultivated<=4 & ///
					_mergeempldemo==3 & _mergeempldemoactiv==3 & _mergeempldemoactivintensity==3 & sector=="1",c(0) ci(95) p(2) binselect(es)
********************************************************************************
