select * from census_project.dbo.Data1;
select * from census_project.dbo.Data2;


-- number of rows into our dataset
select count(*) from census_project..Data1
select count(*) from census_project..Data2


-- select dataset for jharkhand and bihar
select * from census_project..Data1 where state in ('jharkhand','bihar')
select * from census_project..Data1 where state in ('gujarat')


-- population of india
select * from census_project..Data2
select sum(population) as total_population from census_project..Data2


-- average growth
select avg(growth)*100 as avg_growth_percent from census_project..Data1


-- state avg growth
select state, avg(growth)*100 as avg_growth from census_project..data1 group by state;


-- avg sex ratio
select round(avg(sex_ratio),0) as avg_sex_ratio from census_project..Data1 
select state, round(avg(sex_ratio),0) as avg_sex_ratio from census_project..Data1 group by state;


-- avg sex ratio in descending order
select state, round(avg(sex_ratio),0) as avg_sex_ratio from census_project..Data1 group by state order by avg_sex_ratio desc;


-- avg literacy rate 
select state, round(avg(literacy),0) as avg_literacy_rate from census_project..Data1 group by state order by avg_literacy_rate desc;
select state, round(avg(literacy),0) as avg_literacy_rate from census_project..Data1 group by state having round(avg(literacy),0)>90 order by avg_literacy_rate desc;


-- top 3 states showing highest growth ratio
select top 3 state, avg(growth)*100 top_3_states from census_project..Data1 group by State order by top_3_states desc;
select state, avg(growth)*100 top_3_states from census_project..Data1 group by State order by top_3_states desc limit 3;


-- bottom 3 states showing lowest sex ratio
select top 3 state, round(avg(sex_ratio),0) bottom_3_states from census_project..Data1 group by State order by bottom_3_states asc;


-- top and bottom 3 states in literacy state

-- top 3 states in literacy state
drop table if exists #top_states
create table #top_states
( state nvarchar(255),
  topstate float
  )

  insert into #top_states
  select state, round(avg(literacy),0) as avg_literacy_rate from census_project..Data1 group by state order by avg_literacy_rate desc;

  select top 3 * from #top_states order by #top_states.topstate desc;



  -- bottom 3 states in literacy state
drop table if exists #bottom_states
create table #bottom_states
( state nvarchar(255),
  bottomstate float
  )

  insert into #bottom_states
  select state, round(avg(literacy),0) as avg_literacy_rate from census_project..Data1 group by state order by avg_literacy_rate desc;

  select top 3 * from #bottom_states order by #bottom_states.bottomstate asc;


  -- union operator
 select * from
 (select top 3 * from #top_states order by #top_states.topstate desc) a
 union
  select * from
(select top 3 * from #bottom_states order by #bottom_states.bottomstate asc) b


-- state starting with letter a
select distinct state from census_project..Data1 where lower(state) like 'a%'


-- state starting with letter a or b
select distinct state from census_project..Data1 where lower(state) like 'a%' or lower(state) like 'b%'


-- select state start with letter a or end with letter d
select distinct state from census_project..Data1 where lower(state) like 'a%' or lower(state) like '%d'


-- select state start with letter a and end with letter m
select distinct state from census_project..Data1 where lower(state) like 'a%' and lower(state) like '%m'




-- male and female
-- joining both the table 
select * from census_project.dbo.Data1;
select * from census_project.dbo.Data2;
select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from census_project..Data1 a inner join census_project..Data2 b  on a.district = b.District

-- calculation of number of males and females disrtict wise
select c.district,c.state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from 
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from census_project..Data1 a inner join census_project..Data2 b  on a.district = b.District)c

-- calculation of number of males and females state wise
select d.state,sum(d.males) total_male, sum(d.females) total_female from
(select c.district,c.state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from 
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from census_project..Data1 a inner join census_project..Data2 b  on a.district = b.District)c)d
group by d.state



