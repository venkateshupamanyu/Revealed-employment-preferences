********************************************************************************
********************************************************************************
********************************************************************************
*** Consumer expenditure files ***
*** Type 1 - Uniform and Mixed Reference Period ***

use "Identification of Sample Household.dta",clear

ren *,l
ren hh_id hhid
unique hhid 

*** Date of survey ***
tab dos
gen year=substr(dos,-2,2)
tab year
gen month=substr(dos,-4,2)
tab month

tab month year
unique hhid
sort hhid 

keep hhid state district month year sector mlt multiplier

save "Round 66 T1 id.dta",replace
********************************************************************************
*** Summary of consumer expenditure *** 
use "Summary of comsumer expenditure.dta",clear

ren *,l
unique hh_id

ren hh_id hhid
sort hhid sl_no
tab sl_no

by hhid: gen monthly_percap_type1_1 = value/100 if sl_no=="47"
by hhid: gen monthly_percap_type2_1 = value/100 if sl_no=="48"
by hhid: gen monthly_consum_type1_1 = value if sl_no=="43"
by hhid: gen monthly_consum_type2_1 = value if sl_no=="44"
by hhid: gen minordurable_1 = sum(value) if inlist(sl_no,"20","21","22")
by hhid: gen durable_1 = sum(value) if inlist(sl_no,"42")
by hhid: gen non_durable_1 = sum(value) if inlist(sl_no,"17","19","23","24")

*** following 2 measure are mpce_urp and mpce_mrp ***
by hhid: egen monthly_percap_type1 = max(monthly_percap_type1_1)
by hhid: egen monthly_percap_type2 = max(monthly_percap_type2_1)
by hhid: egen monthly_consum_type1 = max(monthly_consum_type1_1)
by hhid: egen monthly_consum_type2 = max(monthly_consum_type2_1)
by hhid: egen minordurable = max(minordurable_1)
by hhid: egen durable = max(durable_1)
by hhid: egen non_durable = max(non_durable_1)

drop monthly_consum_type1_1 monthly_consum_type2_1 monthly_percap_type1_1 monthly_percap_type2_1 minordurable_1 durable_1 non_durable_1
summ hhid monthly_consum_type1 monthly_consum_type2 monthly_percap_type1 monthly_percap_type2 minordurable durable non_durable

keep hhid monthly_consum_type1 monthly_consum_type2 monthly_percap_type1 monthly_percap_type2 minordurable durable non_durable

duplicates drop
unique hhid
summ monthly_consum_type1 monthly_consum_type2 monthly_percap_type1 monthly_percap_type2 minordurable durable non_durable

save "Round 66 T1 consum_summary.dta",replace
********************************************************************************
*** Household characteristics ***
use "Household Characteristics.dta",clear
ren *,l
unique hh_id
ren hh_id hhid
order hhid
sort hhid

gen nic_3 = substr(nic_2004,1,3)
tab nic_3

ren social_group soc_grp
tab soc_grp

count if land_cultivated==0
count if land_cultivated==.
count if land_cultivated<2 & !inlist(land_cultivated,0,.)
count if land_cultivated>2 & land_cultivated<4 & !inlist(land_cultivated,0,.)

count if land_owned<2 & !inlist(land_owned,0,.) & hh_type=="14" & inlist(nic_3,"011","012","013","014")
count if land_owned>2 & land_owned<5 & !inlist(land_owned,0,.) & hh_type=="14" & inlist(nic_3,"011","012","013","014")

count if land_leasedin<2 & !inlist(land_leasedin,0,.)
count if land_leasedin>2 & land_leasedin<5 & !inlist(land_leasedin,0,.)

count if total_land_possesed<2 & !inlist(total_land_possesed,0,.)
count if total_land_possesed>2 & total_land_possesed<5 & !inlist(total_land_possesed,0,.)

count if land_cultivated<2 & !inlist(land_cultivated,0,.) & hh_type=="14" & inlist(nic_3,"011","012","013","014")
count if land_cultivated>2 & land_cultivated<5 & !inlist(land_cultivated,0,.)  & hh_type=="14" & inlist(nic_3,"011","012","013","014")

count if land_irrigated<2 & !inlist(land_irrigated,0,.) & hh_type=="14" & inlist(nic_3,"011","012","013","014") 
count if land_irrigated>2 & land_irrigated<5 & !inlist(land_irrigated,0,.) & hh_type=="14" & inlist(nic_3,"011","012","013","014")

