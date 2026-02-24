-- Object: PROCEDURE dbo.spTurnOverAnalysisReport
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


/*
-------------------------------------------------------------------------------------------------------------------------
														SEBI Audit Reports 
-------------------------------------------------------------------------------------------------------------------------
1. List of all members traded during the month "November 2007"
Sl No.    Member Code          Member Name      Total Turnover (Buy Value + Sell Value)     Percentage of total Turnover


2. List of Top 10 members traded during the month "November 2007"
Sl No.    Member Code          Member Name      Total Turnover (Buy Value + Sell Value)     Percentage of total Turnover


3. List of all Scrips traded during the month "November 2007"
Sl No.    Scrip Code     Scrip Name     Turnover (Buy Value + Sell Value)      Percentage to Total Turnover


4. List of Top 10 scrips traded during the month "November 2007"
Sl No.    Scrip Code     Scrip Name     Turnover (Buy Value + Sell Value)      Percentage to Total Turnover

 Turnover Anyais Report
1. List of all members   
2. Top 10 members
3. List of all srips
4. Top 10 Scripts

From Date
To Date

*/

CREATE PROCEDURE spTurnOverAnalysisReport
(
	@FromDate VARCHAR(11),
	@ToDate VARCHAR(11),
	@ReportOption INT
) AS
BEGIN

	SET NOCOUNT ON

	DECLARE @TotalTurnOver NUMERIC(24,2)

	DECLARE @TurnOverAnalysis  TABLE(
		PartyCode VARCHAR(10) DEFAULT(''),
		PartyName VARCHAR(100) DEFAULT(''),
		ScripCode VARCHAR(10) DEFAULT(''),
		ScripName VARCHAR(50) DEFAULT(''),
		TurnOverBuy NUMERIC(24,2) DEFAULT(0),
		TurnOverSell NUMERIC(24,2) DEFAULT(0),
		TurnOverTotal NUMERIC(24,2) DEFAULT(0),
		TurnOverPercentage NUMERIC(24,4) DEFAULT(0)
	)

	IF @ReportOption = 1 OR @ReportOption = 2
	BEGIN
		INSERT INTO @TurnOverAnalysis
		(
			PartyCode,
			TurnOverBuy,
			TurnOverSell,
			TurnOverTotal
		)
	
		SELECT PartyCode = S.Party_Code,
				  TurnOverBuy = SUM(CASE WHEN S.SELL_BUY = 1 THEN (S.TradeQty * S.MarketRate) ELSE 0 END),
				  TurnOverSell = SUM(CASE WHEN S.SELL_BUY = 2 THEN (S.TradeQty * S.MarketRate) ELSE 0 END),
				  TurnOverTotal = SUM(TradeQty * MarketRate)
		FROM	SETTLEMENT S   
		WHERE    
			   S.SAUDA_DATE >= @FromDate                        
				AND S.SAUDA_DATE <= @ToDate + ' 23:59'                        
				AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FS', 'FA', 'FC', 'FL')                    
		GROUP BY S.Party_Code
	
		--- Update Party Name
		UPDATE @TurnOverAnalysis SET PartyName = C1.Long_Name FROM @TurnOverAnalysis T, Client1 C1, Client2 C2
			WHERE T.PartyCode = C2.Party_Code AND C1.Cl_Code = C2.Cl_Code

		---- Total TurnOver
		SELECT @TotalTurnOver = SUM(TurnOverTotal) FROM @TurnOverAnalysis
	
		--- Update Individual Party Turn Over Percentage
		UPDATE @TurnOverAnalysis SET TurnOverPercentage = CONVERT(NUMERIC(24,4), ((TurnOverTotal/@TotalTurnOver)*100.0000) )

		SET  NOCOUNT OFF

		IF @ReportOption = 1
			SELECT 
				[Member Code] = PartyCode,
				[Member Name] = PartyName,
				[Turnover Buy] = TurnOverBuy,
				[Turnover Sell] = TurnOverSell,
				[Total Turnover] = TurnOverTotal,
				[Turnover Percentage] = TurnOverPercentage
			 FROM @TurnOverAnalysis
				ORDER BY PartyName
		ELSE IF @ReportOption = 2
			SELECT TOP 10 
				[Member Code] = PartyCode,
				[Member Name] = PartyName,
				[Turnover Buy] = TurnOverBuy,
				[Turnover Sell] = TurnOverSell,
				[Total Turnover] = TurnOverTotal,
				[Turnover Percentage] = TurnOverPercentage
			 FROM @TurnOverAnalysis 
			 ORDER BY TurnOverPercentage DESC

	END				--- IF @ReportOption = 1 OR @ReportOption = 2
	IF @ReportOption = 3 OR @ReportOption = 4
	BEGIN
		INSERT INTO @TurnOverAnalysis
		(
			ScripCode,
			TurnOverBuy,
			TurnOverSell,
			TurnOverTotal
		)
	
		SELECT ScripCode = S.Scrip_Cd,
				  TurnOverBuy = SUM(CASE WHEN S.SELL_BUY = 1 THEN (S.TradeQty * S.MarketRate) ELSE 0 END),
				  TurnOverSell = SUM(CASE WHEN S.SELL_BUY = 2 THEN (S.TradeQty * S.MarketRate) ELSE 0 END),
				  TurnOverTotal = SUM(S.TradeQty * S.MarketRate)
		FROM	SETTLEMENT S   
		WHERE    
			   S.SAUDA_DATE >= @FromDate                        
				AND S.SAUDA_DATE <= @ToDate + ' 23:59'                        
				AND S.AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FS', 'FA', 'FC', 'FL')                    
		GROUP BY S.Scrip_Cd
	
		--- Update ScripName Name
		UPDATE @TurnOverAnalysis SET ScripName = S1.Long_Name FROM @TurnOverAnalysis T, Scrip1 S1, Scrip2 S2
				WHERE T.ScripCode = S2.Scrip_Cd AND S1.Co_Code = S2.Co_Code 

		---- Total TurnOver
		SELECT @TotalTurnOver = SUM(TurnOverTotal) FROM @TurnOverAnalysis
	
		--- Update Individual Scrip Turn Over Percentage
		UPDATE @TurnOverAnalysis SET TurnOverPercentage = CONVERT(NUMERIC(24,4), ((TurnOverTotal/@TotalTurnOver)*100.0000) )

		SET  NOCOUNT OFF

		IF @ReportOption = 3
			SELECT 
				[Scrip Code] = ScripCode,
				[Scrip Name] = ScripName,
				[Turnover Buy] = TurnOverBuy,
				[Turnover Sell] = TurnOverSell,
				[Total Turnover] = TurnOverTotal,
				[Turnover Percentage] = TurnOverPercentage
			 FROM @TurnOverAnalysis 
			 ORDER BY ScripCode
		ELSE IF @ReportOption = 4
			SELECT TOP 10 
				[Scrip Code] = ScripCode,
				[Scrip Name] = ScripName,
				[Turnover Buy] = TurnOverBuy,
				[Turnover Sell] = TurnOverSell,
				[Total Turnover] = TurnOverTotal,
				[Turnover Percentage] = TurnOverPercentage
			 FROM @TurnOverAnalysis 
			 ORDER BY TurnOverPercentage DESC

	END				--- IF @ReportOption = 3 OR @ReportOption = 4

END

/*

DECLARE
	@FromDate VARCHAR(11),
	@ToDate VARCHAR(11),
	@ReportOption INT

SET @FromDate = 'OCT  1 2005'
SET @ToDate = 'DEC  8 2007'
SET @ReportOption = 4

EXEC spTurnOverAnalysisReport
	@FromDate,
	@ToDate,
	@ReportOption

*/

GO
