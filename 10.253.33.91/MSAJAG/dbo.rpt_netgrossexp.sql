-- Object: PROCEDURE dbo.rpt_netgrossexp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_netgrossexp    Script Date: 04/27/2001 4:32:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_netgrossexp    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_netgrossexp    Script Date: 20-Mar-01 11:39:01 PM ******/







/* report : misnews
    file : rptclient_scripsett
    finds net exposure of clients for current settlement
*/
/* changed by mousami on 06/02/2001
     added family login	
*/


CREATE PROCEDURE rpt_netgrossexp
@statusid varchar(15),
@statusname varchar(25),
@settno varchar(7),
@wsettno varchar(7)

as
if @statusid='broker'
begin
select  s.series, ser=( Case when s.sett_Type = 'P' then 'BE' else s.series end ), s.scrip_cd ,  s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name ,
rate=isnull((case s.markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type /* and s.series=a.series */
and (a.sett_no=@settno or a.sett_no=@wsettno)  )else (0) end ),0),s.markettype, s.sell_buy, source='SETT',
party=(select distinct cl_code from albmwparty where c1.cl_code=cl_code)
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and (s.sett_no=@settno or s.sett_no=@wsettno)
and (( s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')) 
or (s.sett_no=@settno and s.sett_type='l') or  (s.sett_no=@wsettno and s.sett_type='p' and s.series='01')) 
group by  c1.cl_code,c1.short_name,s.sett_type,s.markettype,s.scrip_Cd,s.series, s.sell_buy,s.tradeqty ,s.trade_no
union all
select s.series, ser= (CASE when s.series in ('01','02','03','04','05')  then 'BE' else s.series end), s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
rate=s.marketrate, markettype,s.sell_buy, source='TRD',
party=(select distinct cl_code from albmwparty where c1.cl_code=cl_code)
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code  
group by c1.cl_code,c1.short_name,s.series,s.markettype,s.scrip_Cd, s.sell_buy,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.ser,s.markettype,s.scrip_cd,s.sell_buy
end 

if @statusid='branch'
begin
select  s.series, ser=( Case when s.sett_Type = 'P' then 'BE' else s.series end ), s.scrip_cd ,  s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name ,
rate=isnull((case s.markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type /* and s.series=a.series */
and (a.sett_no=@settno or a.sett_no=@wsettno)  )else (0) end ),0),s.markettype, s.sell_buy,
party=(select distinct cl_code from albmwparty where c1.cl_code=cl_code)
from settlement s,client1 c1,client2 c2 , branches b
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and (s.sett_no=@settno or s.sett_no=@wsettno)
and (( s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')) 
or (s.sett_no=@settno and s.sett_type='l') or  (s.sett_no=@wsettno and s.sett_type='p' and s.series='01')) 
and b.branch_cd=@statusname and b.short_name=c1.trader
group by  c1.cl_code,c1.short_name,s.sett_type,s.markettype,s.scrip_Cd,s.series, s.sell_buy,s.tradeqty ,s.trade_no
union all
select s.series, ser= (CASE when s.series in ('01','02','03','04','05')  then 'BE' else s.series end), s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
 rate=s.marketrate, markettype,s.sell_buy,
party=(select distinct cl_code from albmwparty where c1.cl_code=cl_code)
from trade4432 s,client1 c1,client2 c2 , branches b 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code  
and b.branch_cd=@statusname and b.short_name=c1.trader
group by c1.cl_code,c1.short_name,s.series,s.markettype,s.scrip_Cd, s.sell_buy,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.ser,s.markettype,s.scrip_cd,s.sell_buy
end


if @statusid='trader'
begin
select  s.series, ser=( Case when s.sett_Type = 'P' then 'BE' else s.series end ), s.scrip_cd ,  s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name ,
rate=isnull((case s.markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type /* and s.series=a.series */
and (a.sett_no=@settno or a.sett_no=@wsettno)  )else (0) end ),0),s.markettype, s.sell_buy,
party=(select distinct cl_code from albmwparty where c1.cl_code=cl_code)
from settlement s,client1 c1,client2 c2  
where c1.trader=@statusname
and c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and (s.sett_no=@settno or s.sett_no=@wsettno)
and (( s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')) 
or (s.sett_no=@settno and s.sett_type='l') or  (s.sett_no=@wsettno and s.sett_type='p' and s.series='01')) 
group by  c1.cl_code,c1.short_name,s.sett_type,s.markettype,s.scrip_Cd,s.series, s.sell_buy,s.tradeqty ,s.trade_no
union all
select s.series,ser= (CASE when s.series in ('01','02','03','04','05')  then 'BE' else s.series end),s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
rate=s.marketrate, markettype,s.sell_buy,
party=(select distinct cl_code from albmwparty where c1.cl_code=cl_code)
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code  
and c1.trader=@statusname
group by c1.cl_code,c1.short_name,s.series,s.markettype,s.scrip_Cd, s.sell_buy,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.ser,s.markettype,s.scrip_cd,s.sell_buy
end 


if @statusid='subbroker'
begin
select  s.series, ser=( Case when s.sett_Type = 'P' then 'BE' else s.series end ),s.scrip_cd ,  s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name ,
rate=isnull((case s.markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type /* and s.series=a.series */
and (a.sett_no=@settno or a.sett_no=@wsettno)  )else (0) end ),0),s.markettype, s.sell_buy,
party=(select distinct cl_code from albmwparty where c1.cl_code=cl_code)
from settlement s,client1 c1,client2 c2 , subbrokers sb
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and (s.sett_no=@settno or s.sett_no=@wsettno)
and (( s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')) 
or (s.sett_no=@settno and s.sett_type='l') or  (s.sett_no=@wsettno and s.sett_type='p' and s.series='01')) 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by  c1.cl_code,c1.short_name,s.sett_type,s.markettype,s.scrip_Cd,s.series, s.sell_buy,s.tradeqty ,s.trade_no
union all
select s.series, ser= (CASE when s.series in ('01','02','03','04','05')  then 'BE' else s.series end),s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
 rate=s.marketrate, markettype,s.sell_buy,
party=(select distinct cl_code from albmwparty where c1.cl_code=cl_code)
from trade4432 s,client1 c1,client2 c2 ,subbrokers sb
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code  
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by c1.cl_code,c1.short_name,s.series,s.markettype,s.scrip_Cd, s.sell_buy,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.ser,s.markettype,s.scrip_cd,s.sell_buy
end 

if @statusid='client'
begin
select  s.series, ser=( Case when s.sett_Type = 'P' then 'BE' else s.series end ),s.scrip_cd ,  s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name ,
rate=isnull((case s.markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type /* and s.series=a.series */
and (a.sett_no=@settno or a.sett_no=@wsettno)  )else (0) end ),0),s.markettype, s.sell_buy,
party=(select distinct cl_code from albmwparty where c1.cl_code=cl_code)
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and (s.sett_no=@settno or s.sett_no=@wsettno)
and (( s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')) 
or (s.sett_no=@settno and s.sett_type='l') or  (s.sett_no=@wsettno and s.sett_type='p' and s.series='01')) 
and s.party_code=@statusname
group by  c1.cl_code,c1.short_name,s.sett_type,s.markettype,s.scrip_Cd,s.series, s.sell_buy,s.tradeqty ,s.trade_no
union all
select s.series, ser= (CASE when s.series in ('01','02','03','04','05')  then 'BE' else s.series end),s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
 rate=s.marketrate, markettype,s.sell_buy,
party=(select distinct cl_code from albmwparty where c1.cl_code=cl_code)
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code  
and s.party_code=@statusname
group by c1.cl_code,c1.short_name,s.series,s.markettype,s.scrip_Cd, s.sell_buy,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.ser,s.markettype,s.scrip_cd,s.sell_buy
end 



if @statusid='family'
begin
select  s.series, ser=( Case when s.sett_Type = 'P' then 'BE' else s.series end ), s.scrip_cd ,  s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name ,
rate=isnull((case s.markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type /* and s.series=a.series */
and (a.sett_no=@settno or a.sett_no=@wsettno)  )else (0) end ),0),s.markettype, s.sell_buy, source='SETT',
party=(select distinct cl_code from albmwparty where c1.cl_code=cl_code)
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and (s.sett_no=@settno or s.sett_no=@wsettno)
and (( s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')) 
or (s.sett_no=@settno and s.sett_type='l') or  (s.sett_no=@wsettno and s.sett_type='p' and s.series='01')) 
and c1.family=@statusname
group by  c1.cl_code,c1.short_name,s.sett_type,s.markettype,s.scrip_Cd,s.series, s.sell_buy,s.tradeqty ,s.trade_no
union all
select s.series, ser= (CASE when s.series in ('01','02','03','04','05')  then 'BE' else s.series end), s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
rate=s.marketrate, markettype,s.sell_buy, source='TRD',
party=(select distinct cl_code from albmwparty where c1.cl_code=cl_code)
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code  
and c1.family=@statusname
group by c1.cl_code,c1.short_name,s.series,s.markettype,s.scrip_Cd, s.sell_buy,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.ser,s.markettype,s.scrip_cd,s.sell_buy
end 



/*
CREATE PROCEDURE rpt_netgrossexp
@statusid varchar(15),
@statusname varchar(25),
@settno varchar(7)

as
if @statusid='broker'
begin
select  s.series, s.scrip_cd ,  s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name ,
rate=isnull((case s.markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type and s.series=a.series
and a.sett_no=@settno) else (0) end ),0),s.markettype, s.sell_buy
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and s.sett_no=@settno
and (( s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')) 
or (s.sett_no=@settno and s.sett_type='l')) 
group by  c1.cl_code,c1.short_name,s.sett_type,s.markettype,s.scrip_Cd,s.series, s.sell_buy,s.tradeqty ,s.trade_no
union all
select s.series,s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
 rate=s.marketrate, markettype,s.sell_buy
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code  
group by c1.cl_code,c1.short_name,s.series,s.markettype,s.scrip_Cd, s.sell_buy,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.series,s.markettype,s.scrip_cd,s.sell_buy
end 

if @statusid='branch'
begin
select  s.series, s.scrip_cd ,  s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name ,
rate=isnull((case s.markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type and s.series=a.series
and a.sett_no=@settno) else (0) end ),0),s.markettype,s.sell_buy
from settlement s,client1 c1,client2 c2 ,branches b
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and s.sett_no=@settno
and (( s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')) 
or (s.sett_no=@settno and s.sett_type='l')) 
and b.branch_cd=@statusname and b.short_name=c1.trader
group by  c1.cl_code,c1.short_name,s.sett_type,s.markettype,s.scrip_Cd,s.series, s.sell_buy,s.tradeqty ,s.trade_no
union all
select s.series,s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
 rate=s.marketrate, markettype,s.sell_buy
from trade4432 s,client1 c1,client2 c2 , branches b
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code  
and b.branch_cd=@statusname and b.short_name=c1.trader
group by c1.cl_code,c1.short_name,s.series,s.markettype,s.scrip_Cd, s.sell_buy,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.series,s.markettype,s.scrip_cd,s.sell_buy
end


if @statusid='trader'
begin
select  s.series, s.scrip_cd ,  s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name ,
rate=isnull((case s.markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type and s.series=a.series
and a.sett_no=@settno) else (0) end ),0),s.markettype,s.sell_buy
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and s.sett_no=@settno
and (( s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')) 
or (s.sett_no=@settno and s.sett_type='l')) 
and c1.trader=@statusname
group by  c1.cl_code,c1.short_name,s.sett_type,s.markettype,s.scrip_Cd,s.series, s.sell_buy,s.tradeqty ,s.trade_no
union all
select s.series,s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
 rate=s.marketrate, markettype,s.sell_buy
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code  
and c1.trader=@statusname
group by c1.cl_code,c1.short_name,s.series,s.markettype,s.scrip_Cd, s.sell_buy,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.series,s.markettype,s.scrip_cd,s.sell_buy
end 


if @statusid='subbroker'
begin
select  s.series, s.scrip_cd ,  s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name ,
rate=isnull((case s.markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type and s.series=a.series
and a.sett_no=@settno) else (0) end ),0),s.markettype,s.sell_buy
from settlement s,client1 c1,client2 c2 ,subbrokers sb
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and s.sett_no=@settno
and (( s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')) 
or (s.sett_no=@settno and s.sett_type='l')) 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by  c1.cl_code,c1.short_name,s.sett_type,s.markettype,s.scrip_Cd,s.series,s.sell_buy, s.tradeqty ,s.trade_no
union all
select s.series,s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
 rate=s.marketrate, markettype,s.sell_buy
from trade4432 s,client1 c1,client2 c2 ,subbrokers sb
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code  
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by c1.cl_code,c1.short_name,s.series,s.markettype,s.scrip_Cd, s.sell_buy,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.series,s.markettype,s.scrip_cd,s.sell_buy
end 

if @statusid='client'
begin
select  s.series, s.scrip_cd ,  s.trade_no, s.tradeqty, grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name ,
rate=isnull((case s.markettype when '3' then (select distinct rate from albmrate a 
where a.scrip_cd=s.scrip_Cd and a.sett_type=s.sett_type and s.series=a.series
and a.sett_no=@settno) else (0) end ),0),s.markettype,s.sell_buy
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and s.sett_no=@settno
and (( s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')) 
or (s.sett_no=@settno and s.sett_type='l')) 
and s.party_code=@statusname
group by  c1.cl_code,c1.short_name,s.sett_type,s.markettype,s.scrip_Cd,s.series, s.sell_buy,s.tradeqty ,s.trade_no
union all
select s.series,s.scrip_Cd,  s.trade_no , s.tradeqty, grossexp=sum(s.tradeqty* s.marketrate),c1.cl_code,c1.short_name ,
 rate=s.marketrate, markettype,s.sell_buy
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code  
and s.party_code=@statusname
group by c1.cl_code,c1.short_name,s.series,s.markettype,s.scrip_Cd, s.sell_buy,s.marketrate, s.tradeqty,s.trade_no
order by c1.short_name,c1.cl_code,s.series,s.markettype,s.scrip_cd,s.sell_buy
end 

*/

GO
