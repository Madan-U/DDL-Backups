-- Object: PROCEDURE dbo.DelAucPenalty
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc DelAucPenalty 
(@Sett_No Varchar(7), @Sett_Type Varchar(2), @ASett_No Varchar(7), @ASett_Type Varchar(2))
AS
Update Settlement Set Other_Chrg = AuctionChrg*(TradeQty*MarketRate)/100 From DelSegment
Where Sett_no = @ASett_No and sett_type = @ASett_Type
And AuctionPart Like 'FS' And Sell_buy = 1

GO
