-- Object: PROCEDURE dbo.RearrangeTrdflag_STT_15072019
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[RearrangeTrdflag_STT]      
AS      
  DECLARE  @@TRADE_NO         VARCHAR(14),      
           @@PQTY             NUMERIC(9),      
           @@SQTY             NUMERIC(9),      
           @@SRNO          NUMERIC(18, 0),      
           @@LQTY             NUMERIC(9),      
           @@PDIFF            NUMERIC(9),      
           @@FLAG             CURSOR,      
           @@LOOP             CURSOR,      
           @@TPQTY            NUMERIC(9),      
           @@TSQTY            NUMERIC(9),      
           @@TSELL_BUY        INT,      
           @@PARTY_CODE       VARCHAR(15),      
           @@SCRIP_CD         VARCHAR(20),      
           @@SERIES           VARCHAR(3),      
           @@PARTIPANTCODE  VARCHAR(30),      
           @@TMARK            VARCHAR(3),      
           @@TPARTY_CODE      VARCHAR(15),      
           @@TSCRIP_CD        VARCHAR(20),      
           @@TSERIES          VARCHAR(3),      
           @@TPARTIPANTCODE VARCHAR(30),      
           @@TSETT_TYPE       VARCHAR(3),      
           @@SETT_TYPE        VARCHAR(3),      
           @@TTMARK           VARCHAR(3),      
           @@SCRIPLOOP        CURSOR,      
           @@SAUDA_DATE       VARCHAR(11)      



  SELECT PARTY_CODE INTO #PARENT FROM (
  SELECT PARTY_CODE, SCHEME 
  FROM STT_SETTLEMENT
  GROUP BY PARTY_CODE, SCHEME ) A
  GROUP BY PARTY_CODE
  HAVING COUNT(1) > 1 
  /*
  SELECT DISTINCT PARTY_CODE, SCHEME INTO #PARENT 
  FROM STT_SETTLEMENT
  GROUP BY PARTY_CODE, SCHEME 
  HAVING COUNT(1) > 1 
  */
  
  CREATE CLUSTERED INDEX PARENT_IDX ON #PARENT
  (
	PARTY_CODE
  )           
                             
  UPDATE STT_SETTLEMENT      
  SET    SETTFLAG = (CASE       
                       WHEN SELL_BUY = 1 THEN 4      
                       ELSE 5      
                     END)      
  WHERE  SETT_TYPE = 'W'      
                         
  UPDATE STT_SETTLEMENT SET TMARK = 'N'  
  
  UPDATE STT_SETTLEMENT      
  SET    SETTFLAG = (CASE       
                       WHEN PQTY = 0      
                            AND SQTY > 0 THEN 5      
                       WHEN PQTY > 0      
                            AND SQTY = 0 THEN 4      
                       ELSE (CASE       
                               WHEN SELL_BUY = 1 THEN 2      
                               ELSE 3      
                             END)      
                     END)      
  FROM   
         (SELECT   SETT_TYPE,
				   S.PARTY_CODE,      
                   SCRIP_CD,      
                   SERIES,      
                   PQTY = ISNULL(SUM(CASE       
                                       WHEN SELL_BUY = 1 THEN TRADEQTY      
                                       ELSE 0      
                                     END),0),      
                   SQTY = ISNULL(SUM(CASE       
                                       WHEN SELL_BUY = 2 THEN TRADEQTY      
                                       ELSE 0      
                                     END),0),      
                   PARTIPANTCODE,      
                   TMARK      
          FROM     STT_SETTLEMENT S, #PARENT      
          WHERE    SETT_TYPE <> 'W' 
          AND S.PARTY_CODE = #PARENT.PARTY_CODE   
          GROUP BY SETT_TYPE,S.PARTY_CODE,SCRIP_CD,SERIES,PARTIPANTCODE,      
                   TMARK) T1      
  WHERE  STT_SETTLEMENT.SETT_TYPE = T1.SETT_TYPE
		 AND STT_SETTLEMENT.PARTY_CODE = T1.PARTY_CODE      
         AND STT_SETTLEMENT.SCRIP_CD = T1.SCRIP_CD      
         AND STT_SETTLEMENT.SERIES = T1.SERIES      
         AND STT_SETTLEMENT.PARTIPANTCODE = T1.PARTIPANTCODE      
         AND STT_SETTLEMENT.TMARK = T1.TMARK      
      
        
  SET @@FLAG = CURSOR FOR      
        
   SELECT   *      
   FROM     (SELECT   SETT_TYPE,
				      T.PARTY_CODE,      
                      PARTIPANTCODE,      
                      SCRIP_CD,      
                      SERIES,      
                      TMARK,      
                            
                      PQTY = ISNULL(SUM(CASE       
                                          WHEN SELL_BUY = 1 THEN TRADEQTY      
                                          ELSE 0      
                                        END),0),      
                      SQTY = ISNULL(SUM(CASE       
                                          WHEN SELL_BUY = 2 THEN TRADEQTY      
                                    ELSE 0      
                                        END),0)      
                                   
             FROM     STT_SETTLEMENT T      
             WHERE    SETT_TYPE <> 'W'          
					  AND EXISTS (SELECT PARTY_CODE FROM #PARENT
					  WHERE T.PARTY_CODE = #PARENT.PARTY_CODE)       
             GROUP BY SETT_TYPE,T.PARTY_CODE,SCRIP_CD,SERIES,PARTIPANTCODE,      
                      TMARK) T      
                  
   WHERE    PQTY > 0      
            AND SQTY > 0      
     AND PQTY <> SQTY      
                              
   ORDER BY SETT_TYPE,
		    T.PARTY_CODE,      
            SCRIP_CD,      
            SERIES,      
            PARTIPANTCODE,      
            TMARK      
       
  OPEN @@FLAG      
        
  FETCH NEXT FROM @@FLAG      
  INTO @@SETT_TYPE,
	   @@PARTY_CODE,      
       @@PARTIPANTCODE,      
       @@SCRIP_CD,      
       @@SERIES,      
       @@TMARK,      
       @@TPQTY,      
       @@TSQTY      
             
  SELECT @@SQTY = 0      
                        
  SELECT @@PQTY = 0      
                        
  SELECT @@TPARTY_CODE = @@PARTY_CODE      
                               
  SELECT @@TPARTIPANTCODE = @@PARTIPANTCODE      
                                    
  SELECT @@TSCRIP_CD = @@SCRIP_CD      
                             
  SELECT @@TSERIES = @@SERIES      
                           
  SELECT @@TTMARK = @@TMARK      
                          
  WHILE ((@@FETCH_STATUS = 0))      
    BEGIN      
      IF @@TSQTY = 0      
        BEGIN      
          UPDATE STT_SETTLEMENT      
          SET    SETTFLAG = 4      
          WHERE  SETT_TYPE = @@SETT_TYPE
				 AND PARTY_CODE = @@TPARTY_CODE      
                 AND SCRIP_CD = @@TSCRIP_CD      
                 AND SERIES = @@TSERIES      
                 AND SELL_BUY = 1      
                 AND TMARK LIKE @@TMARK + '%'      
                 AND PARTIPANTCODE = @@TPARTIPANTCODE      
        END      
              
      IF @@TPQTY = 0      
        BEGIN      
          UPDATE STT_SETTLEMENT      
          SET    SETTFLAG = 5      
          WHERE  SETT_TYPE = @@SETT_TYPE
				 AND PARTY_CODE = @@PARTY_CODE      
                 AND SCRIP_CD = @@SCRIP_CD      
                 AND SERIES = @@SERIES      
                 AND SELL_BUY = 2      
                 AND TMARK LIKE @@TMARK + '%'      
                 AND PARTIPANTCODE = @@TPARTIPANTCODE      
        END      
              
      IF ((@@TPQTY > @@TSQTY)      
          AND (@@TSQTY > 0))      
        BEGIN      
          SELECT @@PDIFF = @@TPQTY - @@TSQTY      
                                           
          SET @@LOOP = CURSOR FOR SELECT   SRNO,      
                                           TRADEQTY      
                                  FROM     STT_SETTLEMENT      
                                  WHERE    SETT_TYPE = @@SETT_TYPE
										   AND PARTY_CODE = @@TPARTY_CODE      
                                           AND SCRIP_CD = @@TSCRIP_CD      
                                           AND SERIES = @@TSERIES      
                                           AND SELL_BUY = 1      
                                           AND PARTIPANTCODE = @@TPARTIPANTCODE      
                                  ORDER BY MARKETRATE DESC      
                                                 
          OPEN @@LOOP      
                
          FETCH NEXT FROM @@LOOP      
          INTO @@SRNO,      
               @@LQTY      
                     
          WHILE (@@FETCH_STATUS = 0)      
                AND (@@PDIFF > 0)      
            BEGIN      
              IF @@PDIFF >= @@LQTY      
                BEGIN      
                  UPDATE STT_SETTLEMENT      
                  SET    SETTFLAG = 4      
                  WHERE  SETT_TYPE = @@SETT_TYPE
				 AND PARTY_CODE = @@TPARTY_CODE      
                         AND SCRIP_CD = @@TSCRIP_CD      
                         AND SERIES = @@TSERIES      
                         AND SELL_BUY = 1      
                         AND SRNO = @@SRNO     
                         AND TRADEQTY = @@LQTY      
             AND PARTIPANTCODE = @@TPARTIPANTCODE      
                                                     
                  SELECT @@PDIFF = @@PDIFF - @@LQTY      
                END      
              ELSE      
                IF @@PDIFF < @@LQTY      
                  BEGIN      
                        
                    INSERT INTO STT_SETTLEMENT      
           SELECT ORGSRNO, CONTRACTNO,BILLNO,'A' + TRADE_NO,PARTY_CODE,SCRIP_CD,USER_ID,@@PDIFF,AUCTIONPART,    
     MARKETTYPE,SERIES,ORDER_NO,MARKETRATE,SAUDA_DATE,TABLE_NO,LINE_NO,VAL_PERC,NORMAL,DAY_PUC,    
     DAY_SALES,SETT_PURCH,SETT_SALES,SELL_BUY,4,BROKAPPLIED,NETRATE,AMOUNT,INS_CHRG,TURN_TAX,    
     OTHER_CHRG,SEBI_TAX,BROKER_CHRG,SERVICE_TAX,TRADE_AMOUNT,BILLFLAG,SETT_NO,NBROKAPP,NSERTAX,    
     N_NETRATE,SETT_TYPE,PARTIPANTCODE,STATUS,PRO_CLI,CPID,INSTRUMENT,BOOKTYPE,BRANCH_ID,TMARK,    
     SCHEME,DUMMY1,DUMMY2  
                    FROM   STT_SETTLEMENT      
                    WHERE      
                          
                           SETT_TYPE = @@SETT_TYPE
				 AND PARTY_CODE = @@TPARTY_CODE      
                           AND SCRIP_CD = @@TSCRIP_CD      
                           AND SERIES = @@TSERIES      
                           AND SELL_BUY = 1      
						   AND SRNO = @@SRNO     
                           AND TRADEQTY = @@LQTY      
                           AND PARTIPANTCODE = @@TPARTIPANTCODE      
                                                       
                    UPDATE STT_SETTLEMENT      
                    SET    SETTFLAG = 2,      
                           TRADEQTY = @@LQTY - @@PDIFF      
                    WHERE  SETT_TYPE = @@SETT_TYPE
				 AND PARTY_CODE = @@TPARTY_CODE      
                           AND SCRIP_CD = @@TSCRIP_CD      
                           AND SELL_BUY = 1      
                           AND SRNO = @@SRNO  
                           AND TRADEQTY = @@LQTY      
                           AND PARTIPANTCODE = @@PARTIPANTCODE      
                                                       
                    SELECT @@PDIFF = 0      
                  END      
                        
              IF @@PDIFF = 0      
                BREAK      
                      
              FETCH NEXT FROM @@LOOP      
              INTO @@SRNO,      
                   @@LQTY      
            END      
                  
          CLOSE @@LOOP      
        END      
              
      IF ((@@TPQTY < @@TSQTY)      
          AND (@@TPQTY > 0))      
        BEGIN      
          SELECT @@PDIFF = @@TSQTY - @@TPQTY      
                                           
          SET @@LOOP = CURSOR FOR SELECT   SRNO,      
                                           TRADEQTY      
                                  FROM     STT_SETTLEMENT      
                                  WHERE    SETT_TYPE = @@SETT_TYPE
				 AND PARTY_CODE = @@TPARTY_CODE      
                                           AND SCRIP_CD = @@TSCRIP_CD      
                                           AND SERIES = @@TSERIES      
                                           AND SELL_BUY = 2      
                                           AND PARTIPANTCODE = @@TPARTIPANTCODE      
                                  ORDER BY MARKETRATE DESC      
                                                 
          OPEN @@LOOP      
                
          FETCH NEXT FROM @@LOOP      
          INTO @@SRNO,      
               @@LQTY      
                     
          WHILE (@@FETCH_STATUS = 0)      
                AND (@@PDIFF > 0)      
            BEGIN      
              IF @@PDIFF >= @@LQTY      
                BEGIN      
                  UPDATE STT_SETTLEMENT      
                  SET    SETTFLAG = 5      
                  WHERE  SETT_TYPE = @@SETT_TYPE
				 AND PARTY_CODE = @@TPARTY_CODE      
                         AND SCRIP_CD = @@TSCRIP_CD      
                         AND SERIES = @@TSERIES      
                         AND SELL_BUY = 2      
           AND SRNO = @@SRNO  
                         AND TRADEQTY = @@LQTY      
                         AND PARTIPANTCODE = @@TPARTIPANTCODE      
                                                     
                  SELECT @@PDIFF = @@PDIFF - @@LQTY      
                END      
              ELSE      
                IF @@PDIFF < @@LQTY      
                  BEGIN      
                        
                    INSERT INTO STT_SETTLEMENT      
                    SELECT ORGSRNO, CONTRACTNO,BILLNO,'A' + TRADE_NO,PARTY_CODE,SCRIP_CD,USER_ID,@@PDIFF,AUCTIONPART,    
     MARKETTYPE,SERIES,ORDER_NO,MARKETRATE,SAUDA_DATE,TABLE_NO,LINE_NO,VAL_PERC,NORMAL,DAY_PUC,    
     DAY_SALES,SETT_PURCH,SETT_SALES,SELL_BUY,5,BROKAPPLIED,NETRATE,AMOUNT,INS_CHRG,TURN_TAX,    
     OTHER_CHRG,SEBI_TAX,BROKER_CHRG,SERVICE_TAX,TRADE_AMOUNT,BILLFLAG,SETT_NO,NBROKAPP,NSERTAX,    
     N_NETRATE,SETT_TYPE,PARTIPANTCODE,STATUS,PRO_CLI,CPID,INSTRUMENT,BOOKTYPE,BRANCH_ID,TMARK,    
     SCHEME,DUMMY1,DUMMY2    
                    FROM   STT_SETTLEMENT      
                    WHERE  SETT_TYPE = @@SETT_TYPE
				 AND PARTY_CODE = @@TPARTY_CODE      
                    AND SCRIP_CD = @@TSCRIP_CD      
                           AND SERIES = @@TSERIES      
                           AND SELL_BUY = 2      
                           AND SRNO = @@SRNO   
                           AND TRADEQTY = @@LQTY      
                           AND PARTIPANTCODE = @@TPARTIPANTCODE      
                                                       
                    UPDATE STT_SETTLEMENT      
                    SET    SETTFLAG = 3,      
                           TRADEQTY = @@LQTY - @@PDIFF      
                    WHERE  SETT_TYPE = @@SETT_TYPE
				 AND PARTY_CODE = @@TPARTY_CODE      
                           AND SCRIP_CD = @@TSCRIP_CD      
                           AND SELL_BUY = 2      
                           AND SRNO = @@SRNO  
                           AND TRADEQTY = @@LQTY      
                           AND PARTIPANTCODE = @@PARTIPANTCODE      
                                                       
                    SELECT @@PDIFF = 0      
                  END      
                        
              IF @@PDIFF = 0      
                BREAK      
                      
              FETCH NEXT FROM @@LOOP      
              INTO @@SRNO,      
                   @@LQTY      
            END      
                  
          CLOSE @@LOOP      
        END      
              
      FETCH NEXT FROM @@FLAG      
      INTO @@sett_type, @@PARTY_CODE,      
           @@PARTIPANTCODE,      
           @@SCRIP_CD,      
           @@SERIES,      
           @@TMARK,      
           @@TPQTY,      
           @@TSQTY      
                 
      SELECT @@TPARTY_CODE = @@PARTY_CODE      
                                   
      SELECT @@TPARTIPANTCODE = @@PARTIPANTCODE      
                                        
      SELECT @@TSCRIP_CD = @@SCRIP_CD      
                                 
      SELECT @@TSERIES = @@SERIES      
                               
      SELECT @@TTMARK = @@TMARK      
                              
    END      
          
  CLOSE @@FLAG      
        
  DEALLOCATE @@FLAG

GO
