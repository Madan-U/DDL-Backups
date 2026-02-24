-- Object: PROCEDURE dbo.DeleteDelBrokerage
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Procedure [dbo].[DeleteDelBrokerage] (@ExchangeSegment Varchar(10), @Sauda_date Varchar(11),@Action Varchar(3))
As
-- DeleteDelBrokerage 'ALL','SEP  9 2019','' 

Declare @BSeSett_no Varchar(11)
Declare @NseSett_no Varchar(11)

Select @BSeSett_no = Sett_no from AngelBSECM.bsedb_ab.dbo.Sett_Mst 
where Start_date >=Left(Convert(Varchar,@Sauda_Date,109),11) and Start_date <= Left(Convert(Varchar,@Sauda_Date,109),11) + ' 23:59' and sett_type ='D'
Select @NSeSett_no = Sett_no from AngelNseCM.Msajag.dbo.Sett_Mst 
where Start_date >=Left(Convert(Varchar,@Sauda_Date,109),11) and Start_date <= Left(Convert(Varchar,@Sauda_Date,109),11) + ' 23:59' and sett_type ='N'

Select @BseSett_no
Select @NseSett_no


IF @Exchangesegment = ''
Return

IF @Sauda_Date = ''
Return



Select * into #Temp from ( SELECT Party_code FROM AngelNseCM.msajag.dbo.Del_Zero_Brok_CLIENT Where To_date > Getdate() ) A

If ( @Exchangesegment = 'BSECM' Or @Exchangesegment = 'ALL')
Begin
     /* We will update Log Tables for any previous data uploads 
	 ProcessStatus "P" means that the process is pending.
     ProcessStatus "O" means that the process was not completed.
	 ProcessStatus "C" means that the process completed.

	 */
     Update DeleteDelBrokerageBseSettlementLog Set Processstatus = 'O'
	 Where
	 DeleteDelBrokerageBseSettlementLog.Sett_no = @BSeSett_no
	 And
	 DeleteDelBrokerageBseSettlementLog.Sett_Type in('C','D')
	 And
	 DeleteDelBrokerageBseSettlementLog.ProcessStatus = 'P'
	 
	 Update BseDeleteDelBrokerageChargesDetailLog  Set Processstatus = 'O'  
	 Where
	 BseDeleteDelBrokerageChargesDetailLog.Cd_Sett_no = @BseSett_no
	 And
	 BseDeleteDelBrokerageChargesDetailLog.Cd_Sett_Type in('C','D')
	 And
	 BseDeleteDelBrokerageChargesDetailLog.ProcessStatus = 'P'
	 
	 /* Create a Data Snapshot for Log */
	 Insert into DeleteDelBrokerageBseSettlementLog 
	 Select ContractNo,BillNo,Trade_no,S.Party_Code,Scrip_Cd,User_id,Tradeqty,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,Trade_amount,Billflag,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,participantcode,status,pro_cli,cpid,instrument,bookType,branch_id,dummy1,dummy2,tmark,Scheme,SRNO,Processstatus = 'P',ApprovedBy = '',Getdate()
	 From AngelBSECM.Bsedb_ab.dbo.Settlement S , #Temp T 
	 Where
	 T.Party_code = S.Party_code
	 And
	 S.Sett_no = @BseSett_no
	 And
	 S.Sett_type in('C','D')
	 And S.Settflag in(1,4,5)

	 Insert into BseDeleteDelBrokerageChargesDetailLog 
	 Select CD_SrNo,CD_Party_Code,CD_Sett_No,CD_Sett_Type,CD_Sauda_Date,CD_ContractNo,CD_Trade_No,CD_Order_No,CD_Scrip_Cd,CD_Series,CD_BuyRate,CD_SellRate,CD_TrdBuy_Qty,CD_TrdSell_Qty,CD_DelBuy_Qty,CD_DelSell_Qty,CD_TrdBuyBrokerage,CD_TrdSellBrokerage,CD_DelBuyBrokerage,CD_DelSellBrokerage,CD_TotalBrokerage,CD_TrdBuySerTax,CD_TrdSellSerTax,CD_DelBuySerTax,CD_DelSellSerTax,CD_TotalSerTax,CD_TrdBuy_TurnOver,CD_TrdSell_TurnOver,CD_DelBuy_TurnOver,CD_DelSell_TurnOver,CD_Computation_Level,CD_Min_BrokAmt,CD_Max_BrokAmt,CD_Min_ScripAmt,CD_Max_ScripAmt,CD_TimeStamp,Processstatus = 'P',ApprovedBy = '',Logtime = Getdate() from AngelBSECM.bsedb_ab.dbo.charges_Detail D ,#Temp T
	 Where
	 D.Cd_Party_code = T.Party_code
	 And
	 D.Cd_Sett_no = @BseSett_no
	 And
	 D.Cd_Sett_type in('C','D')
     And 
	 (D.Cd_DelBuyBrokerage > 0 Or D.Cd_DelSellBrokerage > 0)

	 /* 
	 /* Update routines for setting brokerages and service tax*/

	 Begin Tran
	 Update AngelBSECM.Bsedb_ab.dbo.Settlement Set Brokapplied = 0,NBrokapp = 0 , Service_tax = 0, NSerTax = 0
	 From DeleteDelBrokerageBseSettlementLoG D
	 Where
	 AngelBSECM.Bsedb_ab.dbo.Settlement.SEtt_no = D.Sett_no
	 And
	 AngelBSECM.Bsedb_ab.dbo.Settlement.Sett_type = D.Sett_type
	 And
	 AngelBSECM.Bsedb_ab.dbo.Settlement.Party_code = D.Party_code
	 And
	 D.ProcessStatus = 'P'

	 Update DeleteDelBrokerageBseSettlementLoG Set ProcessStatus = 'C'
	 Where ProcessStatus = 'P' and sett_no = @BseSett_no and Sett_Type in('C','D')


	 Update AngelBSECM.Bsedb_ab.dbo.Charges_detail Set Cd_DelBuyBrokerage = 0,Cd_DelSellBrokerage = 0 , CD_TotalBrokerage = ( CD_TotalBrokerage - Cd_DelBuyBrokerage - Cd_DelSellBrokerage),Cd_DelBuySetax = 0 ,Cd_DElSellSerTax = 0,Cd_TotalSertax = ( Cd_TotalSertax - Cd_DelBuySetax - Cd_DElSellSerTax ),
	 From BseDeleteDelBrokerageChargesDetailLog  D
	 Where 
	 AngelBSECM.Bsedb_ab.dbo.Charges_detail.Party_code = D.Party_code
	 and
	 AngelBSECM.Bsedb_ab.dbo.Charges_detail.SEtt_no = D.Sett_no
	 And
	 AngelBSECM.Bsedb_ab.dbo.Charges_detail.Sett_type = D.Sett_type
	 And
	 D.ProcessStatus = 'P'
	 And
	 AngelBSECM.Bsedb_ab.dbo.Charges_detail.Cd_Sett_no = @BseSett_no 
	 and 
	 AngelBSECM.Bsedb_ab.dbo.Charges_detail.Sett_Type in('C','D')

	 Update BseDeleteDelBrokerageChargesDetailLog Set Processstatus = 'C' 
	 Where
	 CD_Sett_no = @BseSett_no
	 And
	 Cd_Sett_type in ('C','D')

	 Commit Tran
	 */

