-- Object: PROCEDURE dbo.rpt_newalbmgrossexpo
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_newalbmgrossexpo    Script Date: 04/27/2001 4:32:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newalbmgrossexpo    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newalbmgrossexpo    Script Date: 20-Mar-01 11:39:01 PM ******/









/* report : misnews 
   file : topclient_scrip.asp
*/
/* finds gross exposure of all clients for current settlement as well as today's day */
/* changed by mousami on 06/02/2001 
     added family login */

CREATE PROCEDURE rpt_newalbmgrossexpo
@statusid varchar(15),
@statusname varchar(25),
@settno varchar(7),
@wsettno varchar(7)

AS


if @statusid='broker' 
begin
select  s.series,original=s.ser,s.scrip_cd , s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code, c1.short_name , 
rate=isnull((case markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type /* a.series=s.series condition is not given as albmrate for 01-05 series is 
same and while filling table you will write series as be (in albmrate))*/
and (a.sett_no like ltrim(@settno)+'%'  or a.sett_no like ltrim(@wsettno)+'%')) else (0) end ),0),
s.markettype,
party=(select cl_code from albmwparty where cl_code=c1.cl_code)  /* checks whether selected clcode has done trading in w which is 
settling in current settlement of  w*/
/*
prevgross=(case when (s.series='be' and s.markettype='3') then (select grossexp=sum(a.rate*a.tradeqty) from albmhist a
					 where a.sett_no=@wsettno and a.ser <> '01'
					 and a.cl_code=c1.cl_code
					 and s.scrip_cd=a.scrip_cd
					 group by a.sett_no,a.series) else 0 end)
*/
from rpt_currentsett s , client1 c1, client2 c2
where  
c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
group by  c1.cl_code,c1.short_name,s.sett_type,s.scrip_Cd,s.series, s.ser, s.markettype,s.tradeqty ,s.trade_no
union all
select series= (CASE when s.series in ('01','02','03','04','05')  then 'BE' else s.series end),original=s.series, s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
rate=s.marketrate,
s.markettype,
party=(select cl_code from albmwparty where cl_code=c1.cl_code) 
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
group by c1.cl_code,c1.short_name,s.scrip_Cd,s.series, s.markettype,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.series,s.markettype,s.scrip_cd
end


if @statusid='branch' 
begin
select  s.series,original=s.ser,s.scrip_cd , s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code, c1.short_name , 
rate=isnull((case markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type /* a.series=s.series condition is not given as albmrate for 01-05 series is 
same and while filling table you will write series as be (in albmrate))*/
and (a.sett_no like ltrim(@settno)+'%'  or a.sett_no like ltrim(@wsettno)+'%')) else (0) end ),0),
s.markettype,
party=(select cl_code from albmwparty where cl_code=c1.cl_code)
/*
prevgross=(case when (s.series='be' and s.markettype='3') then (select grossexp=sum(a.rate*a.tradeqty) from albmhist a
					 where a.sett_no=@wsettno and a.ser <> '01'
					 and a.cl_code=c1.cl_code
					 and s.scrip_cd=a.scrip_cd
					 group by a.sett_no,a.series) else 0 end)
*/
from rpt_currentsett s , client1 c1, client2 c2, branches b
where  c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and b.short_name=c1.trader
and b.branch_cd=@statusname
group by  c1.cl_code,c1.short_name,s.sett_type,s.scrip_Cd,s.series, s.ser, s.markettype,s.tradeqty ,s.trade_no
union all
select series= (CASE when s.series in ('01','02','03','04','05')  then 'BE' else s.series end),original=s.series, s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
rate=s.marketrate,
s.markettype,
party=(select cl_code from albmwparty where cl_code=c1.cl_code) 
from trade4432 s,client1 c1,client2 c2 , branches b
where b.short_name=c1.trader and b.branch_cd=@statusname and c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
group by c1.cl_code,c1.short_name,s.scrip_Cd,s.series, s.markettype,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.series,s.markettype,s.scrip_cd
end

if @statusid='trader' 
begin
select  s.series,original=s.ser,s.scrip_cd , s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code, c1.short_name , 
rate=isnull((case markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type /* a.series=s.series condition is not given as albmrate for 01-05 series is 
same and while filling table you will write series as be (in albmrate))*/
and (a.sett_no like ltrim(@settno)+'%'  or a.sett_no like ltrim(@wsettno)+'%')) else (0) end ),0),
s.markettype,
party=(select cl_code from albmwparty where cl_code=c1.cl_code)
/*
prevgross=(case when (s.series='be' and s.markettype='3') then (select grossexp=sum(a.rate*a.tradeqty) from albmhist a
					 where a.sett_no=@wsettno and a.ser <> '01'
					 and a.cl_code=c1.cl_code
					 and s.scrip_cd=a.scrip_cd
					 group by a.sett_no,a.series) else 0 end)
*/
from rpt_currentsett s , client1 c1, client2 c2
where  
c1.trader=@statusname and
c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
group by  c1.cl_code,c1.short_name,s.sett_type,s.scrip_Cd,s.series, s.ser, s.markettype,s.tradeqty ,s.trade_no
union all
select series= (CASE when s.series in ('01','02','03','04','05')  then 'BE' else s.series end),original=s.series, s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
rate=s.marketrate,
s.markettype,
party=(select cl_code from albmwparty where cl_code=c1.cl_code) 
from trade4432 s,client1 c1,client2 c2 
where 
c1.trader=@statusname and
c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
group by c1.cl_code,c1.short_name,s.scrip_Cd,s.series, s.markettype,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.series,s.markettype,s.scrip_cd
end

