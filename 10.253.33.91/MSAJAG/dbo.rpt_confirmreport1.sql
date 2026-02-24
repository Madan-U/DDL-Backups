-- Object: PROCEDURE dbo.rpt_confirmreport1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/* Changed by BBG 23 Feb 2002  added group by trade_no */ 
/****** Object:  Stored Procedure dbo.rpt_confirmreport1    Script Date: 01/29/2002 10:53:18 PM ******/
CREATE PROCEDURE rpt_confirmreport1
@statusid varchar(15),
@statusname varchar(25),
@settype varchar(3),
@fcode varchar(10),
@tcode varchar(10),
@trader varchar(12),
@sdate varchar(12)
 
AS

if @statusid = 'broker'
begin
SELECT s.party_code, tm=convert(varchar,sauda_date,108),
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date, 
 s.Scrip_CD as scrip_cd, s.series,
 scripname=S.scrip_Cd, sdt = convert(VARchar,sauda_date,103),
 s.sell_buy,/*s.markettype, */ service_tax = isnull(s.service_tax,0),
/*   N_NetRate,CL_RATE=0,*/
  pqty=isnull((case sell_buy
  when 1 then s.tradeqty end),0),
 sqty=isnull((case sell_buy
  when 2 then s.tradeqty end),0),
 prate=isnull((case sell_buy
  when 1 then s.marketrate end),0),
 srate=isnull((case sell_buy
  when 2 then s.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 
 sbrok=abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 pnetrate=s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 

 snetrate=s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0))), 

 pamt=s.tradeqty * (s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 samt=s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)))), 


 Brokerage=isnull(tradeqty*brokapplied,0) ,
 NewBrokerage =isnull(tradeqty*nbrokapp,0), 
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy2,User_Id,Sett_No
 from settlement s , client1 c1, client2 c2
 where s.party_code = c2.party_code
 and s.sett_type = @settype
 and c1.cl_code = c2.cl_code
 and s.Party_Code >= @fcode and s.Party_Code <= @tcode
and left(convert(varchar,s.sauda_date,109),11) =@sdate 
and c1.trader like ltrim(@trader)+'%'
 AND s.TRADEQTY <> '0'  
 and status <> 'N'
 group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series, 
 s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, 
 s.brokapplied, c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy2,User_Id,Sett_No

union all

SELECT s.party_code, tm=convert(varchar,sauda_date,108),
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date, 
 s.Scrip_CD as scrip_cd, s.series,
 scripname=S.scrip_Cd , sdt = convert(VARchar,sauda_date,103),
 s.sell_buy,/*s.markettype, */ service_tax = isnull(s.service_tax,0),
/*   N_NetRate,CL_RATE=0,*/
 pqty=isnull((case sell_buy
  when 1 then sum(s.tradeqty) end),0),
 sqty=isnull((case sell_buy
  when 2 then sum(s.tradeqty) end),0),
 prate=isnull((case sell_buy
  when 1 then s.marketrate end),0),
 srate=isnull((case sell_buy
  when 2 then s.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 
 sbrok=abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 pnetrate=s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 

 snetrate=s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0))), 

 pamt=s.tradeqty * (s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 samt=s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)))), 

 Brokerage=isnull(tradeqty*brokapplied,0) ,
 NewBrokerage =isnull(tradeqty*nbrokapp,0),
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code ,s.dummy2,User_Id,Sett_No
 from history s , client1 c1, client2 c2
 where s.party_code = c2.party_code
and s.sett_type = @settype
and c1.cl_code = c2.cl_code
and s.Party_Code >= @fcode and s.Party_Code <= @tcode
and left(convert(varchar,s.sauda_date,109),11) =@sdate 
and c1.trader like ltrim(@trader)+'%'
AND s.TRADEQTY <> '0'  
and status <> 'N'
group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series, 
s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, 
s.brokapplied,c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy2,User_Id,Sett_No


union all

select s.party_code,tm=(Select Convert(Varchar,Min(Sauda_Date),108) from Isettlement i where i.scrip_cd = s.scrip_cd and i.dummy2 = s.dummy2 
           and i.party_code = s.party_code and i.Sauda_Date like @SDate + '%' and i.series = s.series and i.sell_buy = s.sell_buy ),
 tdate='', trade_no =(Select Min(Trade_No) from Isettlement i where i.scrip_cd = s.scrip_cd and i.dummy2 = s.dummy2 
           and i.party_code = s.party_code and i.Sauda_Date like @SDate + '%' and i.series = s.series and i.sell_buy = s.sell_buy )
, sauda_date ='', 
 s.Scrip_CD as scrip_cd, series ,
 scripname=S.scrip_Cd+'  (I)', sdt = '',
 s.sell_buy, service_tax = isnull(sum(s.service_tax),0)  , 
PQty = ( case when sell_buy = 1 then SUM(TRADEQTY) else 0 end ),
SQty = ( case when sell_buy = 2 then SUM(TRADEQTY) else 0 end ),
prate =isnull((case sell_buy
  when 1 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0),
srate=isnull((case sell_buy
  when 2 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0),
  pbrok=isnull((case  s.sell_buy
  when 1 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty)) 
  else 
   sum( s.brokapplied*tradeqty)/sum(tradeqty) 
  end)
 end),0),
  sbrok=isnull((case  s.sell_buy
   when 2 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.SERVICE_tax)/sum( s.tradeqty)) 
  else 
  sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end)
 end),0),

