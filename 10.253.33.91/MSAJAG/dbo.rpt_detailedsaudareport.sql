-- Object: PROCEDURE dbo.rpt_detailedsaudareport
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_detailedsaudareport    Script Date: 05/20/2002 5:36:55 PM ******/
CREATE PROCEDURE rpt_detailedsaudareport
@statusid varchar(15),  
@statusname varchar(25),  
@code varchar(10),  
@name varchar(21),  
@trader varchar(12),  
@sdate varchar(12),
@scripcd varchar(12)  
   
AS  
/*----------------------------------------------------statusid = broker  starts   ------------------------------------------------------------------------------------------------*/  
if @statusid ='broker'  
begin  
 SELECT s.party_code, tm=convert(varchar,sauda_date,108),  
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date,   
 s.Scrip_CD, s.series,s.user_id,  
 sdt = convert(VARchar,sauda_date,103),  
 s.sell_buy, service_tax = isnull(s.service_tax,0),  
 pqty = isnull((case sell_buy when 1 then s.tradeqty end),0),  
 sqty = isnull((case sell_buy  when 2 then s.tradeqty end),0),  
 prate = isnull((case sell_buy  when 1 then s.marketrate end),0),  
 srate = isnull((case sell_buy  when 2 then s.marketrate end),0),  
 pbrok = isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 sbrok = abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 pnetrate = s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 snetrate = s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0))), /*commented by bhagyashree on 28-05-2001*/  
 pamt = s.tradeqty * (s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 samt = s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)))), /*commented by bhagyashree on 28-05-2001*/  
 Brokerage = isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
 NewBrokerage  = isnull(tradeqty*convert(numeric(9,2),nbrokapp),0),  
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy1,s.sett_no,s.tmark,  
 s.table_no,s.line_no,s.val_perc, trd_del = ( case when billflag<4 then b.trd_del else 'D' end ),billflag,nsertax = isnull(s.nsertax,0)
, pdbrok = isnull((case sell_buy  
  when 1 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
  sdbrok = abs(isnull((case sell_buy  
  when 2 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0)) /*commented by bhagyashree on 28-05-2001*/  

 from settlement s  , client1 c1, client2 c2  , broktable b
 where s.party_code = c2.party_code  
 and c1.cl_code =  c2.cl_code  
 and s.Party_Code like ltrim(@code)+'%'  
 and convert(varchar,s.sauda_date,103) = @sdate  
 and c1.short_name like ltrim(@name)+'%'  
 and c1.trader like ltrim(@trader)+'%'  
 AND s.TRADEQTY <> '0'    
 and status <> 'N'  
 and s.table_no = b.table_no
 and s.line_no = b.line_no
 and scrip_cd like ltrim(@scripcd)+'%'  
 group by s.party_code,billno,trade_no, sauda_date, s.scrip_cd, s.series,     
 s.sell_buy,c1.short_name,c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, s.brokapplied,  
 c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy1,s.user_id,s.sett_no,s.tmark ,s.table_no,s.line_no,s.val_perc,  b.trd_del , s.nsertax,billflag 

 union all  
  

 SELECT s.party_code, tm=convert(varchar,sauda_date,108),  
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date,   
 s.Scrip_CD, s.series,s.user_id,  
 sdt = convert(VARchar,sauda_date,103),  
 s.sell_buy, service_tax = isnull(s.service_tax,0),  
 pqty = isnull((case sell_buy when 1 then s.tradeqty end),0),  
 sqty = isnull((case sell_buy  when 2 then s.tradeqty end),0),  
 prate = isnull((case sell_buy  when 1 then s.marketrate end),0),  
 srate = isnull((case sell_buy  when 2 then s.marketrate end),0),  
 pbrok = isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 sbrok = abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 pnetrate = s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 snetrate = s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0))), /*commented by bhagyashree on 28-05-2001*/  
 pamt = s.tradeqty * (s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 samt = s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)))), /*commented by bhagyashree on 28-05-2001*/  
 Brokerage = isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
 NewBrokerage  = isnull(tradeqty*convert(numeric(9,2),nbrokapp),0),  
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy1,s.sett_no,s.tmark,  
 s.table_no,s.line_no,s.val_perc, trd_del = ( case when billflag<4 then b.trd_del else 'D' end ),billflag,nsertax = isnull(s.nsertax,0)
