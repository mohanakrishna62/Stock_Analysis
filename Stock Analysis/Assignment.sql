############################# Creating schema Assignment #############################
create database assignment;

############### Importing file using the Import wizard of MySQL workbench ############
use assignment;
set SQL_SAFE_UPDATES = 0;

############## Describe the data types of variables in the repective company table #############
desc bajaj_auto;
desc eicher_motors;
desc hero_motocorp;
desc infosys;
desc tcs;
desc tvs_motors;

######### Creating temporary tables to convert Date variable to date format so that it could be sorted and fetch Close Price ########
create table bajajtemp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from bajaj_auto; 
create table eichertemp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from eicher_motors;
create table herotemp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from hero_motocorp;
create table infosystemp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from infosys;
create table tcstemp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from tcs;
create table tvstemp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from tvs_motors;

################################################################################################
################## 1 Calculating the 20 and 50 Days Moving Average #############################
################################################################################################

##### For Bajaj #####
create table bajaj1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from bajajtemp
window w as (order by Date asc);
select * from bajaj1 limit 100;

#### For Eicher #####
create table eicher1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from eichertemp
window w as (order by Date asc);
select * from eicher1 limit 100;

#### For Hero motocorp ####
create table hero1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from herotemp
window w as (order by Date asc);
select * from hero1 limit 100;

#### For Infosys ####
create table infosys1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from infosystemp
window w as (order by Date asc);
select * from infosys1 limit 100;

#### For TCS ####
create table tcs1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from tcstemp
window w as (order by Date asc);
select * from tcs1 limit 100;

#### For TVS motors ####
create table tvs1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from tvstemp
window w as (order by Date asc);
select * from tvs1 limit 100;

############### Each new table created shows the 20 day & 50 day Moving average ############################
############### Values till 19th day and 49th day are null for 20 day MA and 50 day MA repectively #########

############## Dropping Temporary tables #############
drop table bajajtemp;
drop table eichertemp;
drop table herotemp;
drop table infosystemp;
drop table tcstemp;
drop table tvstemp;

#######################################################################################################
##################### 2 Master table creation by joining all the tables created in 1 ##################
#######################################################################################################
create table master_table 
select b.Date as Date,b.`Close Price` as Bajaj, e.`Close Price` as Eicher, h.`Close Price` as Hero, i.`Close Price` as Infosys, 
t.`Close Price` as TCS, tv.`Close Price` as TVS
from bajaj1 b
left join eicher1 e on b.Date = e.Date 
left join hero1 h on b.Date = h.Date
left join infosys1 i on b.Date = i.Date
left join tcs1 t on b.Date = t.Date
left join tvs1 tv on b.Date = tv.Date;

select * from master_table;

######################################################################################################
############################# 3 Generating BUY/SELL/HOLD signal tables ###############################
######################################################################################################

######### creating temporary tables to get the previous day value for 20day MA and 50day MA ############

create table bajajtemp
select Day, Date, `Close Price`, `20 Day MA`, lag(`20 Day MA`,1) over w as 20_MA_prev, `50 Day MA`, lag(`50 Day MA`,1) over w as 50_MA_prev
from bajaj1
window w as (order by Day);
select * from bajajtemp;

create table eichertemp
select Day, Date, `Close Price`, `20 Day MA`, lag(`20 Day MA`,1) over w as 20_MA_prev, `50 Day MA`, lag(`50 Day MA`,1) over w as 50_MA_prev
from eicher1
window w as (order by Day);
select * from eichertemp;

create table herotemp
select Day, Date, `Close Price`, `20 Day MA`, lag(`20 Day MA`,1) over w as 20_MA_prev, `50 Day MA`, lag(`50 Day MA`,1) over w as 50_MA_prev
from hero1
window w as (order by Day);
select * from herotemp;

create table infosystemp
select Day, Date, `Close Price`, `20 Day MA`, lag(`20 Day MA`,1) over w as 20_MA_prev, `50 Day MA`, lag(`50 Day MA`,1) over w as 50_MA_prev
from infosys1
window w as (order by Day);
select * from infosystemp;