pnetrate = isnull((case sell_buy
  when 1 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0) +
 isnull((case  s.sell_buy
  when 1 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty)) 
  else 
   sum( s.brokapplied*tradeqty)/sum(tradeqty) 
  end)
 end),0),

 snetrate= isnull((case sell_buy
  when 2 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0)-
isnull((case  s.sell_buy
   when 2 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.SERVICE_tax)/sum( s.tradeqty)) 
  else 
  sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end)
 end),0),
 pamt=(isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) + sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty))
  else
   (Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty)) + sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end ) 
 end),0)) * sum(tradeqty),
 samt= (isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) - sum( s.brokapplied*tradeqty)/sum(tradeqty) - (sum( s.nsertax)/sum( s.tradeqty))
  else
   (Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty)) - sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end ) 
 end),0)) * sum(tradeqty),
  Brokerage=isnull(sum(tradeqty*brokapplied),0) ,
 NewBrokerage =isnull(sum(tradeqty*nbrokapp),0),
 c1.short_name, c1.trader, c1.Res_Phone1, 
c2.service_chrg, c1.cl_code , s.dummy2,User_Id = 0 ,Sett_No
from  ISETTLEMENT s , client1 c1, client2 c2
where s.party_code = c2.party_code 
and s.sett_type = @settype
and c2.cl_code = c1.cl_code and s.tradeqty <> '0' and status <> 'N'
 and s.Party_Code >= @fcode and s.Party_Code <= @tcode
and left(convert(varchar,s.sauda_date,109),11) =@sdate
and c1.trader like ltrim(@trader)+'%' 
and s.party_code = c2.party_code 
and c1.cl_code = c2.cl_code

group by s.party_code,s.scrip_cd,s.series, sell_buy, c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, 
c1.cl_code ,marketrate,  s.dummy2,  /* User_Id, */    Sett_No

Order By s.party_code, s.Scrip_CD,s.series
end



/*---------------------------------------------This is for statusd = subbroker----------------------------------------------------------------------------*/

if @statusid = 'subbroker'
begin
SELECT s.party_code, tm=convert(varchar,sauda_date,108),
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date, 
 s.Scrip_CD as scrip_cd, s.series,
 scripname=S.scrip_Cd, sdt = convert(VARchar,sauda_date,103),
 s.sell_buy,/*s.markettype, */ service_tax = isnull(s.service_tax,0),
/*   N_NetRate,CL_RATE=0,*/
  pqty=isnull((case sell_buy
  when 1 then s.tradeqty end),0),
 sqty=isnull((case sell_buy
  when 2 then s.tradeqty end),0),
 prate=isnull((case sell_buy
  when 1 then s.marketrate end),0),
 srate=isnull((case sell_buy
  when 2 then s.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 
 sbrok=abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 pnetrate=s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 

 snetrate=s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0))), 

 pamt=s.tradeqty * (s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 samt=s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)))), 


 Brokerage=isnull(tradeqty*brokapplied,0) ,
 NewBrokerage =isnull(tradeqty*nbrokapp,0), 
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy2,User_Id,Sett_No
 from settlement s , client1 c1, client2 c2 ,subbrokers sb
 where s.party_code = c2.party_code
 and s.sett_type = @settype
 and c1.cl_code = c2.cl_code
 and s.Party_Code >= @fcode and s.Party_Code <= @tcode
and left(convert(varchar,s.sauda_date,109),11) =@sdate
 and c1.trader like ltrim(@trader)+'%'
 and sb.sub_broker = c1.sub_broker
 and c1.sub_broker = @statusname
 AND s.TRADEQTY <> '0'  
 and status <> 'N'
 group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series, 
 s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, 
 s.brokapplied, c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy2,User_Id,Sett_No

union all

SELECT s.party_code, tm=convert(varchar,sauda_date,108),
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date, 
 s.Scrip_CD as scrip_cd, s.series,
 scripname=S.scrip_Cd , sdt = convert(VARchar,sauda_date,103),
 s.sell_buy,/*s.markettype, */ service_tax = isnull(s.service_tax,0),
/*   N_NetRate,CL_RATE=0,*/
 pqty=isnull((case sell_buy
  when 1 then s.tradeqty end),0),
 sqty=isnull((case sell_buy
  when 2 then s.tradeqty end),0),
 prate=isnull((case sell_buy
  when 1 then s.marketrate end),0),
 srate=isnull((case sell_buy
  when 2 then s.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 
 sbrok=abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 pnetrate=s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 
 snetrate=s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0))), 
 pamt=s.tradeqty * (s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 samt=s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)))), 
 Brokerage=isnull(tradeqty*brokapplied,0) ,
 NewBrokerage =isnull(tradeqty*nbrokapp,0),
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code ,s.dummy2,User_Id,Sett_No
 from history s , client1 c1, client2 c2 ,subbrokers sb
 where s.party_code = c2.party_code
and s.sett_type = @settype
 and c1.cl_code = c2.cl_code
 and s.Party_Code >= @fcode and s.Party_Code <= @tcode
