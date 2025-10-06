--Covid 19 Data Exploration 
--Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types


SELECT *
FROM [Portfolio Project].dbo.CovidDeaths
WHERE continent is not null
Order by 3,4;

--SELECT *
--FROM [Portfolio Project].dbo.CovidVaccinations
--Order by 3,4;

--Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project].dbo.CovidDeaths
WHERE continent is not null
Order by 1,2;

-- Total Cases vs. Total Deaths
-- This shows the liklihood of death if you contract COVID in your country

SELECT
    location,
    date,
    total_cases,
    total_deaths,
    (CAST(total_deaths AS float) / total_cases) * 100 AS Death_Percentage
FROM
    [Portfolio Project].dbo.CovidDeaths
    WHERE continent is not null
ORDER BY
    1, 2;

SELECT
    location,
    date,
    total_cases,
    total_deaths,
    (CAST(total_deaths AS float) / total_cases) * 100 AS Death_Percentage
FROM
    [Portfolio Project].dbo.CovidDeaths
WHERE location like '%states%'
ORDER BY
    1, 2;

SELECT
    location,
    date,
    total_cases,
    total_deaths,
    (CAST(total_deaths AS float) / total_cases) * 100 AS Death_Percentage
FROM
    [Portfolio Project].dbo.CovidDeaths
WHERE location like '%nigeria%'
ORDER BY
    1, 2;

    -- Total Cases vs. Population
    -- Shows the percentage of popultion that got COVID

SELECT
    location,
    date,
    population,
    total_cases,
    (CAST(total_cases AS float) / Population) * 100 AS Population_withCOVID
FROM
    [Portfolio Project].dbo.CovidDeaths
WHERE location like '%states%'
ORDER BY
    1, 2;
    
SELECT
    location,
    date,
    population,
    total_cases,
    (CAST(total_cases AS float) / Population) * 100 AS Population_withCOVID
FROM
    [Portfolio Project].dbo.CovidDeaths
WHERE location like '%nigeria%'
ORDER BY
    1, 2;

-- Countries with the highest infection rate compared to Population

SELECT
    location,
    population,
    MAX(total_cases) as Highest_Infection_Count,
    MAX(CAST(total_cases AS float) / Population) * 100 AS Rateof_InfectedPopulation
FROM
    [Portfolio Project].dbo.CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY Rateof_InfectedPopulation desc;


-- Countries with the Highest Death Cunt Per Population    

SELECT
    location,
    MAX(total_deaths) as Total_Death_Count
FROM
[Portfolio Project].dbo.CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY Total_Death_Count desc;


-- BREAKING THINGS DOWN BY CONTINENT

-- Contintents with the highest death count per population

SELECT
    location,
    MAX(total_deaths) as Total_Death_Count
FROM
[Portfolio Project].dbo.CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY Total_Death_Count desc;

SELECT
    continent,
    MAX(total_deaths) as Total_Death_Count
FROM
[Portfolio Project].dbo.CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY Total_Death_Count desc;


-- Global Numbers

SELECT
    location,
    date,
    total_cases,
    total_deaths,
    (CAST(total_deaths AS float) / total_cases) * 100 AS Death_Percentage
FROM
    [Portfolio Project].dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1, 2;

Select date,
SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From 
    [Portfolio Project].dbo.CovidDeaths
where continent is not null 
Group By date
order by 1,2

Select
SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From 
    [Portfolio Project].dbo.CovidDeaths
where continent is not null 
--Group By date
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT *
FROM [Portfolio Project].dbo.CovidDeaths as COVDea
Join [Portfolio Project].dbo.CovidVaccinations as COVVac
     ON COVDea.location = COVVac.location
     and COVDea.date = COVVac.date;

Select COVdea.continent, COVdea.location, COVdea.date, COVdea.population, COVVac.new_vaccinations
FROM [Portfolio Project].dbo.CovidDeaths as COVDea
Join [Portfolio Project].dbo.CovidVaccinations as COVVac
     ON COVDea.location = COVVac.location
     and COVDea.date = COVVac.date
WHERE COVdea.continent is not null 
ORDER BY 2,3