create table tcstemp
select Day, Date, `Close Price`, `20 Day MA`, lag(`20 Day MA`,1) over w as 20_MA_prev, `50 Day MA`, lag(`50 Day MA`,1) over w as 50_MA_prev
from tcs1
window w as (order by Day);
select * from tcstemp;

create table tvstemp
select Day, Date, `Close Price`, `20 Day MA`, lag(`20 Day MA`,1) over w as 20_MA_prev, `50 Day MA`, lag(`50 Day MA`,1) over w as 50_MA_prev
from tvs1
window w as (order by Day);
select * from tvstemp;

############## Generating BUY/SELL/HOLD signal tables ##################

### For Bajaj ###
create table bajaj2
select Date,`Close Price`,
(case when Day > 49 and `20 Day MA` > `50 Day MA` and 20_MA_prev < 50_MA_prev then 'BUY'
	 when Day > 49 and `20 Day MA` < `50 Day MA` and 20_MA_prev > 50_MA_prev then 'SELL'
else 'HOLD' end) as 'Signal'
from bajajtemp;
select * from bajaj2 limit 100;

### For Eicher motors ###
create table eicher2
select Date,`Close Price`,
(case when Day > 49 and `20 Day MA` > `50 Day MA` and 20_MA_prev < 50_MA_prev then 'BUY'
	 when Day > 49 and `20 Day MA` < `50 Day MA` and 20_MA_prev > 50_MA_prev then 'SELL'
else 'HOLD' end) as 'Signal'
from eichertemp;
select * from eicher2 limit 100;

### For Hero motocorp ###
create table hero2
select Date,`Close Price`,
(case when Day > 49 and `20 Day MA` > `50 Day MA` and 20_MA_prev < 50_MA_prev then 'BUY'
	 when Day > 49 and `20 Day MA` < `50 Day MA` and 20_MA_prev > 50_MA_prev then 'SELL'
else 'HOLD' end) as 'Signal'
from herotemp;
select * from hero2 limit 100;

### For Infosys ###
create table infosys2
select Date,`Close Price`,
(case when Day > 49 and `20 Day MA` > `50 Day MA` and 20_MA_prev < 50_MA_prev then 'BUY'
	 when Day > 49 and `20 Day MA` < `50 Day MA` and 20_MA_prev > 50_MA_prev then 'SELL'
else 'HOLD' end) as 'Signal'
from infosystemp;
select * from infosys2 limit 100;

### For TCS ###
create table tcs2
select Date,`Close Price`,
(case when Day > 49 and `20 Day MA` > `50 Day MA` and 20_MA_prev < 50_MA_prev then 'BUY'
	 when Day > 49 and `20 Day MA` < `50 Day MA` and 20_MA_prev > 50_MA_prev then 'SELL'
else 'HOLD' end) as 'Signal'
from tcstemp;
select * from tcs2 limit 100;

### For TVS ###
create table tvs2
select Date,`Close Price`,
(case when Day > 49 and `20 Day MA` > `50 Day MA` and 20_MA_prev < 50_MA_prev then 'BUY'
	 when Day > 49 and `20 Day MA` < `50 Day MA` and 20_MA_prev > 50_MA_prev then 'SELL'
else 'HOLD' end) as 'Signal'
from tvstemp;
select * from tvs2 limit 100;

################### drop temporary tables #########################
drop table bajajtemp;
drop table eichertemp;
drop table infosystemp;
drop table herotemp;
drop table tcstemp;
drop table tvstemp;

###################################################################################################################
##################  4 UDF for taking date as input and return Signal of that day for Bajaj ########################
###################################################################################################################

delimiter $$
create function input_signal (s date)
returns char(50) deterministic
begin
declare s_value varchar(5);
set s_value = (select 'Signal' from bajaj2 where Date = s);
return s_value;
end
$$
delimiter ;
select input_signal('2016-03-16') as `signal`;
		