and left(convert(varchar,s.sauda_date,109),11) =@sdate
 and c1.trader like ltrim(@trader)+'%'
 AND s.TRADEQTY <> '0'  
and status <> 'N'
and sb.sub_broker = c1.sub_broker
and c1.sub_broker = @statusname
group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series, 
s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, 
s.brokapplied,c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy2,User_Id,Sett_No


union all

select s.party_code,tm=(Select Convert(Varchar,Min(Sauda_Date),108) from Isettlement i where i.scrip_cd = s.scrip_cd and i.dummy2 = s.dummy2 
           and i.party_code = s.party_code and i.Sauda_Date like @SDate + '%' and i.series = s.series and i.sell_buy = s.sell_buy ), tdate='',
trade_no =(Select Min(Trade_No) from Isettlement i where i.scrip_cd = s.scrip_cd and i.dummy2 = s.dummy2 
           and i.party_code = s.party_code and i.Sauda_Date like @SDate + '%' and i.series = s.series and i.sell_buy = s.sell_buy ),
sauda_date ='', s.Scrip_CD as scrip_cd, series ,
 scripname=S.scrip_Cd+'  (I)', sdt = '',
 s.sell_buy, service_tax = isnull(sum(s.service_tax),0)  , 
PQty = ( case when sell_buy = 1 then SUM(TRADEQTY) else 0 end ),
SQty = ( case when sell_buy = 2 then SUM(TRADEQTY) else 0 end ),
prate =isnull((case sell_buy
  when 1 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0),
srate=isnull((case sell_buy
  when 2 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0),
  pbrok=isnull((case  s.sell_buy
  when 1 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty)) 
  else 
   sum( s.brokapplied*tradeqty)/sum(tradeqty) 
  end)
 end),0),
  sbrok=isnull((case  s.sell_buy
   when 2 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.SERVICE_tax)/sum( s.tradeqty)) 
  else 
  sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end)
 end),0),
netrate = isnull((case sell_buy
  when 1 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0) +
 isnull((case  s.sell_buy
  when 1 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty)) 
  else 
   sum( s.brokapplied*tradeqty)/sum(tradeqty) 
  end)
 end),0),
 snetrate= isnull((case sell_buy
  when 2 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0)-
isnull((case  s.sell_buy
   when 2 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.SERVICE_tax)/sum( s.tradeqty)) 
  else 
  sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end)
 end),0),
 pamt=(isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) + sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty))
  else
   (Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty)) + sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end ) 
 end),0)) * sum(tradeqty),
 samt= (isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) - sum( s.brokapplied*tradeqty)/sum(tradeqty) - (sum( s.nsertax)/sum( s.tradeqty))
  else
   (Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty)) - sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end ) 
 end),0)) * sum(tradeqty),
  Brokerage=isnull(sum(tradeqty*brokapplied),0) ,
 NewBrokerage =isnull(sum(tradeqty*nbrokapp),0),
 c1.short_name, c1.trader, c1.Res_Phone1, 
c2.service_chrg, c1.cl_code , s.dummy2,User_Id = 0 ,Sett_No
from  ISETTLEMENT s , client1 c1, client2 c2,subbrokers sb
where s.party_code = c2.party_code 
and s.sett_type = @settype
and c2.cl_code = c1.cl_code and s.tradeqty <> '0' and status <> 'N'
and s.Party_Code >= @fcode and s.Party_Code <= @tcode
and left(convert(varchar,s.sauda_date,109),11) =@sdate
and c1.trader like ltrim(@trader)+'%' 
and s.party_code = c2.party_code 
and c1.cl_code = c2.cl_code
and sb.sub_broker = c1.sub_broker
and c1.sub_broker = @statusname
group by s.party_code,s.scrip_cd,s.series,
sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , c2.service_chrg, c1.cl_code , s.dummy2,/* User_Id, */ Sett_No
Order By s.party_code, s.Scrip_CD,s.series

end




/*--------------------------the part below is executed if status id = trader ------------------------------------------------*/

if @statusid = 'trader'
begin
SELECT s.party_code, tm=convert(varchar,sauda_date,108),
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date, 
 s.Scrip_CD as scrip_cd, s.series,
 scripname=S.scrip_Cd, sdt = convert(VARchar,sauda_date,103),
 s.sell_buy,/*s.markettype, */ service_tax = isnull(s.service_tax,0),
/*   N_NetRate,CL_RATE=0,*/
  pqty=isnull((case sell_buy
  when 1 then s.tradeqty end),0),
 sqty=isnull((case sell_buy
  when 2 then s.tradeqty end),0),
 prate=isnull((case sell_buy
  when 1 then s.marketrate end),0),
 srate=isnull((case sell_buy
  when 2 then s.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 
 sbrok=abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 pnetrate=s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 

 snetrate=s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0))), 

 pamt=s.tradeqty * (s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 samt=s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)))), 
 Brokerage=isnull(tradeqty*brokapplied,0) ,
 NewBrokerage =isnull(tradeqty*nbrokapp,0), 
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy2,User_Id,Sett_No
 from settlement s , client1 c1, client2 c2
 where s.party_code = c2.party_code
 and s.sett_type = @settype
 and c1.cl_code = c2.cl_code
 and s.Party_Code >= @fcode and s.Party_Code <= @tcode
