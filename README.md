# Revealed-employment-preferences
While welfare schemes can serve as a valuable safety net, they may also give rise to unintended consequences which may not be fully captured during implementation. We study the impact of a 2008 debt waiver scheme in India on the employment outcomes of its beneficiaries. We observe that farmers who benefitted from the waiver tend to shift their labor away from agriculture and towards casual and wage employment. We suggest that credit constraints faced by the waiver beneficiaries could drive such a shift in employment preferences. We find that the shift towards casual employment helps beneficiaries maintain consumption levels in the face of negative shocks, meaning the alternative employment helps serve as a coping mechanism for the household. This tendency of waiver beneficiaries to shift away from agriculture shows the externalities associated with welfare programs on rural labor markets.


Contains STATA codes for data cleaning and analysis

1 - DW - Round 66 Consumption datasets.do
Extracts consumption variables from Round 66 data modules
Creates consumption variables like expenditures on basic food, luxury food, intoxicants, fuel & light, durable goods and monthly per capita expenditure

2 - DW - Round 66 Employment-Unemployment datasets.do
Extracts employment variables/features from Round 66 data modules
Creates employment variables under various employment types - self-employment, casual employment, wage/salary employment and other employment.
Outputs employment variables like number of houeshold members, proportion of household members, time spent by household, income and percapita wages obtained for different type of employments 

3 - DW - Round 66 merged datasets and analysis.do
Merges the consumption and employment datasets, creates required variables/features and performs RD analysis and RD plots.

4 - IHDS II data - credit outcomes and analysis.do
Extracts required credit outcome variables/features from IHDS-II dataset and obtians credit outcomes in the form of number of loans obtained, magnitude of the largest loan, interest rates of loans and sources of loans
