-- Object: PROCEDURE dbo.AfterBillFlagUpdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.AfterBillFlagUpdate    Script Date: 3/17/01 9:55:42 PM ******/

/****** Object:  Stored Procedure dbo.AfterBillFlagUpdate    Script Date: 3/21/01 12:49:58 PM ******/

/****** Object:  Stored Procedure dbo.AfterBillFlagUpdate    Script Date: 20-Mar-01 11:38:41 PM ******/

/****** Object:  Stored Procedure dbo.AfterBillFlagUpdate    Script Date: 2/5/01 12:06:05 PM ******/

/****** Object:  Stored Procedure dbo.AfterBillFlagUpdate    Script Date: 12/27/00 8:58:41 PM ******/

/* 
For Updating trade's qty ,flags 
used in After Contract, after bill
Create Date 28 Aug 2000 11:00 PM 
Created By Animesh Jain
*/
CREATE procedure AfterBillFlagUpdate  
@ttradeno varchar(10), 
@tqty int, 
@tnetrate numeric(28,13) , 
@tmrate numeric(28,13) , 
@tscrip varchar(12), 
@tseries varchar(2), 
@tpartycd varchar(10), 
@tdate varchar(10),
@tsellbuy varchar(2),
@tBillFlag int
AS 
   if @Tqty > 0 
 begin
  update Settlement set TradeQty = @TQty, BillFlag = @TBillFlag
  where trade_no = @ttradeno
  and scrip_cd =@tscrip and series =@TSeries
           and sell_buy =@tsellbuy  and party_code = @tpartycd 
  and marketrate = @tMrate and netrate= @tNetRate
  and Convert(varchar,sauda_date,103) = @tdate
 end 
   else
 begin
    update settlement set tradeqty= 0,Normal = 0,Day_puc = 0,day_sales = 0,Sett_purch = 0,Sett_sales  = 0, 
                 marketrate = 0,Brokapplied = 0,NetRate = 0,Amount = 0,Ins_chrg = 0,turn_tax = 0,other_chrg = 0,
  sebi_tax = 0,Broker_chrg = 0,Service_tax = 0,Trade_amount = 0,NBrokApp = 0,NSerTax = 0,N_NetRate = 0
  where trade_no = @ttradeno
  and scrip_cd =@tscrip and series =@TSeries
  and sell_buy =@tsellbuy  and party_code = @tpartycd
  and marketrate = @tMrate and netrate= @tNetRate
  and Convert(varchar,sauda_date,103) = @tdate
 end

GO
