-- Object: PROCEDURE dbo.TransToHis
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.TransToHis    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.TransToHis    Script Date: 3/21/01 12:50:33 PM ******/

/****** Object:  Stored Procedure dbo.TransToHis    Script Date: 20-Mar-01 11:39:11 PM ******/

/****** Object:  Stored Procedure dbo.TransToHis    Script Date: 2/5/01 12:06:30 PM ******/

/****** Object:  Stored Procedure dbo.TransToHis    Script Date: 12/27/00 8:59:17 PM ******/
/****** Object:  Stored Procedure dbo.TransToHis    Script Date: 1/12/01 9:25:14 PM ******/
CREATE Proc TransToHis (@SettNo varchar(7),@Sett_Type Varchar(2)) As
Begin
insert into history select ContractNo,BillNo,Trade_no,Party_Code,Scrip_Cd,User_id,Tradeqty,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,Trade_amount,Billflag,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,Partipantcode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2
from settlement where billno <> '0' and sett_no = @settno and sett_type = @sett_type
 /*modified by sheetal  23/10/2000  to remove the duplicate insertion of records*/
/*Execute InsProc @settno,@sett_type  */    
/*Execute DelProc @settno,@sett_type*/
delete from settlement where billno <> '0' and sett_no = @settno and sett_type = @sett_type
Execute InsProc @settno,@sett_type
Execute DelProc @settno,@sett_type
End

GO
