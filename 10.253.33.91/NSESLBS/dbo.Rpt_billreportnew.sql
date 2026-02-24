-- Object: PROCEDURE dbo.Rpt_billreportnew
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_billreportnew    Script Date: 01/15/2005 1:27:52 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_billreportnew    Script Date: 12/16/2003 2:31:43 Pm ******/  
  
  
  
/****** Object:  Stored Procedure Dbo.rpt_billreportnew    Script Date: 05/08/2002 12:35:08 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_billreportnew    Script Date: 01/14/2002 20:32:52 ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_billreportnew    Script Date: 12/14/2001 1:25:14 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_billreportnew    Script Date: 11/30/01 4:48:32 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_billreportnew    Script Date: 11/5/01 1:27:16 Pm ******/  
Create Procedure Rpt_billreportnew  
  
@statusid Varchar(15),  
@statusname Varchar(25),  
@settno Varchar(10),  
@settype Varchar(3),  
@fpartycode Varchar(10),  
@tpartycode Varchar(10)  
  
As  
  
If @statusid = 'broker'  
Begin  
  Select Settlement.party_code, Settlement.billno,settlement.contractno ,tm=convert(char,sauda_date,8),  
  Settlement.trade_no,convert(varchar, Settlement.sauda_date,103),settlement.scrip_cd,settlement.series,  
  Scripname=scrip1.short_name,sdt=substring(convert(varchar,sauda_date,109),1,11),  
  Settlement.sell_buy,settlement.markettype, Service_tax = Isnull(settlement.service_tax,0),  
  Nsertax ,  N_netrate,  
  Pqty=isnull((case Sell_buy When 1 Then Settlement.tradeqty End),0),  
  Sqty=isnull((case Sell_buy When 2 Then Settlement.tradeqty End),0),  
  Prate=isnull((case Sell_buy When 1 Then Settlement.marketrate End),0),  
  Srate=isnull((case Sell_buy When 2 Then Settlement.marketrate End),0),  
  Pbrok=isnull((case Sell_buy When 1 Then Settlement.brokapplied End),0),  
  Sbrok=isnull((case Sell_buy When 2 Then Settlement.brokapplied End),0),  
  Pnetrate=isnull((case Sell_buy  
   When 1 Then ( Case When Service_chrg = 1 Then   
   Round((settlement.marketrate + (settlement.brokapplied + (service_tax/tradeqty))),2)  
  Else  
   Round((settlement.marketrate + Settlement.brokapplied),2)   
  End )   
 End),0),  
  Snetrate=isnull((case Sell_buy  
   When 2 Then ( Case When Service_chrg = 1 Then   
   Round((settlement.marketrate -( Settlement.brokapplied + (service_tax/tradeqty))),2)  
  Else  
   Round((settlement.marketrate - Settlement.brokapplied ),2)  
  End )   
 End),0),  
 Pamt=isnull((case Sell_buy  
   When 1 Then ( Case When Service_chrg = 1 Then   
   /*round(((settlement.marketrate + Settlement.brokapplied) * Tradeqty +service_tax),2)*/  
   Tradeqty*(round((settlement.marketrate + (settlement.brokapplied + (service_tax/tradeqty))),2))  
  Else  
   /*round(((settlement.marketrate + Settlement.brokapplied) * Tradeqty),2)*/  
   Tradeqty*(round((settlement.marketrate + Settlement.brokapplied),2) )  
  End )   
 End),0),  
 Samt=isnull((case Sell_buy  
   When 2 Then ( Case When Service_chrg = 1 Then   
   /*round(((settlement.marketrate - Settlement.brokapplied) * Tradeqty - Service_tax),2)*/  
   Tradeqty*(round((settlement.marketrate - (settlement.brokapplied + (service_tax/tradeqty))),2))  
  Else  
   /*round(((settlement.marketrate - Settlement.brokapplied) * Tradeqty),2)*/  
   Tradeqty*(round((settlement.marketrate - Settlement.brokapplied ),2))  
  End )   
  End),0),  
  Brokerage=isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
  Newbrokerage =isnull(tradeqty*convert(numeric(9,2),nbrokapp),0) ,  
  Interest = 0, Fees =0, Slprate=0, Client2.service_chrg, Settlement.sett_no, Settlement.sett_type,  
  Client1.short_name, Client1.l_address1, Client1.l_address2, Client1.l_address3, Client1.l_city,   
  Client1.l_zip, Client1.res_phone1, Client1.off_phone1,  
  Sauda_date = Convert(varchar,settlement.sauda_date,103), Client2.sebi_turn_tax,   
  Client2.other_chrg, Client2.brokernote,  Client2.insurance_chrg, Client2.turnover_tax,   
  Settlement.sebi_tax,other =  Settlement.other_chrg, Settlement.broker_chrg, Client2.brokernote,   
  Client2.insurance_chrg, Settlement.ins_chrg, Client2.turnover_tax, Settlement.turn_tax  
  From Settlement,scrip1,scrip2,client2, Client1  
  Where Settlement.scrip_cd=scrip2.scrip_cd  
  And Settlement.series=scrip2.series And Scrip2.co_code=scrip1.co_code  
  And Scrip2.series=scrip1.series  And Client1.cl_code = Client2.cl_code  
  And Settlement.sett_no = @settno And Settlement.sett_type = @settype  
  And Settlement.party_code >= @fpartycode  And Settlement.party_code <= @tpartycode   
  And Settlement.billno <> '0' And Settlement.tradeqty <> '0'  
 And Client2.party_code = Settlement.party_code  
 Order By Settlement.party_code, Settlement.scrip_cd, Sell_buy  
