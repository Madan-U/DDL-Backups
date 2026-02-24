-- Object: PROCEDURE dbo.rpt_igrossexptoday
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_igrossexptoday    Script Date: 04/27/2001 4:32:43 PM ******/

/****** Object:  Stored Procedure dbo.rpt_igrossexptoday    Script Date: 3/21/01 12:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_igrossexptoday    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_igrossexptoday    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_igrossexptoday    Script Date: 12/27/00 8:58:54 PM ******/

/* institutional trades */
/* report : gross exposure report
    file : grossexptrd.asp
    displays gross exposure of client or clients for today's date   for institution 
 */
CREATE PROCEDURE rpt_igrossexptoday
@statusid varchar(15),
@statusname varchar(25),
@shortname varchar(21),
@scripcd varchar(12),
@partycode varchar(10),
@trader varchar(15),
@pcode varchar(15)
AS
if @statusid = 'broker' 
begin
select c1.short_name,t4.party_code,t4.scrip_cd,t4.series,sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and 
c1.short_name like ltrim(@shortname)+'%' 
and t4.scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%'
and c1.trader like ltrim(@trader)+'%' 
and series not in ('AE','BE','N1') 
and t4.partipantcode like ltrim(@pcode)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy
end
if @statusid = 'branch' 
begin
select c1.short_name,t4.party_code,t4.scrip_cd,t4.series,sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade t4,client1 c1,client2 c2 , branches b
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and 
c1.short_name like ltrim(@shortname)+'%' 
and t4.scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%'
and c1.trader like ltrim(@trader)+'%' 
and series not in ('AE','BE','N1') 
and b.branch_cd=@statusname and b.short_name=c1.trader
and t4.partipantcode like ltrim(@pcode)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy
end
if @statusid = 'trader' 
begin
select c1.short_name,t4.party_code,t4.scrip_cd,t4.series,sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and 
c1.short_name like ltrim(@shortname)+'%' 
and t4.scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%'
and c1.trader  = @statusname 
and series not in ('AE','BE','N1') 
and t4.partipantcode like ltrim(@pcode)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy
end 
if @statusid = 'subbroker' 
begin
select c1.short_name,t4.party_code,t4.scrip_cd,t4.series,sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade t4,client1 c1,client2 c2 , subbrokers sb
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and 
c1.short_name like ltrim(@shortname)+'%' 
and t4.scrip_cd like ltrim(@scripcd)+'%' and t4.party_code like ltrim(@partycode)+'%'
and c1.trader like ltrim(@trader)+'%' 
and series not in ('AE','BE','N1') 
and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
and t4.partipantcode like ltrim(@pcode)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy
end 
if @statusid = 'client' 
begin
select c1.short_name,t4.party_code,t4.scrip_cd,t4.series,sum(t4.tradeqty),
Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy 
from trade t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code  
and t4.scrip_cd like ltrim(@scripcd)+'%' and t4.party_code =@statusname
and series not in ('AE','BE','N1') 
and t4.partipantcode like ltrim(@pcode)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy
end

GO
