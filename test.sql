Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Myportfolio..CovidDeath$
Where location = 'Nigeria'
Order by 1,2

-- looking at total cases vs population
-- show percentage infected

Select Location, date, total_cases, population, (total_cases/population)*100 as Percentofpopulationinfected
From Myportfolio..CovidDeath$
Where location = 'Nigeria'
Order by 1,2

-- higest infection rate by country
Select Location, MAX(total_cases) AS highestinfectioncount, Max((total_cases/population))*100 as totalpercentinfected
From Myportfolio..CovidDeath$
--Where location = 'Nigeria'
Group by Location, population
Order by totalpercentinfected desc

--countries by death count

Select Location, MAX(cast(total_deaths as int)) AS totaldeathcount
From Myportfolio..CovidDeath$
--Where location = 'Nigeria'
Where continent is not null
Group by Location, population
Order by totaldeathcount desc

-- by continent 

Select continent, MAX(cast(total_deaths as int)) AS totaldeathcount
From Myportfolio..CovidDeath$
--Where location = 'Nigeria'
Where continent is not null
Group by continent
Order by totaldeathcount desc

-- by country

Select location, MAX(cast(total_deaths as int)) AS totaldeathcount
From Myportfolio..CovidDeath$
--Where location = 'Nigeria'
Where continent is null
Group by location
Order by totaldeathcount desc


--showing the continents with the highest death count

Select continent, MAX(cast(total_deaths as int)) AS totaldeathcount
From Myportfolio..CovidDeath$
--Where location = 'Nigeria'
Where continent is not null
Group by continent
Order by totaldeathcount desc


--global numbers

Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/ sum(New_cases)*100 as DeathPercentage
From Myportfolio..CovidDeath$
--Where location = 'Nigeria'
where continent is not null
Group By date
Order by 1,2

-- total population s vaccination

Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
 sum(convert(int,new_vaccinations)) over (partition by death.location order by death.location) as rollingpeoplevaccinated
From Myportfolio..CovidDeath$  death
Join  Myportfolio..CovidVaccination$ vacc
	On death.location = vacc.location
	and death.date = vacc.date
where death.continent is not null
order by 2,3

--using cte

with popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated) as 
(
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
 sum(convert(int,new_vaccinations)) over (partition by death.location order by death.location) as rollingpeoplevaccinated
From Myportfolio..CovidDeath$  death
Join  Myportfolio..CovidVaccination$ vacc
	On death.location = vacc.location
	and death.date = vacc.date
where death.continent is not null
--order by 2,3
)
select * , (rollingpeoplevaccinated/population)* 100 as percentrolling
from popvsvac


-- creating views

Create View Percentpopulation as
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
 sum(convert(int,new_vaccinations)) over (partition by death.location order by death.location) as rollingpeoplevaccinated
From Myportfolio..CovidDeath$  death
Join  Myportfolio..CovidVaccination$ vacc
	On death.location = vacc.location
	and death.date = vacc.date
where death.continent is not null
--order by 2,3