End

If ( @Exchangesegment = 'NSECM' Or @Exchangesegment = 'ALL')
Begin
     /* We will update Log Tables for any previous data uploads 
	 ProcessStatus "P" means that the process is pending.
     ProcessStatus "O" means that the process was not completed.
	 ProcessStatus "C" means that the process completed.

	 */
     Update DeleteDelBrokerageNseSettlementLog Set Processstatus = 'O'
	 Where
	 DeleteDelBrokerageNseSettlementLog.Sett_no = @NSeSett_no
	 And
	 DeleteDelBrokerageNseSettlementLog.Sett_Type in('N','W')
	 And
	 DeleteDelBrokerageNseSettlementLog.ProcessStatus = 'P'
	 
	 Update NseDeleteDelBrokerageChargesDetailLog  Set Processstatus = 'O'  
	 Where
	 NseDeleteDelBrokerageChargesDetailLog.Cd_Sett_no = @NseSett_no
	 And
	 NseDeleteDelBrokerageChargesDetailLog.Cd_Sett_Type in('N','W')
	 And
	 NseDeleteDelBrokerageChargesDetailLog.ProcessStatus = 'P'
	 
	 /* Create a Data Snapshot for Log */
	 Insert into DeleteDelBrokerageNseSettlementLog 
	 Select ContractNo,BillNo,Trade_no,S.Party_Code,Scrip_Cd,User_id,Tradeqty,AuctionPart,MarketType,Series,Order_no,
	 MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,
	 Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,Trade_amount,
	 Billflag,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,Partipantcode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,
	 TMark,Scheme,Dummy1,Dummy2,SRNO,Processstatus = 'P',ApprovedBy = '',Getdate()
	 From AngelNseCM.MSajag.dbo.Settlement S , #Temp T 
	 Where
	 T.Party_code = S.Party_code
	 And
	 S.Sett_no = @NseSett_no
	 And
	 S.Sett_type in('N','W')
	 And S.Settflag in(1,4,5)

	 Insert into NseDeleteDelBrokerageChargesDetailLog 
	 Select CD_SrNo,CD_Party_Code,CD_Sett_No,CD_Sett_Type,CD_Sauda_Date,CD_ContractNo,CD_Trade_No,CD_Order_No,CD_Scrip_Cd,CD_Series,CD_BuyRate,CD_SellRate,CD_TrdBuy_Qty,CD_TrdSell_Qty,CD_DelBuy_Qty,CD_DelSell_Qty,CD_TrdBuyBrokerage,CD_TrdSellBrokerage,CD_DelBuyBrokerage,CD_DelSellBrokerage,CD_TotalBrokerage,CD_TrdBuySerTax,CD_TrdSellSerTax,CD_DelBuySerTax,CD_DelSellSerTax,CD_TotalSerTax,CD_TrdBuy_TurnOver,CD_TrdSell_TurnOver,CD_DelBuy_TurnOver,CD_DelSell_TurnOver,CD_Computation_Level,CD_Min_BrokAmt,CD_Max_BrokAmt,CD_Min_ScripAmt,CD_Max_ScripAmt,CD_TimeStamp,Processstatus = 'P',ApprovedBy = '',Logtime = Getdate() 
	 From AngelNseCM.Msajag.dbo.charges_Detail D ,#Temp T
	 Where
	 D.Cd_Party_code = T.Party_code
	 And
	 D.Cd_Sett_no = @NseSett_no
	 And
	 D.Cd_Sett_type in('N','W')
     And (D.Cd_DelBuyBrokerage > 0 Or D.Cd_DelSellBrokerage > 0)

	 /* 
	 /* Update routines for setting brokerages and service tax*/

	 Begin Tran
	 Update AngelBSECM.Msajag.dbo.Settlement Set Brokapplied = 0,NBrokapp = 0 , Service_tax = 0, NSerTax = 0
	 From DeleteDelBrokerageNseSettlementLoG D
	 Where
	 AngelBSECM.Msajag.dbo.Settlement.SEtt_no = D.Sett_no
	 And
	 AngelBSECM.Msajag.dbo.Settlement.Sett_type = D.Sett_type
	 And
	 AngelBSECM.Msajag.dbo.Settlement.Party_code = D.Party_code
	 And
	 D.ProcessStatus = 'P'
	 And
	 AngelBSECM.Msajag.dbo.Settlement.Sett_no = @NSeSett_no
	 And
	 AngelBSECM.Msajag.dbo.Settlement.Sett_Type in('N','W')
	 
	 Update DeleteDelBrokerageNseSettlementLoG Set ProcessStatus = 'C'
	 Where ProcessStatus = 'P' and Sett_no = @NseSett_no and Sett_Type in('N','W')


	 Update AngelNseCM.Msajag.dbo.Charges_detail 
	 Set Cd_DelBuyBrokerage = 0,Cd_DelSellBrokerage = 0 , CD_TotalBrokerage = ( CD_TotalBrokerage - Cd_DelBuyBrokerage - Cd_DelSellBrokerage),Cd_DelBuySetax = 0 ,Cd_DElSellSerTax = 0,Cd_TotalSertax = ( Cd_TotalSertax - Cd_DelBuySetax - Cd_DElSellSerTax ),
	 From NseDeleteDelBrokerageChargesDetailLog  D
	 Where 
	 AngelNseCM.Msajag.dbo.Charges_detail.Party_code = D.Party_code
	 and
	 AngelNseCM.Msajag.dbo.Charges_detail.Cd_SEtt_no = D.CD_Sett_no
	 And
	 AngelNseCM.Msajag.dbo.Charges_detail.Cd_Sett_type = D.Cd_Sett_type
	 And
	 D.ProcessStatus = 'P'
	 And
	 AngelNseCM.Msajag.dbo.Charges_detail.CD_Sett_no = @NseSett_no
	 And
	 AngelNseCM.Msajag.dbo.Charges_detail.CD_Sett_Type In('N','W')

	 Update NseDeleteDelBrokerageChargesDetailLog Set ProcessStatus = 'C' 
	 Where ProcessStatus = 'P' and CD_Sett_no = @NseSett_no and CD_Sett_Type in('N','W')
	 
	 Commit Tran
	 */

End

--truncate table DeleteDelBrokerageBseSettlementLog 
--truncate table BseDeleteDelBrokerageChargesDetailLog 
--truncate table DeleteDelBrokerageNseSettlementLog 
--truncate table NseDeleteDelBrokerageChargesDetailLog

GO
