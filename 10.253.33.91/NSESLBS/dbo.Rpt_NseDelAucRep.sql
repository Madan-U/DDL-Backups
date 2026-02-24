-- Object: PROCEDURE dbo.Rpt_NseDelAucRep
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_NseDelAucRep   
(@Sett_No Varchar(7),  
 @Sett_Type Varchar(2)  
) As  
  
Declare   
@@Party_Code Varchar(10),  
@@Buyer Varchar(10),  
@@Scrip_Cd Varchar(12),  
@@TempScrip_Cd Varchar(12),  
@@Series Varchar(3),  
@@TempSeries Varchar(3),  
@@AuctionPart Varchar(2),  
@@Qty Int,  
@@BQty Int,  
@@AucCur Cursor,  
@@DelCur Cursor  
Set Transaction Isolation level read uncommitted  
truncate table DelSett   
insert into DelSett   
Select Contractno,Billno,Trade_No,Party_Code,Scrip_Cd,User_Id,Tradeqty,Auctionpart,Markettype,Series,Order_No,Marketrate,Sauda_Date,Table_No,Line_No,Val_Perc,Normal,Day_Puc,Day_Sales,Sett_Purch,Sett_Sales,Sell_Buy,Settflag,Brokapplied,Netrate,Amount,Ins_Chrg,Turn_Tax,Other_Chrg,Sebi_Tax,Broker_Chrg,Service_Tax,Trade_Amount,Billflag,Sett_No,Nbrokapp,Nsertax,N_Netrate,Sett_Type,Partipantcode,Status,Pro_Cli,Cpid,Instrument,Booktype,Branch_Id,Tmark,Scheme,Dummy1,Dummy2
From Settlement Where AuctionPart Like 'F%'  
And Sett_Type = @Sett_Type And Sett_No = @Sett_No And Branch_Id <> 'Dummy'  
  
Truncate Table DelAucReport  
Insert into DelAucReport  
Select Party_Code,'',Scrip_Cd,Series,AuctionPart,Qty=Sum(TradeQty),'','','',''  
From DelSett Where AuctionPart Like 'FL'  
And Sett_Type = @Sett_Type And Sett_No = @Sett_No And Sell_Buy = 1   
Group By Party_Code,Scrip_Cd,Series,AuctionPart  
  
Insert into DelAucReport  
Select Party_Code,'',Scrip_Cd,Series,AuctionPart,Qty=Sum(TradeQty),'','','',''  
From DelSett Where AuctionPart in ('FC','FS','FP')  
And Sett_Type = @Sett_Type And Sett_No = @Sett_No And Sell_Buy = 2   
Group By Party_Code,Scrip_Cd,Series,AuctionPart  
  
Update DelAucReport Set Seller = 'EXCHANGE',SName='EXCHANGE' Where AuctionPart = 'FS'   
  
Set @@AucCur = Cursor For  
Select Party_Code,Scrip_Cd,Series,AuctionPart,Qty=Sum(TradeQty)  
From DelSett Where AuctionPart Like 'FL' And AuctionPart <> 'FS'   
And Sett_Type = @Sett_Type And Sett_No = @Sett_No And Sell_Buy = 2   
Group By Party_Code,Scrip_Cd,Series,AuctionPart  
Union All  
Select Party_Code,Scrip_Cd,Series,AuctionPart,Qty=Sum(TradeQty)  
From DelSett Where AuctionPart in ('FC','FS','FP') And AuctionPart <> 'FS'   
And Sett_Type = @Sett_Type And Sett_No = @Sett_No And Sell_Buy = 1   
Group By Party_Code,Scrip_Cd,Series,AuctionPart  
Order By Scrip_Cd,Series,AuctionPart  
Open @@AucCur  
Fetch Next From @@AucCur into @@Party_Code,@@Scrip_Cd,@@Series,@@AuctionPart,@@Qty  
While @@Fetch_Status = 0   
Begin     
  
 Set @@DelCur = Cursor For  
 Select Buyer,Qty From DelAucReport   
 Where AuctionPart = @@AuctionPart   
 And Scrip_Cd = @@Scrip_CD And Seller = ''  
 Open @@DelCur   
 Fetch Next From @@DelCur into @@Buyer,@@BQty  
  
 if @@Fetch_Status = 0   
 Begin  
  if @@Qty = @@BQty   
  Begin  
   Update DelAucReport Set Seller = @@Party_Code Where   
   AuctionPart = @@AuctionPart   
   And Scrip_Cd = @@Scrip_CD And Seller = ''  
   And Buyer = @@Buyer  
   Fetch Next From @@AucCur into @@Party_Code,@@Scrip_Cd,@@Series,@@AuctionPart,@@Qty  
  end  
  Else if @@BQty > @@Qty   
  Begin  
   Update DelAucReport Set Seller = @@Party_Code, Qty = @@Qty Where   
   AuctionPart = @@AuctionPart   
   And Scrip_Cd = @@Scrip_CD And Seller = ''  
   And Buyer = @@Buyer  
  
   Insert into DelAucReport  
   Select Buyer,BName,Scrip_Cd,Series,AuctionPart,@@BQty-@@Qty,'','','','' From DelAucReport   
   Where AuctionPart = @@AuctionPart   
   And Scrip_Cd = @@Scrip_CD And Seller = @@Party_Code  
   And Buyer = @@Buyer And Qty = @@Qty  
   Fetch Next From @@AucCur into @@Party_Code,@@Scrip_Cd,@@Series,@@AuctionPart,@@Qty  
  End   
  Else  
  Begin  
   Update DelAucReport Set Seller = @@Party_Code Where   
   AuctionPart = @@AuctionPart   
   And Scrip_Cd = @@Scrip_CD And Seller = ''  
   And Buyer = @@Buyer  
   Select @@Qty = @@Qty - @@BQty  
  End  
 End  
 Else  
 Begin  
  Fetch Next From @@AucCur into @@Party_Code,@@Scrip_Cd,@@Series,@@AuctionPart,@@Qty  
 End   
End  
  
Insert into DelAucReport  
Select 'EXCHANGE','EXCHANGE',Scrip_Cd,Series,AuctionPart,Qty=Sum(TradeQty),Party_Code,'','',''  
From DelSett Where AuctionPart Like 'FS'  
And Sett_Type = @Sett_Type And Sett_No = @Sett_No And Sell_Buy = 1   
Group By Party_Code,Scrip_Cd,Series,AuctionPart  
  
Update DelAucReport Set BName = Left(Short_Name,21) From Client1 C1, Client2 C2  
Where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = DelAucReport.Buyer  
  
Update DelAucReport Set SName = Left(Short_Name,21) From Client1 C1, Client2 C2  
Where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = DelAucReport.Seller  
  
Update DelAucReport Set BName='EXCHANGE',BUYER='EXCHANGE' Where BUYER = ''  
  
Update DelAucReport Set SName='EXCHANGE',SELLER='EXCHANGE' Where SELLER = ''  
  
Update DelAucReport Set SettNo = Sett_No, SettType = Sett_Type From DelAuctionPos P  
Where AuctionPart Like 'FP'  
And DelAucReport.Scrip_CD = P.Scrip_CD And Buyer = P.Party_Code  
And ASett_Type = @Sett_Type And ASett_No = @Sett_No

GO
