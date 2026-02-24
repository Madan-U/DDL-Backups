-- Object: PROCEDURE dbo.rpt_mtomoddlot
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mtomoddlot    Script Date: 04/27/2001 4:32:45 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomoddlot    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomoddlot    Script Date: 20-Mar-01 11:39:01 PM ******/





/****** Object:  Stored Procedure dbo.rpt_mtomoddlot    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomoddlot    Script Date: 12/27/00 8:58:56 PM ******/



/* Report : mtom
   File  : mtom_oddlot.asp
*/
/* changed by mousami  on 17/03/2001
     added family login
*/
CREATE PROCEDURE rpt_mtomoddlot
@statusid varchar(15),
@statusname varchar(25),
@code varchar(10),
@partyname varchar(21)

AS
if @statusid = 'broker'
begin
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code 
from trade4432 t,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.series= 'BE' and t.party_code like  ltrim(@code) +'%'  and  c1.short_name like ltrim(@partyname)+'%'
group by c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy 
Union all 
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code 
from settlement t,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.billno = 0 and t.series= 'BE' and t.party_code like ltrim( @code)+'%'
and  c1.short_name like ltrim(@partyname)+'%'
group by c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy 
end
if @statusid = 'subbroker'
begin
 select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code 
from trade4432 t,client1 c1,client2 c2 , subbrokers sb
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.series= 'BE' and t.party_code  like ltrim( @code)+'%'
and sb.sub_broker = @statusname and sb.sub_broker = c1.sub_broker
and  c1.short_name like ltrim(@partyname)+'%'
group by c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy 
Union all 
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code 
from settlement t,client1 c1,client2 c2 ,subbrokers sb
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.billno = 0 and t.series= 'BE' and t.party_code like ltrim( @code)+'%'
and sb.sub_broker = @statusname and sb.sub_broker = c1.sub_broker
and  c1.short_name like ltrim(@partyname)+'%'
group by c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy 
end
if @statusid = 'branch'
begin
 select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code 
from trade4432 t,client1 c1,client2 c2 , branches b
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.series= 'BE' and t.party_code like ltrim( @code)+'%'
and  b.branch_cd = @statusname and b.short_name = c1.trader
and  c1.short_name like ltrim(@partyname)+'%'
group by c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy 
Union all 
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code 
from settlement t,client1 c1,client2 c2 ,branches b
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.billno = 0 and t.series= 'BE' and t.party_code like ltrim( @code)+'%'
and  b.branch_cd = @statusname and b.short_name = c1.trader
and  c1.short_name like ltrim(@partyname)+'%'
group by c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy 
end
if @statusid = 'client'
begin
 select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code 
from trade4432 t,client1 c1,client2 c2
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.series= 'BE' and t.party_code  like ltrim( @code)+'%'
and  c1.short_name like ltrim(@partyname)+'%'
group by c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy 
Union all 
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code 
from settlement t,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.billno = 0 and t.series= 'BE' and t.party_code like ltrim( @code)+'%'
and  c1.short_name like ltrim(@partyname)+'%'
group by c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy 
end
if @statusid = 'trader'
begin
 select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code 
from trade4432 t,client1 c1,client2 c2
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.series= 'BE' and t.party_code like ltrim( @code)+'%' and c1.trader = @statusname
and  c1.short_name like ltrim(@partyname)+'%'
group by c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy 
Union all 
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code 
from settlement t,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.billno = 0 and t.series= 'BE' and t.party_code like ltrim( @code)+'%' and c1.trader = @statusname
and  c1.short_name like ltrim(@partyname)+'%'
group by c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy 
end


if @statusid = 'family'
begin
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code 
from trade4432 t,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.series= 'BE' 
and c1.family=@statusname
group by c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy 
Union all 
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code 
from settlement t,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.billno = 0 and t.series= 'BE' 
and c1.family=@statusname
group by c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy 
end

GO
