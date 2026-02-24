-- Object: PROCEDURE dbo.newrpt_netgrossexpo
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.newrpt_netgrossexpo    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.newrpt_netgrossexpo    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.newrpt_netgrossexpo    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.newrpt_netgrossexpo    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.newrpt_netgrossexpo    Script Date: 12/27/00 8:58:52 PM ******/

/* report : misnews
   file: topclient_scrisett.asp
*/
/* shows netexposure of all clients for current settlement plus today's trading */
CREATE PROCEDURE newrpt_netgrossexpo
@statusid varchar(15),
@statusname varchar(25),
@settno varchar (7)
as
if @statusid='broker'
begin
select s.series,s.sell_buy,grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')
and s.sett_no=@settno
group by s.sett_type,c1.cl_code,c1.short_name,s.sell_buy,s.series
union
select s.series,s.sell_buy,grossexp=sum(s.tradeqty*s.marketrate),c1.cl_code,c1.short_name 
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
group by c1.cl_code,c1.short_name,s.sell_buy,s.series
order by c1.short_name,s.series,s.sell_buy
end
if @statusid='branch'
begin
select s.series,s.sell_buy,grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name 
from settlement s,client1 c1,client2 c2 , branches b
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')
and s.sett_no=@settno
and b.branch_cd=@statusname and b.short_name=c1.trader
group by s.sett_type,c1.cl_code,c1.short_name,s.sell_buy,s.series
union
select s.series,s.sell_buy,grossexp=sum(s.tradeqty*s.marketrate),c1.cl_code,c1.short_name 
from trade4432 s,client1 c1,client2 c2 , branches b
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and b.branch_cd=@statusname and b.short_name=c1.trader
group by c1.cl_code,c1.short_name,s.sell_buy,s.series
order by c1.short_name,s.series,s.sell_buy
end
if @statusid='subbroker'
begin
select s.series,s.sell_buy,grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name 
from settlement s,client1 c1,client2 c2 , subbrokers sb
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')
and s.sett_no=@settno
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by s.sett_type,c1.cl_code,c1.short_name,s.sell_buy,s.series
union
select s.series,s.sell_buy,grossexp=sum(s.tradeqty*s.marketrate),c1.cl_code,c1.short_name 
from trade4432 s,client1 c1,client2 c2 , subbrokers sb
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by c1.cl_code,c1.short_name,s.sell_buy,s.series
order by c1.short_name,s.series,s.sell_buy
end
if @statusid='trader'
begin
select s.series,s.sell_buy,grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')
and s.sett_no=@settno
and c1.trader=@statusname
group by s.sett_type,c1.cl_code,c1.short_name,s.sell_buy,s.series
union
select s.series,s.sell_buy,grossexp=sum(s.tradeqty*s.marketrate),c1.cl_code,c1.short_name 
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and c1.trader=@statusname
group by c1.cl_code,c1.short_name,s.sell_buy,s.series
order by c1.short_name,s.series,s.sell_buy
end
if @statusid='client'
begin
select s.series,s.sell_buy,grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.billno = '0' and (s.sett_type='N' or s.sett_type='W' or s.sett_type='M')
and s.sett_no=@settno
and s.party_code=@statusname
group by s.sett_type,c1.cl_code,c1.short_name,s.sell_buy,s.series
union
select s.series,s.sell_buy,grossexp=sum(s.tradeqty*s.marketrate),c1.cl_code,c1.short_name 
from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and s.party_code=@statusname
group by c1.cl_code,c1.short_name,s.sell_buy,s.series
order by c1.short_name,s.series,s.sell_buy
end

GO
