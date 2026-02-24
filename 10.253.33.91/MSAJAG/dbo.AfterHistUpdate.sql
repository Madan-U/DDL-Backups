-- Object: PROCEDURE dbo.AfterHistUpdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.AfterHistUpdate    Script Date: 3/17/01 9:55:43 PM ******/

/****** Object:  Stored Procedure dbo.AfterHistUpdate    Script Date: 3/21/01 12:49:58 PM ******/

/****** Object:  Stored Procedure dbo.AfterHistUpdate    Script Date: 20-Mar-01 11:38:41 PM ******/

/****** Object:  Stored Procedure dbo.AfterHistUpdate    Script Date: 2/5/01 12:06:05 PM ******/

/****** Object:  Stored Procedure dbo.AfterHistUpdate    Script Date: 12/27/00 8:59:05 PM ******/

/* 
Recent changes done by vaishali on 9/1/2001
Added tmark and member code in the condition.
For Updating trade's qty ,flags 
used in After History
Create Date 04 Sept 2000 11:27 AM
Created By Sheetal Apte
*/
CREATE procedure AfterHistUpdate  
@ttradeno varchar(7), 
@tqty int, 
@tnetrate numeric(19,6) , 
@tmrate numeric(19,6) , 
@tscrip varchar(12), 
@tseries varchar(2), 
@tpartycd varchar(10), 
@tdate varchar(10), 
@tmarktype varchar(2), 
@tsellbuy varchar(2),
@tsettflag varchar(1),
@tBillflag varchar(1),
@memcode varchar(15),
@tmark varchar(1)
AS 
   if @Tqty > 0 
 begin
  update History set TradeQty = @TQty, SettFlag = @Tsettflag, BillFlag = @TBillFlag
  where trade_no = @ttradeno
  and scrip_cd =@tscrip and series =@TSeries
          and convert(varchar,sauda_date,3)= @TDate
  and sell_buy =@tsellbuy  and party_code = @tpartycd 
  and markettype=@tmarktype and marketrate = @tMrate
  and netrate= @tNetRate
  and partipantcode = @memcode
  and tmark = @tmark
 end 
   else
 begin
    update History set tradeqty= 0, 
                 marketrate = 0,Brokapplied = 0,NetRate = 0,Amount = 0,other_chrg = 0,
  sebi_tax = 0,Broker_chrg = 0,Service_tax = 0,NBrokApp = 0,NSerTax = 0,N_NetRate = 0
  where trade_no = @ttradeno
  and scrip_cd =@tscrip and series =@TSeries
  and convert(varchar,sauda_date,3)= @TDate
  and sell_buy =@tsellbuy  and party_code = @tpartycd
  and markettype=@tmarktype and marketrate = @tMrate
  and netrate= @tNetRate
  and partipantcode = @memcode
  and tmark = @tmark
 end

GO
