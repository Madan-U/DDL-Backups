-- Object: PROCEDURE dbo.recontract
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.recontract    Script Date: 3/17/01 9:55:54 PM ******/

/****** Object:  Stored Procedure dbo.recontract    Script Date: 3/21/01 12:50:11 PM ******/

/****** Object:  Stored Procedure dbo.recontract    Script Date: 20-Mar-01 11:38:53 PM ******/

/****** Object:  Stored Procedure dbo.recontract    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.recontract    Script Date: 12/27/00 8:58:52 PM ******/

CREATE PROCEDURE recontract
 @contdt char(8) ,@fparty char(10),@tparty char(10)
AS
declare @@Mystr char(30)
declare @@D datetime
/* select @@d =  */
/*
select @@p= 'Contract Date ' + @contdt /*(CONVERT(char(12), @contdt))*/
print @@p
print'-------'
select @@p ='Starting party ' + @fparty 
print @@p
print'-------'
select @@p ='Last party ' + @tparty 
print @@p
print '-------'
print ' if starting party is null then start from 000000'
print ' if last party is null then end party is 999999'
print '-------------------'
*/
SELECT distinct settlement.party_code, settlement.contractno , settlement.order_no ,tm=convert(char,sauda_date,108),
 settlement.trade_no, settlement.sauda_date,settlement.scrip_cd,scripname=scrip1.short_name,sdt=convert(char,sauda_date,3),
 settlement.sell_buy,settlement.auctionpart,ins_chrg=isnull(settlement.ins_chrg,0),
 turn_tax=isnull(settlement.turn_tax,0),other_chrg=isnull(settlement.other_chrg,0),
 sebi_tax=isnull(settlement.sebi_tax,0),broker_chrg=isnull(settlement.broker_chrg,0),
 service_tax=isnull(settlement.service_tax,0),
 partyname=client1.short_name,client1.l_address1,client1.l_address2,client1.l_address3,
 client1.l_city,client1.l_state,client1.l_nation,client1.l_zip,
 client1.fax,client1.phoneold,
 sett_mst.sett_no,sett_mst.start_date,sett_mst.end_date,
 taxes.insurance_chrg,taxes.turnover_Tax,taxes.sebiturn_tax,
 taxes.broker_note,SerTax=globals.service_tax,globals.year,globals.exchange,
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
from settlement,client1,client2,sett_mst,taxes,globals,scrip1,scrip2
where settlement.party_code=client2.party_code
 and client2.cl_code=client1.cl_code
 and settlement.scrip_cd=scrip2.scrip_cd
 and settlement.series=scrip2.series
 and scrip2.co_code=scrip1.co_code
 and scrip2.series=scrip1.series
 and ((settlement.sauda_date <=sett_mst.end_date) and (settlement.sauda_date >= sett_mst.start_date))
 and client2.tran_cat=taxes.trans_cat
 and taxes.exchange='NSE'
 and settlement.settflag <> null
        and settlement.sett_no = sett_mst.sett_no
        and settlement.sett_type = sett_mst.sett_type
        and convert(char ,settlement.sauda_date,3) = @contdt
 and ((settlement.party_code >= isnull(@fparty,'          ')) 
        and (settlement.party_code <= isnull(@tparty,'zzzzzzzzzz')))
order by settlement.party_code

GO
