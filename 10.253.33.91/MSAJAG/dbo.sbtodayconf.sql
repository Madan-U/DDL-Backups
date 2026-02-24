-- Object: PROCEDURE dbo.sbtodayconf
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbtodayconf    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbtodayconf    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbtodayconf    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbtodayconf    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbtodayconf    Script Date: 12/27/00 8:59:02 PM ******/

/*** file :positionreport.asp
     report :client position 
displays details of asettlement for a particular client
**/
/* displays total buy and sell (qty and amt) of a particular subbroker till today */
/* report : Confirmation
    file : Tcofirmationreport.asp 
displays confiramtion as per inputs
*/
CREATE PROCEDURE sbtodayconf
@subbroker varchar(15),
@partycode varchar(10),
@name1 varchar(21),
@sdate  varchar(10)
AS
select c.Party_Code,c.short_name,c.Scrip_Cd, c.tradeqty,c.MarketRate,c.BrokApplied,
c.netrate,c.amount,c.Trade_no,c.Sauda_date, c.Sell_buy,c.markettype, 
c.series,c.sett_no,c.Insurance_chrg,c.turnover_tax, 
c.sebiturn_tax,c.broker_note, c.sertax ,  c.exchange,  
c.ins_chrg,c.turn_tax, c.other_chrg, c.sebi_tax,c.broker_chrg,c.trade_amount,  c.service_tax 
,c1.Off_Phone1, c1.trader "TRADER_NAME",CONVERT(VARCHAR,c.Sauda_date,103) 'SDATE',c1.cl_code
from Confirmview c,client1 c1,client2 c2, subbrokers sb  
where c.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and c1.sub_broker=sb.sub_broker
and sb.sub_broker=@subbroker
and c.party_code like  ltrim(@partycode) + '%'
and c.short_name like ltrim(@name1)+ '%'
and convert(varchar,c.sauda_date,103) like ltrim(@sdate)+'%'
union all
select s.Party_Code,c1.short_name,s.Scrip_Cd, s.tradeqty, s.MarketRate,s.BrokApplied,
s.netrate,s.amount,s.Trade_no,s.Sauda_date, s.Sell_buy,s.markettype,s.series,s.sett_no,t.Insurance_chrg,t.turnover_tax,
t.sebiturn_tax,t.broker_note,g.service_tax,  t.exchange,
s.ins_chrg,s.turn_tax, s.other_chrg, s.sebi_tax,s.broker_chrg,s.trade_amount, s.service_tax  
, c1.Off_Phone1 , c1.trader "TRADER_NAME",CONVERT(VARCHAR,S.Sauda_date,103) 'SDATE' ,c1.cl_code
from settlement s, client1 c1, client2 c2, taxes t, globals g, subbrokers sb  
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and c1.sub_broker=sb.sub_broker
and sb.sub_broker=@subbroker
and t.Exchange ='NSE' and t.Trans_cat = 'TRD'
and g.Exchange ='NSE' 
and s.party_code like  ltrim(@partycode)+ '%'
and c1.short_name like ltrim(@name1)+ '%'
and convert(varchar,s.sauda_date,103) like ltrim(@sdate)+ '%'
order by  c.Party_Code,c.short_name,c.Scrip_Cd

GO