and left(convert(varchar,s.sauda_date,109),11) =@sdate
 and c1.trader like ltrim(@trader)+'%'
 AND s.TRADEQTY <> '0'  
 and status <> 'N'
and c1.trader =@statusname
group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series, 
s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, 
s.brokapplied, c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy2,User_Id,Sett_No
union all

SELECT s.party_code, tm=convert(varchar,sauda_date,108),
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date, 
 s.Scrip_CD as scrip_cd, s.series,
 scripname=S.scrip_Cd , sdt = convert(VARchar,sauda_date,103),
 s.sell_buy,/*s.markettype, */ service_tax = isnull(s.service_tax,0),
/*   N_NetRate,CL_RATE=0,*/
 pqty=isnull((case sell_buy
  when 1 then s.tradeqty end),0),
 sqty=isnull((case sell_buy
  when 2 then s.tradeqty end),0),
 prate=isnull((case sell_buy
  when 1 then s.marketrate end),0),
 srate=isnull((case sell_buy
  when 2 then s.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 
 sbrok=abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 pnetrate=s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 
 snetrate=s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0))), 
 pamt=s.tradeqty * (s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 samt=s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)))), 
 Brokerage=isnull(tradeqty*brokapplied,0) ,
 NewBrokerage =isnull(tradeqty*nbrokapp,0),
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code ,s.dummy2,User_Id,Sett_No
 from history s , client1 c1, client2 c2
 where s.party_code = c2.party_code
and s.sett_type = @settype
 and c1.cl_code = c2.cl_code
 and s.Party_Code >= @fcode and s.Party_Code <= @tcode
and left(convert(varchar,s.sauda_date,109),11) =@sdate
 and c1.trader like ltrim(@trader)+'%'
 AND s.TRADEQTY <> '0'  
and status <> 'N'
and c1.trader =@statusname
group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series, 
s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, 
s.brokapplied,c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy2,User_Id,Sett_No


union all

select s.party_code,tm=(Select Convert(Varchar,Min(Sauda_Date),108) from Isettlement i where i.scrip_cd = s.scrip_cd and i.dummy2 = s.dummy2 
           and i.party_code = s.party_code and i.Sauda_Date like @SDate + '%' and i.series = s.series and i.sell_buy = s.sell_buy ),
 tdate='',trade_no =(Select Min(Trade_No) from Isettlement i where i.scrip_cd = s.scrip_cd and i.dummy2 = s.dummy2 
           and i.party_code = s.party_code and i.Sauda_Date like @SDate + '%' and i.series = s.series and i.sell_buy = s.sell_buy )
, sauda_date ='', 
 s.Scrip_CD as scrip_cd, series,
 scripname=S.scrip_Cd+'  (I)', sdt = '',
 s.sell_buy, service_tax = isnull(sum(s.service_tax),0)  , 
PQty = ( case when sell_buy = 1 then SUM(TRADEQTY) else 0 end ),
SQty = ( case when sell_buy = 2 then SUM(TRADEQTY) else 0 end ),
prate =isnull((case sell_buy
  when 1 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0),
srate=isnull((case sell_buy
  when 2 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0),
  pbrok=isnull((case  s.sell_buy
  when 1 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty)) 
  else 
   sum( s.brokapplied*tradeqty)/sum(tradeqty) 
  end)
 end),0),
  sbrok=isnull((case  s.sell_buy
   when 2 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.SERVICE_tax)/sum( s.tradeqty)) 
  else 
  sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end)
 end),0),

pnetrate = isnull((case sell_buy
  when 1 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0) +
 isnull((case  s.sell_buy
  when 1 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty)) 
  else 
   sum( s.brokapplied*tradeqty)/sum(tradeqty) 
  end)
 end),0),

 snetrate= isnull((case sell_buy
  when 2 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0)-
isnull((case  s.sell_buy
   when 2 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.SERVICE_tax)/sum( s.tradeqty)) 
  else 
  sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end)
 end),0),
 pamt=(isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) + sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty))
  else
   (Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty)) + sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end ) 
 end),0)) * sum(tradeqty),
 samt= (isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) - sum( s.brokapplied*tradeqty)/sum(tradeqty) - (sum( s.nsertax)/sum( s.tradeqty))
  else
   (Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty)) - sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end ) 
 end),0)) * sum(tradeqty),
  Brokerage=isnull(sum(tradeqty*brokapplied),0) ,
 NewBrokerage =isnull(sum(tradeqty*nbrokapp),0),
 c1.short_name, c1.trader, c1.Res_Phone1, 
c2.service_chrg, c1.cl_code , s.dummy2,User_Id = 0,Sett_No
from  ISETTLEMENT s , client1 c1, client2 c2
where s.party_code = c2.party_code 
and s.sett_type = @settype
and c2.cl_code = c1.cl_code and s.tradeqty <> '0' and status <> 'N'
 and s.Party_Code >= @fcode and s.Party_Code <= @tcode
and left(convert(varchar,s.sauda_date,109),11) =@sdate
and c1.trader like ltrim(@trader)+'%' 
and s.party_code = c2.party_code 
and c1.cl_code = c2.cl_code
and c1.trader =@statusname
group by s.party_code,s.scrip_cd,s.series,
sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , c2.service_chrg, c1.cl_code , s.dummy2,/* User_Id, */ Sett_No
Order By s.party_code, s.Scrip_CD,s.series