, pdbrok = isnull((case sell_buy  
  when 1 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
  sdbrok = abs(isnull((case sell_buy  
  when 2 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0)) /*commented by bhagyashree on 28-05-2001*/  

 from history s  , client1 c1, client2 c2  , broktable b
 where s.party_code = c2.party_code  
 and c1.cl_code =  c2.cl_code  
 and s.Party_Code like ltrim(@code)+'%'  
 and convert(varchar,s.sauda_date,103) = @sdate  
 and c1.short_name like ltrim(@name)+'%'  
 and c1.trader like ltrim(@trader)+'%'  
 AND s.TRADEQTY <> '0'    
 and status <> 'N'  
 and s.table_no = b.table_no
 and s.line_no = b.line_no
 and scrip_cd like ltrim(@scripcd)+'%'  
 group by s.party_code,billno,trade_no, sauda_date, s.scrip_cd, s.series,
 s.sell_buy,c1.short_name,c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, s.brokapplied,  
 c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy1,s.user_id,s.sett_no,s.tmark ,s.table_no,s.line_no,s.val_perc,  b.trd_del , s.nsertax,billflag 


 Order By s.party_code, s.scrip_cd ,  billflag
  
end  


/*----------------------------------------------------statusid = broker ends--------------------------------------------------------------------------------------------------*/  
  
  
  
  
  
  
/*----------------------------------------------------statusid = subbroker  starts   ------------------------------------------------------------------------------------------------*/  
  
  
if @statusid ='subbroker'  
begin  
 SELECT s.party_code, tm=convert(varchar,sauda_date,108),  
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date,   
 s.Scrip_CD, s.series,s.user_id,  
 sdt = convert(VARchar,sauda_date,103),  
 s.sell_buy, service_tax = isnull(s.service_tax,0),  
 pqty = isnull((case sell_buy when 1 then s.tradeqty end),0),  
 sqty = isnull((case sell_buy  when 2 then s.tradeqty end),0),  
 prate = isnull((case sell_buy  when 1 then s.marketrate end),0),  
 srate = isnull((case sell_buy  when 2 then s.marketrate end),0),  
 pbrok = isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 sbrok = abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 pnetrate = s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 snetrate = s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0))), /*commented by bhagyashree on 28-05-2001*/  
 pamt = s.tradeqty * (s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 samt = s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)))), /*commented by bhagyashree on 28-05-2001*/  
 Brokerage = isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
 NewBrokerage  = isnull(tradeqty*convert(numeric(9,2),nbrokapp),0),  
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy1,s.sett_no,s.tmark,  
 s.table_no,s.line_no,s.val_perc, trd_del = ( case when billflag<4 then b.trd_del else 'D' end ),billflag,nsertax = isnull(s.nsertax,0)
