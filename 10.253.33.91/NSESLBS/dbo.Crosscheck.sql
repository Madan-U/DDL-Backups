-- Object: PROCEDURE dbo.Crosscheck
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Crosscheck As  
Select   
Pqty = Isnull(( Case When Sell_buy = 1 Then Sum(tradeqty) End ),0),   
Pamt = Isnull(( Case When Sell_buy = 1 Then Sum(tradeqty*marketrate) End ),0),   
Sqty = Isnull(( Case When Sell_buy = 2 Then Sum(tradeqty) End ),0),  
Samt = Isnull(( Case When Sell_buy = 2 Then Sum(tradeqty*marketrate) End ),0)  
From Settlement  
Group By Sell_buy

GO
