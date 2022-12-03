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
	people_fully_vaccinated int,
	total_boosters int,
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

show variables like "local_infile";
set global local_infile = 1;

load data local infile 'D:/Fariz Files/Data Analyst/SQL Project/covid_vaccinations.csv'
into table covid_vaccinations
fields terminated by ','
ignore 1 rows;

load data local infile 'D:/Fariz Files/Data Analyst/SQL Project/covid_deaths.csv'
into table covid_death
fields terminated by ','
ignore 1 rows;

-- Quick view of the data that will be used

select Location, date, total_cases, new_cases, total_deaths, population
from covid_death
order by 1,2;

-- Death percentage in Indonesia
-- Indicates the probability of death if infected by covid

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from covid_death
where location like 'Indonesia'
order by 1,2;

-- Percentage of the population infected with Covid

select Location, date, Population, total_cases, (total_cases/population)*100 as percent_population_infected
from covid_death
where location like 'Indonesia'
order by 1,2;

-- Countries with highest infection rate

select Location, Population, MAX(total_cases) as highest_infection_count, Max((total_cases/population))*100 as percent_population_infected
from covid_death
group by Location, Population
order by 4 desc;

-- Locations or categories with highest total death

select Location, max(total_deaths) as total_death
from covid_death
group by Location
order by 2 desc;

-- Growth number of population that has been vaccinated
-- Define temporary table using CTE

with temp_table as (
	select cd.continent, 
		cd.location, 
		cd.date, 
		cd.population, 
		cv.new_vaccinations,
		sum(new_vaccinations) over (partition by cd.location order by cd.location, cd.date) as total_vaccinations_growth
	from covid_death as cd
	join covid_vaccinations as cv
		on cd.location = cv.location
		and cd.date = cv.date
	order by 2,3
	)
select *, (total_vaccinations_growth/population)*100 as vaccination_growth_percentage
from temp_table;