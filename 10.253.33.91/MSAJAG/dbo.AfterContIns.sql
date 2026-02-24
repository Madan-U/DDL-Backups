-- Object: PROCEDURE dbo.AfterContIns
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/*  Recent changes by vaishali on 5/1/2001--  Added tmark,member code
For inserting transfere party for the affected qty 
used in After Contract
Create Date 26 Aug 2000 5:15 PM 
Created By Sheetal Apte
*/
CREATE procedure AfterContIns  
@sett_type varchar (2),
@contractno varchar(5),
@billno as varchar(5),
@ttradeno varchar(12), 
@tparty varchar(7), 
@tqty int,
@oldqty int,
@tnetrate numeric(19,7) ,
@tmrate numeric(19,7) ,
@temptradeno varchar(12), 
@tscrip varchar(12), 
@tseries varchar(2), 
@tpartycd varchar(7), 
@tdate varchar(10), 
@tmarktype varchar(2), 
@tsellbuy varchar(2),
@tsettflag varchar(1),
@tbillflag varchar(1),
@tmark varchar(1),
@memcode varchar(15)
AS 

  	Insert into settlement select
  	@contractno, @billno,@ttradeno,@tparty, Scrip_Cd,user_id,@tqty, AUCTIONPART, MarketType,
  	series,order_no,MarketRate, Sauda_date,Table_no, Line_No ,Val_perc, Normal,Day_puc,day_sales, 
  	Sett_purch,Sett_sales,Sell_buy,@tsettflag ,Brokapplied, NetRate,amount =  (@tqty *@tNetRate) ,
  	Ins_chrg,turn_tax,other_chrg, sebi_tax,Broker_chrg,Service_tax,Trade_amount= (@tqty * @tMrate) ,
  	@tBillflag,sett_no,nbrokapp ,nsertax ,n_netrate ,sett_type,@memcode,Status,Pro_Cli,CpId,Instrument,
  	BookType,Branch_Id,Tmark,scheme,Dummy1,Dummy2
  	from settlement 
  	where  sett_type = @sett_type
  	and trade_no = @temptradeno
  	and scrip_cd =@tscrip and series =@TSeries
  	and convert(varchar,sauda_date,3)= @TDate
  	and sell_buy =@tsellbuy  
  	and party_code = @tpartycd
  	and markettype=@tmarktype 
  	and marketrate = @tMrate
  	and netrate= @tNetRate
  	and tmark = @tmark
  	and partipantcode = @memcode
 	and tradeqty = @oldqty 

 /*Insert into settlement select
  @contractno, @billno,@ttradeno,@tparty, Scrip_Cd,user_id,@tqty, AUCTIONPART, MarketType,
  series,order_no,MarketRate, Sauda_date,Table_no, Line_No ,Val_perc, Normal,Day_puc,day_sales, 
  Sett_purch,Sett_sales,Sell_buy,@tsettflag ,Brokapplied, NetRate,amount =  (@tqty *@tNetRate) ,
  Ins_chrg,turn_tax,other_chrg, sebi_tax,Broker_chrg,Service_tax,Trade_amount= (@tqty * @tMrate) ,
  @tBillflag,sett_no,nbrokapp ,nsertax ,n_netrate ,sett_type,PartiPantCode,Status,Pro_Cli,CpId,Instrument,
  BookType,Branch_Id,Tmark,scheme,Dummy1,Dummy2
  from settlement 
  where  sett_type = @sett_type
  and trade_no = @temptradeno
  and scrip_cd =@tscrip and series =@TSeries
  and convert(varchar,sauda_date,3)= @TDate
  and sell_buy =@tsellbuy  
  and party_code = @tpartycd
  and markettype=@tmarktype 
  and marketrate = @tMrate
  and netrate= @tNetRate

*/

GO
