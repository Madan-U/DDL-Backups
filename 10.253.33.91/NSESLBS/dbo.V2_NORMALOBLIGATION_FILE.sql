-- Object: PROCEDURE dbo.V2_NORMALOBLIGATION_FILE
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROC V2_NORMALOBLIGATION_FILE 
(
	@FILE_DATE VARCHAR(11)
) 

AS

/*========================================================
	EXEC V2_NORMALOBLIGATION_FILE 
		@FILE_DATE = 'AUG 29 2006'
========================================================*/

SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	SELECT  Sett_no, 
			Sett_Type, 
			Sec_Payin, 
			Start_Date 
	INTO    #NSESett_Mst 
	FROM    Sett_Mst With(NoLock)
	WHERE   Sec_Payin      >= @File_Date  
			AND Start_Date <= @File_Date  
			AND sett_type   = 'N' 
			AND Sec_PayIn Not Like 
			(
				SELECT Left(Convert(Varchar,Sec_PayIn,109),11)+'%' 
				FROM    Sett_Mst With(NoLock) 
				WHERE   start_date like @File_Date + '%'  
						AND sett_type= 'N'
			)    

	SELECT  Sett_no, 
			Sett_Type, 
			Sec_Payin, 
			Start_Date 
	INTO    #BSESett_Mst 
	FROM    BSEDB.DBO.Sett_Mst With(NoLock) 
	WHERE   Sec_Payin      >= @File_Date  
			AND Start_Date <= @File_Date  
			AND sett_type   = 'D' 
			AND Sec_PayIn Not Like 
			(
				SELECT Left(Convert(Varchar,Sec_PayIn,109),11)+'%' 
				FROM    BSEDB.DBO.Sett_Mst With(NoLock) 
				WHERE   start_date like @File_Date + '%'  
						AND sett_type= 'D'
			)    

	SELECT PARTY_CODE, 
			SCRIP_CD, 
			SERIES, 
			BuyQty   = Sum(
				CASE 
						WHEN Sell_Buy = 1 
						THEN TradeQty 
						ELSE -TradeQty END),  
			NetBuyValue = 				
				Sum(
				CASE 
						WHEN Sell_Buy = 1 
						THEN TradeQty*N_NetRate
						ELSE 0 END), 
			NetBuyQty = 
				Sum(
				CASE 
						WHEN Sell_Buy = 1 
						THEN TradeQty
						ELSE 0 END), 
			SM.Sett_No, 
			SM.Sett_Type, 
			SM.Sec_Payin, 
			SM.Start_Date 
	INTO #SETT_NSE 
	FROM    Settlement S With(NoLock), 
			#NSESett_Mst SM With(NoLock) 
	WHERE   S.Sett_No       = SM.Sett_No  
			AND S.Sett_Type = SM.Sett_Type  
			AND Sauda_DATE  < @File_Date  
	GROUP BY S.Party_code, 
			SCRIP_CD, 
			SERIES, 
			SM.Sett_No, 
			SM.Sett_Type, 
			SM.Sec_Payin, 
			SM.Start_Date 

	DELETE #SETT_NSE WHERE Start_Date IN (SELECT MIN(Start_Date) FROM #NSESett_Mst) AND BuyQty < 0 

	SELECT PARTY_CODE, 
			SCRIP_CD, 
			SERIES, 
			BuyQty   = Sum(
				CASE 
						WHEN Sell_Buy = 1 
						THEN TradeQty 
						ELSE -TradeQty END),  
			NetBuyValue = 				
				Sum(
				CASE 
						WHEN Sell_Buy = 1 
						THEN TradeQty*N_NetRate
						ELSE 0 END), 
			NetBuyQty = 
				Sum(
				CASE 
						WHEN Sell_Buy = 1 
						THEN TradeQty
						ELSE 0 END), 
			SM.Sett_No, 
			SM.Sett_Type, 
			SM.Sec_Payin, 
			SM.Start_Date 
	INTO #SETT_BSE 
	FROM    BSEDB.DBO.Settlement S With(NoLock), 
			#BSESett_Mst SM With(NoLock) 
	WHERE   S.Sett_No       = SM.Sett_No  
			AND S.Sett_Type = SM.Sett_Type  
			AND Sauda_DATE  < @File_Date  
	GROUP BY S.Party_code, 
			SCRIP_CD, 
			SERIES, 
			SM.Sett_No, 
			SM.Sett_Type, 
			SM.Sec_Payin, 
			SM.Start_Date 

	DELETE #SETT_BSE WHERE Start_Date IN (SELECT MIN(Start_Date) FROM #BSESett_Mst) AND BuyQty < 0 

/*========================================================
	Final Select 

As per CR NO 200607-4976. 
Changed the placement of result set from BuyQty/ BuyValue/ SellQty/ SellValue to BuyQty/ SellQty/ BuyValue/ SellValue 
AND 

========================================================*/
	SELECT  Header  ='01',
			Exchange='NSE', 
			S.Party_code, 
			TRADETYPE='SRS', 
			SCRIP_CD =LTrim(RTrim(Scrip_Cd)) + LTrim(RTrim(Series)), 
			BuyQty   = Sum(BuyQty),  
			SellQty   = 0,  
			BuyValue = Round( ( Sum(NetBuyValue) / Sum(NetBuyQty) * Sum(BuyQty) ),2),  
			SellValue = 0, 
			RecordType='M'  
	FROM    #SETT_NSE S With(NoLock), 
			#NSESett_Mst SM With(NoLock), 
			Client1 C1 With(NoLock), 
			Client2 C2 With(NoLock)   
	WHERE   S.Sett_No       = SM.Sett_No  
			AND S.Sett_Type = SM.Sett_Type  
			AND S.Party_Code = C2.Party_Code 
			AND C2.Cl_Code = C1.Cl_Code 
			AND C1.Cl_Type In ('WEB','WBB')
	GROUP BY S.Party_code, 
			LTrim(RTrim(Scrip_Cd)) + LTrim(RTrim(Series))  
	HAVING Sum(BuyQty) > 0  
	UNION ALL  
	SELECT  Header ='01',
			Exchange ='BSE', 
			S.Party_code, 
			TRADETYPE='SRS', 
			SCRIP_CD =LTrim(RTrim(Scrip_Cd)), 
			BuyQty   = Sum(BuyQty),  
			SellQty   = 0,  
			BuyValue = Round( ( Sum(NetBuyValue) / Sum(NetBuyQty) * Sum(BuyQty) ),2),  
			SellValue = 0, 
			RecordType='M'  
	FROM    #SETT_BSE S With(NoLock), 
			#BSESett_Mst SM With(NoLock),  
			Client1 C1 With(NoLock), 
			Client2 C2 With(NoLock)   
	WHERE   S.Sett_No       = SM.Sett_No  
			AND S.Sett_Type = SM.Sett_Type  
			AND Scrip_Cd Not In 
			(
				SELECT Scrip_Cd 
				FROM    BSEDB.DBO.NoDel N With(NoLock) 
				WHERE   SM.Sett_No = N.Sett_No
			)  
			AND S.Party_Code = C2.Party_Code 
			AND C2.Cl_Code = C1.Cl_Code 
			AND C1.Cl_Type In ('WEB','WBB')
	GROUP BY S.Party_code, 
			LTrim(RTrim(Scrip_Cd))  
	HAVING Sum(BuyQty) > 0  
	ORDER BY 3, 5

GO
