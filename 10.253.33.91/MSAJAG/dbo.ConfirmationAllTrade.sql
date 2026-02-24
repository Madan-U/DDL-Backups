-- Object: PROCEDURE dbo.ConfirmationAllTrade
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*TrdMain maintains a copy of the trade after trade is imported and before confirmation */
/*TrdBackup stires the data (i.e. the netrate,marketrate etc) for the subbroker*/

CREATE Procedure ConfirmationAllTrade as 
Begin
           /* Insert into TrdMain Select * from Trade */  
           If ( Select Count(*) From Owner Where Mainbroker > 0 ) > 0
           Begin
                      Insert Into TrdBackUp (contractno,Billno,Trade_no, Party_Code, Scrip_Cd,user_id ,tradeqty,
                      AuctionPart, markettype,series, order_no, MarketRate, Sauda_date, sell_buy, 
                      Settflag, sett_no, partipantcode, Line_no,Table_no, BillFlag, status, Pro_Cli, CpId, Instrument, BookType, Branch_Id,TMark,Scheme, Dummy1, Dummy2   ) Select 0,0,Trade_no, Party_Code, Scrip_Cd,user_id ,tradeqty,
                      AuctionPart, markettype,series, order_no, MarketRate,Sauda_date,sell_buy,settflag,0 settno,partipantcode,2,21,0,Trade.status,Trade.Pro_Cli,Trade.CpId, Trade.Instrument,Trade.BookType, Trade.Branch_Id, Trade.TMark,Trade.Scheme,Trade.Dummy1,Trade.Dummy2   from trade 
                     Exec RearrangeSubTrdflag
         End

         Exec  RearrangeTrdflag
End

GO
