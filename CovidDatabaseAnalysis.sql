-- looking at total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/COVID_Deaths.total_cases)*100 as DeathPercentage
from COVID_Deaths
where location like '%india%';

-- looking at total cases vs population
-- shows what percentage of people got covid
Select location, date, total_cases, population, (COVID_Deaths.total_cases/COVID_Deaths.population)*100 as InfectionRate
from COVID_Deaths
where location like '%canada%';

-- looking at countries with highest infection rate compared to population
Select location, population, max(total_cases) as HighestInfectionCount, max((COVID_Deaths.total_cases/COVID_Deaths.population))*100 as InfectionRate
from COVID_Deaths
group by population, location
order by InfectionRate desc;

-- Showing countries with highest death count
Select location, max(total_deaths) as TotalDeathCount
from COVID_Deaths
where continent is not null
group by location
order by TotalDeathCount desc;

-- lets break things down by continent
-- showing continents with death count
Select location, max(total_deaths) as TotalDeathCount
from COVID_Deaths
where continent is null
group by location
order by TotalDeathCount desc;

-- Global Numbers
Select date, sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, (sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
from COVID_Deaths
where continent is not null
group by date;

Select sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, (sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
from COVID_Deaths
where continent is not null;



-- looking at total population vs population vaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       (sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date)) as CummulativeVaccineSum,
from COVID_Deaths dea
join COVID_Vaccines vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null;


-- using temp table
drop table if exists PercentPopulationVaccinated;
create temporary table PercentPopulationVaccinated
    (
        Continent nvarchar(255),
        Location nvarchar(255),
        date date,
        Population bigint,
        New_Vaccinations bigint,
        CummulativeVaccineSum bigint
);
insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       (sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date)) as CummulativeVaccineSum
from COVID_Deaths dea
join COVID_Vaccines vac
    on dea.location = vac.location
    and dea.date = vac.date;
-- where dea.continent is not null;

Select *, (CummulativeVaccineSum/PercentPopulationVaccinated.Population)*100
from PercentPopulationVaccinated;



-- Creating view
Create view PercentPopulationVaccinated as
    Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       (sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date)) as CummulativeVaccineSum
from COVID_Deaths dea
join COVID_Vaccines vac
    on dea.location = vac.location
    and dea.date = vac.date;