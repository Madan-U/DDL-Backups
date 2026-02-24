-- Object: PROCEDURE dbo.rpt_mtomallclients
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mtomallclients    Script Date: 04/27/2001 4:32:45 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomallclients    Script Date: 3/21/01 12:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomallclients    Script Date: 20-Mar-01 11:39:00 PM ******/


/****** Object:  Stored Procedure dbo.rpt_mtomallclients    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomallclients    Script Date: 12/27/00 8:58:55 PM ******/

/* Report : mtom
   File : allclients.asp
*/
CREATE PROCEDURE rpt_mtomallclients
@statusid varchar(15),
@statusname varchar(25),
@code varchar(10)
AS
if @statusid = 'broker'
begin
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,c2.exposure_lim,c2.Cl_Code 
from trade4432 t,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.series= 'BE' and t.party_code like ltrim(@code)+'%' 
group by c1.short_name,t.party_code,c2.Cl_Code,t.scrip_cd ,t.series,
t.sell_buy,c2.exposure_lim 
Union all 
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,c2.exposure_lim,c2.Cl_Code 
from settlement t,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.series= 'BE' and t.party_code like ltrim(@code)+'%' and t.billno = 0 
group by c1.short_name,t.party_code,c2.Cl_Code,t.scrip_cd ,t.series,
t.sell_buy,c2.exposure_lim 
end 
if @statusid = 'subbroker'
begin
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,c2.exposure_lim,c2.Cl_Code 
from trade4432 t,client1 c1,client2 c2 , subbrokers sb
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.series= 'BE' and t.party_code like ltrim(@code)+'%' 
and sb.sub_Broker = @statusname and sb.sub_broker = c1.sub_broker
group by c1.short_name,t.party_code,c2.Cl_Code,t.scrip_cd ,t.series,
t.sell_buy,c2.exposure_lim 
Union all 
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,c2.exposure_lim,c2.Cl_Code 
from settlement t,client1 c1,client2 c2 , subbrokers sb
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.series= 'BE' and t.party_code like ltrim(@code)+'%' and t.billno = 0 
and sb.sub_Broker = @statusname and sb.sub_broker = c1.sub_broker
group by c1.short_name,t.party_code,c2.Cl_Code,t.scrip_cd ,t.series,
t.sell_buy,c2.exposure_lim 
end
if @statusid = 'branch'
begin
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,c2.exposure_lim,c2.Cl_Code 
from trade4432 t,client1 c1,client2 c2 ,branches b
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.series= 'BE' and t.party_code like ltrim(@code)+'%' 
and b.branch_cd = @statusname and b.short_name = c1.trader
group by c1.short_name,t.party_code,c2.Cl_Code,t.scrip_cd ,t.series,
t.sell_buy,c2.exposure_lim 
Union all 
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,c2.exposure_lim,c2.Cl_Code 
from settlement t,client1 c1,client2 c2 , branches b
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.series= 'BE' and t.party_code like ltrim(@code)+'%' and t.billno = 0 
and b.branch_cd = @statusname and b.short_name = c1.trader
group by c1.short_name,t.party_code,c2.Cl_Code,t.scrip_cd ,t.series,
t.sell_buy,c2.exposure_lim 
end 
if @statusid = 'client'
begin
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,c2.exposure_lim,c2.Cl_Code 
from trade4432 t,client1 c1,client2 c2
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.series= 'BE' and t.party_code = @statusname
group by c1.short_name,t.party_code,c2.Cl_Code,t.scrip_cd ,t.series,
t.sell_buy,c2.exposure_lim 
Union all 
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,c2.exposure_lim,c2.Cl_Code 
from settlement t,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.series= 'BE' and t.party_code = @statusname and t.billno = 0 
group by c1.short_name,t.party_code,c2.Cl_Code,t.scrip_cd ,t.series,
t.sell_buy,c2.exposure_lim 
end
if @statusid = 'trader'
begin
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,c2.exposure_lim,c2.Cl_Code 
from trade4432 t,client1 c1,client2 c2
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.series= 'BE' and t.party_code like ltrim(@code)+'%' 
and c1.trader = @statusname
group by c1.short_name,t.party_code,c2.Cl_Code,t.scrip_cd ,t.series,
t.sell_buy,c2.exposure_lim 
Union all 
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,c2.exposure_lim,c2.Cl_Code 
from settlement t,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code 
and t.series= 'BE' and t.party_code like ltrim(@code)+'%' and t.billno = 0 
and c1.trader = @statusname
group by c1.short_name,t.party_code,c2.Cl_Code,t.scrip_cd ,t.series,
t.sell_buy,c2.exposure_lim 
end

GO
