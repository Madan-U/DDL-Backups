-- Object: PROCEDURE dbo.V2_INTEREST_CAL
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------



CREATE PROCEDURE V2_INTEREST_CAL 
(  
        @@BALDATE INT 
)  
  
AS  
  
/*==============================================================================================================  
        EXEC V2_INTEREST_CAL  
                @@BALDATE = 20070401 
==============================================================================================================*/  
  
        SET NOCOUNT ON

	DECLARE 
		@@CREDIT_INT MONEY, 
		@@DEBIT_INT MONEY,
		@@SPAN_MARGIN INT, 
		@@EXPOSURE_MARGIN INT

	SELECT 
		@@CREDIT_INT = CREDIT_INT, 
		@@DEBIT_INT = DEBIT_INT, 
        @@SPAN_MARGIN = SPAN_MARGIN, 
        @@EXPOSURE_MARGIN = EXPOSURE_MARGIN
	FROM V2_CLIENTPROFILES_FA 
	WHERE CLTCODE = 'ALL'


    SELECT 
        CLTCODE, 
        SEGMENTCODE, 
        LEDTYPE, 
        VDTBAL = SUM(VDTBAL), 
        VDTINTEREST = SUM(VDTINTEREST), 
        EDTBAL = SUM(EDTBAL), 
        EDTINTEREST = SUM(EDTINTEREST), 
		INTDATE = @@BALDATE 
    FROM 
    (
        SELECT 
        	V.CLTCODE, 
        	V.SEGMENTCODE, 
            V.LEDTYPE, 
        	VDTBAL = SUM(BALCR - BALDR), 
    		VDTINTEREST = (CASE WHEN SUM(BALCR - BALDR) > 0 
    				THEN ((SUM(BALCR - BALDR) * ISNULL(CREDIT_INT,@@CREDIT_INT)) / 100) / 365
    				ELSE 
    				(CASE WHEN SUM(BALCR - BALDR) < 0 
    				THEN ((SUM(BALCR - BALDR) * ISNULL(DEBIT_INT,@@DEBIT_INT)) / 100) / 365
    				ELSE 0 END) END), 
    		EDTBAL = 0, 
    		EDTINTEREST = 0
        FROM 
        	V2_ACCOUNTBALANCES V LEFT OUTER JOIN 
            V2_CLIENTPROFILES_FA F ON (V.CLTCODE = F.CLTCODE), 
        	PARAMETER P 
        WHERE 
        	CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) <= @@BALDATE
        	AND CONVERT(INT,CONVERT(VARCHAR,LDTCUR,112)) >= @@BALDATE 
        	AND VDT BETWEEN CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) AND @@BALDATE 
        GROUP BY 
        	V.CLTCODE, V.SEGMENTCODE, V.LEDTYPE, CREDIT_INT, DEBIT_INT
        HAVING SUM(BALCR - BALDR) <> 0 
        
        UNION ALL
    
        SELECT 
        	V.CLTCODE, 
        	V.SEGMENTCODE, 
            V.LEDTYPE, 
    		VDTBAL = 0, 
    		VDTINTEREST = 0, 
        	EDTBAL = SUM(BALCR - BALDR), 
    		EDTINTEREST = (CASE WHEN SUM(BALCR - BALDR) > 0 
    				THEN ((SUM(BALCR - BALDR) * ISNULL(CREDIT_INT,@@CREDIT_INT)) / 100) / 365
    				ELSE 
    				(CASE WHEN SUM(BALCR - BALDR) < 0 
    				THEN ((SUM(BALCR - BALDR) * ISNULL(DEBIT_INT,@@DEBIT_INT)) / 100) / 365
    				ELSE 0 END) END)
        FROM 
        	V2_ACCOUNTBALANCES V LEFT OUTER JOIN 
            V2_CLIENTPROFILES_FA F ON (V.CLTCODE = F.CLTCODE), 
        	PARAMETER P 
        WHERE 
        	CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) <= @@BALDATE
        	AND CONVERT(INT,CONVERT(VARCHAR,LDTCUR,112)) >= @@BALDATE 
        	AND EDT BETWEEN CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) AND @@BALDATE 
        GROUP BY 
        	V.CLTCODE, V.SEGMENTCODE, V.LEDTYPE, CREDIT_INT, DEBIT_INT
        HAVING SUM(BALCR - BALDR) <> 0 
    
        UNION ALL
    
        SELECT 
        	V.CLTCODE, 
        	V.SEGMENTCODE, 
            V.LEDTYPE, 
    		VDTBAL = 0, 
    		VDTINTEREST = 0, 
        	EDTBAL = SUM(BALCR - BALDR), 
    		EDTINTEREST = (CASE WHEN SUM(BALDR - BALCR) > 0 
    				THEN ((SUM(BALDR - BALCR) * ISNULL(DEBIT_INT,@@DEBIT_INT)) / 100) / 365
    				ELSE 
    				(CASE WHEN SUM(BALDR - BALCR) < 0 
    				THEN ((SUM(BALDR - BALCR) * ISNULL(CREDIT_INT,@@CREDIT_INT)) / 100) / 365
    				ELSE 0 END) END)
        FROM 
        	V2_ACCOUNTBALANCES V LEFT OUTER JOIN 
            V2_CLIENTPROFILES_FA F ON (V.CLTCODE = F.CLTCODE), 
        	PARAMETER P 
        WHERE 
        	CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) <= @@BALDATE
        	AND CONVERT(INT,CONVERT(VARCHAR,LDTCUR,112)) >= @@BALDATE 
        	AND EDT BETWEEN CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) AND @@BALDATE 
            AND VDT < CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112))
        GROUP BY 
        	V.CLTCODE, V.SEGMENTCODE, V.LEDTYPE, CREDIT_INT, DEBIT_INT
        HAVING SUM(BALDR - BALCR) <> 0 

        UNION ALL 
    
    	SELECT 
        	V.CLTCODE, 
        	SEGMENTCODE = 3, 
            LEDTYPE = 3, 
        	VDTBAL = NONCASH - (
                                (CASE WHEN ISNULL(SPAN_MARGIN,@@SPAN_MARGIN) = 1 THEN TOTALMARGIN ELSE 0 END) 
                                + 
                                (CASE WHEN ISNULL(EXPOSURE_MARGIN,@@EXPOSURE_MARGIN) = 1 THEN MTOM ELSE 0 END) 
                                    ), 
    		VDTINTEREST = (CASE WHEN NONCASH - (
                                (CASE WHEN ISNULL(SPAN_MARGIN,@@SPAN_MARGIN) = 1 THEN TOTALMARGIN ELSE 0 END) 
                                + 
                                (CASE WHEN ISNULL(EXPOSURE_MARGIN,@@EXPOSURE_MARGIN) = 1 THEN MTOM ELSE 0 END) 
                                    ) > 0 
    				THEN ((NONCASH - (
                                (CASE WHEN ISNULL(SPAN_MARGIN,@@SPAN_MARGIN) = 1 THEN TOTALMARGIN ELSE 0 END) 
                                + 
                                (CASE WHEN ISNULL(EXPOSURE_MARGIN,@@EXPOSURE_MARGIN) = 1 THEN MTOM ELSE 0 END) 
                                    ) * ISNULL(CREDIT_INT,@@CREDIT_INT)) / 100) / 365
    				ELSE 
    				(CASE WHEN NONCASH - (
                                (CASE WHEN ISNULL(SPAN_MARGIN,@@SPAN_MARGIN) = 1 THEN TOTALMARGIN ELSE 0 END) 
                                + 
                                (CASE WHEN ISNULL(EXPOSURE_MARGIN,@@EXPOSURE_MARGIN) = 1 THEN MTOM ELSE 0 END) 
                                    ) < 0 
    				THEN ((NONCASH - (
                                (CASE WHEN ISNULL(SPAN_MARGIN,@@SPAN_MARGIN) = 1 THEN TOTALMARGIN ELSE 0 END) 
                                + 
                                (CASE WHEN ISNULL(EXPOSURE_MARGIN,@@EXPOSURE_MARGIN) = 1 THEN MTOM ELSE 0 END) 
                                    ) * ISNULL(DEBIT_INT,@@DEBIT_INT)) / 100) / 365
    				ELSE 0 END) END), 
        	EDTBAL = NONCASH - (
                                (CASE WHEN ISNULL(SPAN_MARGIN,@@SPAN_MARGIN) = 1 THEN TOTALMARGIN ELSE 0 END) 
                                + 
                                (CASE WHEN ISNULL(EXPOSURE_MARGIN,@@EXPOSURE_MARGIN) = 1 THEN MTOM ELSE 0 END) 
                                    ), 
    		EDTINTEREST = (CASE WHEN NONCASH - (
                                (CASE WHEN ISNULL(SPAN_MARGIN,@@SPAN_MARGIN) = 1 THEN TOTALMARGIN ELSE 0 END) 
                                + 
                                (CASE WHEN ISNULL(EXPOSURE_MARGIN,@@EXPOSURE_MARGIN) = 1 THEN MTOM ELSE 0 END) 
                                    ) > 0 
    				THEN ((NONCASH - (
                                (CASE WHEN ISNULL(SPAN_MARGIN,@@SPAN_MARGIN) = 1 THEN TOTALMARGIN ELSE 0 END) 
                                + 
                                (CASE WHEN ISNULL(EXPOSURE_MARGIN,@@EXPOSURE_MARGIN) = 1 THEN MTOM ELSE 0 END) 
                                    ) * ISNULL(CREDIT_INT,@@CREDIT_INT)) / 100) / 365
    				ELSE 
    				(CASE WHEN NONCASH - (
                                (CASE WHEN ISNULL(SPAN_MARGIN,@@SPAN_MARGIN) = 1 THEN TOTALMARGIN ELSE 0 END) 
                                + 
                                (CASE WHEN ISNULL(EXPOSURE_MARGIN,@@EXPOSURE_MARGIN) = 1 THEN MTOM ELSE 0 END) 
                                    ) < 0 
    				THEN ((NONCASH - (
                                (CASE WHEN ISNULL(SPAN_MARGIN,@@SPAN_MARGIN) = 1 THEN TOTALMARGIN ELSE 0 END) 
                                + 
                                (CASE WHEN ISNULL(EXPOSURE_MARGIN,@@EXPOSURE_MARGIN) = 1 THEN MTOM ELSE 0 END) 
                                    ) * ISNULL(DEBIT_INT,@@DEBIT_INT)) / 100) / 365
    				ELSE 0 END) END)
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
    					WHERE CONVERT(INT,CONVERT(VARCHAR,TRANS_DATE,112)) = 
                            (SELECT CONVERT(INT,CONVERT(VARCHAR,MAX(TRANS_DATE),112)) FROM MSAJAG.DBO.COLLATERAL WHERE CONVERT(INT,CONVERT(VARCHAR,TRANS_DATE,112)) <= @@BALDATE AND EXCHANGE = 'NSE' AND SEGMENT = 'FUTURES') 
    					AND EXCHANGE = 'NSE' AND SEGMENT = 'FUTURES'
    				) C FULL OUTER JOIN 
    				(
    					SELECT CLTCODE = PARTY_CODE, TOTALMARGIN, MTOM 
    					FROM NSEFO.DBO.FOMARGINNEW 
    					WHERE CONVERT(INT,CONVERT(VARCHAR,MDATE,112)) = 
                            (SELECT CONVERT(INT,CONVERT(VARCHAR,MAX(MDATE),112)) FROM NSEFO.DBO.FOMARGINNEW WHERE CONVERT(INT,CONVERT(VARCHAR,MDATE,112)) <= @@BALDATE) 
    				) M 
    			ON M.CLTCODE = C.CLTCODE 
    		 ) V LEFT OUTER JOIN V2_CLIENTPROFILES_FA F ON (V.CLTCODE = F.CLTCODE)
    	WHERE NONCASH - (
                            (CASE WHEN ISNULL(SPAN_MARGIN,@@SPAN_MARGIN) = 1 THEN TOTALMARGIN ELSE 0 END) 
                            + 
                            (CASE WHEN ISNULL(EXPOSURE_MARGIN,@@EXPOSURE_MARGIN) = 1 THEN MTOM ELSE 0 END) 
                                ) < 0 
    ) FINAL 
    GROUP BY 
        CLTCODE, 
        SEGMENTCODE, 
        LEDTYPE

GO
