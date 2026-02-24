-- Object: PROCEDURE dbo.aConfirmationAllTrade
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Procedure aConfirmationAllTrade 
@statusid varchar(12),
@statusname varchar(12)
as 

if @statusid <> 'broker'
Begin
     if ( Select Count(*) From Owner Where Mainbroker > 0 ) > 0
     Begin 
          Exec aRearrangeSubTrdflag @statusid,@statusname 
    	  Insert Into TrdBackUp (contractno,Billno,Trade_no, Party_Code, Scrip_Cd,user_id ,tradeqty,
	  AuctionPart, markettype,series, order_no, MarketRate, Sauda_date, sell_buy, 
	  settflag, sett_no, partipantcode, Line_no,Table_no, BillFlag, status, Pro_Cli, CpId, 
	  Instrument, BookType, Branch_Id,TMark,Scheme, Dummy1, Dummy2   ) Select 0,0,t.Trade_no, t.Party_Code, 
	  t.Scrip_Cd,t.user_id ,t.tradeqty,t.AuctionPart, t.markettype,t.series, t.order_no, t.MarketRate,t.Sauda_date,
	  t.sell_buy,t.settflag,0 settno,t.partipantcode,2,21,0,t.status,t.Pro_Cli,t.CpId,t.Instrument,t.BookType,t.Branch_Id,
	  t.TMark,t.Scheme,t.Dummy1,t.Dummy2  from atrade t,branch b, branches b1
	  where t.User_Id = b1.terminal_id and b.BRANCH_CODE = b1.Branch_cd
	  and b.branch = @statusname
       End
       Exec  aRearrangeTrdflag @statusid,@statusname 
 End 
 Else
 If @statusid = 'BROKER'
 Begin 
      If ( Select Count(*) From Owner Where Mainbroker > 0 ) > 0
      Begin 
	   Insert Into TrdBackUp (contractno,Billno,Trade_no, Party_Code, Scrip_Cd,user_id ,tradeqty,
	   AuctionPart, markettype,series, order_no, MarketRate, Sauda_date, sell_buy, 
	   Settflag, sett_no, partipantcode, Line_no,Table_no, BillFlag, status, Pro_Cli, CpId, 
	   Instrument, BookType, Branch_Id,TMark,Scheme, Dummy1, Dummy2   ) Select 0,0,t.Trade_no, t.Party_Code, 
	   t.Scrip_Cd,t.user_id ,t.tradeqty,t.AuctionPart, t.markettype,t.series, t.order_no, t.MarketRate,t.Sauda_date,
	   t.sell_buy,t.settflag,0 settno,t.partipantcode,2,21,0,t.status,t.Pro_Cli,t.CpId,t.Instrument,t.BookType,t.Branch_Id,
	   t.TMark,t.Scheme,t.Dummy1,t.Dummy2  from atrade t,branch b, branches b1
	   Where t.User_Id = b1.terminal_id and b.BRANCH_CODE = b1.Branch_cd
           Exec aRearrangeSubTrdflag @statusid,@statusname 
      End
    Exec  aRearrangeTrdflag @statusid,@statusname
  End

GO
