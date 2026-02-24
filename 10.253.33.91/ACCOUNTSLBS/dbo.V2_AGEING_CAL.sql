-- Object: PROCEDURE dbo.V2_AGEING_CAL
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

--sp_helptext v2_ageing_cal
   CREATE PROCEDURE V2_AGEING_CAL   
(    
        @@BALDATE INT   
)    
    
AS    
    
/*==============================================================================================================    
        EXEC V2_AGEING_CAL    
                @@BALDATE = 20070626   
==============================================================================================================*/    
    
  
SET NOCOUNT ON  
  
DECLARE   
    @@BUCKET_1 INT,   
    @@BUCKET_2 INT,   
    @@BUCKET_3 INT,   
    @@BUCKET_4 INT,   
    @@CALDATE INT,   
    @@BUCKET INT,   
    @@UPDATEDATE DATETIME    
  
    SELECT @@UPDATEDATE = GETDATE()   
      
    SET @@BUCKET = 0   
      
/*==============================================================================================================    
    Populate No of Days Bucket Values for Canned Ageing  
        Also, identify & store the dates for Balance Computation based on Bucket Values  
==============================================================================================================*/    
  
    SELECT   
        @@BUCKET_1 = BUCKET_1,   
        @@BUCKET_2 = BUCKET_2,   
        @@BUCKET_3 = BUCKET_3,   
        @@BUCKET_4 = BUCKET_4   
    FROM V2_AGEINGBUCKETS  
      
    SELECT BUCKET = 0, BUCKET_DAYS = 0, BALDATE = @@BALDATE INTO #BUCKETS   
      
    INSERT INTO #BUCKETS SELECT 1, @@BUCKET_1, CONVERT(INT,CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(CHAR,@@BALDATE)) - @@BUCKET_1,112))   
    INSERT INTO #BUCKETS SELECT 2, @@BUCKET_2, CONVERT(INT,CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(CHAR,@@BALDATE)) - @@BUCKET_2,112))   
    INSERT INTO #BUCKETS SELECT 3, @@BUCKET_3, CONVERT(INT,CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(CHAR,@@BALDATE)) - @@BUCKET_3,112))   
    INSERT INTO #BUCKETS SELECT 4, @@BUCKET_4, CONVERT(INT,CONVERT(VARCHAR,CONVERT(DATETIME,CONVERT(CHAR,@@BALDATE)) - @@BUCKET_4,112))   
  
/*==============================================================================================================    
    Populate default NSEFO Margin Settings for considering Margin Requirement (after adjusting ]collateral)   
==============================================================================================================*/    
 DECLARE   
  @@SPAN_MARGIN INT,  
  @@EXPOSURE_MARGIN INT  
  
 SELECT   
        @@SPAN_MARGIN = SPAN_MARGIN,   
        @@EXPOSURE_MARGIN = EXPOSURE_MARGIN   
 FROM V2_CLIENTPROFILES_FA   
 WHERE CLTCODE = 'ALL'  
  
