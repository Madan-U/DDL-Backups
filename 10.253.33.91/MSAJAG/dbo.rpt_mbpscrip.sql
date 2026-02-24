-- Object: PROCEDURE dbo.rpt_mbpscrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mbpscrip    Script Date: 04/27/2001 4:32:44 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mbpscrip    Script Date: 3/21/01 12:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mbpscrip    Script Date: 20-Mar-01 11:39:00 PM ******/





/****** Object:  Stored Procedure dbo.rpt_mbpscrip    Script Date: 2/5/01 12:06:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mbpscrip    Script Date: 12/27/00 8:59:13 PM ******/

/* changed by mousami on 27/02/2001 
    added isnull to all columns
*/

CREATE PROCEDURE rpt_mbpscrip
@scripcd varchar(10),
@series varchar(3)
AS

Select  Scrip_cd=isnull(Scrip_cd,''),Series=isnull(Series,''), People1=isnull(People1,0),
TradeQty1=isnull(TradeQty1,0),Rate1=isnull(Rate1,0), RecNo1=isnull(RecNo1,0),
People2=isnull(People2,0),TradeQty2=isnull(TradeQty2,0),Rate2=isnull(Rate2,0),
RecNo2=isnull(RecNo2,0),
People3=isnull(People3,0),TradeQty3=isnull(TradeQty3,0),
Rate3=isnull(Rate3,0),RecNo3=isnull(RecNo3,0),People4=isnull(People4,0),
TradeQty4=isnull(TradeQty4,0),
rate4=isnull(rate4,0),RecNo4=isnull(RecNo4,0)
,People5=isnull(People5,0),tradeQty5=isnull(tradeQty5,0),Rate5=isnull(Rate5,0),
RecNo5=isnull(RecNo5,0),
People6=isnull(People6,0),TradeQty6=isnull(TradeQty6,0),Rate6=isnull(Rate6,0),
RecNo6=isnull(RecNo6,0),People7=isnull(People7,0),TradeQty7=isnull(TradeQty7,0),
Rate7=isnull(Rate7,0),
RecNo7=isnull(RecNo7,0),People8=isnull(People8,0),TradeQty8=isnull(TradeQty8,0),
Rate8=isnull(Rate8,0),RecNo8=isnull(RecNo8,0),People9=isnull(People9,0),
TradeQty9=isnull(TradeQty9,0),Rate9=isnull(Rate9,0),
RecNo9=isnull(RecNo9,0),
People10=isnull(People10,0),TradeQty10=isnull(TradeQty10,0),Rate10=isnull(Rate10,0),RecNo10=isnull(RecNo10,0)
from MBPINFO1 where scrip_cd like @scripcd+'%'
and series =@series
order by scrip_cd,series

/*
old query
Select * from MBPINFO1 where scrip_cd like ltrim(@scripcd)+'%'
and series = @series order by scrip_cd,series
*/

GO
