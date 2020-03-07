/* Creating Database */
create database Assignment;

/* Using Assignment Database */
use Assignment;
/* Checking all the imported tables */
show tables;
/* Creating bajaj_temp table */
create temporary table bajaj_temp
select *,avg(`Close Price`) over(order by Date ROWS 19 PRECEDING) as '20 Day MA',
avg(`Close Price`) over(order by Date ROWS 49 PRECEDING) as '50 Day MA'
 FROM (select STR_TO_DATE(Date, '%d-%M-%Y') as Date, `Close Price` from bajaj order by Date) as a;
/* Creating bajaj1 table from temp table containing the date, close price, 20 Day MA and 50 Day MA */
create table bajaj1 like bajaj_temp;
INSERT INTO bajaj1 SELECT * FROM bajaj_temp;
DROP TEMPORARY TABLE IF EXISTS bajaj_temp;

/* Creating eicher_temp table */
create temporary table eicher_temp
select *,avg(`Close Price`) over(order by Date ROWS 19 PRECEDING) as '20 Day MA',
avg(`Close Price`) over(order by Date ROWS 49 PRECEDING) as '50 Day MA'
 FROM (select STR_TO_DATE(Date, '%d-%M-%Y') as Date, `Close Price` from eicher order by Date) as a;
/* Creating eicher1 table from temp table */
create table eicher1 like eicher_temp;
INSERT INTO eicher1 SELECT * FROM eicher_temp;
DROP TEMPORARY TABLE IF EXISTS eicher_temp;

/* Creating hero_temp table */
create temporary table hero_temp
select *,avg(`Close Price`) over(order by Date ROWS 19 PRECEDING) as '20 Day MA',
avg(`Close Price`) over(order by Date ROWS 49 PRECEDING) as '50 Day MA'
 FROM (select STR_TO_DATE(Date, '%d-%M-%Y') as Date, `Close Price` from hero order by Date) as a;
/* Creating hero1 table from temp table */
create table hero1 like hero_temp;
INSERT INTO hero1 SELECT * FROM hero_temp;
DROP TEMPORARY TABLE IF EXISTS hero_temp;

/* Creating infosys1 temp table */
create temporary table infosys_temp
select *,avg(`Close Price`) over(order by Date ROWS 19 PRECEDING) as '20 Day MA',
avg(`Close Price`) over(order by Date ROWS 49 PRECEDING) as '50 Day MA'
 FROM (select STR_TO_DATE(Date, '%d-%M-%Y') as Date, `Close Price` from infosys order by Date) as a;
/* Creating infosys1 table from temp table */
create table infosys1 like infosys_temp;
INSERT INTO infosys1 SELECT * FROM infosys_temp;
DROP TEMPORARY TABLE IF EXISTS infosys_temp;

/* Creating tcs_temp table */
create temporary table tcs_temp 
select *,avg(`Close Price`) over(order by Date ROWS 19 PRECEDING) as '20 Day MA',
avg(`Close Price`) over(order by Date ROWS 49 PRECEDING) as '50 Day MA'
 FROM (select STR_TO_DATE(Date, '%d-%M-%Y') as Date, `Close Price` from tcs order by Date) as a;
/* Creating tcs1 table from temp table */
create table tcs1 like tcs_temp;
INSERT INTO tcs1 SELECT * FROM tcs_temp;
DROP TEMPORARY TABLE IF EXISTS tcs_temp;

/* Creating tvs_temp table */
create temporary table tvs_temp 
select *,avg(`Close Price`) over(order by Date ROWS 19 PRECEDING) as '20 Day MA',
avg(`Close Price`) over(order by Date ROWS 49 PRECEDING) as '50 Day MA'
 FROM (select STR_TO_DATE(Date, '%d-%M-%Y') as Date, `Close Price` from tvs order by Date) as a;