end

/*------------------------------------------------The part below is executed for statusid =branch            ------------------------------------------------- */

if @statusid = 'branch'
begin
SELECT s.party_code, tm=convert(varchar,sauda_date,108),
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date, 
 s.Scrip_CD as scrip_cd, s.series,
 scripname=S.scrip_Cd, sdt = convert(VARchar,sauda_date,103),
 s.sell_buy,/*s.markettype, */ service_tax = isnull(s.service_tax,0),
/*   N_NetRate,CL_RATE=0,*/
  pqty=isnull((case sell_buy
  when 1 then s.tradeqty end),0),
 sqty=isnull((case sell_buy
  when 2 then s.tradeqty end),0),
 prate=isnull((case sell_buy
  when 1 then s.marketrate end),0),
 srate=isnull((case sell_buy
  when 2 then s.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 
 sbrok=abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 pnetrate=s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 
 snetrate=s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0))), 
 pamt=s.tradeqty * (s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 samt=s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)))), 
 Brokerage=isnull(tradeqty*brokapplied,0) ,
 NewBrokerage =isnull(tradeqty*nbrokapp,0), 
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy2,User_Id = 0 ,Sett_No
 from settlement s , client1 c1, client2 c2 ,branches br
 where s.party_code = c2.party_code
 and s.sett_type = @settype
 and c1.cl_code = c2.cl_code
 and s.Party_Code >= @fcode and s.Party_Code <= @tcode
and left(convert(varchar,s.sauda_date,109),11) =@sdate
 and c1.trader like ltrim(@trader)+'%'
 AND s.TRADEQTY <> '0'  
 and status <> 'N'
and br.short_name =c1.trader
and br.branch_cd = @statusname
group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series, 
s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, 
s.brokapplied, c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy2,/* User_Id, */ Sett_No

union all

SELECT s.party_code, tm=convert(varchar,sauda_date,108),
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date, 
 s.Scrip_CD as scrip_cd, s.series,
 scripname=S.scrip_Cd , sdt = convert(VARchar,sauda_date,103),
 s.sell_buy,/*s.markettype, */ service_tax = isnull(s.service_tax,0),
/*   N_NetRate,CL_RATE=0,*/
 pqty=isnull((case sell_buy
  when 1 then s.tradeqty end),0),
 sqty=isnull((case sell_buy
  when 2 then s.tradeqty end),0),
 prate=isnull((case sell_buy
  when 1 then s.marketrate end),0),
 srate=isnull((case sell_buy
  when 2 then s.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 
 sbrok=abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 pnetrate=s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 

 snetrate=s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0))), 

 pamt=s.tradeqty * (s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 samt=s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)))), 

 Brokerage=isnull(tradeqty*brokapplied,0) ,
 NewBrokerage =isnull(tradeqty*nbrokapp,0),
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code ,s.dummy2,User_Id,Sett_No
 from history s , client1 c1, client2 c2 ,branches br
 where s.party_code = c2.party_code
and s.sett_type = @settype
 and c1.cl_code = c2.cl_code
 and s.Party_Code >= @fcode and s.Party_Code <= @tcode
and left(convert(varchar,s.sauda_date,109),11) =@sdate
 and c1.trader like ltrim(@trader)+'%'
 AND s.TRADEQTY <> '0'  
and status <> 'N'
and br.short_name =c1.trader
and br.branch_cd = @statusname
group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series, 
s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, 
s.brokapplied,c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy2,User_Id,Sett_No


union all

select s.party_code,tm=(Select Convert(Varchar,Min(Sauda_Date),108) from Isettlement i where i.scrip_cd = s.scrip_cd and i.dummy2 = s.dummy2 
           and i.party_code = s.party_code and i.Sauda_Date like @SDate + '%' and i.series = s.series and i.sell_buy = s.sell_buy ),
 tdate='', trade_no =(Select Min(Trade_No) from Isettlement i where i.scrip_cd = s.scrip_cd and i.dummy2 = s.dummy2 
           and i.party_code = s.party_code and i.Sauda_Date like @SDate + '%' and i.series = s.series and i.sell_buy = s.sell_buy )
, sauda_date ='', 
 s.Scrip_CD as scrip_cd, series ,
 scripname=S.scrip_Cd+'  (I)', sdt = '',
 s.sell_buy, service_tax = isnull(sum(s.service_tax),0)  , 
PQty = ( case when sell_buy = 1 then SUM(TRADEQTY) else 0 end ),
SQty = ( case when sell_buy = 2 then SUM(TRADEQTY) else 0 end ),
prate =isnull((case sell_buy
  when 1 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0),
srate=isnull((case sell_buy
  when 2 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0),
  pbrok=isnull((case  s.sell_buy
  when 1 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty)) 
  else 
   sum( s.brokapplied*tradeqty)/sum(tradeqty) 
  end)
 end),0),
  sbrok=isnull((case  s.sell_buy
   when 2 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.SERVICE_tax)/sum( s.tradeqty)) 
  else 
  sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end)
 end),0),

