-- Create table covid_death and covid_vaccinations

create table covid_death (
	iso_code text,
    continent text,
    location text,
    date date,
    population bigint,
    total_cases bigint,
    new_cases bigint,
    new_cases_smoothed decimal(8,2),
    total_deaths bigint,
    new_deaths int,
    new_deaths_smoothed decimal(8,2),
    total_cases_per_million decimal(8,2),
    new_cases_per_million decimal(8,2),
    new_cases_smoothed_per_million decimal(8,2),
    total_deaths_per_million decimal(8,2),
    new_deaths_per_million decimal(8,2),
    new_deaths_smoothed_per_million decimal(8,2),
    reproduction_rate decimal(3,2),
    icu_patients int,
    icu_patients_per_million decimal(8,2),
    hosp_patients int,
    hosp_patients_per_million decimal(8,2),
    weekly_icu_admissions decimal(8,2),
    weekly_icu_admissions_per_million decimal(8,2),
    weekly_hosp_admissions decimal(8,2),
    weekly_hosp_admissions_per_million decimal(8,2)
    );

create table covid_vaccinations (
	iso_code text,	
	continent text,
	location text,
	date date,
	total_tests bigint,
	new_tests bigint,
	total_tests_per_thousand decimal(8,2),
	new_tests_per_thousand decimal(8,2),
	new_tests_smoothed int,
	new_tests_smoothed_per_thousand decimal(8,2),
	positive_rate decimal(3,2),
	tests_per_case decimal(5,1),
	tests_units text,
	total_vaccinations bigint,
	people_vaccinated bigint,
	people_fully_vaccinated bigint,
	total_boosters bigint,
	new_vaccinations int,
	new_vaccinations_smoothed int,
	total_vaccinations_per_hundred decimal(5,2),
	people_vaccinated_per_hundred decimal(5,2),
	people_fully_vaccinated_per_hundred decimal(5,2),
	total_boosters_per_hundred decimal(5,2),
	new_vaccinations_smoothed_per_million int,
	new_people_vaccinated_smoothed int,
	new_people_vaccinated_smoothed_per_hundred decimal(4,2),
	stringency_index decimal(4,2),
	population_density decimal(8,2),
	median_age int,
	aged_65_older decimal(4,2),
	aged_70_older decimal(4,2),
	gdp_per_capita decimal(8,2),
	extreme_poverty decimal(3,1),
	cardiovasc_death_rate decimal(5,2),
	diabetes_prevalence decimal(4,2),
	female_smokers decimal(3,1),
	male_smokers decimal(3,1),
	handwashing_facilities decimal(4,2),
	hospital_beds_per_thousand decimal(4,2),
	life_expectancy decimal(4,2),
	human_development_index decimal(3,2)
    );

-- Load data local infile to the tables

load data local infile 'covid_vaccinations.csv'
into table covid_vaccinations
fields terminated by ','
ignore 1 rows;

load data local infile 'covid_deaths.csv'
into table covid_death
fields terminated by ','
ignore 1 rows;

-- Quick view of the data that will be used

select Location, date, total_cases, new_cases, total_deaths, population
from covid_death
order by 1,2;

-- reported case-fatality ratio (CFR) in Indonesia

select Location, date, total_cases, total_deaths, (total_deaths/NULLIF(total_cases, 0))*100 as reported_case_fatality_ratio_pct
from covid_death
where location = 'Indonesia'
order by 1,2;

-- reported cumulative cases as a percentage of population

select Location, date, Population, total_cases, (total_cases/NULLIF(population, 0))*100 as reported_cases_per_population_pct
from covid_death
where location = 'Indonesia'
order by 1,2;

-- Countries with highest infection rate

select Location, Population, MAX(total_cases) as highest_infection_count, Max((total_cases/NULLIF(population, 0)))*100 as reported_cases_per_population_pct
from covid_death
where continent is not null and continent <> ''
group by Location, Population
order by 4 desc;

-- Countries with highest reported death count

select Location, max(total_deaths) as highest_reported_death_count
from covid_death
where continent is not null and continent <> ''
group by Location
order by 2 desc;

-- Growth number of cumulative vaccine doses administered
-- Define temporary table using CTE

with temp_table as (
	select cd.continent, 
		cd.location, 
		cd.date, 
		cd.population, 
		cv.new_vaccinations,
		SUM(COALESCE(cv.new_vaccinations, 0)) over (partition by cd.location order by cd.date ROWS UNBOUNDED PRECEDING) as cumulative_vaccine_doses
	from covid_death as cd
	join covid_vaccinations as cv
		on cd.location = cv.location
		and cd.date = cv.date
    where cd.continent is not null and cd.continent <> ''
	order by 2,3
	)
select *, (cumulative_vaccine_doses/NULLIF(population, 0))*100 as doses_per_100_people
from temp_table;