-- Object: PROCEDURE dbo.brnetgty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brnetgty    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brnetgty    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brnetgty    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brnetgty    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brnetgty    Script Date: 12/27/00 8:58:45 PM ******/

/* Report : Netposition Trader
    File : netqty.asp
*/
CREATE PROCEDURE brnetgty
@br varchar  (3),
@settno varchar(7),
@settype varchar(3)
AS
select sett_no,sett_type,scrip_cd,series,sum(tradeqty) 'Qty',sell_buy,
amt = sum(tradeqty * marketrate)
from NetTradeA , client1 c1, client2 c2,branches b
where sett_no =@settno and sett_type = @settype
and c1.cl_code = c2.cl_code and b.short_name = c1.trader
and b.branch_cd = @br
group by sett_no,sett_type,scrip_cd,series,sell_buy

GO