, pdbrok = isnull((case sell_buy  
  when 1 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
  sdbrok = abs(isnull((case sell_buy  
  when 2 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0)) /*commented by bhagyashree on 28-05-2001*/  

 from settlement s  ,  client1 c1, client2 c2 ,subbrokers sb  , broktable b
 where s.party_code = c2.party_code  
 and c1.cl_code =  c2.cl_code  
 and s.Party_Code like ltrim(@code)+'%'  
 and convert(varchar,s.sauda_date,103) = @sdate  
 and c1.short_name like ltrim(@name)+'%'  
 and c1.trader like ltrim(@trader)+'%'  
 AND s.TRADEQTY <> '0'    
 and status <> 'N'  
 and c1.sub_broker = sb.sub_broker  
 and sb.sub_broker = @statusname  
 and s.table_no = b.table_no
 and s.line_no = b.line_no
 and scrip_cd like ltrim(@scripcd)+'%'  
 group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series,
 s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, s.brokapplied,  
 c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy1,s.user_id,s.sett_no,s.tmark ,s.table_no,s.line_no,s.val_perc,  b.trd_del, s.nsertax ,billflag


 union all  
  
 SELECT s.party_code, tm=convert(varchar,sauda_date,108),  
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date,   
 s.Scrip_CD, s.series,s.user_id,  
 sdt = convert(VARchar,sauda_date,103),  
 s.sell_buy, service_tax = isnull(s.service_tax,0),  
 pqty = isnull((case sell_buy when 1 then s.tradeqty end),0),  
 sqty = isnull((case sell_buy  when 2 then s.tradeqty end),0),  
 prate = isnull((case sell_buy  when 1 then s.marketrate end),0),  
 srate = isnull((case sell_buy  when 2 then s.marketrate end),0),  
 pbrok = isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 sbrok = abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 pnetrate = s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 snetrate = s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0))), /*commented by bhagyashree on 28-05-2001*/  
 pamt = s.tradeqty * (s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 samt = s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)))), /*commented by bhagyashree on 28-05-2001*/  
 Brokerage = isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
 NewBrokerage  = isnull(tradeqty*convert(numeric(9,2),nbrokapp),0),  
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy1,s.sett_no,s.tmark,  
 s.table_no,s.line_no,s.val_perc, trd_del = ( case when billflag<4 then b.trd_del else 'D' end ),billflag,nsertax = isnull(s.nsertax,0)
, pdbrok = isnull((case sell_buy  
  when 1 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
  sdbrok = abs(isnull((case sell_buy  
  when 2 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0)) /*commented by bhagyashree on 28-05-2001*/  

 from history s  ,  client1 c1, client2 c2 ,subbrokers sb  , broktable b
 where s.party_code = c2.party_code  
 and c1.cl_code =  c2.cl_code  
 and s.Party_Code like ltrim(@code)+'%'  
 and convert(varchar,s.sauda_date,103) = @sdate  
 and c1.short_name like ltrim(@name)+'%'  
 and c1.trader like ltrim(@trader)+'%'  
 AND s.TRADEQTY <> '0'    
 and status <> 'N'  
 and c1.sub_broker = sb.sub_broker  
 and sb.sub_broker = @statusname  
 and s.table_no = b.table_no
 and s.line_no = b.line_no
 and scrip_cd like ltrim(@scripcd)+'%'  
 group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series, 
 s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, s.brokapplied,  
 c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy1,s.user_id,s.sett_no,s.tmark ,s.table_no,s.line_no,s.val_perc,  b.trd_del, s.nsertax ,billflag


 Order By s.party_code, s.scrip_cd ,  billflag

end  
  
/*----------------------------------------------------statusid =subbroker  ends   ------------------------------------------------------------------------------------------------*/  
  
  
  
/*----------------------------------------------------statusid =branch  starts   ------------------------------------------------------------------------------------------------*/  
  
  
if @statusid ='branch'  
begin  
 SELECT s.party_code, tm=convert(varchar,sauda_date,108),  
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date,   
 s.Scrip_CD, s.series,s.user_id,  
 sdt = convert(VARchar,sauda_date,103),  
 s.sell_buy, service_tax = isnull(s.service_tax,0),  
 pqty = isnull((case sell_buy when 1 then s.tradeqty end),0),  
 sqty = isnull((case sell_buy  when 2 then s.tradeqty end),0),  
 prate = isnull((case sell_buy  when 1 then s.marketrate end),0),  
 srate = isnull((case sell_buy  when 2 then s.marketrate end),0),  
 pbrok = isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 sbrok = abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 pnetrate = s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 snetrate = s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0))), /*commented by bhagyashree on 28-05-2001*/  
 pamt = s.tradeqty * (s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 samt = s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)))), /*commented by bhagyashree on 28-05-2001*/  
 Brokerage = isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
 NewBrokerage  = isnull(tradeqty*convert(numeric(9,2),nbrokapp),0),  
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy1,s.sett_no,s.tmark,  
 s.table_no,s.line_no,s.val_perc, trd_del = ( case when billflag<4 then b.trd_del else 'D' end ),billflag,nsertax = isnull(s.nsertax,0)
