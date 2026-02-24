-- Object: PROCEDURE dbo.rptNseExchShortage
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE rptNseExchShortage
(
	@SettType VarChar(3),
	@SettNo VarChar(7),
	@ShortageOption SmallInt,
	@ReportOption SmallInt
)
AS
BEGIN
	/*
	Shortage :
		1. Received
		2. Delived
		3. All
	
	Report Option
		1. Matched
		2. Mismatched
		3. All
	*/

	--- Temporary table to populate the report
	CREATE TABLE #SHORTAGE
	(
		SettType VarChar(3) Not Null Default(''),
		SettNo VarChar(7) Not Null Default(''),
		Symbol  VarChar(12) Not Null Default(''),
		Series  VarChar(3) Not Null Default(''),
		ExchQtyToDelivered Int Not Null Default(0),
		ExchQtyDelivered Int Not Null Default(0),
		ExchQtyShortDelivered	Int Not Null Default(0),
		ExchQtyToReceived Int Not Null Default(0),
		ExchQtyReceived Int Not Null Default(0),
		ExchQtyShortReceived	Int Not Null Default(0),
		BOQtyToDelivered Int Not Null Default(0),
		BOQtyDelivered Int Not Null Default(0),
		BOQtyShortDelivered	Int Not Null Default(0),
		BOQtyToReceived Int Not Null Default(0),
		BOQtyReceived Int Not Null Default(0),
		BOQtyShortReceived	Int Not Null Default(0),
		MimatchShortDelivered Bit Default(0),
		MimatchShortReceived Bit Default(0)
	)

	--- Insert the traded scrips for the selected settlement
	INSERT INTO #SHORTAGE(
		SettType,
		SettNo,
		Symbol,
		Series)
	SELECT DISTINCT 
		SETT_TYPE,
	   SETT_NO,
		SCRIP_CD, 
		SERIES 
	FROM DELNET 		-- SETTLEMENT & ISETTLEMENT
	WHERE Sett_Type = @SettType AND Sett_No = @SettNo

	--- Update Exchange Delivered - Shortage 
	UPDATE #SHORTAGE SET 
		ExchQtyToDelivered = QtyToDelivered,
		ExchQtyDelivered = QtyDelivered,
		ExchQtyShortDelivered = QtyShort 
	FROM #SHORTAGE A, ExchShortDelivered B
	WHERE A.SettType = B.SettType
		AND A.SettNo = B.SettNo
		AND A.Symbol = B.Symbol
		AND A.Series = B.Series

	--- Update Exchange Received - Shortage 
	UPDATE #SHORTAGE SET 
		ExchQtyToReceived = QtyToReceived,
		ExchQtyReceived = QtyReceivedTotal,
		ExchQtyShortReceived = QtyShort
	FROM #SHORTAGE A, ExchShortReceived B
	WHERE A.SettType = B.SettType
		AND A.SettNo = B.SettNo
		AND A.Symbol = B.Symbol
		AND A.Series = B.Series

	--- Update Back Office Delivered - Shortage 
	UPDATE #SHORTAGE SET 
		BOQtyToDelivered = GIVENSE,
		BOQtyDelivered = (GIVENNSE- RECEIVEDNSE),
		BOQtyShortDelivered = (GIVENSE + RECEIVEDNSE - GIVENNSE)
	FROM #SHORTAGE A, 
	(SELECT 
		D.SETT_NO,
		D.SETT_TYPE,
		D.SCRIP_CD,
		D.SERIES,
		GIVENSE=D.QTY,        
		GIVENNSE= ISNULL(SUM(CASE WHEN DRCR = 'D' THEN DT.QTY ELSE 0 END),0),        
		RECEIVEDNSE=ISNULL(SUM(CASE WHEN DRCR = 'C' THEN DT.QTY ELSE 0 END),0)    
		FROM DELNET D LEFT OUTER JOIN DELTRANS DT        
			ON (DT.SETT_NO = D.SETT_NO AND DT.SETT_TYPE = D.SETT_TYPE AND         
			DT.SCRIP_CD = D.SCRIP_CD AND DT.SERIES = D.SERIES AND TRTYPE = 906         
			AND FILLER2 = 1 )        
			WHERE D.SETT_NO = @SettNo AND D.SETT_TYPE = @SettType AND INOUT = 'I'         
			GROUP BY D.SETT_NO,D.SETT_TYPE,D.SCRIP_CD,D.SERIES,D.QTY) AS B      
	WHERE A.SettType = B.Sett_Type
		AND A.SettNo = B.Sett_No
		AND A.Symbol = B.Scrip_Cd
		AND A.Series = B.Series

	--- Update Back Office Received - Shortage 
	UPDATE #SHORTAGE SET 
		BOQtyToReceived = GETFROMNSE,
		BOQtyReceived = (RECIEVEDNSE-GIVENNSE),
		BOQtyShortReceived = (GETFROMNSE + GIVENNSE - RECIEVEDNSE)   
	FROM #SHORTAGE A, 
	(SELECT 
		D.SETT_NO,
		D.SETT_TYPE,
		D.SCRIP_CD,
		D.SERIES,
		GETFROMNSE=D.QTY,    
	   GIVENNSE= ISNULL(SUM(CASE WHEN DRCR = 'D' THEN DT.QTY ELSE 0 END),0),    
 		RECIEVEDNSE=ISNULL(SUM(CASE WHEN DRCR = 'C' THEN DT.QTY ELSE 0 END),0)    
 		FROM DELNET D LEFT OUTER JOIN DELTRANS DT    
		 ON (DT.SETT_NO = D.SETT_NO AND DT.SETT_TYPE = D.SETT_TYPE AND     
		 DT.SCRIP_CD = D.SCRIP_CD AND DT.SERIES = D.SERIES AND TRTYPE = 906     
		 AND FILLER2 = 1 )    
		 WHERE D.SETT_NO = @SettNo AND D.SETT_TYPE = @SettType AND INOUT = 'O'     
		 GROUP BY D.SETT_NO,D.SETT_TYPE,D.SCRIP_CD,D.SERIES,D.QTY) AS B   
	WHERE A.SettType = B.Sett_Type
		AND A.SettNo = B.Sett_No
		AND A.Symbol = B.Scrip_Cd
		AND A.Series = B.Series

	--- Update Mismatched DeliveredShortage & ReceivedShortage 
	UPDATE #SHORTAGE SET
		MimatchShortDelivered = CASE WHEN (ExchQtyShortDelivered <> BOQtyShortDelivered) THEN 1 ELSE 0 END,
		MimatchShortReceived = CASE WHEN (ExchQtyShortReceived <> BOQtyShortReceived) THEN 1 ELSE 0 END

	--- Remove the records where all values are zero
	DELETE FROM #SHORTAGE
	WHERE
		ExchQtyToDelivered = 0 AND
		ExchQtyDelivered = 0 AND
		ExchQtyShortDelivered	= 0 AND
		ExchQtyToReceived = 0 AND
		ExchQtyReceived = 0 AND
		ExchQtyShortReceived	= 0 AND
		BOQtyToDelivered = 0 AND
		BOQtyDelivered = 0 AND
		BOQtyShortDelivered	= 0 AND
		BOQtyToReceived = 0 AND
		BOQtyReceived = 0 AND
		BOQtyShortReceived = 0 	

	/*
	Shortage :
		1. Received
		2. Delived
		3. All
	
	Report Option
		1. Matched
		2. Mismatched
		3. All
	*/

	--- Received Details
		SELECT 
			SettType,
			SettNo,
			Symbol,
			Series,
			FromOrToExch = 'PAY-OUT' ,
			ExchObligation = ExchQtyToReceived ,
			ExchDeliveredOrReceived = ExchQtyReceived,
			ExchShortage = ExchQtyShortReceived,
			BOObligation = BOQtyToReceived,
			BODeliveredOrReceived = BOQtyReceived,
			BOShortage = BOQtyShortReceived,
			MisMatched = MimatchShortReceived
		INTO #SHORTAGEREPORT
		FROM #SHORTAGE
		WHERE ( 
		   ExchQtyToReceived > 0 OR
			ExchQtyReceived > 0 OR
			ExchQtyShortReceived > 0 OR
			BOQtyToReceived > 0 OR
			BOQtyReceived > 0 OR
			BOQtyShortReceived > 0 )

	--- Delivered Details
		INSERT INTO #SHORTAGEREPORT
		SELECT 
			SettType,
			SettNo,
			Symbol,
			Series,
			FromOrToExch = 'PAY-IN' ,
			ExchObligation = ExchQtyToDelivered ,
			ExchDeliveredOrReceived = ExchQtyDelivered,
			ExchShortage = ExchQtyShortDelivered,
			BOObligation = BOQtyToDelivered,
			BODeliveredOrReceived = BOQtyDelivered,
			BOShortage = BOQtyShortDelivered,
			MisMatched = MimatchShortDelivered
		FROM #SHORTAGE
		WHERE ( 
		   ExchQtyToDelivered > 0 OR
			ExchQtyDelivered > 0 OR
			ExchQtyShortDelivered > 0 OR
			BOQtyToDelivered > 0 OR
			BOQtyDelivered > 0 OR
			BOQtyShortDelivered > 0 )

	IF	@ShortageOption = 1	AND @ReportOption = 1		--- Received & Matched
		SELECT
			SettType,
			SettNo,
			Symbol,
			Series,
			FromOrToExch,
			ExchObligation,
			ExchDeliveredOrReceived,
			ExchShortage,
			BOObligation,
			BODeliveredOrReceived,
			BOShortage,
			MisMatched
		FROM #SHORTAGEREPORT 
		WHERE FromOrToExch = 'PAY-OUT'
			AND MisMatched = 0

	IF	@ShortageOption = 1	AND @ReportOption = 2		--- Received & MisMatched
		SELECT
			SettType,
			SettNo,
			Symbol,
			Series,
			FromOrToExch,
			ExchObligation,
			ExchDeliveredOrReceived,
			ExchShortage,
			BOObligation,
			BODeliveredOrReceived,
			BOShortage,
			MisMatched
		FROM #SHORTAGEREPORT 
		WHERE FromOrToExch = 'PAY-OUT'
			AND MisMatched = 1

	IF	@ShortageOption = 1	AND @ReportOption = 3		--- Received & Matched & MisMatched
		SELECT
			SettType,
			SettNo,
			Symbol,
			Series,
			FromOrToExch,
			ExchObligation,
			ExchDeliveredOrReceived,
			ExchShortage,
			BOObligation,
			BODeliveredOrReceived,
			BOShortage,
			MisMatched
		FROM #SHORTAGEREPORT 
		WHERE FromOrToExch = 'PAY-OUT'

	IF	@ShortageOption = 2	AND @ReportOption = 1		--- Received & Matched
		SELECT
			SettType,
			SettNo,
			Symbol,
			Series,
			FromOrToExch,
			ExchObligation,
			ExchDeliveredOrReceived,
			ExchShortage,
			BOObligation,
			BODeliveredOrReceived,
			BOShortage,
			MisMatched
		FROM #SHORTAGEREPORT 
		WHERE FromOrToExch = 'PAY-IN'
			AND MisMatched = 0

	IF	@ShortageOption = 2	AND @ReportOption = 2		--- Received & MisMatched
		SELECT
			SettType,
			SettNo,
			Symbol,
			Series,
			FromOrToExch,
			ExchObligation,
			ExchDeliveredOrReceived,
			ExchShortage,
			BOObligation,
			BODeliveredOrReceived,
			BOShortage,
			MisMatched
		FROM #SHORTAGEREPORT 
		WHERE FromOrToExch = 'PAY-IN'
			AND MisMatched = 1

	IF	@ShortageOption = 2	AND @ReportOption = 3		--- Received & Matched & MisMatched
		SELECT
			SettType,
			SettNo,
			Symbol,
			Series,
			FromOrToExch,
			ExchObligation,
			ExchDeliveredOrReceived,
			ExchShortage,
			BOObligation,
			BODeliveredOrReceived,
			BOShortage,
			MisMatched
		FROM #SHORTAGEREPORT 
		WHERE FromOrToExch = 'PAY-IN'

