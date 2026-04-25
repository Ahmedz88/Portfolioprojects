select *
from globalpowerplant
-- Put primary key on gppd_idnr
Alter table globalpowerplant
add primary key (gppd_idnr)
------------------------------------------------------------------------------------------------------------------
-- Cleaning data
-- create table for cleaning data
CREATE TABLE [dbo].[globalpowerplant_staging](
	[country] [nvarchar](255) NULL,
	[country_long] [nvarchar](255) NULL,
	[name] [nvarchar](255) NULL,
	[gppd_idnr] [nvarchar](255) NOT NULL,
	[capacity_mw] [float] NULL,
	[latitude] [float] NULL,
	[longitude] [float] NULL,
	[primary_fuel] [nvarchar](255) NULL,
	[other_fuel1] [nvarchar](255) NULL,
	[other_fuel2] [nvarchar](255) NULL,
	[other_fuel3] [nvarchar](255) NULL,
	[commissioning_year] [nvarchar](255) NULL,
	[owner] [nvarchar](255) NULL,
	[source] [nvarchar](255) NULL,
	[url] [nvarchar](255) NULL,
	[geolocation_source] [nvarchar](255) NULL,
	[wepp_id] [float] NULL,
	[year_of_capacity_data] [float] NULL,
	[generation_gwh_2013] [nvarchar](255) NULL,
	[generation_gwh_2014] [nvarchar](255) NULL,
	[generation_gwh_2015] [nvarchar](255) NULL,
	[generation_gwh_2016] [nvarchar](255) NULL,
	[generation_gwh_2017] [nvarchar](255) NULL,
	[generation_gwh_2018] [nvarchar](255) NULL,
	[generation_gwh_2019] [nvarchar](255) NULL,
	[generation_data_source] [nvarchar](255) NULL,
	[estimated_generation_gwh_2013] [float] NULL,
	[estimated_generation_gwh_2014] [float] NULL,
	[estimated_generation_gwh_2015] [float] NULL,
	[estimated_generation_gwh_2016] [float] NULL,
	[estimated_generation_gwh_2017] [float] NULL,
	[estimated_generation_note_2013] [nvarchar](255) NULL,
	[estimated_generation_note_2014] [nvarchar](255) NULL,
	[estimated_generation_note_2015] [nvarchar](255) NULL,
	[estimated_generation_note_2016] [nvarchar](255) NULL,
	[estimated_generation_note_2017] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[gppd_idnr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

select * from globalpowerplant_staging

insert into globalpowerplant_staging
select *
from globalpowerplant
---------------------------------------------------------------------------------------------------------------------
-- 2. Remove duPlicates
-- check duplicates
select *
from globalpowerplant_staging
where gppd_idnr in
	(select gppd_idnr
	from globalpowerplant_staging
	group by gppd_idnr
	having count(*) > 1)
---------------------------------------------------------------------------------------------------------------------
-- 3. Standardize the data
-- change name
update globalpowerplant_staging
set name = 'HKW West'
where name = 'HKW West ?'
-- Convert data typr for generation_gwh to float
-- generation_gwh_2013
Select generation_gwh_2013, convert(float, generation_gwh_2013)
from globalpowerplant_staging

ALTER TABLE globalpowerplant_staging
Add generation_gwh_2013_converted float;
Update globalpowerplant_staging
Set generation_gwh_2013_converted = convert(float, generation_gwh_2013)

-- generation_gwh_2014
Select generation_gwh_2014, convert(float, generation_gwh_2014)
from globalpowerplant_staging

ALTER TABLE globalpowerplant_staging
Add generation_gwh_2014_converted float;
Update globalpowerplant_staging
Set generation_gwh_2014_converted = convert(float, generation_gwh_2014)

-- generation_gwh_2015
Select generation_gwh_2015, convert(float, generation_gwh_2015)
from globalpowerplant_staging

ALTER TABLE globalpowerplant_staging
Add generation_gwh_2015_converted float;
Update globalpowerplant_staging
Set generation_gwh_2015_converted = convert(float, generation_gwh_2015)

-- generation_gwh_2016
Select generation_gwh_2016, convert(float, generation_gwh_2016)
from globalpowerplant_staging

ALTER TABLE globalpowerplant_staging
Add generation_gwh_2016_converted float;
Update globalpowerplant_staging
Set generation_gwh_2016_converted = convert(float, generation_gwh_2016)

-- generation_gwh_2017
Select generation_gwh_2017, convert(float, generation_gwh_2017)
from globalpowerplant_staging

ALTER TABLE globalpowerplant_staging
Add generation_gwh_2017_converted float;
Update globalpowerplant_staging
Set generation_gwh_2017_converted = convert(float, generation_gwh_2017)

-- generation_gwh_2018
Select generation_gwh_2018, convert(float, generation_gwh_2018)
from globalpowerplant_staging

ALTER TABLE globalpowerplant_staging
Add generation_gwh_2018_converted float;
Update globalpowerplant_staging
Set generation_gwh_2018_converted = convert(float, generation_gwh_2018)

-- generation_gwh_2019
Select generation_gwh_2019, convert(float, generation_gwh_2019)
from globalpowerplant_staging

ALTER TABLE globalpowerplant_staging
Add generation_gwh_2019_converted float;
Update globalpowerplant_staging
Set generation_gwh_2019_converted = convert(float, generation_gwh_2019)

-- Drop nvarchar columns
ALTER TABLE globalpowerplant_staging
DROP COLUMN generation_gwh_2013, generation_gwh_2014,
	generation_gwh_2015, generation_gwh_2016,
	generation_gwh_2017, generation_gwh_2018,
	generation_gwh_2019

-- Round generation, estimated GWH, and capacity_MW to 1

select *
from globalpowerplant_staging

update globalpowerplant_staging
set 
		capacity_mw = round(capacity_mw, 1),
		generation_gwh_2013_converted = round(generation_gwh_2013_converted, 1),
		generation_gwh_2014_converted = round(generation_gwh_2014_converted, 1),
		generation_gwh_2015_converted = round(generation_gwh_2015_converted, 1),
		generation_gwh_2016_converted = round(generation_gwh_2016_converted, 1),
		generation_gwh_2017_converted = round(generation_gwh_2017_converted, 1),
		generation_gwh_2018_converted = round(generation_gwh_2018_converted, 1),
		generation_gwh_2019_converted = round(generation_gwh_2019_converted, 1),
		estimated_generation_gwh_2013 = round(estimated_generation_gwh_2013, 1),
		estimated_generation_gwh_2014 = round(estimated_generation_gwh_2014, 1),
		estimated_generation_gwh_2015 = round(estimated_generation_gwh_2015, 1),
		estimated_generation_gwh_2016 = round(estimated_generation_gwh_2016, 1),
		estimated_generation_gwh_2017 = round(estimated_generation_gwh_2017, 1)
-------------------------------------------------------------------------------------------------------------------
-- convert year of capacity from float to int

Select year_of_capacity_data, cast (year_of_capacity_data as int) 
from globalpowerplant_staging

alter table globalpowerplant_staging
add Year_of_Data int

update globalpowerplant_staging
set Year_of_Data = cast (year_of_capacity_data as int)
alter table globalpowerplant_staging
drop column year_of_capacity_data
---------------------------------------------------------------------------------------------------------------------
-- convert commissioning_ year from nvarchar to int
-- First remove the decimal b=numbers

Select left(commissioning_year, 4)
from globalpowerplant_staging

update globalpowerplant_staging
set commissioning_year = left(commissioning_year, 4)

-- check if still any year has decimal numbers
Select commissioning_year
from globalpowerplant_staging
where len(commissioning_year) >4

-- then update the tble with new column and drop the old one

Select commissioning_year, cast (commissioning_year as int) 
from globalpowerplant_staging

alter table globalpowerplant_staging
add commissioning_year_converted int
update globalpowerplant_staging
set commissioning_year_converted = cast (commissioning_year as int)

alter table globalpowerplant_staging
drop column commissioning_year
----------------------------------------------------------------------------------------------------------
-- Drop columns

alter table globalpowerplant_staging
drop column other_fuel1, other_fuel2, other_fuel3, wepp_id

alter table globalpowerplant_staging
drop column wepp_id

----------------------------------------------------------------------------------------------
-- Data exploration
-- 1. Global capacity distribution
-- Top countries by total capacity (MW)   
select	country_long as Country,
		round(sum (Capacity_mw), 0) as total_capacity_MW
from globalpowerplant_staging
group by country_long
order by total_capacity_MW Desc

-- Top power plants by capacity (MW)
select	name,
		primary_fuel,
		country_long as country, capacity_MW
from globalpowerplant_staging
order by capacity_MW DESC

-- Share of global capacity %
select	country_long as Country,
		round(sum(Capacity_mw)*100/ sum(sum(Capacity_mw)) over(), 3) as pctg_global_capacity
from globalpowerplant_staging
group by country_long
order by pctg_global_capacity desc

-- Contribution of top 20 plants
with top_plants as (
select	top 20 capacity_MW
from globalpowerplant_staging
order by capacity_MW DESC
)
select
round(SUM(capacity_mw) * 100 /(select	sum(capacity_MW) from globalpowerplant_staging), 3) as pctg_top20_plants
from top_plants


-- 2. Fuel type
-- Total capacity by fuel type
select	primary_fuel,
		round(sum (Capacity_mw), 0) as total_capacity_MW
from globalpowerplant_staging
group by primary_fuel
order by total_capacity_MW desc

-- Total capacity by Fuel type and country
select	country_long as Country, primary_fuel,
		round(sum (Capacity_mw), 0) as total_capacity_MW
from globalpowerplant_staging
group by country_long, primary_fuel
order by country_long, total_capacity_MW desc

-- Avg capacity by fuel type
select	primary_fuel,
		count(*) as number_of_plants,
		round(avg (Capacity_mw), 0) as Avg_capacity_MW,
		round(sum (Capacity_mw), 0) as total_capacity_MW
from globalpowerplant_staging
group by primary_fuel
order by Avg_capacity_MW desc

-- 3. Commissioning Year
-- Capacity added per year
select	commissioning_year_converted as commissioning_year,
		round(sum (Capacity_mw), 0) as total_capacity_MW
from globalpowerplant_staging
where commissioning_year_converted is not null
group by commissioning_year_converted
order by commissioning_year_converted

-- Capacity growth/country
select	country_long as Country,
		commissioning_year_converted as commissioning_year,
		round(sum (Capacity_mw), 0) as total_capacity_MW
from globalpowerplant_staging
where commissioning_year_converted is not null
group by country_long, commissioning_year_converted
order by country_long, commissioning_year_converted

-- Renewable growth over time
select	commissioning_year_converted as commissioning_year,
		sum(case 
		when primary_fuel in ('Hydro', 'Storage', 'Waste', 'Wave and Tidal', 'Wind', 'Biomass', 'Solar', 'Geothermal')
		then Capacity_mw else 0 end) as Renewable_capacity_MW
from globalpowerplant_staging
where commissioning_year_converted is not null
group by commissioning_year_converted
order by commissioning_year_converted

-- 4. Renewable vs Nor_renewable
-- Fuel distribution per country
select	country_long as Country,
		round(sum(case when primary_fuel = 'Gas' then Capacity_mw else 0 end), 0) as Gas_MW,
		round(sum(case when primary_fuel = 'Coal' then Capacity_mw else 0 end), 0) as Coal_MW,
		round(sum(case when primary_fuel = 'Cogeneration' then Capacity_mw else 0 end), 0) as Cogeneration_MW,
		round(sum(case when primary_fuel = 'Oil' then Capacity_mw else 0 end), 0) as Oil_MW,
		round(sum(case when primary_fuel = 'Nuclear' then Capacity_mw else 0 end), 0) as Nuclear_MW,
		round(sum(case when primary_fuel = 'Petcoke' then Capacity_mw else 0 end), 0) as Petcoke_MW,
		round(sum(case when primary_fuel = 'Other' then Capacity_mw else 0 end), 0) as Other_MW,
		round(sum(case when primary_fuel in
		('Hydro', 'Storage', 'Waste', 'Wave and Tidal', 'Wind', 'Biomass', 'Solar', 'Geothermal')
		then Capacity_mw else 0 end), 0) as Renewable_MW
from globalpowerplant_staging
group by country_long
order by Renewable_MW desc

-- Renewable percent per country
select	country_long as Country,
		sum(case 
		when primary_fuel in ('Hydro', 'Storage', 'Waste', 'Wave and Tidal', 'Wind', 'Biomass', 'Solar', 'Geothermal')
		then Capacity_mw else 0 end) as Renewable_MW,
		SUM(capacity_mw) as total_mw,
		round(sum(case 
		when primary_fuel in ('Hydro', 'Storage', 'Waste', 'Wave and Tidal', 'Wind', 'Biomass', 'Solar', 'Geothermal')
		then Capacity_mw else 0 end) * 100 / SUM(capacity_mw), 1) as Renewable_Percent
from globalpowerplant_staging
group by country_long
order by Renewable_Percent desc

-- 5. Plants counts and geographic
-- Plants counts by country
select	country_long as Country,
		count(*) as number_of_plants
from globalpowerplant_staging
group by country_long
order by number_of_plants desc

-- Grid clustering by country
select country_long as Country,
		round(latitude, 1) as Lat_Cluster,
		round(longitude, 1) as Lon_Cluster,
		count(*) as Plant_Count
from globalpowerplant_staging
group by country_long, round(latitude, 1), round(longitude, 1)
order by Plant_Count desc

-- 6. Avg capacity by plant age
select 
	case
		when commissioning_year_converted < 1990 then 'Old'
		when commissioning_year_converted between 1990 and 2010 then 'Mid'
		else 'New'
	end as Plant_age,
	round(AVG(capacity_mw), 0) as Avg_capacity_MW,
	count(*) as Plants_count
from globalpowerplant_staging
where commissioning_year_converted is not null
group by
	case
		when commissioning_year_converted < 1990 then 'Old'
		when commissioning_year_converted between 1990 and 2010 then 'Mid'
		else 'New'
	end
order by Avg_capacity_MW desc
-------------------------------------------------------------------------------------------------------
 -- Generation and estimated GWH
 -- Total Actual Generation per Year
SELECT 
    round(SUM(generation_gwh_2013_converted), 0) AS Gen_Gwh_2013,
    round(SUM(generation_gwh_2014_converted), 0) AS Gen_Gwh_2014,
    round(SUM(generation_gwh_2015_converted), 0) AS Gen_Gwh_2015,
    round(SUM(generation_gwh_2016_converted), 0) AS Gen_Gwh_2016,
    round(SUM(generation_gwh_2017_converted), 0) AS Gen_Gwh_2017,
	round(SUM(generation_gwh_2018_converted), 0) AS Gen_Gwh_2018,
	round(SUM(generation_gwh_2019_converted), 0) AS Gen_Gwh_2019
FROM globalpowerplant_staging

-- Yearly generation Gwh growth
SELECT 
    '2014 vs 2013' AS Period,
    round((SUM(generation_gwh_2014_converted) - SUM(generation_gwh_2013_converted)) * 100.0 / SUM(generation_gwh_2013_converted), 2) AS Generated_Gwh_Growth_pctg
FROM globalpowerplant_staging

UNION ALL

SELECT 
    '2015 vs 2014',
    round((SUM(generation_gwh_2015_converted) - SUM(generation_gwh_2014_converted)) * 100.0 / SUM(generation_gwh_2014_converted), 2)
FROM globalpowerplant_staging

UNION ALL

SELECT 
    '2016 vs 2015',
    round((SUM(generation_gwh_2016_converted) - SUM(generation_gwh_2015_converted)) * 100.0 / SUM(generation_gwh_2015_converted), 2)
FROM globalpowerplant_staging

UNION ALL

SELECT 
    '2017 vs 2016',
    round((SUM(generation_gwh_2017_converted) - SUM(generation_gwh_2016_converted)) * 100.0 / SUM(generation_gwh_2016_converted), 2)
FROM globalpowerplant_staging

UNION ALL

SELECT 
    '2018 vs 2017',
    round((SUM(generation_gwh_2018_converted) - SUM(generation_gwh_2017_converted)) * 100.0 / SUM(generation_gwh_2017_converted), 2)
FROM globalpowerplant_staging

UNION ALL

SELECT 
    '2019 vs 2018',
    round((SUM(generation_gwh_2019_converted) - SUM(generation_gwh_2018_converted)) * 100.0 / SUM(generation_gwh_2018_converted), 2)
FROM globalpowerplant_staging

-- Actual vs Estimated Generation 2017 (Accuracy Check )
SELECT 
    name,
    country_long as Country,
    primary_fuel,
    generation_gwh_2017_converted AS Actual_generation_2017,
    estimated_generation_gwh_2017 AS Estimated_generation_2017,
    
    (generation_gwh_2017_converted - estimated_generation_gwh_2017) AS Difference_Gwh_2017,
    
    CASE 
        WHEN estimated_generation_gwh_2017 IS NOT NULL AND estimated_generation_gwh_2017 <> 0
        THEN round((generation_gwh_2017_converted - estimated_generation_gwh_2017) * 100.0 / estimated_generation_gwh_2017, 2)
        ELSE NULL
    END AS Error_pct_2017
FROM globalpowerplant_staging
WHERE generation_gwh_2017_converted IS NOT NULL 
  AND estimated_generation_gwh_2017 IS NOT NULL
ORDER BY Error_pct_2017 DESC

-- Top 20 Plants by Actual Generation 2019
SELECT TOP 20 name, country_long as Country, primary_fuel, generation_gwh_2019_converted as Gen_Gwh_2019
FROM globalpowerplant_staging
ORDER BY Gen_Gwh_2019 DESC

-- Capacity Factor 2019 = [Actual(Gwh)*1000 (MWH)] / [Capacity (Mw) × total hours per year (8760)]
SELECT	name, country_long as country, primary_fuel, capacity_mw, generation_gwh_2019_converted as Gen_Gwh_2019,
		round(generation_gwh_2019_converted * 1000.0 / (capacity_mw * 8760), 2) AS Capacity_factor
FROM globalpowerplant_staging
WHERE generation_gwh_2019_converted IS NOT NULL
  AND capacity_mw IS NOT NULL
order by Capacity_factor desc

-- Renewable vs Non-Renewable Generation 2017
SELECT 
    country_long as Country,
    SUM(CASE 
        WHEN primary_fuel IN ('Hydro', 'Storage', 'Waste', 'Wave and Tidal', 'Wind', 'Biomass', 'Solar', 'Geothermal') 
        THEN generation_gwh_2017_converted ELSE 0 END) AS Renewable_Gwh_2017,
    
    SUM(generation_gwh_2017_converted) AS Total_Gwh_2017,
    
    round(SUM(CASE 
        WHEN primary_fuel IN ('Hydro', 'Storage', 'Waste', 'Wave and Tidal', 'Wind', 'Biomass', 'Solar', 'Geothermal') 
        THEN generation_gwh_2017_converted ELSE 0 END) * 100.0 / 
    SUM(generation_gwh_2017_converted), 2) AS Renewable_pct_2017

FROM globalpowerplant_staging
WHERE	generation_gwh_2017_converted IS NOT NULL
		and generation_gwh_2017_converted <> 0
GROUP BY country_long
ORDER BY Renewable_pct_2017 DESC

-- Average Capacity Factor by Fuel
SELECT 
    primary_fuel,
    round(AVG(generation_gwh_2019_converted * 1000.0 / (capacity_mw * 8760)), 2) AS Avg_capacity_factor_2019
FROM globalpowerplant_staging
WHERE generation_gwh_2019_converted IS NOT NULL
  AND capacity_mw IS NOT NULL
GROUP BY primary_fuel
ORDER BY Avg_capacity_factor_2019 DESC

-- Plants with Highest Forecast Error 2017
SELECT TOP 20
    name,
    country_long as Country,
    primary_fuel,
    ABS(generation_gwh_2017_converted - estimated_generation_gwh_2017) AS Abs_error
FROM globalpowerplant_staging
WHERE generation_gwh_2017_converted IS NOT NULL
  AND estimated_generation_gwh_2017 IS NOT NULL
ORDER BY Abs_error DESC