/* Creating tvs1 table from temp table */
create table tvs1 like tvs_temp;
INSERT INTO tvs1 SELECT * FROM tvs_temp;
DROP TEMPORARY TABLE IF EXISTS tvs_temp;

/* Creating Master temp Table */
create temporary table master_table_temp 
select a.Date,a.`Close Price` as  Bajaj,b.`Close Price` as  TCS ,c.`Close Price` as TVS,
d.`Close Price` as Infosys,e.`Close Price` as Eicher,f.`Close Price` as Hero
FROM bajaj1 as a
Join tcs1 as b  on a.Date = b.Date
JOIN tvs1 as c on a.Date = c.Date
JOIN infosys1 as d on a.Date = d.Date
JOIN eicher1 as e on a.Date = e.Date
JOIN Hero1 as f on a.Date = f.Date;
/* Creating master table from temp table, containing the date and close price of all the six stocks */
create table master_table like master_table_temp;
INSERT INTO master_table SELECT * FROM master_table_temp;
DROP TEMPORARY TABLE IF EXISTS master_table_temp;


/* Finding Signal */

/* Creating bajaj2 table */
create temporary table bajaj2_temp 
select Date,`Close Price`,`Signal` from
(select a.Date,`Close Price`,a.difference,a.ranking,
(case when a.ranking=0 and b.ranking=-1 then 'SELL'
when (a.ranking=0 and b.ranking =1) then 'BUY'
when (a.ranking=-1 and b.ranking=1) then 'BUY'
when (a.ranking=1 and b.ranking=-1) then 'SELL' ELSE 'HOLD' END) as `Signal`,
a.row_num,b.row_num as row_numb,row_number() over(partition by a.Date order by a.row_num desc) as uniq_id
from (select * FROM(select *,(`20 Day MA` - `50 Day MA`) as difference,
(case When (`20 Day MA` - `50 Day MA`) >0 then 1
      when (`20 Day MA` - `50 Day MA`) <0 then -1 ELSE 0 END ) as ranking,
      ROW_NUMBER() OVER (ORDER BY Date) as row_num
 from bajaj1) as t1) as a
 Join 
 (select ranking,row_num FROM(select *,(`20 Day MA` - `50 Day MA`) as difference,
(case When (`20 Day MA` - `50 Day MA`) >0 then 1
      when (`20 Day MA` - `50 Day MA`) <0 then -1 ELSE 0 END ) as ranking,
      ROW_NUMBER() OVER (ORDER BY Date) as row_num
 from bajaj1) as t2) as b
 on b.row_num = a.row_num+1 ) as c
 where uniq_id =1;
create table bajaj2 like bajaj2_temp;
INSERT INTO bajaj2 SELECT * FROM bajaj2_temp;
DROP TEMPORARY TABLE IF EXISTS bajaj2_temp;

/* creating hero2 table */
create temporary table hero2_temp 
select Date,`Close Price`,`Signal` from 
(select a.Date,`Close Price`,a.difference,a.ranking,
(case when a.ranking=0 and b.ranking=-1 then 'SELL'
when (a.ranking=0 and b.ranking =1) then 'BUY'
when (a.ranking=-1 and b.ranking=1) then 'BUY'
when (a.ranking=1 and b.ranking=-1) then 'SELL' ELSE 'HOLD' END) as `Signal`,
a.row_num,b.row_num as row_numb,row_number() over(partition by a.Date order by a.row_num desc) as uniq_id
from (select * FROM(select *,(`20 Day MA` - `50 Day MA`) as difference,
(case When (`20 Day MA` - `50 Day MA`) >0 then 1
      when (`20 Day MA` - `50 Day MA`) <0 then -1 ELSE 0 END ) as ranking,
      ROW_NUMBER() OVER (ORDER BY Date) as row_num
 from hero1) as t1) as a
 Join 
 (select ranking,row_num FROM(select *,(`20 Day MA` - `50 Day MA`) as difference,
(case When (`20 Day MA` - `50 Day MA`) >0 then 1
      when (`20 Day MA` - `50 Day MA`) <0 then -1 ELSE 0 END ) as ranking,
      ROW_NUMBER() OVER (ORDER BY Date) as row_num
 from hero1) as t2) as b
 on b.row_num = a.row_num+1 ) as c
 where uniq_id =1;