IF	@ShortageOption = 3	AND @ReportOption = 1		--- Received & Matched
		SELECT
			SettType,
			SettNo,
			Symbol,
			Series,
			FromOrToExch,
			ExchObligation,
			ExchDeliveredOrReceived,
			ExchShortage,
			BOObligation,
			BODeliveredOrReceived,
			BOShortage,
			MisMatched
		FROM #SHORTAGEREPORT 
		WHERE MisMatched = 0

	IF	@ShortageOption = 3	AND @ReportOption = 2		--- Received & MisMatched
		SELECT
			SettType,
			SettNo,
			Symbol,
			Series,
			FromOrToExch,
			ExchObligation,
			ExchDeliveredOrReceived,
			ExchShortage,
			BOObligation,
			BODeliveredOrReceived,
			BOShortage,
			MisMatched
		FROM #SHORTAGEREPORT 
		WHERE MisMatched = 1

	IF	@ShortageOption = 3	AND @ReportOption = 3		--- Received & Matched & MisMatched
		SELECT
			SettType,
			SettNo,
			Symbol,
			Series,
			FromOrToExch,
			ExchObligation,
			ExchDeliveredOrReceived,
			ExchShortage,
			BOObligation,
			BODeliveredOrReceived,
			BOShortage,
			MisMatched
		FROM #SHORTAGEREPORT 


END
    

/*

EXEC rptNseExchShortage 'N', '2007093', 3, 2
	
*/

GO