, pdbrok = isnull((case sell_buy  
  when 1 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
  sdbrok = abs(isnull((case sell_buy  
  when 2 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0)) /*commented by bhagyashree on 28-05-2001*/  

 from settlement s , client1 c1, client2 c2 , branches br  , broktable b
 where s.party_code = c2.party_code  
 and c1.cl_code =  c2.cl_code  
 and s.Party_Code like ltrim(@code)+'%'  
 and convert(varchar,s.sauda_date,103) = @sdate  
 and c1.short_name like ltrim(@name)+'%'  
 and c1.trader like ltrim(@trader)+'%'  
 AND s.TRADEQTY <> '0'    
 and status <> 'N'  
 and br.short_name = c1.trader  
 and br.branch_cd   = @statusname  
 and s.table_no = b.table_no
 and s.line_no = b.line_no
 and scrip_cd like ltrim(@scripcd)+'%'  
 group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series,
 s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, s.brokapplied,  
 c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy1,s.user_id,s.sett_no,s.tmark ,s.table_no,s.line_no,s.val_perc,  b.trd_del, s.nsertax ,billflag

   
 
 union all  
  

 SELECT s.party_code, tm=convert(varchar,sauda_date,108),  
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date,   
 s.Scrip_CD, s.series,s.user_id,  
 sdt = convert(VARchar,sauda_date,103),  
 s.sell_buy, service_tax = isnull(s.service_tax,0),  
 pqty = isnull((case sell_buy when 1 then s.tradeqty end),0),  
 sqty = isnull((case sell_buy  when 2 then s.tradeqty end),0),  
 prate = isnull((case sell_buy  when 1 then s.marketrate end),0),  
 srate = isnull((case sell_buy  when 2 then s.marketrate end),0),  
 pbrok = isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 sbrok = abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 pnetrate = s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 snetrate = s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0))), /*commented by bhagyashree on 28-05-2001*/  
 pamt = s.tradeqty * (s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 samt = s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)))), /*commented by bhagyashree on 28-05-2001*/  
 Brokerage = isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
 NewBrokerage  = isnull(tradeqty*convert(numeric(9,2),nbrokapp),0),  
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy1,s.sett_no,s.tmark,  
 s.table_no,s.line_no,s.val_perc, trd_del = ( case when billflag<4 then b.trd_del else 'D' end ),billflag,nsertax = isnull(s.nsertax,0)
, pdbrok = isnull((case sell_buy  
  when 1 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
  sdbrok = abs(isnull((case sell_buy  
  when 2 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0)) /*commented by bhagyashree on 28-05-2001*/  

 from history s , client1 c1, client2 c2 , branches br  , broktable b
 where s.party_code = c2.party_code  
 and c1.cl_code =  c2.cl_code  
 and s.Party_Code like ltrim(@code)+'%'  
 and convert(varchar,s.sauda_date,103) = @sdate  
 and c1.short_name like ltrim(@name)+'%'  
 and c1.trader like ltrim(@trader)+'%'  
 AND s.TRADEQTY <> '0'    
 and status <> 'N'  
 and br.short_name = c1.trader  
 and br.branch_cd   = @statusname  
 and s.table_no = b.table_no
 and s.line_no = b.line_no
 and scrip_cd like ltrim(@scripcd)+'%'  
 group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series,
 s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, s.brokapplied,  
 c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy1,s.user_id,s.sett_no,s.tmark ,s.table_no,s.line_no,s.val_perc,  b.trd_del, s.nsertax ,billflag

   

 Order By s.party_code, s.scrip_cd ,  billflag
  
end  
  
/*----------------------------------------------------statusid =branch  ends   ------------------------------------------------------------------------------------------------*/  
  
  
  
  
/*----------------------------------------------------statusid = trader starts   ------------------------------------------------------------------------------------------------*/  
  
  
if @statusid ='trader'  
begin  
 SELECT s.party_code, tm=convert(varchar,sauda_date,108),  
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date,   
 s.Scrip_CD, s.series,s.user_id,  
 sdt = convert(VARchar,sauda_date,103),  
 s.sell_buy, service_tax = isnull(s.service_tax,0),  
 pqty = isnull((case sell_buy when 1 then s.tradeqty end),0),  
 sqty = isnull((case sell_buy  when 2 then s.tradeqty end),0),  
 prate = isnull((case sell_buy  when 1 then s.marketrate end),0),  
 srate = isnull((case sell_buy  when 2 then s.marketrate end),0),  
 pbrok = isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 sbrok = abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 pnetrate = s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 snetrate = s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0))), /*commented by bhagyashree on 28-05-2001*/  
 pamt = s.tradeqty * (s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 samt = s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)))), /*commented by bhagyashree on 28-05-2001*/  
 Brokerage = isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
 NewBrokerage  = isnull(tradeqty*convert(numeric(9,2),nbrokapp),0),  
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy1,s.sett_no,s.tmark,  
 s.table_no,s.line_no,s.val_perc, trd_del = ( case when billflag<4 then b.trd_del else 'D' end ),billflag,nsertax = isnull(s.nsertax,0)