End   
  
  
If @statusid = 'branch'  
Begin  
  Select Settlement.party_code, Settlement.billno,settlement.contractno ,tm=convert(char,sauda_date,8),  
  Settlement.trade_no,convert(varchar, Settlement.sauda_date,103),settlement.scrip_cd,settlement.series,  
  Scripname=scrip1.short_name,sdt=substring(convert(varchar,sauda_date,109),1,11),  
  Settlement.sell_buy,settlement.markettype, Service_tax = Isnull(settlement.service_tax,0),  
  Nsertax ,  N_netrate,  
  Pqty=isnull((case Sell_buy When 1 Then Settlement.tradeqty End),0),  
  Sqty=isnull((case Sell_buy When 2 Then Settlement.tradeqty End),0),  
  Prate=isnull((case Sell_buy When 1 Then Settlement.marketrate End),0),  
  Srate=isnull((case Sell_buy When 2 Then Settlement.marketrate End),0),  
  Pbrok=isnull((case Sell_buy When 1 Then Settlement.brokapplied End),0),  
  Sbrok=isnull((case Sell_buy When 2 Then Settlement.brokapplied End),0),  
  Pnetrate=isnull((case Sell_buy  
   When 1 Then ( Case When Service_chrg = 1 Then   
   Round((settlement.marketrate + (settlement.brokapplied + (service_tax/tradeqty))),2)  
  Else  
   Round((settlement.marketrate + Settlement.brokapplied),2)   
  End )   
 End),0),  
  Snetrate=isnull((case Sell_buy  
   When 2 Then ( Case When Service_chrg = 1 Then   
   Round((settlement.marketrate -( Settlement.brokapplied + (service_tax/tradeqty))),2)  
  Else  
   Round((settlement.marketrate - Settlement.brokapplied ),2)  
  End )   
 End),0),  
 Pamt=isnull((case Sell_buy  
   When 1 Then ( Case When Service_chrg = 1 Then   
   /*round(((settlement.marketrate + Settlement.brokapplied) * Tradeqty +service_tax),2)*/  
   Tradeqty*(round((settlement.marketrate + (settlement.brokapplied + (service_tax/tradeqty))),2))  
  Else  
   /*round(((settlement.marketrate + Settlement.brokapplied) * Tradeqty),2)*/  
   Tradeqty*(round((settlement.marketrate + Settlement.brokapplied),2) )  
  End )   
 End),0),  
 Samt=isnull((case Sell_buy  
   When 2 Then ( Case When Service_chrg = 1 Then   
   /*round(((settlement.marketrate - Settlement.brokapplied) * Tradeqty - Service_tax),2)*/  
   Tradeqty*(round((settlement.marketrate - (settlement.brokapplied + (service_tax/tradeqty))),2))  
  Else  
   /*round(((settlement.marketrate - Settlement.brokapplied) * Tradeqty),2)*/  
   Tradeqty*(round((settlement.marketrate - Settlement.brokapplied ),2))  
  End )   
  End),0),  
  Brokerage=isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
  Newbrokerage =isnull(tradeqty*convert(numeric(9,2),nbrokapp),0) ,  
  Interest = 0, Fees =0, Slprate=0, Client2.service_chrg, Settlement.sett_no, Settlement.sett_type,  
  Client1.short_name, Client1.l_address1, Client1.l_address2, Client1.l_address3, Client1.l_city,   
  Client1.l_zip, Client1.res_phone1, Client1.off_phone1,  
  Sauda_date = Convert(varchar,settlement.sauda_date,103), Client2.sebi_turn_tax,   
  Client2.other_chrg, Client2.brokernote,  Client2.insurance_chrg, Client2.turnover_tax,   
  Settlement.sebi_tax,other =  Settlement.other_chrg, Settlement.broker_chrg, Client2.brokernote,   
  Client2.insurance_chrg, Settlement.ins_chrg, Client2.turnover_tax, Settlement.turn_tax  
  From Settlement,scrip1,scrip2,client2, Client1, Branches    
  Where Settlement.scrip_cd=scrip2.scrip_cd  
  And Settlement.series=scrip2.series And Scrip2.co_code=scrip1.co_code  
  And Scrip2.series=scrip1.series  And Client1.cl_code = Client2.cl_code  
  And Settlement.sett_no = @settno And Settlement.sett_type = @settype  
  And Settlement.party_code >= @fpartycode  And Settlement.party_code <= @tpartycode   
  And Settlement.billno <> '0' And Settlement.tradeqty <> '0'  
 And Client2.party_code = Settlement.party_code   
 And Branches.short_name = Client1.trader And Branches.branch_cd = @statusname  
 Order By Settlement.party_code, Settlement.scrip_cd, Sell_buy  
