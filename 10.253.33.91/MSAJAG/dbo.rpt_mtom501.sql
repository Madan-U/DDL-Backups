-- Object: PROCEDURE dbo.rpt_mtom501
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mtom501    Script Date: 04/27/2001 4:32:45 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtom501    Script Date: 3/21/01 12:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtom501    Script Date: 20-Mar-01 11:39:00 PM ******/

/* Report : mtom
   File : mtom50.asp 
changed by bhushan on 6 march 2001 added exposure limit according to the client3 table
*/
CREATE PROCEDURE rpt_mtom501
@statusid varchar(15),
@statusname varchar(25),
@code varchar(10)
AS
if @statusid = 'broker'
begin
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,exposure_lim = convert(float,
                IsNull((Select (Margin*NoOfTimes) from Client3 Where Client3.Cl_Code = C2.Cl_code 
                and Client3.Party_code = C2.Party_code and markettype = 'CAPITAL' and Exchange = 'NSE'),
                c2.exposure_lim))
from trade4432 t,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code and t.series= 'BE' 
and t.party_code like ltrim(@code)+'%' and c2.exposure_lim <> 0 
group by c1.cl_code,c2.cl_code,c2.party_code,c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy,c2.exposure_lim
Union all 
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,exposure_lim = convert(float,
                IsNull((Select (Margin*NoOfTimes) from Client3 Where Client3.Cl_Code = C2.Cl_code 
                and Client3.Party_code = C2.Party_code and markettype = 'CAPITAL' and Exchange = 'NSE'),
                c2.exposure_lim))

from settlement t,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code and t.series= 'BE' 
and t.party_code like ltrim(@code)+'%' and t.billno = 0 and c2.exposure_lim <> 0 
group by c1.cl_code,c2.cl_code,c2.party_code,c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy,c2.exposure_lim

end
if @statusid = 'subbroker'
begin
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,exposure_lim = convert(float,
                IsNull((Select (Margin*NoOfTimes) from Client3 Where Client3.Cl_Code = C2.Cl_code 
                and Client3.Party_code = C2.Party_code and markettype = 'CAPITAL' and Exchange = 'NSE'),
                c2.exposure_lim))
from trade4432 t,client1 c1,client2 c2 , subbrokers sb
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code and t.series= 'BE' 
and t.party_code like ltrim(@code)+'%' and c2.exposure_lim <> 0 
and sb.sub_broker = @statusname and sb.sub_broker = c1.sub_broker
group by c1.cl_code,c2.cl_code,c2.party_code,c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy,c2.exposure_lim
Union all 
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,exposure_lim = convert(float,
                IsNull((Select (Margin*NoOfTimes) from Client3 Where Client3.Cl_Code = C2.Cl_code 
                and Client3.Party_code = C2.Party_code and markettype = 'CAPITAL' and Exchange = 'NSE'),
                c2.exposure_lim))
from settlement t,client1 c1,client2 c2 , subbrokers sb
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code and t.series= 'BE' 
and t.party_code like ltrim(@code)+'%' and t.billno = 0 and c2.exposure_lim <> 0 
and sb.sub_broker = @statusname and sb.sub_broker = c1.sub_brokergroup by c1.cl_code,c2.cl_code,c2.party_code,c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy,c2.exposure_lim

end
if @statusid = 'branch'
begin
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,exposure_lim = convert(float,
                IsNull((Select (Margin*NoOfTimes) from Client3 Where Client3.Cl_Code = C2.Cl_code 
                and Client3.Party_code = C2.Party_code and markettype = 'CAPITAL' and Exchange = 'NSE'),
                c2.exposure_lim))
from trade4432 t,client1 c1,client2 c2 , branches b
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code and t.series= 'BE' 
and t.party_code like ltrim(@code)+'%' and c2.exposure_lim <> 0 
and b.branch_cd = @statusname and b.short_name = c1.trader
group by c1.cl_code,c2.cl_code,c2.party_code,c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy,c2.exposure_lim
Union all 
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,exposure_lim = convert(float,
                IsNull((Select (Margin*NoOfTimes) from Client3 Where Client3.Cl_Code = C2.Cl_code 
                and Client3.Party_code = C2.Party_code and markettype = 'CAPITAL' and Exchange = 'NSE'),
                c2.exposure_lim))
from settlement t,client1 c1,client2 c2 , branches b
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code and t.series= 'BE' 
and t.party_code like ltrim(@code)+'%' and t.billno = 0 and c2.exposure_lim <> 0 
and b.branch_cd = @statusname and b.short_name = c1.trader
group by c1.cl_code,c2.cl_code,c2.party_code,c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy,c2.exposure_lim

end
if @statusid = 'client'
begin
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,exposure_lim = convert(float,
                IsNull((Select (Margin*NoOfTimes) from Client3 Where Client3.Cl_Code = C2.Cl_code 
                and Client3.Party_code = C2.Party_code and markettype = 'CAPITAL' and Exchange = 'NSE'),
                c2.exposure_lim))
from trade4432 t,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code and t.series= 'BE' 
and t.party_code = @statusname and c2.exposure_lim <> 0 
group by c1.cl_code,c2.cl_code,c2.party_code,c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy,c2.exposure_lim

Union all 
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,exposure_lim = convert(float,
                IsNull((Select (Margin*NoOfTimes) from Client3 Where Client3.Cl_Code = C2.Cl_code 
                and Client3.Party_code = C2.Party_code and markettype = 'CAPITAL' and Exchange = 'NSE'),
                c2.exposure_lim))
from settlement t,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code and t.series= 'BE' 
and t.party_code =@statusname and t.billno = 0 and c2.exposure_lim <> 0 
group by c1.cl_code,c2.cl_code,c2.party_code,c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy,c2.exposure_lim

end
if @statusid = 'trader'
begin
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,exposure_lim = convert(float,
                IsNull((Select (Margin*NoOfTimes) from Client3 Where Client3.Cl_Code = C2.Cl_code 
                and Client3.Party_code = C2.Party_code and markettype = 'CAPITAL' and Exchange = 'NSE'),
                c2.exposure_lim))
from trade4432 t,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code and t.series= 'BE' 
and t.party_code like ltrim(@code)+'%' and c2.exposure_lim <> 0 
and c1.trader = @statusname
group by c1.cl_code,c2.cl_code,c2.party_code,c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy,c2.exposure_lim

Union all 
select t.scrip_cd,t.series,qty =sum(t.TradeQty),amount = sum(t.marketrate * t.tradeqty),
t.sell_buy,c1.short_name,t.party_code,exposure_lim = convert(float,
                IsNull((Select (Margin*NoOfTimes) from Client3 Where Client3.Cl_Code = C2.Cl_code 
                and Client3.Party_code = C2.Party_code and markettype = 'CAPITAL' and Exchange = 'NSE'),
                c2.exposure_lim))
from settlement t,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and t.party_code = c2.party_code and t.series= 'BE' 
and t.party_code like ltrim(@code)+'%' and t.billno = 0 and c2.exposure_lim <> 0 
and c1.trader = @statusname
group by c1.cl_code,c2.cl_code,c2.party_code,c1.short_name,t.party_code,t.scrip_cd ,t.series,t.sell_buy,c2.exposure_lim

end

GO
