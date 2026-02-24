-- Object: PROCEDURE dbo.SettBrokEdit
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SettBrokEdit    Script Date: 3/17/01 9:56:10 PM ******/

/****** Object:  Stored Procedure dbo.SettBrokEdit    Script Date: 3/21/01 12:50:30 PM ******/

/****** Object:  Stored Procedure dbo.SettBrokEdit    Script Date: 20-Mar-01 11:39:08 PM ******/

/****** Object:  Stored Procedure dbo.SettBrokEdit    Script Date: 2/7/2001 12:40:11 PM ******/
CREATE Proc SettBrokEdit (@Sett_no Varchar(7),@Sett_Type Varchar(2),@Party_Code Varchar(10),@Scrip_Cd Varchar(12),@series Varchar(2),@Trade_no Varchar(14),@Order_no Varchar(16),@MarketRate Numeric(18,9),@Flag Int)
as 
If @Flag = 1 
Begin
Select S.Trade_No,S.Party_Code,S.Scrip_Cd,S.Series,Brok=S.brokapplied,NewBork=Convert(Numeric(9,4), C.Brokapplied),S.TradeQty,S.MarketRate,s.Sell_buy,s.BillNo From Settlement S, SettConfirmView C
where S.Sett_no = @Sett_No and S.sett_Type = @Sett_Type 
and S.Party_code Like @Party_Code
and S.scrip_cd like @Scrip_Cd
and s.series Like @Series
And S.Trade_no like @Trade_no
And S.Order_No  Like @Order_no
And S.Sett_no = c.sett_no
and S.sett_Type = C.Sett_type
And S.Party_code = C.Party_code
and S.scrip_cd like C.Scrip_Cd
and s.series = C.series
and s.trade_no = c.trade_no
and s.tradeqty = c.tradeqty
and s.marketrate = c.marketrate
and s.sell_buy = c.sell_buy
Order By S.Party_Code,S.Scrip_Cd,S.Series,S.Trade_No
End
else
Begin
Select  S.Trade_No,S.Party_Code,S.Scrip_Cd,S.Series,Brok=S.brokapplied,NewBork=Convert(Numeric(9,4), C.Brokapplied),S.TradeQty,S.MarketRate,s.Sell_buy,s.BillNo From Settlement S, SettConfirmView C
where S.Sett_no = @Sett_No and S.sett_Type = @Sett_Type 
and S.Party_code Like @Party_Code
and S.scrip_cd like @Scrip_Cd
and s.series Like @Series
and s.MarketRate = @MarketRate
And S.Trade_no like @Trade_no
And S.Order_No  Like @Order_no
And S.Sett_no = c.sett_no
and S.sett_Type = C.Sett_type
And S.Party_code = C.Party_code
and S.scrip_cd like C.Scrip_Cd
and s.series = C.series
and s.trade_no = c.trade_no
and s.tradeqty = c.tradeqty
and s.marketrate = c.marketrate
and s.sell_buy = c.sell_buy
Order By S.Party_Code,S.Scrip_Cd,S.Series,S.Trade_No
End

GO