/*==============================================================================================================    
    Create Based Data for calculating Ageing  
        The base data is created using the summarized data as populated in the V2_ACCOUNTBALANCES Table  
==============================================================================================================*/    
    TRUNCATE TABLE V2_AGEINGDATA_TMP  
      
    SELECT DISTINCT CLTCODE    
    INTO #CLIENT   
    FROM V2_ACCOUNTBALANCES   
      
    CREATE NONCLUSTERED INDEX [MAINIDX] ON [dbo].[#CLIENT]   
    (  
     [CLTCODE] ASC  
    )  
  
    /*==============================================================================================================    
        Voucher Date wise Balances for the date   
    ==============================================================================================================*/    
    INSERT INTO V2_AGEINGDATA_TMP   
    SELECT   
        BALDATETYPE = 1,   
     V.CLTCODE,   
     V.SEGMENTCODE,   
     BALANCE = SUM(BALCR - BALDR),   
        BUCKET_1 = 0,   
        BUCKET_2 = 0,   
        BUCKET_3 = 0,   
        BUCKET_4 = 0,   
        'BACKEND',   
        @@UPDATEDATE   
    FROM   
     V2_ACCOUNTBALANCES V,   
     #CLIENT C,   
     PARAMETER P   
    WHERE   
     CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) <= @@BALDATE  
     AND CONVERT(INT,CONVERT(VARCHAR,LDTCUR,112)) >= @@BALDATE   
     AND VDT BETWEEN CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) AND @@BALDATE   
     AND V.CLTCODE = C.CLTCODE   
    GROUP BY   
     V.CLTCODE, V.SEGMENTCODE, V.LEDTYPE  
    HAVING SUM(BALCR - BALDR) <> 0   
      
    /*==============================================================================================================    
        Effective Date wise Balances for the date   
    ==============================================================================================================*/    
    INSERT INTO V2_AGEINGDATA_TMP   
    SELECT   
        BALDATETYPE = 2,   
     V.CLTCODE,   
     V.SEGMENTCODE,   
     BALANCE = SUM(BALCR - BALDR),   
        BUCKET_1 = 0,   
        BUCKET_2 = 0,   
        BUCKET_3 = 0,   
        BUCKET_4 = 0,   
        'BACKEND',   
        @@UPDATEDATE   
    FROM   
     V2_ACCOUNTBALANCES V,   
     #CLIENT C,   
     PARAMETER P   
    WHERE   
     CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) <= @@BALDATE  
     AND CONVERT(INT,CONVERT(VARCHAR,LDTCUR,112)) >= @@BALDATE   
     AND EDT BETWEEN CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) AND @@BALDATE   
     AND V.CLTCODE = C.CLTCODE   
    GROUP BY   
     V.CLTCODE, V.SEGMENTCODE, V.LEDTYPE  
    HAVING SUM(BALCR - BALDR) <> 0   
  
    INSERT INTO V2_AGEINGDATA_TMP   
    SELECT   
        BALDATETYPE = 2,   
     V.CLTCODE,   
     V.SEGMENTCODE,   
     BALANCE = SUM(BALDR - BALCR),   
        BUCKET_1 = 0,   
        BUCKET_2 = 0,   
        BUCKET_3 = 0,   
        BUCKET_4 = 0,   
        'BACKEND',   
        @@UPDATEDATE   
    FROM   
     V2_ACCOUNTBALANCES V,   
     #CLIENT C,   
     PARAMETER P   
    WHERE   
     CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) <= @@BALDATE  
     AND CONVERT(INT,CONVERT(VARCHAR,LDTCUR,112)) >= @@BALDATE   
     AND EDT BETWEEN CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) AND @@BALDATE   
        AND VDT < CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112))   
     AND V.CLTCODE = C.CLTCODE   
    GROUP BY   
     V.CLTCODE, V.SEGMENTCODE, V.LEDTYPE  
    HAVING SUM(BALDR - BALCR) <> 0   
  
    /*==============================================================================================================    
        NSEFO Margin Requirement for the date   
    ==============================================================================================================*/    
 INSERT INTO V2_AGEINGDATA_TMP    
 SELECT   
        BALDATETYPE = 0,   
     V.CLTCODE,   
     SEGMENTCODE = 3,   
     BALANCE = NONCASH - (  
                            (CASE WHEN ISNULL(SPAN_MARGIN,@@SPAN_MARGIN) = 1 THEN TOTALMARGIN ELSE 0 END)   
                            +   
                            (CASE WHEN ISNULL(EXPOSURE_MARGIN,@@EXPOSURE_MARGIN) = 1 THEN MTOM ELSE 0 END)   
                                ),   
        BUCKET_1 = 0,   
        BUCKET_2 = 0,   
        BUCKET_3 = 0,   
        BUCKET_4 = 0,   
        'BACKEND',   
        @@UPDATEDATE   
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
  
    DELETE #CLIENT WHERE CLTCODE NOT IN (SELECT DISTINCT CLTCODE FROM V2_AGEINGDATA_TMP)  
      