, pdbrok = isnull((case sell_buy  
  when 1 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
  sdbrok = abs(isnull((case sell_buy  
  when 2 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0)) /*commented by bhagyashree on 28-05-2001*/  

 from settlement s , client1 c1, client2 c2  , broktable b
 where s.party_code = c2.party_code  
 and c1.cl_code =  c2.cl_code  
 and s.Party_Code like ltrim(@code)+'%'  
 and convert(varchar,s.sauda_date,103) = @sdate  
 and c1.short_name like ltrim(@name)+'%'  
 and c1.trader like ltrim(@trader)+'%'  
 AND s.TRADEQTY <> '0'    
 and status <> 'N'  
 and c1.trader = @statusname  
 and s.table_no = b.table_no
 and s.line_no = b.line_no
 and scrip_cd like ltrim(@scripcd)+'%'  
 group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series,
 s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, s.brokapplied,  
 c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy1,s.user_id,s.sett_no,s.tmark ,s.table_no,s.line_no,s.val_perc,  b.trd_del, s.nsertax ,billflag

   
 
 union all  
  
 SELECT s.party_code, tm=convert(varchar,sauda_date,108),  
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date,   
 s.Scrip_CD, s.series,s.user_id,  
 sdt = convert(VARchar,sauda_date,103),  
 s.sell_buy, service_tax = isnull(s.service_tax,0),  
 pqty = isnull((case sell_buy when 1 then s.tradeqty end),0),  
 sqty = isnull((case sell_buy  when 2 then s.tradeqty end),0),  
 prate = isnull((case sell_buy  when 1 then s.marketrate end),0),  
 srate = isnull((case sell_buy  when 2 then s.marketrate end),0),  
 pbrok = isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 sbrok = abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 pnetrate = s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 snetrate = s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0))), /*commented by bhagyashree on 28-05-2001*/  
 pamt = s.tradeqty * (s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 samt = s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)))), /*commented by bhagyashree on 28-05-2001*/  
 Brokerage = isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
 NewBrokerage  = isnull(tradeqty*convert(numeric(9,2),nbrokapp),0),  
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy1,s.sett_no,s.tmark,  
 s.table_no,s.line_no,s.val_perc, trd_del = ( case when billflag<4 then b.trd_del else 'D' end ),billflag,nsertax = isnull(s.nsertax,0)
