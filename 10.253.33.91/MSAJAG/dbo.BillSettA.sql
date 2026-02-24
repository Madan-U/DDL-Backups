-- Object: PROCEDURE dbo.BillSettA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BillSettA    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.BillSettA    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.BillSettA    Script Date: 20-Mar-01 11:38:43 PM ******/

/****** Object:  Stored Procedure dbo.BillSettA    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.BillSettA    Script Date: 12/27/00 8:58:43 PM ******/

/****** Object:  Stored Procedure dbo.BillSettA    Script Date: 12/18/99 8:24:11 AM ******/
create proc BillSettA
(@sett_no varchar(7),@sett_type varchar(1),@party varchar(10))
as 
SELECT distinct settlement.party_code, settlement.billno, settlement.order_no ,tm=convert(char,sauda_date,8),
 settlement.trade_no, settlement.sauda_date,settlement.scrip_cd,settlement.series,
 scripname=scrip1.short_name,sdt=convert(char,sauda_date,3),
 settlement.sell_buy,settlement.markettype,ins_chrg=isnull(settlement.ins_chrg,0),
 turn_tax=isnull(settlement.turn_tax,0),other_chrg=isnull(settlement.other_chrg,0),
 sebi_tax=isnull(settlement.sebi_tax,0),broker_chrg=isnull(settlement.broker_chrg,0),
 service_tax = isnull(settlement.service_tax,0),
 partyname=client1.short_name,client1.l_address1,client1.l_address2,client1.l_address3,
 client1.l_city,client1.l_state,client1.l_nation,client1.l_zip,
 client1.fax,client1.phoneold,
 sett_mst.sett_no,sett_mst.start_date,sett_mst.end_date,
 taxes.insurance_chrg,taxes.turnover_Tax,taxes.sebiturn_tax,
 taxes.broker_note, NSertax ,  N_NetRate,
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
from settlement,client1,client2,sett_mst,taxes,globals,scrip1,scrip2
where settlement.party_code like @party
 and settlement.party_code=client2.party_code
 and client2.cl_code=client1.cl_code
 and settlement.scrip_cd=scrip2.scrip_cd
 and settlement.series=scrip2.series
 and scrip2.co_code=scrip1.co_code
 and scrip2.series=scrip1.series
 and ((settlement.sauda_date <=sett_mst.end_date) and (settlement.sauda_date >= sett_mst.start_date))
 and client2.tran_cat=taxes.trans_cat
 and taxes.exchange='NSE'
        and settlement.sett_no = sett_mst.sett_no
 and settlement.sett_no like @sett_no
 and settlement.sett_type = sett_mst.sett_type
        and settlement.sett_type like @sett_type
order by settlement.party_code

GO
