-- Object: PROCEDURE dbo.rpt_grossexptoday2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_grossexptoday2    Script Date: 04/27/2001 4:32:42 PM ******/


/****** Object:  Stored Procedure dbo.rpt_grossexptoday2    Script Date: 04/21/2001 6:05:25 PM ******/

/****** Object:  Stored Procedure dbo.rpt_grossexptoday2    Script Date: 3/21/01 12:50:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_grossexptoday2    Script Date: 20-Mar-01 11:38:58 PM ******/






/* report : gross exposure report
    file : grossexptrd.asp
    displays gross exposure of client or clients for today's date   
 */
/* changed by mousami  on  05/03/2001
     added family login */

CREATE PROCEDURE rpt_grossexptoday2
@statusid varchar(15),
@statusname varchar(25),
@partyname varchar(21),
@scripcd varchar(12),
@partycode varchar(10),
@trader varchar(15)
AS
if @statusid = 'broker' 
begin
select c1.short_name,t4.party_code,t4.scrip_cd,t4.series,
sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy
from trade4432 t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and 
c1.short_name like ltrim(@partyname)+'%' and t4.scrip_cd like ltrim(@scripcd)+'%' 
and t4.party_code like ltrim(@partycode)+'%'
and c1.trader like ltrim(@trader)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy
order by t4.party_code
end
if @statusid = 'branch' 
begin
select c1.short_name,t4.party_code,t4.scrip_cd,t4.series,
sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy
from trade4432 t4,client1 c1,client2 c2, branches b
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and 
c1.short_name like ltrim(@partyname)+'%' and t4.scrip_cd like ltrim(@scripcd)+'%' 
and t4.party_code like ltrim(@partycode)+'%'
and b.branch_cd=@statusname and b.short_name=c1.trader
and c1.trader like ltrim(@trader)+'%'
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy
order by t4.party_code
end
if @statusid = 'trader' 
begin
select c1.short_name,t4.party_code,t4.scrip_cd,t4.series,
sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy
from trade4432 t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and 
c1.short_name like ltrim(@partyname)+'%' and t4.scrip_cd like ltrim(@scripcd)+'%' 
and t4.party_code like ltrim(@partycode)+'%'
and c1.trader=@statusname
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy
order by t4.party_code
end 
if @statusid = 'subbroker' 
begin
select c1.short_name,t4.party_code,t4.scrip_cd,t4.series,
sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy
from trade4432 t4,client1 c1,client2 c2, subbrokers sb
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and 
c1.short_name like ltrim(@partyname)+'%' and t4.scrip_cd like ltrim(@scripcd)+'%' 
and t4.party_code like ltrim(@partycode)+'%' and
sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy
order by t4.party_code
end 
if @statusid = 'client' 
begin
select c1.short_name,t4.party_code,t4.scrip_cd,t4.series,
sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy
from trade4432 t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and t4.scrip_cd like ltrim(@scripcd)+'%' 
and t4.party_code =@statusname
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy
order by t4.party_code
end 

if @statusid = 'family' 
begin
select c1.short_name,t4.party_code,t4.scrip_cd,t4.series,
sum(t4.tradeqty),Amount=sum(t4.tradeqty*t4.marketrate),t4.sell_buy
from trade4432 t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code and 
c1.short_name like ltrim(@partyname)+'%' and t4.scrip_cd like ltrim(@scripcd)+'%' 
and t4.party_code like ltrim(@partycode)+'%'
and c1.family=@statusname
group by c1.short_name,t4.party_code,t4.scrip_cd,t4.series,t4.sell_buy
order by t4.party_code
end

GO