/*==============================================================================================================    
    Begin Loop for calculating Balances for the dates computed based on Bucket Values   
        Provision for 4 + 1 Buckets has been provided  
==============================================================================================================*/    
    WHILE @@BUCKET <= 4   
    BEGIN   
        SELECT @@CALDATE = BALDATE FROM #BUCKETS WHERE BUCKET = @@BUCKET   
      
    /*==============================================================================================================    
        Voucher Date wise Balances as on the date populate against each Bucket  
    ==============================================================================================================*/    
        INSERT INTO V2_AGEINGDATA_TMP   
        SELECT   
            BALDATETYPE = 1,   
         V.CLTCODE,   
         V.SEGMENTCODE,   
         BALANCE = 0,   
            BUCKET_1 = (CASE WHEN @@BUCKET = 1 THEN SUM(BALCR - BALDR) ELSE 0 END),   
            BUCKET_2 = (CASE WHEN @@BUCKET = 2 THEN SUM(BALCR - BALDR) ELSE 0 END),    
            BUCKET_3 = (CASE WHEN @@BUCKET = 3 THEN SUM(BALCR - BALDR) ELSE 0 END),   
            BUCKET_4 = (CASE WHEN @@BUCKET = 4 THEN SUM(BALCR - BALDR) ELSE 0 END),   
            'BACKEND',   
            @@UPDATEDATE   
        FROM   
         V2_ACCOUNTBALANCES V,   
         #CLIENT C,   
         PARAMETER P   
        WHERE   
         CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) <= @@CALDATE  
         AND CONVERT(INT,CONVERT(VARCHAR,LDTCUR,112)) >= @@CALDATE   
         AND VDT BETWEEN CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) AND @@CALDATE   
         AND V.CLTCODE = C.CLTCODE   
        GROUP BY   
         V.CLTCODE, V.SEGMENTCODE, V.LEDTYPE  
        HAVING SUM(BALCR - BALDR) <> 0   
  
    /*==============================================================================================================    
        Effective Date wise Balances as on the date populate against each Bucket  
    ==============================================================================================================*/    
        INSERT INTO V2_AGEINGDATA_TMP   
        SELECT   
            BALDATETYPE = 2,   
         V.CLTCODE,   
         V.SEGMENTCODE,   
         BALANCE = 0,   
            BUCKET_1 = (CASE WHEN @@BUCKET = 1 THEN SUM(BALCR - BALDR) ELSE 0 END),   
            BUCKET_2 = (CASE WHEN @@BUCKET = 2 THEN SUM(BALCR - BALDR) ELSE 0 END),    
            BUCKET_3 = (CASE WHEN @@BUCKET = 3 THEN SUM(BALCR - BALDR) ELSE 0 END),   
            BUCKET_4 = (CASE WHEN @@BUCKET = 4 THEN SUM(BALCR - BALDR) ELSE 0 END),   
            'BACKEND',   
            @@UPDATEDATE   
        FROM   
         V2_ACCOUNTBALANCES V,   
         #CLIENT C,   
         PARAMETER P   
        WHERE   
         CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) <= @@CALDATE  
         AND CONVERT(INT,CONVERT(VARCHAR,LDTCUR,112)) >= @@CALDATE   
         AND EDT BETWEEN CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) AND @@CALDATE   
         AND V.CLTCODE = C.CLTCODE   
        GROUP BY   
         V.CLTCODE, V.SEGMENTCODE, V.LEDTYPE  
        HAVING SUM(BALCR - BALDR) <> 0   
  
        INSERT INTO V2_AGEINGDATA_TMP   
        SELECT   
            BALDATETYPE = 2,   
         V.CLTCODE,   
         V.SEGMENTCODE,   
         BALANCE = 0,   
            BUCKET_1 = (CASE WHEN @@BUCKET = 1 THEN SUM(BALDR - BALCR) ELSE 0 END),   
            BUCKET_2 = (CASE WHEN @@BUCKET = 2 THEN SUM(BALDR - BALCR) ELSE 0 END),    
            BUCKET_3 = (CASE WHEN @@BUCKET = 3 THEN SUM(BALDR - BALCR) ELSE 0 END),   
            BUCKET_4 = (CASE WHEN @@BUCKET = 4 THEN SUM(BALDR - BALCR) ELSE 0 END),   
            'BACKEND',   
            @@UPDATEDATE   
        FROM   
         V2_ACCOUNTBALANCES V,   
         #CLIENT C,   
         PARAMETER P   
        WHERE   
         CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) <= @@CALDATE  
         AND CONVERT(INT,CONVERT(VARCHAR,LDTCUR,112)) >= @@CALDATE   
         AND EDT BETWEEN CONVERT(INT,CONVERT(VARCHAR,SDTCUR,112)) AND @@CALDATE   
         AND V.CLTCODE = C.CLTCODE   
        GROUP BY   
         V.CLTCODE, V.SEGMENTCODE, V.LEDTYPE  
        HAVING SUM(BALDR - BALCR) <> 0   
  
    /*==============================================================================================================    
        NSEFO Margin Requirement as on the date populate against each Bucket  
    ==============================================================================================================*/    
     INSERT INTO V2_AGEINGDATA_TMP    
     SELECT   
            BALDATETYPE = 0,   
         V.CLTCODE,   
         SEGMENTCODE = 3,   
         BALANCE = NONCASH - (  
                                (CASE WHEN ISNULL(SPAN_MARGIN,@@SPAN_MARGIN) = 1 THEN TOTALMARGIN ELSE 0 END)   
                                +   
                                (CASE WHEN ISNULL(EXPOSURE_MARGIN,@@EXPOSURE_MARGIN) = 1 THEN MTOM ELSE 0 END)   
                                    ),   
            BUCKET_1 = 0,   
            BUCKET_2 = 0,   
            BUCKET_3 = 0,   
            BUCKET_4 = 0,   
            'BACKEND',   
            @@UPDATEDATE   
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
                            (SELECT CONVERT(INT,CONVERT(VARCHAR,MAX(TRANS_DATE),112)) FROM MSAJAG.DBO.COLLATERAL WHERE CONVERT(INT,CONVERT(VARCHAR,TRANS_DATE,112)) <= @@CALDATE AND EXCHANGE = 'NSE' AND SEGMENT = 'FUTURES')   
         AND EXCHANGE = 'NSE' AND SEGMENT = 'FUTURES'  
        ) C FULL OUTER JOIN   
        (  
         SELECT CLTCODE = PARTY_CODE, TOTALMARGIN, MTOM   
         FROM NSEFO.DBO.FOMARGINNEW   
         WHERE CONVERT(INT,CONVERT(VARCHAR,MDATE,112)) =   
                            (SELECT CONVERT(INT,CONVERT(VARCHAR,MAX(MDATE),112)) FROM NSEFO.DBO.FOMARGINNEW WHERE CONVERT(INT,CONVERT(VARCHAR,MDATE,112)) <= @@CALDATE)   
        ) M   
       ON M.CLTCODE = C.CLTCODE   
       ) V LEFT OUTER JOIN V2_CLIENTPROFILES_FA F ON (V.CLTCODE = F.CLTCODE)  
     WHERE NONCASH - (  
                            (CASE WHEN ISNULL(SPAN_MARGIN,@@SPAN_MARGIN) = 1 THEN TOTALMARGIN ELSE 0 END)   
                            +   
                            (CASE WHEN ISNULL(EXPOSURE_MARGIN,@@EXPOSURE_MARGIN) = 1 THEN MTOM ELSE 0 END)   
                                ) < 0   
  
        SET @@BUCKET = @@BUCKET + 1   
    END  
  
    /*==============================================================================================================    
        Margin Requirement dummy data populated for Effective Date wise Calculation  
    ==============================================================================================================*/    
    INSERT INTO V2_AGEINGDATA_TMP   
    SELECT 2,CLTCODE,SEGMENTCODE,BALANCE,BUCKET_1,BUCKET_2,BUCKET_3,BUCKET_4,UPDATEBY,UPDATEDATE   
    FROM V2_AGEINGDATA_TMP WHERE BALDATETYPE = 0  
      
    UPDATE V2_AGEINGDATA_TMP SET BALDATETYPE = 1 WHERE BALDATETYPE = 0  
      