create table hero2 like hero2_temp;
INSERT INTO hero2 SELECT * FROM hero2_temp;
DROP TEMPORARY TABLE IF EXISTS hero2_temp;

/* Creating infosys2 table */
create temporary table infosys2_temp 
select Date,`Close Price`,`Signal` from
(select a.Date,`Close Price`,a.difference,a.ranking,
(case when a.ranking=0 and b.ranking=-1 then 'SELL'
when (a.ranking=0 and b.ranking =1) then 'BUY'
when (a.ranking=-1 and b.ranking=1) then 'BUY'
when (a.ranking=1 and b.ranking=-1) then 'SELL' ELSE 'HOLD' END) as `Signal`,
a.row_num,b.row_num as row_numb,row_number() over(partition by a.Date order by a.row_num desc) as uniq_id
from (select * FROM(select *,(`20 Day MA` - `50 Day MA`) as difference,
(case When (`20 Day MA` - `50 Day MA`) >0 then 1
      when (`20 Day MA` - `50 Day MA`) <0 then -1 ELSE 0 END ) as ranking,
      ROW_NUMBER() OVER (ORDER BY Date) as row_num
 from infosys1) as t1) as a
 Join 
 (select ranking,row_num FROM(select *,(`20 Day MA` - `50 Day MA`) as difference,
(case When (`20 Day MA` - `50 Day MA`) >0 then 1
      when (`20 Day MA` - `50 Day MA`) <0 then -1 ELSE 0 END ) as ranking,
      ROW_NUMBER() OVER (ORDER BY Date) as row_num
 from infosys1) as t2) as b
 on b.row_num = a.row_num+1 ) as c
 where uniq_id =1;
 create table infosys2 like infosys2_temp;
INSERT INTO infosys2 SELECT * FROM infosys2_temp;
DROP TEMPORARY TABLE IF EXISTS infosys2_temp;

/* Creating tcs2 table */ 
create temporary table tcs2_temp 
select Date,`Close Price`,`Signal` from
(select a.Date,`Close Price`,a.difference,a.ranking,
(case when a.ranking=0 and b.ranking=-1 then 'SELL'
when (a.ranking=0 and b.ranking =1) then 'BUY'
when (a.ranking=-1 and b.ranking=1) then 'BUY'
when (a.ranking=1 and b.ranking=-1) then 'SELL' ELSE 'HOLD' END) as `Signal`,
a.row_num,b.row_num as row_numb,row_number() over(partition by a.Date order by a.row_num desc) as uniq_id
from (select * FROM(select *,(`20 Day MA` - `50 Day MA`) as difference,
(case When (`20 Day MA` - `50 Day MA`) >0 then 1
      when (`20 Day MA` - `50 Day MA`) <0 then -1 ELSE 0 END ) as ranking,
      ROW_NUMBER() OVER (ORDER BY Date) as row_num
 from tcs1) as t1) as a
 Join 
 (select ranking,row_num FROM(select *,(`20 Day MA` - `50 Day MA`) as difference,
(case When (`20 Day MA` - `50 Day MA`) >0 then 1
      when (`20 Day MA` - `50 Day MA`) <0 then -1 ELSE 0 END ) as ranking,
      ROW_NUMBER() OVER (ORDER BY Date) as row_num
 from tcs1) as t2) as b
 on b.row_num = a.row_num+1 ) as c
 where uniq_id =1;
create table tcs2 like tcs2_temp;
INSERT INTO tcs2 SELECT * FROM tcs2_temp;
DROP TEMPORARY TABLE IF EXISTS tcs2_temp;