sort hhid

keep hhid nic_3 hh_type hh_size owned_any_land owned_land_type land_owned land_leasedin total_land_possesed land_cultivated land_irrigated mpce_urp mpce_mrp soc_grp mlt multiplier

save "Round 66 T1 hh_char.dta",replace
********************************************************************************
*** Jewelry data ***
use "Expenditure for purchase and construction (including repair and maintenance).dta",clear

ren *,l
ren hh_id hhid
unique hhid

unique hhid if item_code=="640"
unique hhid if item_code=="641"
unique hhid if item_code=="642"
unique hhid if item_code=="643"
unique hhid if item_code=="649"

summ total_expenditure_365days if item_code=="649"
count if total_expenditure_365days==0 & item_code=="649"
count if total_expenditure_365days==. & item_code=="649"
count if inlist(total_expenditure_365days,0,.) & item_code=="649"
count if !inlist(total_expenditure_365days,0,.) & item_code=="649"
summ total_expenditure_365days if !inlist(total_expenditure_365days,0,.) & item_code=="649"

drop if item_code!="649"
keep hhid total_expenditure_365days 
ren total_expenditure_365days jewelry
replace jewelry=0 if jewelry==.
gen ln_jewelry=ln(jewelry)
replace ln_jewelry=0 if ln_jewelry==. & jewelry==0
summ jewelry ln_jewelry
sort hhid

save "Round 66 T1 jewelry.dta",replace
********************************************************************************
*** Cereals, pulses, milk and milk products, sugar and salt during the last 30 days ***
use "Consumption of cereals, pulses, milk and milk products, sugar and salt during the last 30 days.dta",clear

ren *,l
ren hh_id hhid
unique hhid 
tab item_code
*** Basic food - cereals,cereal substitutes,pulses,milk & milk products,sugar,salt and vegetables ***
*** Luxury food - edible oil, egg-fish-meat,fruits fresh,fruits dry,spices and beverages ***
*** Intoxicants - pan,tobacco and intoxicants ***
sort hhid item_code
by hhid: gen  basicfood_hp_1 = sum(hp_value) if inlist(item_code,"129","139","159","169","179","189","249")
by hhid: egen basicfood_hp = max(basicfood_hp_1)
by hhid: gen  basicfood_tot_1 = sum(total_value) if inlist(item_code,"129","139","159","169","179","189","249")
by hhid: egen basicfood_tot = max(basicfood_tot_1)
by hhid: gen  basicfood_nonhp = basicfood_tot - basicfood_hp

by hhid: gen  luxfood_hp_1 = sum(hp_value) if inlist(item_code,"199","209","269","279","289","309")
by hhid: egen luxfood_hp = max(luxfood_hp_1)
by hhid: gen  luxfood_tot_1 = sum(total_value) if inlist(item_code,"199","209","269","279","289","309")
by hhid: egen luxfood_tot = max(luxfood_tot_1)
by hhid: gen  luxfood_nonhp = luxfood_tot - luxfood_hp

by hhid: gen  intox_hp_1 = sum(hp_value) if inlist(item_code,"319","329","339")
by hhid: egen intox_hp = max(intox_hp_1)
by hhid: gen  intox_tot_1 = sum(total_value) if inlist(item_code,"319","329","339")
by hhid: egen intox_tot = max(intox_tot_1)
by hhid: gen  intox_nonhp = intox_tot - intox_hp

by hhid: gen  fuellight_hp_1 = sum(hp_value) if inlist(item_code,"359")
by hhid: egen fuellight_hp = max(fuellight_hp_1)
by hhid: gen  fuellight_tot_1 = sum(total_value) if inlist(item_code,"359")
by hhid: egen fuellight_tot = max(fuellight_tot_1)
by hhid: gen  fuellight_nonhp = fuellight_tot - fuellight_hp

drop basicfood_hp_1 basicfood_tot_1 ///
	 luxfood_hp_1 luxfood_tot_1 ///
	 intox_hp_1 intox_tot_1 ///
	 fuellight_hp_1 fuellight_tot_1

keep hhid basicfood_hp basicfood_tot basicfood_nonhp ///
		  luxfood_hp luxfood_tot luxfood_nonhp ///
		  intox_hp intox_tot intox_nonhp ///
		  fuellight_hp fuellight_tot fuellight_nonhp
duplicates drop

save "Round 66 T1 Food.dta",replace
********************************************************************************
