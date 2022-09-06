
Select * 
from PortfolioProject.dbo.CovidDeaths
Where continent is not null
Order By 3,4


--Select * 
--from PortfolioProject.dbo.CovidVaccinations
--Order By 3,4


Select Location, Date, total_cases, new_cases, total_deaths, population 
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
Order By 1,2

--Total cases vs total deaths
--Shows the likelihood of dying if you contract Covid (for Nigeria its 1% chance as of 7/8/2022)

Select Location, Date, total_cases, total_deaths, (total_deaths/total_cases) * 100
From PortfolioProject.dbo.CovidDeaths
Where location like '%Nigeria%'
--Where location like '%States%'
and continent is not null
Order By 1,2

--Looking at the Total Cases vs the Population
--Shows what percentage of population got Covid

Select Location, Date, population, total_cases, (total_cases/population) * 100 as PercentPopulationInfected
From PortfolioProject.dbo.CovidDeaths
--Where location like '%Nigeria%'
Where location like '%States%'
Order By 1,2

--Looking at countries with the highest infection rates compared to the Population

Select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population)) * 100 as PercentPopulationInfected
From PortfolioProject.dbo.CovidDeaths
--Where location like '%Nigeria%'
--Where location like '%States%'
Group By location, population
Order By PercentPopulationInfected desc

--Showing countries with highest death count per population

Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths
--Where location like '%Nigeria%'
--Where location like '%States%'
Where continent is not null
Group By location
Order By TotalDeathCount desc


--BREAKING THINGS DOWN BY CONTINENT

--Showing continents with the highest death count per population

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths
--Where location like '%Nigeria%'
--Where location like '%States%'
Where continent is not null
Group By continent
Order By TotalDeathCount desc

--GLOBAL NUMBERS
--New cases vs New deaths aggregated over countries worldwide daily

Select date, sum(new_cases) as TotalCases, sum(cast(new_deaths as int))as TotalDeaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
where continent is not null
Group By date
Order By 1,2

--Overall total for new cases and new deaths worldwide & death %

Select sum(new_cases) as TotalCases, sum(cast(new_deaths as int))as TotalDeaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
where continent is not null
--Group By date
Order By 1,2

--LOOKING AT Total Population vs Vaccinations

--USE CTE

wITH PopvsVac (Continent, Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
On dea.location= vac.location
and dea.date= vac.date
Where  dea.continent is not null 
--Order By 2,3
)  
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac
 

--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
On dea.location= vac.location
and dea.date= vac.date
Where  dea.continent is not null 
--Order By 2,3

Select * 
from PercentPopulationVaccinated
