-- Object: PROCEDURE dbo.AfterHistIns
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.AfterHistIns    Script Date: 3/17/01 9:55:42 PM ******/

/****** Object:  Stored Procedure dbo.AfterHistIns    Script Date: 3/21/01 12:49:58 PM ******/

/****** Object:  Stored Procedure dbo.AfterHistIns    Script Date: 20-Mar-01 11:38:41 PM ******/

/****** Object:  Stored Procedure dbo.AfterHistIns    Script Date: 2/5/01 12:06:05 PM ******/

/****** Object:  Stored Procedure dbo.AfterHistIns    Script Date: 12/27/00 8:59:05 PM ******/

/* 
For inserting transfere party for the affected qty 
used in After History
Create Date 04 Sept 2000 11:41 AM
Created By Sheetal Apte
*/
CREATE procedure AfterHistIns  
@contractno char(14),
@billno as char(10),
@ttradeno char(12), 
@tparty varchar(10), 
@tqty int, 
@tnetrate numeric(19,6) ,
@tmrate numeric(19,6) ,
@temptradeno char(12), 
@tscrip char(10), 
@tseries varchar(2), 
@tpartycd varchar(10), 
@tdate varchar(10), 
@tmarktype varchar(2), 
@tsellbuy int,
@tsettflag int,
@tbillflag int,
@MemberCode Varchar(10),
@Tmark Varchar(1)
AS 
  Insert into History select @contractno,@billno, @ttradeno, @tparty,Scrip_Cd,User_id,@tqty,AuctionPart,MarketType,Series,Order_no,
MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,
@tsettflag,Brokapplied,NetRate,
Amount=(@tqty *@tNetRate),Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,Trade_amount=(@tqty *marketRate),@tBillflag,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,Partipantcode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2 from History 
  where trade_no = @temptradeno
  and scrip_cd =@tscrip and series =@TSeries
                 and convert(varchar,sauda_date,3)= @TDate
  and sell_buy =@tsellbuy  and party_code = @tpartycd
  and markettype=@tmarktype and marketrate = @tMrate
  and netrate= @tNetRate
  and PartiPantCode = @MemberCode
  and TMark = @Tmark

GO