if @statusid='subbroker' 
begin
select  s.series,original=s.ser,s.scrip_cd , s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code, c1.short_name , 
rate=isnull((case markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type /* a.series=s.series condition is not given as albmrate for 01-05 series is 
same and while filling table you will write series as be (in albmrate))*/
and (a.sett_no like ltrim(@settno)+'%'  or a.sett_no like ltrim(@wsettno)+'%')) else (0) end ),0),
s.markettype,
party=(select cl_code from albmwparty where cl_code=c1.cl_code)
/*
prevgross=(case when (s.series='be' and s.markettype='3') then (select grossexp=sum(a.rate*a.tradeqty) from albmhist a
					 where a.sett_no=@wsettno and a.ser <> '01'
					 and a.cl_code=c1.cl_code
					 and s.scrip_cd=a.scrip_cd
					 group by a.sett_no,a.series) else 0 end)
*/
from rpt_currentsett s , client1 c1, client2 c2, subbrokers sb
where  
sb.sub_broker=c1.sub_broker and
sb.sub_broker=@statusname and
c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
group by  c1.cl_code,c1.short_name,s.sett_type,s.scrip_Cd,s.series, s.ser, s.markettype,s.tradeqty ,s.trade_no
union all
select series= (CASE when s.series in ('01','02','03','04','05')  then 'BE' else s.series end),original=s.series, s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
rate=s.marketrate,
s.markettype,
party=(select cl_code from albmwparty where cl_code=c1.cl_code) 
from trade4432 s,client1 c1,client2 c2 , subbrokers sb
where sb.sub_broker=c1.sub_broker and
sb.sub_broker=@statusname
and c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
group by c1.cl_code,c1.short_name,s.scrip_Cd,s.series, s.markettype,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.series,s.markettype,s.scrip_cd
end

if @statusid='client' 
begin
select  s.series,original=s.ser,s.scrip_cd , s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code, c1.short_name , 
rate=isnull((case markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type /* a.series=s.series condition is not given as albmrate for 01-05 series is 
same and while filling table you will write series as be (in albmrate))*/
and (a.sett_no like ltrim(@settno)+'%'  or a.sett_no like ltrim(@wsettno)+'%')) else (0) end ),0),
s.markettype,
party=(select cl_code from albmwparty where cl_code=c1.cl_code)
/*
prevgross=(case when (s.series='be' and s.markettype='3') then (select grossexp=sum(a.rate*a.tradeqty) from albmhist a
					 where a.sett_no=@wsettno and a.ser <> '01'
					 and a.cl_code=c1.cl_code
					 and s.scrip_cd=a.scrip_cd
					 group by a.sett_no,a.series) else 0 end)
*/
from rpt_currentsett s , client1 c1, client2 c2
where  
c2.party_code=@statusname
and c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
group by  c1.cl_code,c1.short_name,s.sett_type,s.scrip_Cd,s.series, s.ser, s.markettype,s.tradeqty ,s.trade_no
union all
select series= (CASE when s.series in ('01','02','03','04','05')  then 'BE' else s.series end),original=s.series, s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
rate=s.marketrate,
s.markettype,
party=(select cl_code from albmwparty where cl_code=c1.cl_code) 
from trade4432 s,client1 c1,client2 c2 
where c2.party_code=@statusname 
and c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
group by c1.cl_code,c1.short_name,s.scrip_Cd,s.series, s.markettype,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.series,s.markettype,s.scrip_cd
end



if @statusid='family'
begin
select  s.series,original=s.ser,s.scrip_cd , s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code, c1.short_name , 
rate=isnull((case markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type /* a.series=s.series condition is not given as albmrate for 01-05 series is 
same and while filling table you will write series as be (in albmrate))*/
and (a.sett_no like ltrim(@settno)+'%'  or a.sett_no like ltrim(@wsettno)+'%')) else (0) end ),0),
s.markettype,
party=(select cl_code from albmwparty where cl_code=c1.cl_code)  /* checks whether selected clcode has done trading in w which is 
settling in current settlement of  w*/
from rpt_currentsett s , client1 c1, client2 c2
where  
c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and c1.family=@statusname
group by  c1.cl_code,c1.short_name,s.sett_type,s.scrip_Cd,s.series, s.ser, s.markettype,s.tradeqty ,s.trade_no
union all
select series= (CASE when s.series in ('01','02','03','04','05')  then 'BE' else s.series end),original=s.series, s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
rate=s.marketrate,
s.markettype,
party=(select cl_code from albmwparty where cl_code=c1.cl_code) 
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
and c1.family=@statusname
group by c1.cl_code,c1.short_name,s.scrip_Cd,s.series, s.markettype,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.series,s.markettype,s.scrip_cd
end







