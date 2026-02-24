-- Object: PROCEDURE dbo.NETQTY10
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.NETQTY10    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.NETQTY10    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.NETQTY10    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.NETQTY10    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.NETQTY10    Script Date: 12/27/00 8:58:52 PM ******/

/****** Object:  Stored Procedure dbo.NETQTY10    Script Date: 12/18/99 8:24:14 AM ******/
CREATE PROCEDURE NETQTY10 as 
set rowcount 20
select sett_no,sett_type,scrip_cd,series,sum(tradeqty) 'Qty',sell_buy from NetTradeA 
group by sett_no,sett_type,scrip_cd,series,sell_buy
order by sum(tradeqty) desc

GO