End   
  
If @statusid = 'subbroker'  
Begin  
  Select Settlement.party_code, Settlement.billno,settlement.contractno ,tm=convert(char,sauda_date,8),  
  Settlement.trade_no,convert(varchar, Settlement.sauda_date,103),settlement.scrip_cd,settlement.series,  
  Scripname=scrip1.short_name,sdt=substring(convert(varchar,sauda_date,109),1,11),  
  Settlement.sell_buy,settlement.markettype, Service_tax = Isnull(settlement.service_tax,0),  
  Nsertax ,  N_netrate,  
  Pqty=isnull((case Sell_buy When 1 Then Settlement.tradeqty End),0),  
  Sqty=isnull((case Sell_buy When 2 Then Settlement.tradeqty End),0),  
  Prate=isnull((case Sell_buy When 1 Then Settlement.marketrate End),0),  
  Srate=isnull((case Sell_buy When 2 Then Settlement.marketrate End),0),  
  Pbrok=isnull((case Sell_buy When 1 Then Settlement.brokapplied End),0),  
  Sbrok=isnull((case Sell_buy When 2 Then Settlement.brokapplied End),0),  
  Pnetrate=isnull((case Sell_buy  
   When 1 Then ( Case When Service_chrg = 1 Then   
   Round((settlement.marketrate + (settlement.brokapplied + (service_tax/tradeqty))),2)  
  Else  
   Round((settlement.marketrate + Settlement.brokapplied),2)   
  End )   
 End),0),  
  Snetrate=isnull((case Sell_buy  
   When 2 Then ( Case When Service_chrg = 1 Then   
   Round((settlement.marketrate -( Settlement.brokapplied + (service_tax/tradeqty))),2)  
  Else  
   Round((settlement.marketrate - Settlement.brokapplied ),2)  
  End )   
 End),0),  
 Pamt=isnull((case Sell_buy  
   When 1 Then ( Case When Service_chrg = 1 Then   
   /*round(((settlement.marketrate + Settlement.brokapplied) * Tradeqty +service_tax),2)*/  
   Tradeqty*(round((settlement.marketrate + (settlement.brokapplied + (service_tax/tradeqty))),2))  
  Else  
   /*round(((settlement.marketrate + Settlement.brokapplied) * Tradeqty),2)*/  
   Tradeqty*(round((settlement.marketrate + Settlement.brokapplied),2) )  
  End )   
 End),0),  
 Samt=isnull((case Sell_buy  
   When 2 Then ( Case When Service_chrg = 1 Then   
   /*round(((settlement.marketrate - Settlement.brokapplied) * Tradeqty - Service_tax),2)*/  
   Tradeqty*(round((settlement.marketrate - (settlement.brokapplied + (service_tax/tradeqty))),2))  
  Else  
   /*round(((settlement.marketrate - Settlement.brokapplied) * Tradeqty),2)*/  
   Tradeqty*(round((settlement.marketrate - Settlement.brokapplied ),2))  
  End )   
  End),0),  
  Brokerage=isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
  Newbrokerage =isnull(tradeqty*convert(numeric(9,2),nbrokapp),0) ,  
  Interest = 0, Fees =0, Slprate=0, Client2.service_chrg, Settlement.sett_no, Settlement.sett_type,  
  Client1.short_name, Client1.l_address1, Client1.l_address2, Client1.l_address3, Client1.l_city,   
  Client1.l_zip, Client1.res_phone1, Client1.off_phone1,  
  Sauda_date = Convert(varchar,settlement.sauda_date,103), Client2.sebi_turn_tax,   
  Client2.other_chrg, Client2.brokernote,  Client2.insurance_chrg, Client2.turnover_tax,   
  Settlement.sebi_tax,other =  Settlement.other_chrg, Settlement.broker_chrg, Client2.brokernote,   
  Client2.insurance_chrg, Settlement.ins_chrg, Client2.turnover_tax, Settlement.turn_tax  
  From Settlement,scrip1,scrip2,client2, Client1, Subbrokers    
  Where Settlement.scrip_cd=scrip2.scrip_cd  
  And Settlement.series=scrip2.series And Scrip2.co_code=scrip1.co_code  
  And Scrip2.series=scrip1.series  And Client1.cl_code = Client2.cl_code  
  And Settlement.sett_no = @settno And Settlement.sett_type = @settype  
  And Settlement.party_code >= @fpartycode  And Settlement.party_code <= @tpartycode   
  And Settlement.billno <> '0' And Settlement.tradeqty <> '0'  
 And Client2.party_code = Settlement.party_code  
 And Subbrokers.sub_broker = Client1.sub_broker And Subbrokers.sub_broker = @statusname  
 Order By Settlement.party_code, Settlement.scrip_cd, Sell_buy  
