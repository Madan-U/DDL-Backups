-- Object: PROCEDURE dbo.ContSection
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ContSection    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.ContSection    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.ContSection    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.ContSection    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.ContSection    Script Date: 12/27/00 8:58:48 PM ******/

CREATE proc ContSection (@Sdate varchar(12), @Sett_Type varchar(2), @ContNo varchar(6)) as
SELECT distinct  settlement.contractNo,settlement.party_code,settlement.order_no ,tm=convert(char,sauda_date,108),
 settlement.trade_no, settlement.sauda_date,settlement.scrip_cd,scripname=scrip1.short_name,sdt=convert(char,sauda_date,103),
 settlement.sell_buy,settlement.markettype,broker_chrg=isnull(settlement.broker_chrg,0),
 service_tax=isnull(settlement.service_tax,0),
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
 Brokerage=isnull((tradeqty*brokapplied),0)
from settlement,scrip1,scrip2
where settlement.scrip_cd=scrip2.scrip_cd
 and settlement.series=scrip2.series
 and scrip2.co_code=scrip1.co_code
 and scrip2.series=scrip1.series
 and rtrim(settlement.sett_type) = @sett_Type
 and settlement.sauda_date LIKE  @sdate + '%'
 and settlement.party_code not in ('40', '30')
 and settlement.tradeqty <> 0
 and convert(int,settlement.contractno) = @ContNo 
union 
SELECT distinct  history.contractNo,history.party_code,history.order_no ,tm=convert(char,sauda_date,108),
 history.trade_no, history.sauda_date,history.scrip_cd,scripname=scrip1.short_name,sdt=convert(char,sauda_date,103),
 history.sell_buy,history.markettype,broker_chrg=isnull(history.broker_chrg,0),
 service_tax=isnull(history.service_tax,0),
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
 Brokerage=isnull((tradeqty*brokapplied),0)
from history,scrip1,scrip2
where history.scrip_cd=scrip2.scrip_cd
 and history.series=scrip2.series
 and scrip2.co_code=scrip1.co_code
 and scrip2.series=scrip1.series
 and rtrim(history.sett_type) = @sett_Type
 and history.sauda_date like  @sdate + '%'
 and history.party_code not in ('40', '30')
 and history.tradeqty <> 0
 and convert(int,history.contractno) = @ContNo 
order by scrip1.short_name

GO
