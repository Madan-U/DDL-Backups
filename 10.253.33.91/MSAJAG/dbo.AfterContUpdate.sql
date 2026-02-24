-- Object: PROCEDURE dbo.AfterContUpdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/*
Recent changes by vaishali on 5/1/2001
Added Tmark  and partipant code
 
For Updating trade's qty ,flags 
used in After Contract, after bill
Create Date 26 Aug 2000 5:15 PM 
Created By Sheetal Apte
*/
CREATE procedure AfterContUpdate  
@sett_type varchar(2),
@ttradeno varchar(12), 
@tqty int, 
@oldqty int,
@tnetrate numeric(19,10) , 
@tmrate numeric(19,10) , 
@tscrip varchar(12), 
@tseries varchar(2), 
@tpartycd varchar(7), 
@tdate varchar(10), 
@tmarktype varchar(2), 
@tsellbuy varchar(2),
@tsettflag varchar(1),
@tBillflag varchar(1),
@tmark varchar(1),
@memcode varchar(15)
AS 
   	if @Tqty > 0 
 	begin
  		update Settlement set TradeQty = @TQty, SettFlag = @Tsettflag, BillFlag = @TBillFlag
  		where sett_type = @sett_type
  		and trade_no = @ttradeno
  		and scrip_cd =@tscrip and series =@TSeries
           		and convert(varchar,sauda_date,3)= @TDate
  		and sell_buy =@tsellbuy  and party_code = @tpartycd 
  		and markettype=@tmarktype and marketrate = @tMrate
  		and netrate= @tNetRate
  		and tmark = @tmark
  		and Partipantcode = @memcode
		and tradeqty = @oldqty
 	end 
   	else
 	begin
    		update settlement set tradeqty= 0,Normal = 0,Day_puc = 0,day_sales = 0,Sett_purch = 0,Sett_sales  = 0, 
                 	marketrate = 0,Brokapplied = 0,NetRate = 0,Amount = 0,Ins_chrg = 0,turn_tax = 0,other_chrg = 0,
  		sebi_tax = 0,Broker_chrg = 0,Service_tax = 0,Trade_amount = 0,NBrokApp = 0,NSerTax = 0,N_NetRate = 0
  		where sett_type = @sett_type
  		and trade_no = @ttradeno
  		and scrip_cd =@tscrip and series =@TSeries
               		and convert(varchar,sauda_date,3)= @TDate
  		and sell_buy =@tsellbuy  and party_code = @tpartycd
  		and markettype=@tmarktype and marketrate = @tMrate
  		and netrate= @tNetRate
  		and tmark = @tmark
  		and Partipantcode = @memcode
		and tradeqty = @oldqty
 	end

GO