/*==============================================================================================================    
    Begin transaction to compute Final Ageing based on the Data created above   
==============================================================================================================*/    
    BEGIN TRAN  
        TRUNCATE TABLE V2_AGEINGDATA   
      
    /*==============================================================================================================    
        Computation Ageing Data based on the Consolidated Balances  
    ==============================================================================================================*/    
        INSERT INTO V2_AGEINGDATA   
        SELECT   
            @@BALDATE,   
            BALDATETYPE,   
            CLTCODE,   
            SEGMENTCODE = 0,   
            SUM(BALANCE),   
            SUM(BUCKET_1),   
            SUM(BUCKET_2),   
            SUM(BUCKET_3),   
            SUM(BUCKET_4),   
            UPDATEBY,   
            UPDATEDATE   
        FROM V2_AGEINGDATA_TMP   
        GROUP BY   
            BALDATETYPE,   
            CLTCODE,   
            UPDATEBY,   
            UPDATEDATE       
      
    /*==============================================================================================================    
        Computation Ageing Data based on the Segment Wise Balances  
    ==============================================================================================================*/    
        INSERT INTO V2_AGEINGDATA   
        SELECT   
            @@BALDATE,   
            BALDATETYPE,   
            CLTCODE,   
            SEGMENTCODE,   
            SUM(BALANCE),   
            SUM(BUCKET_1),   
            SUM(BUCKET_2),   
            SUM(BUCKET_3),   
            SUM(BUCKET_4),   
            UPDATEBY,   
            UPDATEDATE   
        FROM V2_AGEINGDATA_TMP   
        GROUP BY   
            BALDATETYPE,   
            CLTCODE,   
            SEGMENTCODE,   
            UPDATEBY,   
            UPDATEDATE       
      
    /*==============================================================================================================    
        Computation Final Ageing based on the Ageing Data populated above   
            Value in each Bucket is updated after desired splitting of the net balance of the Client  
    ==============================================================================================================*/    
        TRUNCATE TABLE V2_AGEINGFINAL   
        INSERT INTO V2_AGEINGFINAL   
        SELECT BALDATE,BALDATETYPE,CLTCODE,SEGMENTCODE,BALANCE,BUCKET_1,BUCKET_2,BUCKET_3,BUCKET_4,BUCKET_5 = 0,  
        UPDATEBY,UPDATEDATE   
        FROM V2_AGEINGDATA  
          
        UPDATE V2_AGEINGFINAL   
        SET BUCKET_1 =   
            (CASE   
                WHEN SIGN(BUCKET_1) = SIGN(BALANCE)   
                    AND ABS(BALANCE) > ABS(BUCKET_1)   
                THEN (ABS(BALANCE) - ABS(BUCKET_1)) * SIGN(BALANCE)   
            ELSE   
            CASE   
                WHEN SIGN(BUCKET_1) <> SIGN(BALANCE)   
                THEN BALANCE   
            ELSE 0 END END)  
          
        UPDATE V2_AGEINGFINAL   
        SET BUCKET_2 =   
            (CASE   
                WHEN SIGN(BUCKET_2) = SIGN(BALANCE)   
                    AND ABS(BALANCE) - ABS(BUCKET_1) > ABS(BUCKET_2)   
                THEN (ABS(BALANCE) - ABS(BUCKET_1) - ABS(BUCKET_2)) * SIGN(BALANCE)   
            ELSE   
            CASE   
                WHEN SIGN(BUCKET_2) <> SIGN(BALANCE)   
                THEN (ABS(BALANCE) - ABS(BUCKET_1)) * SIGN(BALANCE)   
            ELSE 0 END END)  
          
        UPDATE V2_AGEINGFINAL   
        SET BUCKET_3 =   
            (CASE   
                WHEN SIGN(BUCKET_3) = SIGN(BALANCE)   
                    AND ABS(BALANCE) - ABS(BUCKET_1) - ABS(BUCKET_2) > ABS(BUCKET_3)   
                THEN (ABS(BALANCE) - ABS(BUCKET_1) - ABS(BUCKET_2) - ABS(BUCKET_3)) * SIGN(BALANCE)   
            ELSE   
            CASE   
                WHEN SIGN(BUCKET_3) <> SIGN(BALANCE)   
                THEN (ABS(BALANCE) - ABS(BUCKET_1) - ABS(BUCKET_2)) * SIGN(BALANCE)   
            ELSE 0 END END)  
          
        UPDATE V2_AGEINGFINAL   
        SET BUCKET_4 =   
            (CASE   
                WHEN SIGN(BUCKET_4) = SIGN(BALANCE)   
                    AND ABS(BALANCE) - ABS(BUCKET_1) - ABS(BUCKET_2) - ABS(BUCKET_3) > ABS(BUCKET_4)   
                THEN (ABS(BALANCE) - ABS(BUCKET_1) - ABS(BUCKET_2) - ABS(BUCKET_3) - ABS(BUCKET_4)) * SIGN(BALANCE)   
            ELSE   
            CASE   
                WHEN SIGN(BUCKET_4) <> SIGN(BALANCE)   
                THEN (ABS(BALANCE) - ABS(BUCKET_1) - ABS(BUCKET_2) - ABS(BUCKET_3)) * SIGN(BALANCE)   
            ELSE 0 END END)  
          
        UPDATE V2_AGEINGFINAL   
        SET BUCKET_5 =   
            (ABS(BALANCE) - ABS(BUCKET_1) - ABS(BUCKET_2) - ABS(BUCKET_3) - ABS(BUCKET_4)) * SIGN(BALANCE)   
        WHERE   
            ABS(BALANCE) > ABS(BUCKET_1) + ABS(BUCKET_2) + ABS(BUCKET_3) + ABS(BUCKET_4)  
  
    TRUNCATE TABLE V2_AGEINGBUCKETS_TMP   
  
    INSERT INTO V2_AGEINGBUCKETS_TMP SELECT @@BUCKET_1, @@BUCKET_2, @@BUCKET_3, @@BUCKET_4   
  
    COMMIT  
      
/*==============================================================================================================    
    Clean Temporary Table   
==============================================================================================================*/    
    TRUNCATE TABLE V2_AGEINGDATA_TMP

GO