End   
  
If @statusid = 'trader'  
Begin  
  Select Settlement.party_code, Settlement.billno,settlement.contractno ,tm=convert(char,sauda_date,8),  
  Settlement.trade_no,convert(varchar, Settlement.sauda_date,103),settlement.scrip_cd,settlement.series,  
  Scripname=scrip1.short_name,sdt=substring(convert(varchar,sauda_date,109),1,11),  
  Settlement.sell_buy,settlement.markettype, Service_tax = Isnull(settlement.service_tax,0),  
  Nsertax ,  N_netrate,  
  Pqty=isnull((case Sell_buy When 1 Then Settlement.tradeqty End),0),  
  Sqty=isnull((case Sell_buy When 2 Then Settlement.tradeqty End),0),   
  Prate=isnull((case Sell_buy When 1 Then Settlement.marketrate End),0),  
  Srate=isnull((case Sell_buy When 2 Then Settlement.marketrate End),0),  
  Pbrok=isnull((case Sell_buy When 1 Then Settlement.brokapplied End),0),  
  Sbrok=isnull((case Sell_buy When 2 Then Settlement.brokapplied End),0),  
  Pnetrate=isnull((case Sell_buy  
   When 1 Then ( Case When Service_chrg = 1 Then   
   Round((settlement.marketrate + (settlement.brokapplied + (service_tax/tradeqty))),2)  
  Else  
   Round((settlement.marketrate + Settlement.brokapplied),2)   
  End )   
 End),0),  
  Snetrate=isnull((case Sell_buy  
   When 2 Then ( Case When Service_chrg = 1 Then   
   Round((settlement.marketrate -( Settlement.brokapplied + (service_tax/tradeqty))),2)  
  Else  
   Round((settlement.marketrate - Settlement.brokapplied ),2)  
  End )   
 End),0),  
 Pamt=isnull((case Sell_buy  
   When 1 Then ( Case When Service_chrg = 1 Then   
   /*round(((settlement.marketrate + Settlement.brokapplied) * Tradeqty +service_tax),2)*/  
   Tradeqty*(round((settlement.marketrate + (settlement.brokapplied + (service_tax/tradeqty))),2))  
  Else  
   /*round(((settlement.marketrate + Settlement.brokapplied) * Tradeqty),2)*/  
   Tradeqty*(round((settlement.marketrate + Settlement.brokapplied),2) )  
  End )   
 End),0),  
 Samt=isnull((case Sell_buy  
   When 2 Then ( Case When Service_chrg = 1 Then   
   /*round(((settlement.marketrate - Settlement.brokapplied) * Tradeqty - Service_tax),2)*/  
   Tradeqty*(round((settlement.marketrate - (settlement.brokapplied + (service_tax/tradeqty))),2))  
  Else  
   /*round(((settlement.marketrate - Settlement.brokapplied) * Tradeqty),2)*/  
   Tradeqty*(round((settlement.marketrate - Settlement.brokapplied ),2))  
  End )   
  End),0),  
  Brokerage=isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
  Newbrokerage =isnull(tradeqty*convert(numeric(9,2),nbrokapp),0) ,  
  Interest = 0, Fees =0, Slprate=0, Client2.service_chrg, Settlement.sett_no, Settlement.sett_type,  
  Client1.short_name, Client1.l_address1, Client1.l_address2, Client1.l_address3, Client1.l_city,   
  Client1.l_zip, Client1.res_phone1, Client1.off_phone1,  
  Sauda_date = Convert(varchar,settlement.sauda_date,103), Client2.sebi_turn_tax,   
  Client2.other_chrg, Client2.brokernote,  Client2.insurance_chrg, Client2.turnover_tax,   
  Settlement.sebi_tax,other =  Settlement.other_chrg, Settlement.broker_chrg, Client2.brokernote,   
  Client2.insurance_chrg, Settlement.ins_chrg, Client2.turnover_tax, Settlement.turn_tax  
  From Settlement,scrip1,scrip2,client2, Client1   
  Where Settlement.scrip_cd=scrip2.scrip_cd  
  And Settlement.series=scrip2.series And Scrip2.co_code=scrip1.co_code  
  And Scrip2.series=scrip1.series  And Client1.cl_code = Client2.cl_code  
  And Settlement.sett_no = @settno And Settlement.sett_type = @settype  
  And Settlement.party_code >= @fpartycode  And Settlement.party_code <= @tpartycode   
  And Settlement.billno <> '0' And Settlement.tradeqty <> '0'  
 And Client2.party_code = Settlement.party_code  
 And Client1.trader = @statusname  
 Order By Settlement.party_code, Settlement.scrip_cd, Sell_buy  
