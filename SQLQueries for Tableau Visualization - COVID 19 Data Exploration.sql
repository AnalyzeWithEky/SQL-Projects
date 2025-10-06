
Queries used for Tableau Project


-- 1. 

SELECT
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths AS int)) AS total_deaths,
    CASE
        WHEN SUM(New_Cases) = 0 THEN 0  -- Prevents divide-by-zero error
        ELSE (SUM(CAST(new_deaths AS float)) / SUM(New_Cases)) * 100 -- CAST to FLOAT here
    END AS DeathPercentage
FROM [Portfolio Project].dbo.CovidDeaths
--Where location like '%states%'
WHERE continent IS NOT NULL
--Group By date
ORDER BY
    1, 2;

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From [Portfolio Project].dbo.CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From [Portfolio Project].dbo.CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,
    CASE
        WHEN MAX(total_cases) = 0 THEN 0  -- Prevents divide-by-zero error
        ELSE (MAX(CAST(total_cases AS float)) / Population) * 100 -- CAST to FLOAT here
    END AS PercentPopulationInfected
From [Portfolio Project].dbo.CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,
CASE
        WHEN MAX(total_cases) = 0 THEN 0  -- Prevents divide-by-zero error
        ELSE (MAX(CAST(total_cases AS float)) / Population) * 100 -- CAST to FLOAT here
    END AS PercentPopulationInfected
From [Portfolio Project].dbo.CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