, pdbrok = isnull((case sell_buy  
  when 1 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
  sdbrok = abs(isnull((case sell_buy  
  when 2 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0)) /*commented by bhagyashree on 28-05-2001*/  

 from history s  , client1 c1, client2 c2  , broktable b
 where s.party_code = c2.party_code  
 and c1.cl_code =  c2.cl_code  
 and s.Party_Code like ltrim(@code)+'%'  
 and convert(varchar,s.sauda_date,103) = @sdate  
 and c1.short_name like ltrim(@name)+'%'  
 and c1.trader like ltrim(@trader)+'%'  
 AND s.TRADEQTY <> '0'    
 and status <> 'N'  
 and c1.trader = @statusname  
 and s.table_no = b.table_no
 and s.line_no = b.line_no
 and scrip_cd like ltrim(@scripcd)+'%'  
 group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series,
 s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, s.brokapplied,  
 c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy1,s.user_id,s.sett_no,s.tmark ,s.table_no,s.line_no,s.val_perc,  b.trd_del, s.nsertax ,billflag

   
 

 Order By s.party_code, s.scrip_cd ,  billflag
  
end  
  
/*----------------------------------------------------statusid = trader  ends   ------------------------------------------------------------------------------------------------*/  
  
  
  
/*----------------------------------------------------statusid = family starts   ------------------------------------------------------------------------------------------------*/  
  
  
if @statusid ='family'  
begin  
 SELECT s.party_code, tm=convert(varchar,sauda_date,108),  
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date,   
 s.Scrip_CD, s.series,s.user_id,  
 sdt = convert(VARchar,sauda_date,103),  
 s.sell_buy, service_tax = isnull(s.service_tax,0),  
 pqty = isnull((case sell_buy when 1 then s.tradeqty end),0),  
 sqty = isnull((case sell_buy  when 2 then s.tradeqty end),0),  
 prate = isnull((case sell_buy  when 1 then s.marketrate end),0),  
 srate = isnull((case sell_buy  when 2 then s.marketrate end),0),  
 pbrok = isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 sbrok = abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 pnetrate = s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 snetrate = s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0))), /*commented by bhagyashree on 28-05-2001*/  
 pamt = s.tradeqty * (s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 samt = s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)))), /*commented by bhagyashree on 28-05-2001*/  
 Brokerage = isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
 NewBrokerage  = isnull(tradeqty*convert(numeric(9,2),nbrokapp),0),  
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy1,s.sett_no,s.tmark,  
 s.table_no,s.line_no,s.val_perc, trd_del = ( case when billflag<4 then b.trd_del else 'D' end ),billflag,nsertax = isnull(s.nsertax,0)
, pdbrok = isnull((case sell_buy  
  when 1 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
  sdbrok = abs(isnull((case sell_buy  
  when 2 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0)) /*commented by bhagyashree on 28-05-2001*/  

 from settlement s , client1 c1, client2 c2  , broktable b
 where s.party_code = c2.party_code  
 and c1.cl_code =  c2.cl_code  
 and s.Party_Code like ltrim(@code)+'%'  
 and convert(varchar,s.sauda_date,103) = @sdate  
 and c1.short_name like ltrim(@name)+'%'  
 and c1.trader like ltrim(@trader)+'%'  
 AND s.TRADEQTY <> '0'    
 and status <> 'N'  
 and c1.family = @statusname  
 and s.table_no = b.table_no
 and s.line_no = b.line_no
 and scrip_cd like ltrim(@scripcd)+'%'  
 group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series, 
 s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, s.brokapplied,  
 c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy1,s.user_id,s.sett_no,s.tmark ,s.table_no,s.line_no,s.val_perc,  b.trd_del, s.nsertax ,billflag

   
   
 union all  
  
 SELECT s.party_code, tm=convert(varchar,sauda_date,108),  
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date,   
 s.Scrip_CD, s.series,s.user_id,  
 sdt = convert(VARchar,sauda_date,103),  
 s.sell_buy, service_tax = isnull(s.service_tax,0),  
 pqty = isnull((case sell_buy when 1 then s.tradeqty end),0),  
 sqty = isnull((case sell_buy  when 2 then s.tradeqty end),0),  
 prate = isnull((case sell_buy  when 1 then s.marketrate end),0),  
 srate = isnull((case sell_buy  when 2 then s.marketrate end),0),  
 pbrok = isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 sbrok = abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 pnetrate = s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 snetrate = s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0))), /*commented by bhagyashree on 28-05-2001*/  
 pamt = s.tradeqty * (s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 samt = s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)))), /*commented by bhagyashree on 28-05-2001*/  
 Brokerage = isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
 NewBrokerage  = isnull(tradeqty*convert(numeric(9,2),nbrokapp),0),  
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy1,s.sett_no,s.tmark,  
 s.table_no,s.line_no,s.val_perc, trd_del = ( case when billflag<4 then b.trd_del else 'D' end ),billflag,nsertax = isnull(s.nsertax,0)
