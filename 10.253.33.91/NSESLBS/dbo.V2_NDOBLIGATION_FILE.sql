-- Object: PROCEDURE dbo.V2_NDOBLIGATION_FILE
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC V2_NDOBLIGATION_FILE (@FILE_DATE VARCHAR(11)) AS
Select Header='01',Exchange='NSE', Party_code, TRADETYPE='ND', SCRIP_CD=LTrim(RTrim(Scrip_Cd)) + S.Series, 
BuyQty    = Sum(Case When Sell_Buy = 1 Then TradeQty Else -TradeQty End),
BuyValue  = Sum(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End)/
	    Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End),
SellQty   = 0,
SellValue = 0, RecordType='M'
From Settlement S, Sett_Mst SM
Where S.Sett_No = SM.Sett_No
And S.Sett_Type = SM.Sett_Type
And Start_Date > @File_Date
And Start_Date > Sauda_Date
And Sauda_Date < @File_Date
And Sec_Payin > @File_Date + ' 23:59'
And S.Sett_Type = 'N'
Group By Party_code, LTrim(RTrim(Scrip_Cd)) + S.Series
Having Sum(Case When Sell_Buy = 1 Then TradeQty Else -TradeQty End) > 0
Union All
Select Header='01',Exchange='BSE', Party_code, TRADETYPE='ND', SCRIP_CD=LTrim(RTrim(Scrip_Cd)), 
BuyQty    = Sum(Case When Sell_Buy = 1 Then TradeQty Else -TradeQty End),
BuyValue  = Sum(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End)/
	    Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End),
SellQty   = 0,
SellValue = 0, RecordType='M'
From BSEDB.DBO.Settlement S, #BSESett_Mst SM
Where S.Sett_No = SM.Sett_No
And S.Sett_Type = SM.Sett_Type
And Sauda_DATE < @File_Date
And Scrip_Cd In (Select Scrip_Cd From BSEDB.DBO.NoDel Where SM.Sett_No = NoDel.Sett_No)
Group By Party_code, LTrim(RTrim(Scrip_Cd))
Having Sum(Case When Sell_Buy = 1 Then TradeQty Else -TradeQty End) > 0
ORDER BY 3, 5

GO