End   
  
If @statusid = 'client'  
Begin  
  Select Settlement.party_code, Settlement.billno,settlement.contractno ,tm=convert(char,sauda_date,8),  
  Settlement.trade_no,convert(varchar, Settlement.sauda_date,103),settlement.scrip_cd,settlement.series,  
  Scripname=scrip1.short_name,sdt=substring(convert(varchar,sauda_date,109),1,11),  
  Settlement.sell_buy,settlement.markettype, Service_tax = Isnull(settlement.service_tax,0),  
  Nsertax ,  N_netrate,  
  Pqty=isnull((case Sell_buy When 1 Then Settlement.tradeqty End),0),  
  Sqty=isnull((case Sell_buy When 2 Then Settlement.tradeqty End),0),  
  Prate=isnull((case Sell_buy When 1 Then Settlement.marketrate End),0),  
  Srate=isnull((case Sell_buy When 2 Then Settlement.marketrate End),0),  
  Pbrok=isnull((case Sell_buy When 1 Then Settlement.brokapplied End),0),  
  Sbrok=isnull((case Sell_buy When 2 Then Settlement.brokapplied End),0),  
  Pnetrate=isnull((case Sell_buy  
   When 1 Then ( Case When Service_chrg = 1 Then   
   Round((settlement.marketrate + (settlement.brokapplied + (service_tax/tradeqty))),2)  
  Else  
   Round((settlement.marketrate + Settlement.brokapplied),2)   
  End )   
 End),0),  
  Snetrate=isnull((case Sell_buy  
   When 2 Then ( Case When Service_chrg = 1 Then   
   Round((settlement.marketrate -( Settlement.brokapplied + (service_tax/tradeqty))),2)  
  Else  
   Round((settlement.marketrate - Settlement.brokapplied ),2)  
  End )   
 End),0),  
 Pamt=isnull((case Sell_buy  
   When 1 Then ( Case When Service_chrg = 1 Then   
   /*round(((settlement.marketrate + Settlement.brokapplied) * Tradeqty +service_tax),2)*/  
   Tradeqty*(round((settlement.marketrate + (settlement.brokapplied + (service_tax/tradeqty))),2))  
  Else  
   /*round(((settlement.marketrate + Settlement.brokapplied) * Tradeqty),2)*/  
   Tradeqty*(round((settlement.marketrate + Settlement.brokapplied),2) )  
  End )   
 End),0),  
 Samt=isnull((case Sell_buy  
   When 2 Then ( Case When Service_chrg = 1 Then   
   /*round(((settlement.marketrate - Settlement.brokapplied) * Tradeqty - Service_tax),2)*/  
   Tradeqty*(round((settlement.marketrate - (settlement.brokapplied + (service_tax/tradeqty))),2))  
  Else  
   /*round(((settlement.marketrate - Settlement.brokapplied) * Tradeqty),2)*/  
   Tradeqty*(round((settlement.marketrate - Settlement.brokapplied ),2))  
  End )   
  End),0),  
  Brokerage=isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
  Newbrokerage =isnull(tradeqty*convert(numeric(9,2),nbrokapp),0) ,  
  Interest = 0, Fees =0, Slprate=0, Client2.service_chrg, Settlement.sett_no, Settlement.sett_type,  
  Client1.short_name, Client1.l_address1, Client1.l_address2, Client1.l_address3, Client1.l_city,   
  Client1.l_zip, Client1.res_phone1, Client1.off_phone1,  
  Sauda_date = Convert(varchar,settlement.sauda_date,103), Client2.sebi_turn_tax,   
  Client2.other_chrg, Client2.brokernote,  Client2.insurance_chrg, Client2.turnover_tax,   
  Settlement.sebi_tax,other =  Settlement.other_chrg, Settlement.broker_chrg, Client2.brokernote,   
  Client2.insurance_chrg, Settlement.ins_chrg, Client2.turnover_tax, Settlement.turn_tax  
  From Settlement,scrip1,scrip2,client2, Client1   
  Where Settlement.scrip_cd=scrip2.scrip_cd  
  And Settlement.series=scrip2.series And Scrip2.co_code=scrip1.co_code  
  And Scrip2.series=scrip1.series  And Client1.cl_code = Client2.cl_code  
  And Settlement.sett_no = @settno And Settlement.sett_type = @settype  
  And Settlement.billno <> '0' And Settlement.tradeqty <> '0'  
   And Client2.party_code = Settlement.party_code  
  And Client2.party_code = @statusname  
 Order By Settlement.party_code, Settlement.scrip_cd, Sell_buy  