/* Creating tvs2 table */
create temporary table tvs2_temp 
select Date,`Close Price`,`Signal` from
(select a.Date,`Close Price`,a.difference,a.ranking,
(case when a.ranking=0 and b.ranking=-1 then 'SELL'
when (a.ranking=0 and b.ranking =1) then 'BUY'
when (a.ranking=-1 and b.ranking=1) then 'BUY'
when (a.ranking=1 and b.ranking=-1) then 'SELL' ELSE 'HOLD' END) as `Signal`,
a.row_num,b.row_num as row_numb,row_number() over(partition by a.Date order by a.row_num desc) as uniq_id
from (select * FROM(select *,(`20 Day MA` - `50 Day MA`) as difference,
(case When (`20 Day MA` - `50 Day MA`) >0 then 1
      when (`20 Day MA` - `50 Day MA`) <0 then -1 ELSE 0 END ) as ranking,
      ROW_NUMBER() OVER (ORDER BY Date) as row_num
 from tvs1) as t1) as a
 Join 
 (select ranking,row_num FROM(select *,(`20 Day MA` - `50 Day MA`) as difference,
(case When (`20 Day MA` - `50 Day MA`) >0 then 1
      when (`20 Day MA` - `50 Day MA`) <0 then -1 ELSE 0 END ) as ranking,
      ROW_NUMBER() OVER (ORDER BY Date) as row_num
 from tvs1) as t2) as b
 on b.row_num = a.row_num+1 ) as c
 where uniq_id =1;
 create table tvs2 like tvs2_temp;
INSERT INTO tvs2 SELECT * FROM tvs2_temp;
DROP TEMPORARY TABLE IF EXISTS tvs2_temp;

/*Creating eicher2 table */
create temporary table eicher2_temp 
select Date,`Close Price`,`Signal` from
(select a.Date,`Close Price`,a.difference,a.ranking,
(case when a.ranking=0 and b.ranking=-1 then 'SELL'
when (a.ranking=0 and b.ranking =1) then 'BUY'
when (a.ranking=-1 and b.ranking=1) then 'BUY'
when (a.ranking=1 and b.ranking=-1) then 'SELL' ELSE 'HOLD' END) as `Signal`,
a.row_num,b.row_num as row_numb,row_number() over(partition by a.Date order by a.row_num desc) as uniq_id
from (select * FROM(select *,(`20 Day MA` - `50 Day MA`) as difference,
(case When (`20 Day MA` - `50 Day MA`) >0 then 1
      when (`20 Day MA` - `50 Day MA`) <0 then -1 ELSE 0 END ) as ranking,
      ROW_NUMBER() OVER (ORDER BY Date) as row_num
 from eicher1) as t1) as a
 Join 
 (select ranking,row_num FROM(select *,(`20 Day MA` - `50 Day MA`) as difference,
(case When (`20 Day MA` - `50 Day MA`) >0 then 1
      when (`20 Day MA` - `50 Day MA`) <0 then -1 ELSE 0 END ) as ranking,
      ROW_NUMBER() OVER (ORDER BY Date) as row_num
 from eicher1) as t2) as b
 on b.row_num = a.row_num+1 ) as c
 where uniq_id =1;
create table eicher2 like eicher2_temp;
INSERT INTO eicher2 SELECT * FROM eicher2_temp;
DROP TEMPORARY TABLE IF EXISTS eicher2_temp;

/* Creating User defined Funtion for Bajaj Stock */

DROP FUNCTION IF EXISTS bajaj_stock_signal;
DELIMITER $$
CREATE FUNCTION bajaj_stock_signal (param varchar(12))
/*RETURNS TEXT DETERMINISTIC */
RETURNS VARCHAR(4) DETERMINISTIC
BEGIN 
     DECLARE signal_value varchar(4);     
     select `signal` into signal_value from bajaj2 where Date=param;
     RETURN signal_value;
END $$    
DELIMITER ;
select bajaj_stock_signal('2015-01-01') ;


