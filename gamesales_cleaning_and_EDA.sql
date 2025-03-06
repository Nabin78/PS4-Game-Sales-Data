-- Data Cleaning
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null values or blank values
-- 4. Remove Any Columns 

select year from ps4gamesalesdata
where year is null;

update ps4gamesalesdata
set year = null
where year = 'N/A'

CREATE TABLE gamesalesdata
(LIKE ps4gamesalesdata INCLUDING ALL);

select *
from gamesalesdata;

insert into gamesalesdata
select * 
from ps4gamesalesdata;

alter table gamesalesdata
alter column year type int using year::integer;

-- 1. Remove duplicate if any

select *,
row_number() over(
partition by game, year, genre, publisher, north_america,europe, japan, rest_of_world,global
) as row_num
from gamesalesdata
;

with dublicate_cte as (
select *,
row_number() over(
partition by game, year, genre, publisher, north_america,europe, japan, rest_of_world,global
) as row_num
from gamesalesdata
)
select * from dublicate_cte
where row_num > 1;
 -- since there are now values with row_num > 1, there are no duplicate values

-- Standardize
select * 
from gamesalesdata;

update gamesalesdata
set publisher = lower(publisher);

-- Null values
select *
from gamesalesdata
where publisher is null;

update gamesalesdata
set publisher = 'unknown'
where publisher is null;

UPDATE gamesalesdata AS t1
SET year = (
    SELECT AVG(year) FROM gamesalesdata AS t2
    WHERE t1.publisher = t2.publisher AND t2.year IS NOT NULL
)
WHERE t1.year IS NULL;

select year
from gamesalesdata 
;

select *
from gamesalesdata
where publisher = 'unknown';


-- EDA
-- max_sales in each country each year
select year, sum(north_america) total_NA,sum(europe) total_sales_EU,sum(japan) total_sales_japan,
sum(rest_of_world) total_sales_rest_of_world,sum(global) total_sales_global
from gamesalesdata
group by year
order by year;

select genre, max(global) as max_global_salesdata
from gamesalesdata
group by genre
order by max_global_salesdata desc;

select publisher, max(global) as max_global_publisher_sales
from gamesalesdata
group by publisher
order by max_global_publisher_sales desc;

-- Top 10 global game sales 
select game,global
from gamesalesdata
order by global desc
limit 10;

-- EU contributes most to the games sales
SELECT 
    SUM(north_america) AS total_na_sales,
    SUM(europe) AS total_eu_sales,
    SUM(japan) AS total_japan_sales,
    SUM(rest_of_world) AS total_row_sales,
    SUM(global) AS total_global_sales
FROM gamesalesdata;

-- Top 5 games in NA
select game,north_america
from gamesalesdata
order by north_america desc
;

select * from gamesalesdata;

select genre,
	sum(north_america) as na_sales,
	sum(europe) as eu_sales,
	sum(japan) as jp_sales,
	sum(rest_of_world) as ros_sales,
	sum(global) as global_sales
from gamesalesdata
group by genre
order by global_sales desc;

-- EU has the highest market ps4 gaming share globally
SELECT 
    ROUND(100 * SUM(north_america) / SUM(global), 2) AS na_market_share,
    ROUND(100 * SUM(europe) / SUM(global), 2) AS eu_market_share,
    ROUND(100 * SUM(japan) / SUM(global), 2) AS japan_market_share,
    ROUND(100 * SUM(rest_of_world) / SUM(global), 2) AS row_market_share
FROM gamesalesdata;