pnetrate = isnull((case sell_buy
  when 1 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0) +
 isnull((case  s.sell_buy
  when 1 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty)) 
  else 
   sum( s.brokapplied*tradeqty)/sum(tradeqty) 
  end)
 end),0),

 snetrate= isnull((case sell_buy
  when 2 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0)-
isnull((case  s.sell_buy
   when 2 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.SERVICE_tax)/sum( s.tradeqty)) 
  else 
  sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end)
 end),0),
 pamt=(isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) + sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty))
  else
   (Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty)) + sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end ) 
 end),0)) * sum(tradeqty),
 samt= (isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) - sum( s.brokapplied*tradeqty)/sum(tradeqty) - (sum( s.nsertax)/sum( s.tradeqty))
  else
   (Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty)) - sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end ) 
 end),0)) * sum(tradeqty),
  Brokerage=isnull(sum(tradeqty*brokapplied),0) ,
 NewBrokerage =isnull(sum(tradeqty*nbrokapp),0),
 c1.short_name, c1.trader, c1.Res_Phone1, 
c2.service_chrg, c1.cl_code , s.dummy2,User_Id = 0 ,Sett_No
from  ISETTLEMENT s , client1 c1, client2 c2 ,branches br
where s.party_code = c2.party_code 
and s.sett_type = @settype
and c2.cl_code = c1.cl_code and s.tradeqty <> '0' and status <> 'N'
 and s.Party_Code >= @fcode and s.Party_Code <= @tcode
and left(convert(varchar,s.sauda_date,109),11) =@sdate
and c1.trader like ltrim(@trader)+'%' 
and s.party_code = c2.party_code 
and c1.cl_code = c2.cl_code
and br.short_name =c1.trader
and br.branch_cd = @statusname
group by s.party_code,s.scrip_cd,s.series,
sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , c2.service_chrg, c1.cl_code , s.dummy2,/* User_Id, */Sett_No
Order By s.party_code, s.Scrip_CD,s.series

end




/*----------------------------the part below si executed when statusid = client --------------------------------------------------------------------*/

if @statusid = 'client'
begin
SELECT s.party_code, tm=convert(varchar,sauda_date,108),
tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date, 
 s.Scrip_CD as scrip_cd, s.series,
 scripname=S.scrip_Cd, sdt = convert(VARchar,sauda_date,103),
 s.sell_buy,/*s.markettype, */ service_tax = isnull(s.service_tax,0),
/*   N_NetRate,CL_RATE=0,*/
  pqty=isnull((case sell_buy
  when 1 then s.tradeqty end),0),
 sqty=isnull((case sell_buy
  when 2 then s.tradeqty end),0),
 prate=isnull((case sell_buy
  when 1 then s.marketrate end),0),
 srate=isnull((case sell_buy
  when 2 then s.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 
 sbrok=abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 pnetrate=s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 

 snetrate=s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0))), 

 pamt=s.tradeqty * (s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 samt=s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)))), 


 Brokerage=isnull(tradeqty*brokapplied,0) ,
 NewBrokerage =isnull(tradeqty*nbrokapp,0), 
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy2,User_Id,Sett_No
 from settlement s , client1 c1, client2 c2
 where s.party_code = c2.party_code
 and s.sett_type = @settype
 and c1.cl_code = c2.cl_code
/* and s.Party_Code >= @fcode and s.Party_Code <= @tcode*/
and left(convert(varchar,s.sauda_date,109),11) =@sdate
 and c1.trader like ltrim(@trader)+'%'
 AND s.TRADEQTY <> '0'  
 and status <> 'N'
and s.party_code = @statusname
group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series, 
s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, 
s.brokapplied, c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy2,User_Id,Sett_No,Trade_no

union all

SELECT s.party_code, tm=convert(varchar,sauda_date,108),
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date, 
 s.Scrip_CD as scrip_cd, s.series,
 scripname=S.scrip_Cd , sdt = convert(VARchar,sauda_date,103),
 s.sell_buy,/*s.markettype, */ service_tax = isnull(s.service_tax,0),
/*   N_NetRate,CL_RATE=0,*/
 pqty=isnull((case sell_buy
  when 1 then s.tradeqty end),0),
 sqty=isnull((case sell_buy
  when 2 then s.tradeqty end),0),
 prate=isnull((case sell_buy
  when 1 then s.marketrate end),0),
 srate=isnull((case sell_buy
  when 2 then s.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 
 sbrok=abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 pnetrate=s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 

 snetrate=s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0))), 

 pamt=s.tradeqty * (s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 samt=s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)))), 

 Brokerage=isnull(tradeqty*brokapplied,0) ,
 NewBrokerage =isnull(tradeqty*nbrokapp,0),
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code ,s.dummy2,User_Id,Sett_No
 from history s , client1 c1, client2 c2
 where s.party_code = c2.party_code
and s.sett_type = @settype
 and c1.cl_code = c2.cl_code
/* and s.Party_Code >= @fcode and s.Party_Code <= @tcode*/
and left(convert(varchar,s.sauda_date,109),11) =@sdate
 and c1.trader like ltrim(@trader)+'%'
 AND s.TRADEQTY <> '0'  
and status <> 'N'
and s.party_code = @statusname
group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series, 
s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, 
s.brokapplied,c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy2,User_Id,Sett_No


union all

