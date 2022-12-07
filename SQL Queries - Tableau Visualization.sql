-- 0.
select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(total_deaths)/SUM(total_cases)*100 as death_percentage
from covid_death
where continent not like "";

-- 1.
select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(total_deaths)/SUM(total_cases)*100 as death_percentage
from covid_death
where location like 'Indonesia';

-- 2.
select continent, SUM(new_deaths) as total_death_count
from covid_death
group by 1
order by 2 desc;

-- 3.
select Location, Population, MAX(total_cases) as highest_infection_count,  Max((total_cases/population))*100 as percent_population_infected
from covid_death
group by Location, Population
order by 4 desc;

-- 4.
select Location, Population, date, MAX(total_cases) as highest_infection_count,  Max((total_cases/population))*100 as percent_population_infected
from covid_death
group by Location, Population, date
order by 5 desc;

-- 5.
select cd.continent, cd.location, cd.date, cd.population, MAX(cv.total_vaccinations) as total_vaccinations, MAX(cv.total_vaccinations/population)*100 as total_vaccinations_growth
from covid_death as cd
join covid_vaccinations as cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent not like ""
group by 1, 2, 3, 4
order by 1, 2, 3;

-- 6.
select cd.date, SUM(cd.new_cases) as total_cases, SUM(cd.new_deaths) as total_deaths, sum(cv.new_vaccinations) as total_vaccinations
from covid_death as cd
join covid_vaccinations as cv
	on cd.date = cv.date
group by 1
order by 1;