Select COVdea.continent, COVdea.location, COVdea.date, COVdea.population, COVvac.new_vaccinations
, SUM(COVvac.new_vaccinations) OVER (Partition by COVdea.Location Order by COVdea.location, COVdea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM [Portfolio Project].dbo.CovidDeaths as COVDea
Join [Portfolio Project].dbo.CovidVaccinations as COVVac
     ON COVDea.location = COVVac.location
     and COVDea.date = COVVac.date
WHERE COVdea.continent is not null 
ORDER by 2,3;



-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(Select COVdea.continent, COVdea.location, COVdea.date, COVdea.population, COVvac.new_vaccinations
, SUM(COVvac.new_vaccinations) OVER (Partition by COVdea.Location Order by COVdea.location, COVdea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM [Portfolio Project].dbo.CovidDeaths as COVDea
Join [Portfolio Project].dbo.CovidVaccinations as COVVac
     ON COVDea.location = COVVac.location
     and COVDea.date = COVVac.date
WHERE COVdea.continent is not null 
)
SELECT *
FROM Popvsvac;


--With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
--as
--(Select COVdea.continent, COVdea.location, COVdea.date, COVdea.population, COVvac.new_vaccinations
--, SUM(COVvac.new_vaccinations) OVER (Partition by COVdea.Location Order by COVdea.location, COVdea.Date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/population)*100
--FROM [Portfolio Project].dbo.CovidDeaths as COVDea
--Join [Portfolio Project].dbo.CovidVaccinations as COVVac
--     ON COVDea.location = COVVac.location
--     and COVDea.date = COVVac.date
--WHERE COVdea.continent is not null 
--)
--SELECT *, (RollingPeopleVaccinated/population)*100
--FROM Popvsvac;


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
  SELECT
        COVdea.continent, COVdea.location, COVdea.date, COVdea.population, COVvac.new_vaccinations,
        SUM(CAST(COVvac.new_vaccinations AS bigint)) OVER (Partition by COVdea.Location Order by COVdea.location, COVdea.Date) as RollingPeopleVaccinated
FROM [Portfolio Project].dbo.CovidDeaths as COVDea
JOIN [Portfolio Project].dbo.CovidVaccinations as COVVac
     ON COVDea.location = COVVac.location
     AND COVDea.date = COVVac.date
WHERE COVdea.continent IS NOT NULL
)        
SELECT *,
    (CAST(RollingPeopleVaccinated AS float) / Population) * 100 AS PercentPeopleVaccinated -- FIXED DIVISION HERE to Stop Showing Zero (The Data Type Issue)
FROM
    PopvsVac;


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
  SELECT
        COVdea.continent, COVdea.location, COVdea.date, COVdea.population, COVvac.new_vaccinations,
 -- Use COALESCE to treat NULL new_vaccinations as 0 before summing
        SUM(CAST(COALESCE(COVvac.new_vaccinations, 0) AS bigint))
        OVER (Partition by COVdea.Location Order by COVdea.location, COVdea.Date) AS RollingPeopleVaccinated
 FROM [Portfolio Project].dbo.CovidDeaths as COVDea
 JOIN [Portfolio Project].dbo.CovidVaccinations as COVVac
     ON COVDea.location = COVVac.location
     AND COVDea.date = COVVac.date
 WHERE COVdea.continent IS NOT NULL
)
SELECT *,
 -- Use ISNULL to ensure the percentage calculation itself doesn't fail if the running total is still NULL
    ISNULL((CAST(RollingPeopleVaccinated AS float) / Population) * 100, 0) AS PercentPeopleVaccinated
FROM PopvsVac;


-- Temp Table

CREATE TABLE #PercentPeopleVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPeopleVaccinated
SELECT
      COVdea.continent, COVdea.location, COVdea.date, COVdea.population, COVvac.new_vaccinations,
      SUM(CAST(COVvac.new_vaccinations AS bigint)) OVER (Partition by COVdea.Location Order by COVdea.location, COVdea.Date) as RollingPeopleVaccinated
FROM [Portfolio Project].dbo.CovidDeaths as COVDea
JOIN [Portfolio Project].dbo.CovidVaccinations as COVVac
     ON COVDea.location = COVVac.location
     AND COVDea.date = COVVac.date
WHERE COVdea.continent IS NOT NULL      
SELECT *, (CAST(RollingPeopleVaccinated AS float) / Population) * 100 AS PercentPeopleVaccinated
FROM #PercentPeopleVaccinated;


DROP TABLE if exists #PercentPeopleVaccinated
CREATE TABLE #PercentPeopleVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPeopleVaccinated
SELECT
      COVdea.continent, COVdea.location, COVdea.date, COVdea.population, COVvac.new_vaccinations,
      SUM(CAST(COVvac.new_vaccinations AS bigint)) OVER (Partition by COVdea.Location Order by COVdea.location, COVdea.Date) as RollingPeopleVaccinated
FROM [Portfolio Project].dbo.CovidDeaths as COVDea
JOIN [Portfolio Project].dbo.CovidVaccinations as COVVac
     ON COVDea.location = COVVac.location
     AND COVDea.date = COVVac.date
--WHERE COVdea.continent IS NOT NULL      
SELECT *, (CAST(RollingPeopleVaccinated AS float) / Population) * 100 AS PercentPeopleVaccinated
FROM #PercentPeopleVaccinated;


-- Creating View to store data for later visualizations

CREATE VIEW PercentPeopleVaccinated AS 
SELECT
      COVdea.continent, COVdea.location, COVdea.date, COVdea.population, COVvac.new_vaccinations,
      SUM(CAST(COVvac.new_vaccinations AS bigint)) OVER (Partition by COVdea.Location Order by COVdea.location, COVdea.Date) as RollingPeopleVaccinated
FROM [Portfolio Project].dbo.CovidDeaths as COVDea
JOIN [Portfolio Project].dbo.CovidVaccinations as COVVac
     ON COVDea.location = COVVac.location
     AND COVDea.date = COVVac.date
WHERE COVdea.continent IS NOT NULL
--ORDER BY 2,3;


SELECT *
FROM PercentPeopleVaccinated;