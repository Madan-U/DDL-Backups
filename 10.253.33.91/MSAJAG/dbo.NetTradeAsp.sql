-- Object: PROCEDURE dbo.NetTradeAsp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.NetTradeAsp    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.NetTradeAsp    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.NetTradeAsp    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.NetTradeAsp    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.NetTradeAsp    Script Date: 12/27/00 8:58:52 PM ******/

/****** Object:  Stored Procedure dbo.NetTradeAsp    Script Date: 12/18/99 8:24:13 AM ******/
CREATE PROCEDURE NetTradeAsp (@sett_no varchar(10), @sett_type varchar(3)) AS
select sett_mst.sett_no,sett_mst.sett_type,trade.scrip_cd,trade.series,trade.sell_buy, Trade.Tradeqty /* sum(trade.tradeqty) 'TQty' */  FROM trade,scrip1,scrip2,Sett_mst
      WHERE 
           ((Trade.Sauda_date <= sett_mst.End_date) And (Trade.Sauda_date >= sett_mst.Start_date))
    
       And
  (sett_mst.sett_type = 
   ( 
    case    
    when trade.series = 'AE'   AND (scrip1.demat_date <= Sett_mst.Sec_payout) 
    then 
    'M'
   
   when trade.series = 'AE' AND (scrip1.demat_date >= Sett_mst.Sec_payout) 
    then 
    'P'
   when trade.series = 'BE' 
   then 
   'W'
   when trade.series = 'TT' 
   then 
   'O'
   
   when trade.series = 'EQ'  and trade.markettype = '3'
   then 
   'L'
   when  trade.series <> 'BE' and trade.series <> 'AE' and trade.markettype = '1'
   then 
   'N'
   
   when trade.series = 'EQ'  and trade.markettype = '4'
   then 
   'A'
   end)
       ) 
           And 
              (Trade.Series = scrip2.series)
           And
             (scrip2.scrip_cd = trade.scrip_cd)
           And 
             (scrip2.co_code = scrip1.co_code) 
           And
             (scrip2.series = scrip1.series) 
    And sett_mst.Sett_no =  @sett_no 
    and Sett_mst.sett_type =  @sett_type 
group by sett_mst.sett_no,sett_mst.sett_type,trade.scrip_cd,trade.series,trade.sell_buy,trade.tradeqty

GO
