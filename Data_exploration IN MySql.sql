PORTFOLIO PROJECT

SELECT count(*) FROM portfolio_project.death_tbl
WHERE location = 'Bosnia and Herzegovina';


-----------------------------------------------Total deaths VS Total cases -----------------------------------------------------------

select location,
       date,
	   new_cases,
       SUM(new_cases) OVER (ORDER BY date) AS cumulative_cases,
       new_deaths,
       SUM(new_deaths) OVER (ORDER BY date) AS cumulative_deaths,
       ROUND(100* SUM(new_deaths) OVER (ORDER BY date)/SUM(new_cases) OVER (ORDER BY date),2) as DC_Racio
       
from death_tbl
where location = 'Bosnia and Herzegovina'

--------------------------------------Total cases VS total population--------------------------------------------------------------------

select location,
       population,
       date,
       round((SUM(new_cases) OVER (ORDER BY date)/population)*100,2)
       
       
from death_tbl
where location = 'Bosnia and Herzegovina'

-------------------------------------Country with highest infection rate compare to population------------------------------------------

select location,
       sum(new_cases),
      round( sum(new_cases)/max(population)*100,2) as CP_Racio
	
from death_tbl
WHERE continent IN ('Asia','Europe','Africa','Oceania','North America','South America')
group by location
order by 3 desc


-------------------------------------Country with highest death rate compare to population----------------------------------------------

select location,
       sum(new_deaths),
       round( sum(new_deaths)/max(population)*100,2) as DP_Racio
	
from death_tbl
WHERE continent IN ('Asia','Europe','Africa','Oceania','North America','South America')
group by location
order by 3 desc


-----------------------------------Continent with highest deaths--------------------------------------------

select continent,
       sum(new_deaths)
from death_tbl
WHERE continent IN ('Asia','Europe','Africa','Oceania','North America','South America')
group by continent
order by 2 desc

---------------------------------------Global Numbers-----------------------------------------------------------------------------
select distinct date,
	     SUM(new_cases) OVER (ORDER BY date) AS cumulative_cases,
         SUM(new_deaths) OVER (ORDER BY date) AS cumulative_deaths
       
from death_tbl
WHERE continent IN ('Asia','Europe','Africa','Oceania','North America','South America')


-----------------------------------Total vactinacion VS Population------------------------------------------------------------
With new_tbl as (
Select 
death_tbl.location,
death_tbl.date,
death_tbl.population,
vactinacion_tbl.new_vaccinations,
sum(vactinacion_tbl.new_vaccinations) over ( partition by death_tbl.location order by death_tbl.location,death_tbl.date) as total_vaccination
	from death_tbl
	join vactinacion_tbl
	on death_tbl.location=vactinacion_tbl.location
	and death_tbl.date=vactinacion_tbl.date
WHERE death_tbl.continent IN ('Asia','Europe','Africa','Oceania','North America','South America'))

select *,round((total_vaccination/population)*100,2)
from new_tbl


-----------------------------------Create a view------------------------------------------------------------------------------------

Create view view_tbl as (
With new_tbl as (
Select 
death_tbl.location,
death_tbl.date,
death_tbl.population,
vactinacion_tbl.new_vaccinations,
sum(vactinacion_tbl.new_vaccinations) over ( partition by death_tbl.location order by death_tbl.location,death_tbl.date) as total_vaccination
	from death_tbl
	join vactinacion_tbl
	on death_tbl.location=vactinacion_tbl.location
	and death_tbl.date=vactinacion_tbl.date
WHERE death_tbl.continent IN ('Asia','Europe','Africa','Oceania','North America','South America'))

select *,round((total_vaccination/population)*100,2)
from new_tbl)