, pdbrok = isnull((case sell_buy  
  when 1 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
  sdbrok = abs(isnull((case sell_buy  
  when 2 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0)) /*commented by bhagyashree on 28-05-2001*/  

 from history s , client1 c1, client2 c2  , broktable b
 where s.party_code = c2.party_code  
 and c1.cl_code =  c2.cl_code  
 and s.Party_Code like ltrim(@code)+'%'  
 and convert(varchar,s.sauda_date,103) = @sdate  
 and c1.short_name like ltrim(@name)+'%'  
 and c1.trader like ltrim(@trader)+'%'  
 AND s.TRADEQTY <> '0'    
 and status <> 'N'  
 and c1.family = @statusname  
 and s.table_no = b.table_no
 and s.line_no = b.line_no
 and scrip_cd like ltrim(@scripcd)+'%'  
 group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series, 
 s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, s.brokapplied,  
 c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy1,s.user_id,s.sett_no,s.tmark ,s.table_no,s.line_no,s.val_perc,  b.trd_del, s.nsertax ,billflag

   

 Order By s.party_code, s.scrip_cd ,  billflag
  
end  
  
/*----------------------------------------------------statusid = family  ends   ------------------------------------------------------------------------------------------------*/  
  
  
  
  
/*----------------------------------------------------statusid = client starts   ------------------------------------------------------------------------------------------------*/  
  
  
if @statusid = 'client'  
begin  
 SELECT s.party_code, tm=convert(varchar,sauda_date,108),  
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date,   
 s.Scrip_CD, s.series,s.user_id,  
 sdt = convert(VARchar,sauda_date,103),  
 s.sell_buy, service_tax = isnull(s.service_tax,0),  
 pqty = isnull((case sell_buy when 1 then s.tradeqty end),0),  
 sqty = isnull((case sell_buy  when 2 then s.tradeqty end),0),  
 prate = isnull((case sell_buy  when 1 then s.marketrate end),0),  
 srate = isnull((case sell_buy  when 2 then s.marketrate end),0),  
 pbrok = isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 sbrok = abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 pnetrate = s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 snetrate = s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0))), /*commented by bhagyashree on 28-05-2001*/  
 pamt = s.tradeqty * (s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 samt = s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)))), /*commented by bhagyashree on 28-05-2001*/  
 Brokerage = isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
 NewBrokerage  = isnull(tradeqty*convert(numeric(9,2),nbrokapp),0),  
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy1,s.sett_no,s.tmark,  
 s.table_no,s.line_no,s.val_perc, trd_del = ( case when billflag<4 then b.trd_del else 'D' end ),billflag,nsertax = isnull(s.nsertax,0)
