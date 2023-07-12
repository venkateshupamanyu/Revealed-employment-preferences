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

gen treat=0 if land_cultivated!=. & land_cultivated!=0
replace treat=1 if land_cultivated!=. & land_cultivated>0 & land_cultivated<=2
gen land_cultivatedsq=land_cultivated*land_cultivated
gen treat_land_cultivated=treat*land_cultivated
gen treat_land_cultivatedsq=treat*land_cultivated*land_cultivated
gen treat_land_cultivatedcu=treat*land_cultivated*land_cultivated*land_cultivated
gen treat_dry=treat*dry
gen treat_rainy=treat*rainy
gen treat_st=treat*st
gen treat_sc=treat*sc
gen treat_obc=treat*obc
gen treat_starstate=treat*star_state

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

*** Regressions - full sample ***
*** Consumption vars ***
label var ln_mpce_urp "Log Monthly Per Capita Expenditure"
label var ln_mpce_mrp "Log Monthly Per Capita Expenditure"
label var ln_monthly_percap_type1 "Log Monthly Per Capita Expenditure"
label var ln_monthly_percap_type2 "Log Monthly Per Capita Expenditure"
label var ln_monthly_consum_type1 "Log Monthly Expenditure"
label var ln_monthly_consum_type2 "Log Monthly Expenditure"
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
********************************************************************************
********************************************************************************
