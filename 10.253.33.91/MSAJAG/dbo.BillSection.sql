-- Object: PROCEDURE dbo.BillSection
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BillSection    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.BillSection    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.BillSection    Script Date: 20-Mar-01 11:38:43 PM ******/

/****** Object:  Stored Procedure dbo.BillSection    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.BillSection    Script Date: 12/27/00 8:58:43 PM ******/

CREATE proc BillSection (@Sett_No varchar(10), @Sett_Type varchar(2), @BillNo varchar(6)) as
SELECT settlement.party_code, settlement.billno,settlement.contractno, settlement.order_no ,tm=convert(char,sauda_date,8),
 settlement.trade_no, settlement.sauda_date,settlement.scrip_cd,settlement.series,
 scripname=scrip1.short_name,sdt=substring(convert(VARchar,sauda_date,109),1,11),
 settlement.sell_buy,settlement.markettype,
 service_tax = isnull(settlement.service_tax,0),
 NSertax ,  N_NetRate,
 pqty=isnull((case sell_buy
  when 1 then settlement.tradeqty end),0),
 sqty=isnull((case sell_buy
  when 2 then settlement.tradeqty end),0),
 prate=isnull((case sell_buy
  when 1 then settlement.marketrate end),0),
 srate=isnull((case sell_buy
  when 2 then settlement.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then settlement.brokapplied end),0),
 sbrok=isnull((case sell_buy
  when 2 then settlement.brokapplied end),0),
 pnetrate=isnull((case sell_buy
  when 1 then settlement.netrate end),0),
 snetrate=isnull((case sell_buy
  when 2 then settlement.netrate end),0),
 pamt=isnull((case sell_buy
  when 1 then settlement.amount end),0),
 samt=isnull((case sell_buy
  when 2 then settlement.amount end),0),
 Brokerage=isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,
 NewBrokerage =isnull(tradeqty*convert(numeric(9,2),nbrokapp),0) 
from settlement,scrip1,scrip2
where settlement.scrip_cd=scrip2.scrip_cd
 and settlement.series=scrip2.series
 and scrip2.co_code=scrip1.co_code
 and scrip2.series=scrip1.series
        and settlement.sett_no = @sett_no
        and settlement.sett_type = @sett_type
 and settlement.billno like @billno
 AND SETTLEMENT.BILLNO <> '0' 
 AND SETTLEMENT.TRADEQTY <> '0'
union
SELECT distinct history.party_code, history.billno,history.contractno, history.order_no ,tm=convert(char,sauda_date,8),
 history.trade_no, history.sauda_date,history.scrip_cd,history.series,
 scripname=scrip1.short_name,sdt=substring(convert(VARchar,sauda_date,109),1,11),
 history.sell_buy,history.markettype,
 service_tax = isnull(history.service_tax,0),
 NSertax ,  N_NetRate,
 pqty=isnull((case sell_buy
  when 1 then history.tradeqty end),0),
 sqty=isnull((case sell_buy
  when 2 then history.tradeqty end),0),
 prate=isnull((case sell_buy
  when 1 then history.marketrate end),0),
 srate=isnull((case sell_buy
  when 2 then history.marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then history.brokapplied end),0),
 sbrok=isnull((case sell_buy
  when 2 then history.brokapplied end),0),
 pnetrate=isnull((case sell_buy
  when 1 then history.netrate end),0),
 snetrate=isnull((case sell_buy
  when 2 then history.netrate end),0),
 pamt=isnull((case sell_buy
  when 1 then history.amount end),0),
 samt=isnull((case sell_buy
  when 2 then history.amount end),0),
 Brokerage=isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,
 NewBrokerage =isnull(tradeqty*convert(numeric(9,2),nbrokapp),0) 
from history,scrip1,scrip2
where history.scrip_cd=scrip2.scrip_cd
 and history.series=scrip2.series
 and scrip2.co_code=scrip1.co_code
 and scrip2.series=scrip1.series
        and history.sett_no = @sett_no
        and history.sett_type = @sett_type
 and history.billno like @billno
 AND history.BILLNO <> '0' 
 AND history.TRADEQTY <> '0'
order by settlement.party_code,scrip1.short_name,settlement.sauda_date

GO