, pdbrok = isnull((case sell_buy  
  when 1 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
  sdbrok = abs(isnull((case sell_buy  
  when 2 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0)) /*commented by bhagyashree on 28-05-2001*/  

 from settlement s  , client1 c1, client2 c2  , broktable b
 where s.party_code = c2.party_code  
 and c1.cl_code =  c2.cl_code  
 and s.Party_Code like ltrim(@code)+'%'  
 and convert(varchar,s.sauda_date,103) = @sdate  
 and c1.short_name like ltrim(@name)+'%'  
 and c1.trader like ltrim(@trader)+'%'  
 AND s.TRADEQTY <> '0'    
 and status <> 'N'  
 and c2.party_code =@statusname  
 and s.table_no = b.table_no
 and s.line_no = b.line_no
 and scrip_cd like ltrim(@scripcd)+'%'  
 group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series,
 s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, s.brokapplied,  
 c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy1,s.user_id,s.sett_no,s.tmark ,s.table_no,s.line_no,s.val_perc,  b.trd_del, s.nsertax ,billflag

   
   
 union all  
  
 SELECT s.party_code, tm=convert(varchar,sauda_date,108),  
 tdate=convert(varchar,sauda_date,103),  s.trade_no,convert(varchar,s.sauda_date,103) as sauda_date,   
 s.Scrip_CD, s.series,s.user_id,  
 sdt = convert(VARchar,sauda_date,103),  
 s.sell_buy, service_tax = isnull(s.service_tax,0),  
 pqty = isnull((case sell_buy when 1 then s.tradeqty end),0),  
 sqty = isnull((case sell_buy  when 2 then s.tradeqty end),0),  
 prate = isnull((case sell_buy  when 1 then s.marketrate end),0),  
 srate = isnull((case sell_buy  when 2 then s.marketrate end),0),  
 pbrok = isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 sbrok = abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 pnetrate = s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
 snetrate = s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0))), /*commented by bhagyashree on 28-05-2001*/  
 pamt = s.tradeqty * (s.marketrate+isnull((case sell_buy  
  when 1 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)), /*commented by bhagyashree on 28-05-2001*/  
 samt = s.tradeqty * (s.marketrate-(abs(isnull((case sell_buy  
  when 2 then round(s.brokapplied + (case when c2.service_chrg=1 then (s.service_tax/s.tradeqty) else 0 end),2) end),0)))), /*commented by bhagyashree on 28-05-2001*/  
 Brokerage = isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
 NewBrokerage  = isnull(tradeqty*convert(numeric(9,2),nbrokapp),0),  
 c1.short_name, c1.trader, c1.Res_Phone1, c2.service_chrg, c1.cl_code,s.dummy1,s.sett_no,s.tmark,  
 s.table_no,s.line_no,s.val_perc, trd_del = ( case when billflag<4 then b.trd_del else 'D' end ),billflag,nsertax = isnull(s.nsertax,0)
, pdbrok = isnull((case sell_buy  
  when 1 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0), /*commented by bhagyashree on 28-05-2001*/  
  sdbrok = abs(isnull((case sell_buy  
  when 2 then round(s.nbrokapp + (case when c2.service_chrg=1 then (s.nsertax/s.tradeqty) else 0 end),2) end),0)) /*commented by bhagyashree on 28-05-2001*/  

 from history s , client1 c1, client2 c2  , broktable b
 where s.party_code = c2.party_code  
 and c1.cl_code =  c2.cl_code  
 and s.Party_Code like ltrim(@code)+'%'  
 and convert(varchar,s.sauda_date,103) = @sdate  
 and c1.short_name like ltrim(@name)+'%'  
 and c1.trader like ltrim(@trader)+'%'  
 AND s.TRADEQTY <> '0'    
 and status <> 'N'  
 and c2.party_code =@statusname  
 and s.table_no = b.table_no
 and s.line_no = b.line_no
 and scrip_cd like ltrim(@scripcd)+'%'  
 group by s.party_code,billno,  trade_no, sauda_date, s.scrip_cd, s.series, 
 s.sell_buy  ,  c1.short_name, c1.trader, c1.Res_Phone1 , s.service_tax, s.marketrate, s.tradeqty, s.brokapplied,  
 c2.service_chrg, s.nbrokapp, c1.cl_code ,s.dummy1,s.user_id,s.sett_no,s.tmark ,s.table_no,s.line_no,s.val_perc,  b.trd_del, s.nsertax ,billflag

   

 Order By s.party_code, s.scrip_cd ,  billflag
  
end  
  
  
  
/*----------------------------------------------------statusid = client  ends   ------------------------------------------------------------------------------------------------*/

GO
