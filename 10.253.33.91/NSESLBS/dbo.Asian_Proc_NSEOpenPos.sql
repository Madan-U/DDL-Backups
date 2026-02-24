-- Object: PROCEDURE dbo.Asian_Proc_NSEOpenPos
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Proc Asian_Proc_NSEOpenPos (@Sauda_Date Varchar(11))
As

Select Header = '17', Exchange = 'NSE', Party_Code, ProductCode = 'OBLIGATION', RTRIM(Scrip_Cd)+RTRIM(SERIES), 
BuyQty = IsNull(Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End),0),
SellQty = IsNull(Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End),0),
BuyAmt = IsNull(Sum(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End),0),
SellAmt = IsNull(Sum(Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End),0)
From Settlement
Where Sauda_Date Like @Sauda_Date + '%'
And AuctionPart Not In ('AP', 'AR', 'FP', 'FS', 'FL', 'FA', 'FC')
And Trade_No Not Like '%C%'
Group By Party_Code, Scrip_Cd, SERIES
Order By Party_Code, Scrip_Cd, SERIES

GO
