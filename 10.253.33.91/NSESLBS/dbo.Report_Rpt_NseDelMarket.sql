-- Object: PROCEDURE dbo.Report_Rpt_NseDelMarket
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




Create Proc Report_Rpt_NseDelMarket 
(
@ASett_No Varchar(7),
@ASett_Type Varchar(2)
) As
Declare 
@@Sett_No Varchar(7),
@@Sett_Type Varchar(2),
@@Scrip_Cd Varchar(12),
@@Series Varchar(3),
@@AuctionParty Varchar(10),
@@SQty Int,
@@SAmount Numeric(18,6),
@@AQty Int,
@@AAmount Numeric(18,6),
@@NAmount Numeric(18,6),
@@DelCur Cursor,
@@Amtcur Cursor

Set @@DelCur = Cursor For
Select AuctionParty From DelSegment 
Open @@DelCur
Fetch Next From @@DelCur into @@AuctionParty
Close @@DelCur

Set @@DelCur = Cursor For
Select Distinct Scrip_CD,series,Sett_no,Sett_Type From DelAuctionPos Where ASett_No = @ASett_No And ASett_Type = @ASett_Type
Order By Scrip_CD,series,Sett_no,Sett_Type
Open @@DelCur
Fetch Next From @@DelCur InTo @@Scrip_Cd,@@Series,@@Sett_No,@@Sett_Type
While @@Fetch_Status = 0 
Begin
	Set @@AmtCur = Cursor For
	Select IsNull(Sum(TradeQty*MarketRate),0),Isnull(Sum(TradeQty),0) From Settlement where Sett_No = @@Sett_No And Sett_Type = @@Sett_Type
        And Scrip_Cd = @@Scrip_Cd And Series = @@Series And Party_code = @@AuctionParty And Sell_buy = 1 And TradeQty > 0 
	Open @@AmtCur
	Fetch Next From @@AmtCur into @@SAmount,@@SQty
	Close @@AmtCur

	Set @@AmtCur = Cursor For
	Select IsNull(Sum(TradeQty*MarketRate),0),Isnull(Sum(TradeQty),0) From Settlement where Sett_No = @ASett_No And Sett_Type = @ASett_Type
        And Scrip_Cd = @@Scrip_Cd And Series = @@Series And Sell_buy = 1 And TradeQty > 0 And AuctionPart = 'FS'
	Open @@AmtCur
	Fetch Next From @@AmtCur into @@AAmount,@@AQty
	Close @@AmtCur

	If (@@SQty + @@AQty) > 0 
        	Select @@NAmount = Round((@@SAmount + @@AAmount) / (@@SQty + @@AQty), 4)
	Else
                Select @@NAmount = 0
            
        If @@SQty > 0 
                Select @@SAmount = Round(@@SAmount / @@SQty, 4)
        Else
                Select @@SAmount = 0

	Update Settlement Set MarketRate = @@SAmount, NetRate = @@SAmount, N_NetRate = @@SAmount where Sett_No = @ASett_No And Sett_Type = @ASett_Type
        And Scrip_Cd = @@Scrip_Cd And Series = @@Series And Sell_buy = 2 And TradeQty > 0 And AuctionPart = 'FP' And branch_Id = 'Dummy'
        
        Update Settlement Set MarketRate = @@NAmount, NetRate = @@NAmount, N_NetRate = @@NAmount where Sett_No = @ASett_No And Sett_Type = @ASett_Type
        And Scrip_Cd = @@Scrip_Cd And Series = @@Series And Sell_buy = 1 And TradeQty > 0 And AuctionPart = 'FS' 
        
        Update Settlement Set MarketRate = @@NAmount, NetRate = @@NAmount, N_NetRate = @@NAmount where Sett_No = @ASett_No And Sett_Type = @ASett_Type
        And Scrip_Cd = @@Scrip_Cd And Series = @@Series And Sell_buy = 1 And TradeQty > 0 And AuctionPart = 'FP' And branch_Id <> 'Dummy'

	Fetch Next From @@DelCur InTo @@Scrip_Cd,@@Series,@@Sett_No,@@Sett_Type        
End 
Close @@DelCur
DeAllocate @@DelCur

Update Settlement Set Other_Chrg = AuctionChrg*(TradeQty*MarketRate)/100 From DelSegment 
Where AuctionPart Like 'F%' And Party_Code <> @@AuctionParty
And Sett_No = @ASett_No And Sett_Type = @ASett_Type And AuctionPart <> 'FC'

GO
