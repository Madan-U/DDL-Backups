-- Object: PROCEDURE dbo.rpt_mtomfill
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mtomfill    Script Date: 04/27/2001 4:32:45 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomfill    Script Date: 3/21/01 12:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomfill    Script Date: 20-Mar-01 11:39:00 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomfill    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomfill    Script Date: 12/27/00 8:58:55 PM ******/

/* report : mtomreport
   file : mtomreport.asp */
/* displays output to show the mtom reports*/
CREATE PROCEDURE rpt_mtomfill
@statusid varchar(15),
@statusname varchar(25),
@partycode varchar(10),
@partyname varchar(21)
AS
if @statusid='broker' 
begin
if ( select Count(*) from settlement where sauda_date like left(convert(varchar,getdate(),109),11)+'%') > 0 
begin
select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.amount),s.sell_buy,c1.short_name,c2.party_code,c1.cl_code 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
and s.billno = '0' and s.sett_type='N' 
and s.party_code like ltrim(@partycode)+'%' 
and c1.short_name like ltrim(@partyname)+'%'
group by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
end
else
begin
 select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.tradeqty*MarketRate),s.sell_buy,c1.short_name,c2.party_code,c1.cl_code 
 from trade4432 s,client1 c1,client2 c2 
 where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
 and s.party_code like ltrim(@partycode) + '%' 
 and c1.short_name like ltrim(@partyname)+'%'
 group by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
 union all
 select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.amount),s.sell_buy,c1.short_name,c2.party_code,c1.cl_code 
 from settlement s,client1 c1,client2 c2 
 where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
 and s.billno = '0' and s.sett_type='N' 
 and s.party_code like ltrim(@partycode) +'%' 
 and c1.short_name like ltrim(@partyname)+'%'
 group by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
 order by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
end
end
if @statusid='branch' 
begin
if ( select Count(*) from settlement where sauda_date  like left(convert(varchar,getdate(),109),11)+'%' ) > 0 
begin
select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.amount),s.sell_buy,c1.short_name,c2.party_code,c1.cl_code 
from settlement s,client1 c1,client2 c2 , branches b
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
and s.billno = '0' and s.sett_type='N' 
and s.party_code like ltrim(@partycode)+'%' 
and c1.short_name like ltrim(@partyname)+'%'
and b.branch_cd=@statusname and b.short_name=c1.trader
group by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
end
else
begin
 select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.tradeqty*MarketRate),s.sell_buy,c1.short_name,c2.party_code,c1.cl_code 
 from trade4432 s,client1 c1,client2 c2 ,branches b
 where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
 and c1.short_name like ltrim(@partyname)+'%'
 and s.party_code like ltrim(@partycode) + '%' 
 and b.branch_cd=@statusname and b.short_name=c1.trader
 group by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
 union all
 select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.amount),s.sell_buy,c1.short_name,c2.party_code,c1.cl_code 
 from settlement s,client1 c1,client2 c2 ,branches b
 where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
 and s.billno = '0' and s.sett_type='N' 
 and s.party_code like ltrim(@partycode) +'%' 
 and c1.short_name like ltrim(@partyname)+'%'
 and b.branch_cd=@statusname and b.short_name=c1.trader
 group by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
 order by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
end
end
if @statusid='subbroker' 
begin
if ( select Count(*) from settlement where sauda_date  like left(convert(varchar,getdate(),109),11)+'%' ) > 0 
begin
select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.amount),s.sell_buy,c1.short_name,c2.party_code,c1.cl_code 
from settlement s,client1 c1,client2 c2 , subbrokers  sb
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
and s.billno = '0' and s.sett_type='N' 
and s.party_code like ltrim(@partycode)+'%' 
and c1.short_name like ltrim(@partyname)+'%'
and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
group by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
end
else
begin
 select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.tradeqty*MarketRate),s.sell_buy,c1.short_name,c2.party_code,c1.cl_code 
 from trade4432 s,client1 c1,client2 c2 ,subbrokers sb
 where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
 and c1.short_name like ltrim(@partyname)+'%'
 and s.party_code like ltrim(@partycode) + '%' 
 and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
 group by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
 union all
 select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.amount),s.sell_buy,c1.short_name,c2.party_code,c1.cl_code 
 from settlement s,client1 c1,client2 c2 ,subbrokers sb
 where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
 and s.billno = '0' and s.sett_type='N' 
 and s.party_code like ltrim(@partycode) +'%' 
 and c1.short_name like ltrim(@partyname)+'%'
 and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
 group by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
 order by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
end
end
if @statusid='trader' 
begin
if ( select Count(*) from settlement where sauda_date  like left(convert(varchar,getdate(),109),11)+'%' ) > 0 
begin
select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.amount),s.sell_buy,c1.short_name,c2.party_code,c1.cl_code 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
and s.billno = '0' and s.sett_type='N' 
and s.party_code like ltrim(@partycode)+'%' 
and c1.short_name like ltrim(@partyname)+'%'
and c1.trader=@statusname
group by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
end
else
begin
 select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.tradeqty*MarketRate),s.sell_buy,c1.short_name,c2.party_code,c1.cl_code 
 from trade4432 s,client1 c1,client2 c2 
 where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
 and s.party_code like ltrim(@partycode) + '%' 
 and c1.short_name like ltrim(@partyname)+'%'
 and c1.trader=@statusname
 group by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
 union all
 select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.amount),s.sell_buy,c1.short_name,c2.party_code,c1.cl_code 
 from settlement s,client1 c1,client2 c2 
 where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
 and s.billno = '0' and s.sett_type='N' 
 and s.party_code like ltrim(@partycode) +'%' 
 and c1.short_name like ltrim(@partyname)+'%'
 and c1.trader=@statusname
 group by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
 order by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
end
end
if @statusid='client' 
begin
if ( select Count(*) from settlement where sauda_date  like left(convert(varchar,getdate(),109),11)+'%' ) > 0 
begin
select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.amount),s.sell_buy,c1.short_name,c2.party_code,c1.cl_code 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
and s.billno = '0' and s.sett_type='N' 
and s.party_code =@statusname 
group by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
end
else
begin
 select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.tradeqty*MarketRate),s.sell_buy,c1.short_name,c2.party_code,c1.cl_code 
 from trade4432 s,client1 c1,client2 c2 
 where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
 and s.party_code =@statusname 
 group by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
 union all
 select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.amount),s.sell_buy,c1.short_name,c2.party_code,c1.cl_code 
 from settlement s,client1 c1,client2 c2 
 where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
 and s.billno = '0' and s.sett_type='N' 
 and s.party_code =@statusname 
 group by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
 order by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy 
end
end

GO