select s.party_code,tm=(Select Convert(Varchar,Min(Sauda_Date),108) from Isettlement i where i.scrip_cd = s.scrip_cd and i.dummy2 = s.dummy2 
           and i.party_code = s.party_code and i.Sauda_Date like @SDate + '%' and i.series = s.series and i.sell_buy = s.sell_buy ),
 tdate='', trade_no =(Select Min(Trade_No) from Isettlement i where i.scrip_cd = s.scrip_cd and i.dummy2 = s.dummy2 
           and i.party_code = s.party_code and i.Sauda_Date like @SDate + '%' and i.series = s.series and i.sell_buy = s.sell_buy )
, sauda_date ='', 
 s.Scrip_CD as scrip_cd, series ,
 scripname=S.scrip_Cd+'  (I)', sdt = '',
 s.sell_buy, service_tax = isnull(sum(s.service_tax),0)  , 
PQty = ( case when sell_buy = 1 then SUM(TRADEQTY) else 0 end ),
SQty = ( case when sell_buy = 2 then SUM(TRADEQTY) else 0 end ),
prate =isnull((case sell_buy
  when 1 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0),
srate=isnull((case sell_buy
  when 2 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0),
  pbrok=isnull((case  s.sell_buy
  when 1 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty)) 
  else 
   sum( s.brokapplied*tradeqty)/sum(tradeqty) 
  end)
 end),0),
  sbrok=isnull((case  s.sell_buy
   when 2 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.SERVICE_tax)/sum( s.tradeqty)) 
  else 
  sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end)
 end),0),

pnetrate = isnull((case sell_buy
  when 1 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0) +
 isnull((case  s.sell_buy
  when 1 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty)) 
  else 
   sum( s.brokapplied*tradeqty)/sum(tradeqty) 
  end)
 end),0),

 snetrate= isnull((case sell_buy
  when 2 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0)-
isnull((case  s.sell_buy
   when 2 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.SERVICE_tax)/sum( s.tradeqty)) 
  else 
  sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end)
 end),0),
 pamt=(isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) + sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty))
  else
   (Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty)) + sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end ) 
 end),0)) * sum(tradeqty),
 samt= (isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) - sum( s.brokapplied*tradeqty)/sum(tradeqty) - (sum( s.nsertax)/sum( s.tradeqty))
  else
   (Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty)) - sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end ) 
 end),0)) * sum(tradeqty),
  Brokerage=isnull(sum(tradeqty*brokapplied),0) ,
 NewBrokerage =isnull(sum(tradeqty*nbrokapp),0),
 c1.short_name, c1.trader, c1.Res_Phone1, 
c2.service_chrg, c1.cl_code , s.dummy2,User_Id = 0 ,Sett_No
from  ISETTLEMENT s , client1 c1, client2 c2
where s.party_code = c2.party_code 
and s.sett_type = @settype
and c2.cl_code = c1.cl_code and s.tradeqty <> '0' and status <> 'N'
/* and s.Party_Code >= @fcode and s.Party_Code <= @tcode*/
and left(convert(varchar,s.sauda_date,109),11) =@sdate
and c1.trader like ltrim(@trader)+'%' 
and s.party_code = c2.party_code 
and c1.cl_code = c2.cl_code
and s.party_code = @statusname
group by s.party_code,s.scrip_cd,s.series,
sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , c2.service_chrg, c1.cl_code , s.dummy2,/*User_Id, */Sett_No
Order By s.party_code, s.Scrip_CD,s.series

end




/*the part elow is executed for statusid = family*/
if @statusid = 'family'
begin
SELECT s.party_code, tm=convert(varchar,sauda_date,108),
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date, 
 s.Scrip_CD as scrip_cd, s.series,
 scripname=S.scrip_Cd, sdt = convert(VARchar,sauda_date,103),
 s.sell_buy,/*s.markettype, */ service_tax = isnull(s.service_tax,0),
/*   N_NetRate,CL_RATE=0,*/
  pqty=isnull((case sell_buy
  when 1 then s.tradeqty end),0),
 sqty=isnull((case sell_buy
  when 2 then s.tradeqty end),0),
 prate=isnull((case sell_buy
  when 1 then s.marketrate end),0),
 srate=isnull((case sell_buy
  when 2 then s.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 
 sbrok=abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 pnetrate=s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 
 snetrate=s.marketrate-(abs(isnull((case sell_buy
 when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0))), 
 pamt=s.tradeqty * (s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 samt=s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)))), 
 Brokerage=isnull(tradeqty*brokapplied,0) ,
 NewBrokerage =isnull(tradeqty*nbrokapp,0), 
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy2,User_Id,Sett_No
 from settlement s , client1 c1, client2 c2
 where s.party_code = c2.party_code
 and s.sett_type = @settype
 and c1.cl_code = c2.cl_code
 and s.Party_Code >= @fcode and s.Party_Code <= @tcode
and left(convert(varchar,s.sauda_date,109),11) =@sdate
 and c1.trader like ltrim(@trader)+'%'
 AND s.TRADEQTY <> '0'  
 and status <> 'N'
and c1.family = @statusname
group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series, 
s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, 
s.brokapplied, c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy2,User_Id,Sett_No
union all

SELECT s.party_code, tm=convert(varchar,sauda_date,108),
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date, 
 s.Scrip_CD as scrip_cd, s.series,
 scripname=S.scrip_Cd , sdt = convert(VARchar,sauda_date,103),
 s.sell_buy,/*s.markettype, */ service_tax = isnull(s.service_tax,0),
