-- 0.
select SUM(new_cases) as total_reported_cases, SUM(new_deaths) as total_reported_deaths, (SUM(new_deaths)/NULLIF(SUM(new_cases), 0))*100 as reported_case_fatality_ratio_pct
from covid_death
where continent is not null and continent <> '';

-- 1.
select SUM(new_cases) as total_reported_cases, SUM(new_deaths) as total_reported_deaths, (SUM(new_deaths)/NULLIF(SUM(new_cases), 0))*100 as reported_case_fatality_ratio_pct
from covid_death
where location = 'Indonesia';

-- 2.
select continent, SUM(new_deaths) as total_death_count
from covid_death
where continent is not null and continent <> ''
group by 1
order by 2 desc;

-- 3.
select Location, Population, MAX(total_cases) as highest_infection_count, Max((total_cases/NULLIF(population, 0)))*100 as reported_cases_per_population_pct
from covid_death
where continent is not null and continent <> ''
group by Location, Population
order by 4 desc;

-- 4.
select Location, Population, date, MAX(total_cases) as highest_infection_count, Max((total_cases/NULLIF(population, 0)))*100 as reported_cases_per_population_pct
from covid_death
where continent is not null and continent <> ''
group by Location, Population, date
order by 5 desc;

-- 5.
select cd.continent, cd.location, cd.date, cd.population, cv.total_vaccinations, cv.total_vaccinations_per_hundred as doses_per_100_people
from covid_death as cd
join covid_vaccinations as cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null and cd.continent <> ''
order by 1, 2, 3;

-- 6.
select cd.date, SUM(cd.new_cases) as total_cases, SUM(cd.new_deaths) as total_deaths, sum(cv.new_vaccinations) as total_vaccinations
from covid_death as cd
join covid_vaccinations as cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null and cd.continent <> ''
group by 1
order by 1;
