-- Object: PROCEDURE dbo.TradeCheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


Create Proc TradeCheck as 
Set Transaction isolation level read uncommitted
select PTQty=Sum(Case When Sell_Buy = 1 And SettFlag = 2 Then TRadeQty Else 0 End),
STQty=Sum(Case When Sell_Buy = 2 And SettFlag = 3 Then TRadeQty Else 0 End),
PDQty=Sum(Case When Sell_Buy = 1 And SettFlag = 4 Then TRadeQty Else 0 End),
SDQty=Sum(Case When Sell_Buy = 2 And SettFlag = 5 Then TRadeQty Else 0 End),
Scrip_CD,Series,Party_Code, Partipantcode, TMark From Trade
Where Series <> 'BE'
Group By Scrip_CD,Series,Party_Code, Partipantcode, TMark
Having ( Sum(Case When Sell_Buy = 1 And SettFlag = 2 Then TRadeQty Else 0 End) 
	<> Sum(Case When Sell_Buy = 2 And SettFlag = 3 Then TRadeQty Else 0 End) )
Or (Sum(Case When Sell_Buy = 1 And SettFlag = 4 Then TRadeQty Else 0 End) > 0 
And Sum(Case When Sell_Buy = 2 And SettFlag = 5 Then TRadeQty Else 0 End) > 0)
Order BY Party_Code, Scrip_CD, Series

GO
