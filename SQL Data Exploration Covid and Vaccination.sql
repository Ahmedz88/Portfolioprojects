select  *
from Portfolioproject..CovidDeaths


--Select data that we going to use for our analysis

select location, date, total_cases, new_cases, total_deaths, population
from portfolioproject..CovidDeaths
order by 1,2

--Looking for total cases vs total deaths
--Shows likelihood of dying if you contract covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
from portfolioproject..CovidDeaths
where location like '%China%'
order by 1,2

-- Looking for total cases vs population
-- Shows what percentage of the population has contracted covid in each country
select  location, date, population, total_cases, total_deaths, (total_deaths/population)*100 as Percent_of_population_deaths
from portfolioproject..CovidDeaths
where location like '%States%'
order by 1,2
-- Looking for countries with the highest infection rate compared to population
--Highest_infected_count
select  location, population, Max(total_cases) as Highest_infected_count, Max((total_cases/population)*100) as Percent_of_population_infected
from portfolioproject..CovidDeaths
Group by location, population
order by Highest_infected_count desc
-- Percent_of_population_infected
select  location, population, Max(total_cases) as Highest_infected_count, Max((total_cases/population)*100) as Percent_of_population_infected
from portfolioproject..CovidDeaths
Group by location, population
order by Percent_of_population_infected desc

-- Looking for countries with the highest infection rate compared to population excluding continents
select  location, population, Max(total_cases) as Highest_infected_count, Max((total_cases/population)*100) as Percent_of_population_infected
from portfolioproject..CovidDeaths
where location not like '%World%' and location not like '%Europ%' and location not like '%Africa%' and location not like '%Asia%' and location not like '%America%'
Group by location, population
order by Highest_infected_count desc

-- Shows countries with highest death count per population
select  location, Max(cast(total_deaths as int)) as Total_death_count
from portfolioproject..CovidDeaths
where continent is not null
Group by location
order by Total_death_count desc

-- Shows continents with highest death count
select  continent, Max(cast(total_deaths as int)) as continent_total_death_count
from portfolioproject..CovidDeaths
where continent is not null
Group by continent
order by continent_total_death_count desc

select  location, Max(cast(total_deaths as int)) as continent_total_death_count
from portfolioproject..CovidDeaths
where continent is null
Group by location
order by continent_total_death_count desc

-- Global Numbers
select date, Sum(new_cases)as Total_new_cases, sum(cast(new_deaths as int))as Total_new_deaths, sum(cast(new_deaths as int))/SUM(new_cases)*100 as Global_death_percentage
from portfolioproject..CovidDeaths
where continent is not null
group by date
order by 1,2

--Vaccination data
-- Joining the two tables to see the relationship between vaccinations and deaths
select  *
from Portfolioproject..CovidDeaths as deaths
    join Portfolioproject..CovidVaccinations as vaccines
      on deaths.location = vaccines.location
      and deaths.date = vaccines.date

-- Looking for total population vs total new vaccinations
select deaths.continent, deaths.location, deaths.date, deaths.population, vaccines.new_vaccinations
from Portfolioproject..CovidDeaths as deaths
    join Portfolioproject..CovidVaccinations as vaccines
      on deaths.location = vaccines.location
      and deaths.date = vaccines.date
where deaths.continent is not null
order by 2,3
-- Rolling count of new vaccinations per day globally
select deaths.continent, deaths.location, deaths.date, deaths.population, vaccines.new_vaccinations,
SUM(convert(int, vaccines.new_vaccinations)) over (partition by deaths.location) as rolling_vaccinations
from Portfolioproject..CovidDeaths as deaths
    join Portfolioproject..CovidVaccinations as vaccines
      on deaths.location = vaccines.location
      and deaths.date = vaccines.date
where deaths.continent is not null
order by 2,3
-- Add order by date to see the trend of vaccinations over time
select deaths.continent, deaths.location, deaths.date, deaths.population, vaccines.new_vaccinations,
SUM(convert(int, vaccines.new_vaccinations)) over (partition by deaths.location
order by deaths.location, deaths.date) as rolling_vaccinations
from Portfolioproject..CovidDeaths as deaths
    join Portfolioproject..CovidVaccinations as vaccines
      on deaths.location = vaccines.location
      and deaths.date = vaccines.date
where deaths.continent is not null
order by 2,3
-- Vaccinated vs population
-- We can not use a created column, need to create a CTE
with Vaccinationvspopulation (continent, location, date, population, new_vaccinations, rolling_vaccinations)
as
(
select deaths.continent, deaths.location, deaths.date, deaths.population, vaccines.new_vaccinations,
SUM(convert(int, vaccines.new_vaccinations)) over (partition by deaths.location
order by deaths.location, deaths.date) as rolling_vaccinations
from Portfolioproject..CovidDeaths as deaths
    join Portfolioproject..CovidVaccinations as vaccines
      on deaths.location = vaccines.location
      and deaths.date = vaccines.date
where deaths.continent is not null
--order by 2,3
)
select *, (rolling_vaccinations/population)*100 as Percent_population_vaccinated
from Vaccinationvspopulation
order by location, date


