-- Object: PROCEDURE dbo.InstData_ToNormalServer
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc [dbo].[InstData_ToNormalServer] (@Sauda_Date Varchar(11))
As

Insert into Isettlement 
select Contractno,Billno,Trade_No,Party_Code,Scrip_Cd,User_Id,Tradeqty,Auctionpart,
Markettype,Series,Order_No,Marketrate,Sauda_Date,Table_No,Line_No,Val_Perc,Normal,
Day_Puc,Day_Sales,Sett_Purch,Sett_Sales,Sell_Buy,Settflag,Brokapplied,Netrate,Amount,
Ins_Chrg,Turn_Tax,Other_Chrg,Sebi_Tax,Broker_Chrg,Service_Tax,Trade_Amount,Billflag,
Sett_No,Nbrokapp,Nsertax,N_Netrate,Sett_Type,Partipantcode,Status,Pro_Cli,Cpid,Instrument,
Booktype,Branch_Id,Tmark,Scheme,Dummy1,Dummy2
from ENC_TESTSRV1.MSAJAG.DBO.Isettlement 
Where Sauda_date like @Sauda_Date + '%'

Insert into settlement 
select Contractno,Billno,Trade_No,Party_Code,Scrip_Cd,User_Id,Tradeqty,Auctionpart,
Markettype,Series,Order_No,Marketrate,Sauda_Date,Table_No,Line_No,Val_Perc,Normal,
Day_Puc,Day_Sales,Sett_Purch,Sett_Sales,Sell_Buy,Settflag,Brokapplied,Netrate,Amount,
Ins_Chrg,Turn_Tax,Other_Chrg,Sebi_Tax,Broker_Chrg,Service_Tax,Trade_Amount,Billflag,
Sett_No,Nbrokapp,Nsertax,N_Netrate,Sett_Type,Partipantcode,Status,Pro_Cli,Cpid,Instrument,
Booktype,Branch_Id,Tmark,Scheme,Dummy1,Dummy2
from ENC_TESTSRV1.MSAJAG.DBO.settlement 
Where Sauda_date like @Sauda_Date + '%'

Delete From details Where sauda_date like @Sauda_Date + '%'

insert into details select distinct Left(convert(varchar,sauda_date,109),11),Sett_no,
sett_type,Party_code,'S' from settlement 
Where sauda_date like @Sauda_Date + '%'

insert into details select distinct Left(convert(varchar,sauda_date,109),11),Sett_no,
sett_type,Party_code,'IS' from Isettlement 
Where sauda_date like @Sauda_Date + '%'

GO