End   
  
  
If @statusid = 'family'  
Begin  
  Select Settlement.party_code, Settlement.billno,settlement.contractno ,tm=convert(char,sauda_date,8),  
  Settlement.trade_no,convert(varchar, Settlement.sauda_date,103),settlement.scrip_cd,settlement.series,  
  Scripname=scrip1.short_name,sdt=substring(convert(varchar,sauda_date,109),1,11),  
  Settlement.sell_buy,settlement.markettype, Service_tax = Isnull(settlement.service_tax,0),  
  Nsertax ,  N_netrate,  
  Pqty=isnull((case Sell_buy When 1 Then Settlement.tradeqty End),0),  
  Sqty=isnull((case Sell_buy When 2 Then Settlement.tradeqty End),0),  
  Prate=isnull((case Sell_buy When 1 Then Settlement.marketrate End),0),  
  Srate=isnull((case Sell_buy When 2 Then Settlement.marketrate End),0),  
  Pbrok=isnull((case Sell_buy When 1 Then Settlement.brokapplied End),0),  
  Sbrok=isnull((case Sell_buy When 2 Then Settlement.brokapplied End),0),  
  Pnetrate=isnull((case Sell_buy  
   When 1 Then ( Case When Service_chrg = 1 Then   
   Round((settlement.marketrate + (settlement.brokapplied + (service_tax/tradeqty))),2)  
  Else  
   Round((settlement.marketrate + Settlement.brokapplied),2)   
  End )   
 End),0),  
  Snetrate=isnull((case Sell_buy  
   When 2 Then ( Case When Service_chrg = 1 Then   
   Round((settlement.marketrate -( Settlement.brokapplied + (service_tax/tradeqty))),2)  
  Else  
   Round((settlement.marketrate - Settlement.brokapplied ),2)  
  End )   
 End),0),  
 Pamt=isnull((case Sell_buy  
   When 1 Then ( Case When Service_chrg = 1 Then   
   /*round(((settlement.marketrate + Settlement.brokapplied) * Tradeqty +service_tax),2)*/  
   Tradeqty*(round((settlement.marketrate + (settlement.brokapplied + (service_tax/tradeqty))),2))  
  Else  
   /*round(((settlement.marketrate + Settlement.brokapplied) * Tradeqty),2)*/  
   Tradeqty*(round((settlement.marketrate + Settlement.brokapplied),2) )  
  End )   
 End),0),  
 Samt=isnull((case Sell_buy  
   When 2 Then ( Case When Service_chrg = 1 Then   
   /*round(((settlement.marketrate - Settlement.brokapplied) * Tradeqty - Service_tax),2)*/  
   Tradeqty*(round((settlement.marketrate - (settlement.brokapplied + (service_tax/tradeqty))),2))  
  Else  
   /*round(((settlement.marketrate - Settlement.brokapplied) * Tradeqty),2)*/  
   Tradeqty*(round((settlement.marketrate - Settlement.brokapplied ),2))  
  End )   
  End),0),  
  Brokerage=isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,  
  Newbrokerage =isnull(tradeqty*convert(numeric(9,2),nbrokapp),0) ,  
  Interest = 0, Fees =0, Slprate=0, Client2.service_chrg, Settlement.sett_no, Settlement.sett_type,  
  Client1.short_name, Client1.l_address1, Client1.l_address2, Client1.l_address3, Client1.l_city,   
  Client1.l_zip, Client1.res_phone1, Client1.off_phone1,  
  Sauda_date = Convert(varchar,settlement.sauda_date,103), Client2.sebi_turn_tax,   
  Client2.other_chrg, Client2.brokernote,  Client2.insurance_chrg, Client2.turnover_tax,   
  Settlement.sebi_tax,other =  Settlement.other_chrg, Settlement.broker_chrg, Client2.brokernote,   
  Client2.insurance_chrg, Settlement.ins_chrg, Client2.turnover_tax, Settlement.turn_tax  
  From Settlement,scrip1,scrip2,client2, Client1   
  Where Settlement.scrip_cd=scrip2.scrip_cd  
  And Settlement.series=scrip2.series And Scrip2.co_code=scrip1.co_code  
  And Scrip2.series=scrip1.series  And Client1.cl_code = Client2.cl_code  
  And Settlement.sett_no = @settno And Settlement.sett_type = @settype  
  And Settlement.party_code >= @fpartycode  And Settlement.party_code <= @tpartycode   
  And Settlement.billno <> '0' And Settlement.tradeqty <> '0'  
   And Client2.party_code = Settlement.party_code  
  And Client1.family = @statusname  
 Order By Settlement.party_code, Settlement.scrip_cd, Sell_buy  
End

GO
