/*
Covid 19 Data Exploration 

*/

--Total COVID 19 cases by Country

Select Country, SUM(New_cases) as Total_Cases
From [WHO-COVID-19-global-data]
Group by Country
Order by Total_Cases desc

--Total COVID 19 deaths by Country

Select Country, SUM(New_deaths) as Total_Deaths
From [WHO-COVID-19-global-data]
Group by Country
Order by Total_Deaths desc

--Percentage regarding deaths

Select Country, SUM(New_cases) as Total_Cases, SUM(New_deaths) as Total_Deaths,
(CONVERT(float,SUM(New_deaths))/CONVERT(float,SUM(New_cases)))*100 as DeathPercentage
From [WHO-COVID-19-global-data]
Group by Country
Having SUM(New_cases) <> 0 and SUM(New_deaths) <> 0
Order by 2 desc, 3 desc

--Global numbers by country

DROP TABLE if exists #GlobalCOVIDNumbers
Create Table #GlobalCOVIDNumbers
(
Country varchar(100),
Cases bigint,
Deaths bigint,
)

Insert into #GlobalCOVIDNumbers
Select Country, SUM(CONVERT(bigint,New_cases)) as Total_Cases, SUM(CONVERT(bigint,New_deaths)) as Total_Deaths
From [WHO-COVID-19-global-data] 
Group by Country

Select cov.Country, cov.Cases as TotalCases, cov.Deaths as TotalDeaths, vac.PERSONS_FULLY_VACCINATED as TotalFullyVaccinated
From #GlobalCOVIDNumbers cov 
Join [vaccination-data] vac
	On cov.Country = vac.COUNTRY
Where cov.Cases <> 0 and cov.Deaths <> 0 and vac.PERSONS_FULLY_VACCINATED <> 0
Order by 2 desc, 3 desc, 4 desc

--Ratio of vaccinations vs cases

Select cov.Country, cov.Cases as TotalCases, vac.PERSONS_FULLY_VACCINATED as TotalFullyVaccinated, 
(CONVERT(float,vac.PERSONS_FULLY_VACCINATED)/CONVERT(float,cov.Cases)) as CasesVacRatio
From #GlobalCOVIDNumbers cov
Join [vaccination-data] vac
	On cov.Country = vac.COUNTRY
Where cov.Cases <> 0 and vac.PERSONS_FULLY_VACCINATED <> 0
Order by 2 desc

--Comparison of People fully vaccinated vs People with only one dose

Select COUNTRY, TOTAL_VACCINATIONS as TotalVaccinatios, PERSONS_FULLY_VACCINATED as FullyVaccinated, 
PERSONS_VACCINATED_1PLUS_DOSE as AtLeastOneDose,
PERSONS_BOOSTER_ADD_DOSE as BoosterAdded,
(PERSONS_VACCINATED_1PLUS_DOSE-PERSONS_FULLY_VACCINATED) as OneDoseVaccinated
From [vaccination-data]
Where TOTAL_VACCINATIONS <> 0 and PERSONS_FULLY_VACCINATED <> 0 and PERSONS_BOOSTER_ADD_DOSE <> 0
Order by 2 desc, 3 desc

--Percentage of vaccinations

Select COUNTRY, (CONVERT(float, PERSONS_FULLY_VACCINATED)/CONVERT(float, TOTAL_VACCINATIONS))*100 as FullyVacPercentage,
(CONVERT(float, (PERSONS_VACCINATED_1PLUS_DOSE-PERSONS_FULLY_VACCINATED))/CONVERT(float, TOTAL_VACCINATIONS))*100 as OneDoseVacPercentage,
(CONVERT(float, PERSONS_BOOSTER_ADD_DOSE)/CONVERT(float, TOTAL_VACCINATIONS))*100 as BoosterVacPercentage
From [vaccination-data]
Where TOTAL_VACCINATIONS <> 0 and PERSONS_FULLY_VACCINATED <> 0 and PERSONS_BOOSTER_ADD_DOSE <> 0
--Order by 2 desc, 3 desc
Order by 2 desc

/*

Note: Wallis and Futuna alongside Kazakhstan present a negative percentage for OneDoseVacPercentage
due to the fact that they present more people as fully vaccinated than at least one dose.

If a person is fully vaccinated, it has at least one dose, so should be included in the 1PLUS_DOSE_PERSONS 
meaning that 1PLUS_DOSE_PERSONS is greater than FULLY_VACCINATED.

This statement is not valid for the countries mentioned above.

*/
