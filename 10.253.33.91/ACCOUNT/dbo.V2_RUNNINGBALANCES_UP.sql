-- Object: PROCEDURE dbo.V2_RUNNINGBALANCES_UP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------



CREATE PROCEDURE V2_RUNNINGBALANCES_UP  
(  
        @@BALDATE INT 
)  
  
AS  
  
/*==============================================================================================================  
        EXEC V2_RUNNINGBALANCES_UP  
                @@BALDATE = 20060402 
  
==============================================================================================================*/  
  
        SET NOCOUNT ON

/*
	IF LEN(CONVERT(CHAR,@@BALDATE)) <> 8 
	BEGIN 
		PRINT 'INCORRECT DATE FORMAT'
		RETURN 
	END

	IF CONVERT(INT,LEFT(RIGHT(CONVERT(CHAR,@@BALDATE),4),2)) > 12 OR  CONVERT(INT,LEFT(RIGHT(CONVERT(CHAR,@@BALDATE),4),2)) <= 0 
	BEGIN 
		PRINT 'INCORRECT DATE FORMAT'
		RETURN 
	END

	IF CONVERT(INT,RIGHT(CONVERT(CHAR,@@BALDATE),2)) > 31 OR  CONVERT(INT,RIGHT(CONVERT(CHAR,@@BALDATE),2)) <= 0 
	BEGIN 
		PRINT 'INCORRECT DATE FORMAT'
		RETURN 
	END
*/

/*==============================================================================================================  
	TO CALCULATE RUNNING BALANCE FOR CLIENTS WHO HAVE AN ENTRY IN THE LEDGER 
==============================================================================================================*/  
	SELECT DISTINCT CLTCODE, SEGMENTCODE, LEDTYPE 
	INTO #CLIENT 
	FROM V2_ACCOUNTBALANCES 
	WHERE VDT = @@BALDATE OR EDT = @@BALDATE 

	CREATE NONCLUSTERED INDEX [MAINIDX] ON [dbo].[#CLIENT] 
	(
		[CLTCODE] ASC
	)

	CREATE STATISTICS [MAINSTATS] ON [dbo].[#CLIENT]([CLTCODE], [SEGMENTCODE], [LEDTYPE])
	
	TRUNCATE TABLE V2_RUNNINGBALANCES_TMP 

/*==============================================================================================================  
	POPULATE VOUCHER DATE WISE LEDGER BALANCES
==============================================================================================================*/  
	INSERT INTO V2_RUNNINGBALANCES_TMP  
	SELECT 
		V.CLTCODE, 
		V.SEGMENTCODE, 
		V.LEDTYPE, 
		VDTBAL = SUM(BALCR - BALDR), 
		EDTBAL = 0, 
		BALDATE = @@BALDATE 
	FROM 
		V2_ACCOUNTBALANCES V, 
		#CLIENT C, 
		PARAMETER P 
	WHERE 
		CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) <= @@BALDATE
		AND CONVERT(INT,CONVERT(VARCHAR,LDTCUR,112)) >= @@BALDATE 
		AND VDT BETWEEN CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) AND @@BALDATE 
		AND V.CLTCODE = C.CLTCODE 
		AND V.SEGMENTCODE = C.SEGMENTCODE
		AND V.LEDTYPE = C.LEDTYPE 
	GROUP BY 
		V.CLTCODE, V.SEGMENTCODE, V.LEDTYPE
	
/*==============================================================================================================  
	POPULATE EFFECTIVE DATE WISE LEDGER BALANCES
==============================================================================================================*/  
	INSERT INTO V2_RUNNINGBALANCES_TMP  
	SELECT 
		V.CLTCODE, 
		V.SEGMENTCODE, 
		V.LEDTYPE, 
		VDTBAL = 0, 
		EDTBAL = SUM(BALCR - BALDR), 
		BALDATE = @@BALDATE 
	FROM 
		V2_ACCOUNTBALANCES V, 
		#CLIENT C, 
		PARAMETER P 
	WHERE 
		CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) <= @@BALDATE
		AND CONVERT(INT,CONVERT(VARCHAR,LDTCUR,112)) >= @@BALDATE 
		AND VDT BETWEEN CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) AND @@BALDATE 
		AND EDT BETWEEN CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) AND @@BALDATE 
		AND V.CLTCODE = C.CLTCODE 
		AND V.SEGMENTCODE = C.SEGMENTCODE
		AND V.LEDTYPE = C.LEDTYPE 
	GROUP BY 
		V.CLTCODE, V.SEGMENTCODE, V.LEDTYPE


/*==============================================================================================================  
	POPULATE MARGIN REQUIREMENT 
==============================================================================================================*/  
	INSERT INTO V2_RUNNINGBALANCES_TMP  
	SELECT 
		V.CLTCODE, 
		SEGMENTCODE = 3, 
		LEDTYPE = 3, 
		VDTBAL = NONCASH - (TOTALMARGIN + MTOM), 
		EDTBAL = NONCASH - (TOTALMARGIN + MTOM), 
		BALDATE = @@BALDATE 
	FROM 
		( 
			SELECT 
				CLTCODE = ISNULL(C.CLTCODE,M.CLTCODE), 
				NONCASH = ISNULL(NONCASH,0), 
				TOTALMARGIN = ISNULL(TOTALMARGIN,0), 
				MTOM = ISNULL(MTOM,0) 
			FROM 
				(
					SELECT CLTCODE = PARTY_CODE, NONCASH 
					FROM MSAJAG.DBO.COLLATERAL 
					WHERE CONVERT(INT,CONVERT(VARCHAR,TRANS_DATE,112)) = @@BALDATE 
					AND EXCHANGE = 'NSE' AND SEGMENT = 'FUTURES'
				) C FULL OUTER JOIN 
				(
					SELECT CLTCODE = PARTY_CODE, TOTALMARGIN, MTOM 
					FROM NSEFO.DBO.FOMARGINNEW 
					WHERE CONVERT(INT,CONVERT(VARCHAR,MDATE,112)) = @@BALDATE
				) M 
			ON M.CLTCODE = C.CLTCODE 
		 ) V
	WHERE NONCASH - (TOTALMARGIN + MTOM) < 0 

/*==============================================================================================================  
	POPULATE DATA IN FINAL TABLE 
==============================================================================================================*/  
	BEGIN TRAN 
		DELETE V2_RUNNINGBALANCES WHERE BALDATE = @@BALDATE

		INSERT INTO V2_RUNNINGBALANCES 
		SELECT 
			CLTCODE, 
			SEGMENTCODE, 
			LEDTYPE, 
			SUM(VDTBAL), 
			SUM(EDTBAL), 
			BALDATE 
		FROM 
			V2_RUNNINGBALANCES_TMP 
		GROUP BY  
			CLTCODE, 
			SEGMENTCODE, 
			LEDTYPE, 
			BALDATE 

		TRUNCATE TABLE V2_RUNNINGBALANCES_TMP 
	COMMIT TRAN

	TRUNCATE TABLE #CLIENT

/*==============================================================================================================  
	END OF PROCESS
==============================================================================================================*/

GO