/*
old query
if @statusid='broker'
begin
select  s.series,original=s.ser,s.scrip_cd , s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code, c1.short_name , 
rate=isnull((case markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type and s.ser=a.series
and (a.sett_no like ltrim(@settno)+'%' or a.sett_no like ltrim(@wsettno)+'%')) else (0) end ),0),
s.markettype
from rpt_currentsett s , client1 c1, client2 c2
where  
c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
group by  c1.cl_code,c1.short_name,s.sett_type,s.scrip_Cd,s.series, s.ser, s.markettype,s.tradeqty ,s.trade_no
union all
select s.series,original=s.series, s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
rate=s.marketrate,
s.markettype
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
group by c1.cl_code,c1.short_name,s.scrip_Cd,s.series, s.markettype,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.series,s.markettype,s.scrip_cd

end

if @statusid='branch'
begin
select  s.series, original=s.ser,s.scrip_cd , s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code, c1.short_name , 
rate=isnull((case markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type and s.ser=a.series
and (a.sett_no like ltrim(@settno)+'%' or a.sett_no like ltrim(@wsettno)+'%')) else (0) end ),0),
s.markettype
from rpt_currentsett s , client1 c1, client2 c2, branches b
where  
c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and b.branch_cd=@statusname
and b.short_name=c1.trader
group by  c1.cl_code,c1.short_name,s.sett_type,s.scrip_Cd,s.series, s.ser, s.markettype,s.tradeqty ,s.trade_no
union all
select s.series, original=s.series, s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),
c1.cl_code,c1.short_name , rate=s.marketrate, s.markettype
from trade4432 s,client1 c1,client2 c2 , branches b
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
and b.branch_cd=@statusname and b.short_name=c1.trader
group by c1.cl_code,c1.short_name,s.scrip_Cd,s.series, s.markettype, s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.series,s.markettype,s.scrip_cd
end


if @statusid='subbroker'
begin
select  s.series, original=s.ser, s.scrip_cd , s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code, c1.short_name , 
rate=isnull((case markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type and s.ser=a.series
and (a.sett_no like ltrim(@settno)+'%' or a.sett_no like ltrim(@wsettno)+'%')) else (0) end ),0),
s.markettype
from rpt_currentsett s , client1 c1, client2 c2, subbrokers sb
where  
c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and sb.sub_broker=c1.sub_broker
and sb.sub_broker=@statusname
group by  c1.cl_code,c1.short_name,s.sett_type,s.scrip_Cd,s.series, s.ser,s.markettype,s.tradeqty ,s.trade_no

union all

select s.series,original=s.series,s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,
c1.short_name , rate=s.marketrate, s.markettype
from trade4432 s,client1 c1,client2 c2 ,subbrokers sb
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by c1.cl_code,c1.short_name,s.scrip_Cd,s.series, s.markettype,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.series,s.markettype,s.scrip_cd
end




if @statusid='trader'
begin
select  s.series, original=s.ser, s.scrip_cd , s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code, c1.short_name , 
rate=isnull((case markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type and s.ser=a.series
and (a.sett_no like ltrim(@settno)+'%' or a.sett_no like ltrim(@wsettno)+'%')) else (0) end ),0),
s.markettype
from rpt_currentsett s , client1 c1, client2 c2
where  
c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and c1.trader=@statusname
group by  c1.cl_code,c1.short_name,s.sett_type,s.scrip_Cd,s.series,s.ser, s.markettype,s.tradeqty ,s.trade_no

union all
select s.series,original=s.series,s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,
c1.short_name , rate=s.marketrate,s.markettype
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
and c1.trader=@statusname
group by c1.cl_code,c1.short_name,s.scrip_Cd,s.series,s.markettype, s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.series,s.markettype,s.scrip_cd
end


if @statusid='client'
begin
select  s.series,original=s.ser, s.scrip_cd , s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code, c1.short_name , 
rate=isnull((case markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type and s.ser=a.series
and (a.sett_no like ltrim(@settno)+'%' or a.sett_no like ltrim(@wsettno)+'%')) else (0) end ),0),
s.markettype
from rpt_currentsett s , client1 c1, client2 c2
where  
c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and s.party_code=@statusname
group by  c1.cl_code,c1.short_name,s.sett_type,s.scrip_Cd,s.series,s.ser, s.markettype,s.tradeqty ,s.trade_no
union all
select s.series,original=s.series,s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name 
, rate=s.marketrate, s.markettype
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
and s.party_code=@statusname
group by c1.cl_code,c1.short_name,s.scrip_Cd,s.series, s.markettype,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.series,s.markettype,s.scrip_cd
end

*/

GO