-- literacy and illiteracy
-- joining both the table 
select * from census_project.dbo.Data1;
select * from census_project.dbo.Data2;
select a.district,a.state,a.literacy/100 literacy_ratio,b.population from census_project..Data1 a inner join census_project..Data2 b  on a.district = b.District

-- calculation of total number of literate and illiterate people disrtict wise
select c.district,c.state,round(c.literacy_ratio*c.population,0) illiterate, round((1-c.literacy_ratio)*c.population,0) illiterate from 
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from census_project..Data1 a inner join census_project..Data2 b  on a.district = b.District)c

-- calculation of total number of literate and illiterate people state wise
select d.state,sum(d.literate) literate_people, sum(d.illiterate) illiterate_people from
(select c.district,c.state,round(c.literacy_ratio*c.population,0) literate, round((1-c.literacy_ratio)*c.population,0) illiterate from 
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from census_project..Data1 a inner join census_project..Data2 b  on a.district = b.District)c)d
group by state



-- population in previous census
-- joining both the table 
select * from census_project.dbo.Data1;
select * from census_project.dbo.Data2;
select a.district,a.state,a.growth, b.population from census_project..Data1 a inner join census_project..Data2 b  on a.district = b.District

-- previous census population district wise
select c.district,c.state,round(c.population/(1+c.growth),0) previos_population, c.population current_population from
(select a.district,a.state,a.growth, b.population from census_project..Data1 a inner join census_project..Data2 b  on a.district = b.District)c

-- previous census population state wise
select d.state,sum(d.previous_population) total_previous_population,sum(d.current_population) total_current_population from
(select c.district,c.state,round(c.population/(1+c.growth),0) previous_population, c.population current_population from
(select a.district,a.state,a.growth, b.population from census_project..Data1 a inner join census_project..Data2 b  on a.district = b.District)c)d
group by state

-- total population of india
select sum(e.previous_population) total_previous_population, sum(e.current_population) total_current_population from
(select d.state,sum(d.previous_population) previous_population,sum(d.current_population) current_population from
(select c.district,c.state,round(c.population/(1+c.growth),0) previous_population, c.population current_population from
(select a.district,a.state,a.growth, b.population from census_project..Data1 a inner join census_project..Data2 b  on a.district = b.District)c)d
group by state)e




-- population vs area

-- put total area, previous_population and current_population in one table
select q.*,r.* from(

-- total population
select '1' as keyy,n. * from(
select sum(e.previous_population) total_previous_population, sum(e.current_population) total_current_population from
(select d.state,sum(d.previous_population) previous_population,sum(d.current_population) current_population from
(select c.district,c.state,round(c.population/(1+c.growth),0) previous_population, c.population current_population from
(select a.district,a.state,a.growth, b.population from census_project..Data1 a inner join census_project..Data2 b  on a.district = b.District)c)d
group by state)e)n) q inner join(

-- total area
select '1' as keyy,z. * from(
select sum(Area_km2) total_area from census_project..Data2) z) r on q.keyy = r.keyy


-- comparision of total area, previous_population and current_population (population density)
select g.total_area/g.total_previous_population total_area_vs_total_previous_population,
g.total_area/g.total_current_population total_area_vs_total_previous_population from
(select q.*,r.total_area from(

select '1' as keyy,n. * from(
select sum(e.previous_population) total_previous_population, sum(e.current_population) total_current_population from
(select d.state,sum(d.previous_population) previous_population,sum(d.current_population) current_population from
(select c.district,c.state,round(c.population/(1+c.growth),0) previous_population, c.population current_population from
(select a.district,a.state,a.growth, b.population from census_project..Data1 a inner join census_project..Data2 b  on a.district = b.District)c)d
group by state)e)n) q inner join(

select '1' as keyy,z. * from(
select sum(Area_km2) total_area from census_project..Data2) z) r on q.keyy = r.keyy) g



-- output top3 district from each state with highest literacy rate
-- window

select a.* from(
select district,state,literacy,rank() over(partition by state order by literacy desc) rnk from census_project..Data1) a
where a.rnk in (1,2,3) order by state