/*   N_NetRate,CL_RATE=0,*/
 pqty=isnull((case sell_buy
  when 1 then s.tradeqty end),0),
 sqty=isnull((case sell_buy
  when 2 then s.tradeqty end),0),
 prate=isnull((case sell_buy
  when 1 then s.marketrate end),0),
 srate=isnull((case sell_buy
  when 2 then s.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 
 sbrok=abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 pnetrate=s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0), 
 snetrate=s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0))), 
 pamt=s.tradeqty * (s.marketrate+isnull((case sell_buy
  when 1 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)), 
 samt=s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy
  when 2 then s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end) end),0)))), 
 Brokerage=isnull(tradeqty*brokapplied,0) ,
 NewBrokerage =isnull(tradeqty*nbrokapp,0),
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code ,s.dummy2,User_Id,Sett_No
 from history s , client1 c1, client2 c2
 where s.party_code = c2.party_code
and s.sett_type = @settype
 and c1.cl_code = c2.cl_code
 and s.Party_Code >= @fcode and s.Party_Code <= @tcode
and left(convert(varchar,s.sauda_date,109),11) =@sdate
 and c1.trader like ltrim(@trader)+'%'
 AND s.TRADEQTY <> '0'  
and status <> 'N'
and c1.family = @statusname
group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series, 
s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, 
s.brokapplied,c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy2,User_Id,Sett_No

union all

select s.party_code,tm=(Select Convert(Varchar,Min(Sauda_Date),108) from Isettlement i where i.scrip_cd = s.scrip_cd and i.dummy2 = s.dummy2 
           and i.party_code = s.party_code and i.Sauda_Date like @SDate + '%' and i.series = s.series and i.sell_buy = s.sell_buy ),
 tdate='', trade_no =(Select Min(Trade_No) from Isettlement i where i.scrip_cd = s.scrip_cd and i.dummy2 = s.dummy2 
           and i.party_code = s.party_code and i.Sauda_Date like @SDate + '%' and i.series = s.series and i.sell_buy = s.sell_buy )
, sauda_date ='', 
 s.Scrip_CD as scrip_cd, series ,
 scripname=S.scrip_Cd+'  (I)', sdt = '',
 s.sell_buy, service_tax = isnull(sum(s.service_tax),0)  , 
PQty = ( case when sell_buy = 1 then SUM(TRADEQTY) else 0 end ),
SQty = ( case when sell_buy = 2 then SUM(TRADEQTY) else 0 end ),
prate =isnull((case sell_buy
  when 1 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0),
srate=isnull((case sell_buy
  when 2 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0),
  pbrok=isnull((case  s.sell_buy
  when 1 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty)) 
  else 
   sum( s.brokapplied*tradeqty)/sum(tradeqty) 
  end)
 end),0),
  sbrok=isnull((case  s.sell_buy
   when 2 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.SERVICE_tax)/sum( s.tradeqty)) 
  else 
  sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end)
 end),0),
pnetrate = isnull((case sell_buy
  when 1 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0) +
 isnull((case  s.sell_buy
  when 1 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty)) 
  else 
   sum( s.brokapplied*tradeqty)/sum(tradeqty) 
  end)
 end),0),
 snetrate= isnull((case sell_buy
  when 2 then   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) end),0)-
isnull((case  s.sell_buy
   when 2 then  ( case when service_chrg = 1 then  
   sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.SERVICE_tax)/sum( s.tradeqty)) 
  else 
  sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end)
 end),0),
 pamt=(isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) + sum( s.brokapplied*tradeqty)/sum(tradeqty) + (sum( s.nsertax)/sum( s.tradeqty))
  else
   (Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty)) + sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end ) 
 end),0)) * sum(tradeqty),
 samt= (isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
   Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty) - sum( s.brokapplied*tradeqty)/sum(tradeqty) - (sum( s.nsertax)/sum( s.tradeqty))
  else
   (Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty)) - sum( s.brokapplied*tradeqty)/sum(tradeqty)
  end ) 
 end),0)) * sum(tradeqty),
  Brokerage=isnull(sum(tradeqty*brokapplied),0) ,
 NewBrokerage =isnull(sum(tradeqty*nbrokapp),0),
 c1.short_name, c1.trader, c1.Res_Phone1, 
c2.service_chrg, c1.cl_code , s.dummy2,User_Id = 0,Sett_No
from  ISETTLEMENT s , client1 c1, client2 c2
where s.party_code = c2.party_code 
and s.sett_type = @settype
and c2.cl_code = c1.cl_code and s.tradeqty <> '0' and status <> 'N'
 and s.Party_Code >= @fcode and s.Party_Code <= @tcode
and left(convert(varchar,s.sauda_date,109),11) =@sdate
and c1.trader like ltrim(@trader)+'%' 
and s.party_code = c2.party_code 
and c1.cl_code = c2.cl_code
and c1.family = @statusname
group by s.party_code,s.scrip_cd,s.series,
sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , c2.service_chrg, c1.cl_code , s.dummy2,/* User_Id, */  Sett_No
Order By s.party_code, s.Scrip_CD,s.series

end

GO
