-- Object: PROCEDURE dbo.FODupRecCheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.FODupRecCheck    Script Date: 5/7/01 5:51:45 PM ******/
CREATE Proc FODupRecCheck As
/*created on 30 april 2001 by ranjeet choudhary*/
insert into FOtrade select * from FOfttrade where trade_no not in 
      ( select tm.trade_no from FOTrade tm
  	where convert(varchar,FOfttrade.ActivityTime,106) = convert(varchar,tm.ActivityTime,106)
 	and FOfttrade.trade_no = tm.trade_no
       	 and FOfttrade.order_no = tm.order_no
	and FOfttrade.inst_type=tm.inst_type
        and fofttrade.symbol=tm.symbol
        and fofttrade.expirydate=tm.expirydate and

   fofttrade.strike_price=tm.strike_price and
                fofttrade.option_type =tm.option_type  
                  

	and FOfttrade.tradeqty = tm.tradeqty
	and FOfttrade.price = tm.price
	and FOfttrade.sell_buy = tm.sell_buy
	and FOfttrade.marketType = tm.marketType )

GO
