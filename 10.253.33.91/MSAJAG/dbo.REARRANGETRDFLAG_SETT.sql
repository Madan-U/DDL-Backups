-- Object: PROCEDURE dbo.REARRANGETRDFLAG_SETT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  /****** OBJECT:  STORED PROCEDURE DBO.REARRANGETRDFLAG_SETT    SCRIPT DATE: 01/14/2005 16:43:28 ******/    
CREATE PROCEDURE [DBO].[REARRANGETRDFLAG_SETT]    
AS    
  DECLARE  @@TRADE_NO         VARCHAR(14),    
           @@PQTY             NUMERIC(9),    
           @@SQTY             NUMERIC(9),    
           @@LTRADE_NO        VARCHAR(14),    
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
                                  
  UPDATE BBGSETTLEMENT    
  SET    SETTFLAG = (CASE     
                       WHEN SELL_BUY = 1 THEN 4    
                       ELSE 5    
                     END)    
  WHERE  SETT_TYPE = 'W'    
                       
  UPDATE BBGSETTLEMENT SET TMARK = 'N'

  UPDATE BBGSETTLEMENT    
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
  FROM   BBGSETTLEMENT T,    
         (SELECT   PARTY_CODE,    
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
          FROM     BBGSETTLEMENT    
          WHERE    SETT_TYPE <> 'W'    
          GROUP BY PARTY_CODE,SCRIP_CD,SERIES,PARTIPANTCODE,    
                   TMARK) T1    
  WHERE  T.PARTY_CODE = T1.PARTY_CODE    
         AND T.SCRIP_CD = T1.SCRIP_CD    
         AND T.SERIES = T1.SERIES    
         AND T.PARTIPANTCODE = T1.PARTIPANTCODE    
         AND T.TMARK = T1.TMARK    
    
      
  SET @@FLAG = CURSOR FOR    
      
   SELECT   *    
   FROM     (SELECT   T.PARTY_CODE,    
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
                                 
             FROM     BBGSETTLEMENT T    
             WHERE    SETT_TYPE <> 'W'    
             GROUP BY T.PARTY_CODE,PARTIPANTCODE,SCRIP_CD,SERIES,    
                      TMARK) T    
                
   WHERE    PQTY > 0    
            AND SQTY > 0    
     AND PQTY <> SQTY    
                            
   ORDER BY T.PARTY_CODE,    
            SCRIP_CD,    
            SERIES,    
            PARTIPANTCODE,    
            TMARK    
     
  OPEN @@FLAG    
      
  FETCH NEXT FROM @@FLAG    
  INTO @@PARTY_CODE,    
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
          UPDATE BBGSETTLEMENT    
          SET    SETTFLAG = 4    
          WHERE  PARTY_CODE = @@TPARTY_CODE    
                 AND SCRIP_CD = @@TSCRIP_CD    
                 AND SERIES = @@TSERIES    
                 AND SELL_BUY = 1    
                 AND TMARK LIKE @@TMARK + '%'    
                 AND PARTIPANTCODE = @@TPARTIPANTCODE    
        END    
            
      IF @@TPQTY = 0    
        BEGIN    
          UPDATE BBGSETTLEMENT    
          SET    SETTFLAG = 5    
          WHERE  PARTY_CODE = @@PARTY_CODE    
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
                                         
          SET @@LOOP = CURSOR FOR SELECT   TRADE_NO,    
                                           TRADEQTY    
                                  FROM     BBGSETTLEMENT    
                                  WHERE    PARTY_CODE = @@TPARTY_CODE    
                                           AND SCRIP_CD = @@TSCRIP_CD    
                                           AND SERIES = @@TSERIES    
                                           AND SELL_BUY = 1    
                                           AND PARTIPANTCODE = @@TPARTIPANTCODE    
                                  ORDER BY MARKETRATE DESC    
                                               
          OPEN @@LOOP    
              
          FETCH NEXT FROM @@LOOP    
          INTO @@LTRADE_NO,    
               @@LQTY    
                   
          WHILE (@@FETCH_STATUS = 0)    
                AND (@@PDIFF > 0)    
            BEGIN    
              IF @@PDIFF >= @@LQTY    
                BEGIN    
                  UPDATE BBGSETTLEMENT    
                  SET    SETTFLAG = 4    
                  WHERE  PARTY_CODE = @@TPARTY_CODE    
                         AND SCRIP_CD = @@TSCRIP_CD    
                         AND SERIES = @@TSERIES    
                         AND SELL_BUY = 1    
                         AND TRADE_NO = @@LTRADE_NO    
                         AND TRADEQTY = @@LQTY    
                         AND PARTIPANTCODE = @@TPARTIPANTCODE    
                                                   
                  SELECT @@PDIFF = @@PDIFF - @@LQTY    
                END    
              ELSE    
                IF @@PDIFF < @@LQTY    
                  BEGIN    
                      
                    INSERT INTO BBGSETTLEMENT    
                    SELECT CONTRACTNO,BILLNO,'A' + TRADE_NO,PARTY_CODE,SCRIP_CD,USER_ID,@@PDIFF,AUCTIONPART,  
     MARKETTYPE,SERIES,ORDER_NO,MARKETRATE,SAUDA_DATE,TABLE_NO,LINE_NO,VAL_PERC,NORMAL,DAY_PUC,  
     DAY_SALES,SETT_PURCH,SETT_SALES,SELL_BUY,4,BROKAPPLIED,NETRATE,AMOUNT,INS_CHRG,TURN_TAX,  
     OTHER_CHRG,SEBI_TAX,BROKER_CHRG,SERVICE_TAX,TRADE_AMOUNT,BILLFLAG,SETT_NO,NBROKAPP,NSERTAX,  
     N_NETRATE,SETT_TYPE,PARTIPANTCODE,STATUS,PRO_CLI,CPID,INSTRUMENT,BOOKTYPE,BRANCH_ID,TMARK,  
     SCHEME,DUMMY1,DUMMY2, PARENTCODE  
                    FROM   BBGSETTLEMENT    
                    WHERE    
                        
                           PARTY_CODE = @@TPARTY_CODE    
                           AND SCRIP_CD = @@TSCRIP_CD    
                           AND SERIES = @@TSERIES    
                           AND SELL_BUY = 1    
         AND TRADE_NO = @@LTRADE_NO    
                           AND TRADEQTY = @@LQTY    
                           AND PARTIPANTCODE = @@TPARTIPANTCODE    
                                                     
                    UPDATE BBGSETTLEMENT    
                    SET    SETTFLAG = 2,    
                           TRADEQTY = @@LQTY - @@PDIFF    
                    WHERE  PARTY_CODE = @@TPARTY_CODE    
                           AND SCRIP_CD = @@TSCRIP_CD    
                           AND SELL_BUY = 1    
                           AND TRADE_NO = @@LTRADE_NO    
                           AND TRADEQTY = @@LQTY    
                           AND PARTIPANTCODE = @@PARTIPANTCODE    
                                                     
                    SELECT @@PDIFF = 0    
                  END    
                      
              IF @@PDIFF = 0    
                BREAK    
                    
              FETCH NEXT FROM @@LOOP    
              INTO @@LTRADE_NO,    
                   @@LQTY    
            END    
                
          CLOSE @@LOOP    
        END    
            
      IF ((@@TPQTY < @@TSQTY)    
          AND (@@TPQTY > 0))    
        BEGIN    
          SELECT @@PDIFF = @@TSQTY - @@TPQTY    
                                         
          SET @@LOOP = CURSOR FOR SELECT   TRADE_NO,    
                                           TRADEQTY    
                                  FROM     BBGSETTLEMENT    
                                  WHERE    PARTY_CODE = @@TPARTY_CODE    
                                           AND SCRIP_CD = @@TSCRIP_CD    
                                           AND SERIES = @@TSERIES    
                                           AND SELL_BUY = 2    
                                           AND PARTIPANTCODE = @@TPARTIPANTCODE    
                                  ORDER BY MARKETRATE DESC    
                                               
          OPEN @@LOOP    
              
          FETCH NEXT FROM @@LOOP    
          INTO @@LTRADE_NO,    
               @@LQTY    
                   
          WHILE (@@FETCH_STATUS = 0)    
                AND (@@PDIFF > 0)    
            BEGIN    
              IF @@PDIFF >= @@LQTY    
                BEGIN    
                  UPDATE BBGSETTLEMENT    
                  SET    SETTFLAG = 5    
                  WHERE  PARTY_CODE = @@TPARTY_CODE    
                         AND SCRIP_CD = @@TSCRIP_CD    
                         AND SERIES = @@TSERIES    
                         AND SELL_BUY = 2    
                         AND TRADE_NO = @@LTRADE_NO    
                         AND TRADEQTY = @@LQTY    
                         AND PARTIPANTCODE = @@TPARTIPANTCODE    
                                                   
                  SELECT @@PDIFF = @@PDIFF - @@LQTY    
                END    
              ELSE    
                IF @@PDIFF < @@LQTY    
                  BEGIN    
                      
                    INSERT INTO BBGSETTLEMENT    
                    SELECT CONTRACTNO,BILLNO,'A' + TRADE_NO,PARTY_CODE,SCRIP_CD,USER_ID,@@PDIFF,AUCTIONPART,  
     MARKETTYPE,SERIES,ORDER_NO,MARKETRATE,SAUDA_DATE,TABLE_NO,LINE_NO,VAL_PERC,NORMAL,DAY_PUC,  
     DAY_SALES,SETT_PURCH,SETT_SALES,SELL_BUY,5,BROKAPPLIED,NETRATE,AMOUNT,INS_CHRG,TURN_TAX,  
     OTHER_CHRG,SEBI_TAX,BROKER_CHRG,SERVICE_TAX,TRADE_AMOUNT,BILLFLAG,SETT_NO,NBROKAPP,NSERTAX,  
     N_NETRATE,SETT_TYPE,PARTIPANTCODE,STATUS,PRO_CLI,CPID,INSTRUMENT,BOOKTYPE,BRANCH_ID,TMARK,  
     SCHEME,DUMMY1,DUMMY2, PARENTCODE  
                    FROM   BBGSETTLEMENT    
                    WHERE  PARTY_CODE = @@TPARTY_CODE    
                    AND SCRIP_CD = @@TSCRIP_CD    
                           AND SERIES = @@TSERIES    
                           AND SELL_BUY = 2    
                           AND TRADE_NO = @@LTRADE_NO    
                           AND TRADEQTY = @@LQTY    
                           AND PARTIPANTCODE = @@TPARTIPANTCODE    
                                                     
                    UPDATE BBGSETTLEMENT    
                    SET    SETTFLAG = 3,    
                           TRADEQTY = @@LQTY - @@PDIFF    
                    WHERE  PARTY_CODE = @@TPARTY_CODE    
                           AND SCRIP_CD = @@TSCRIP_CD    
                           AND SELL_BUY = 2    
                           AND TRADE_NO = @@LTRADE_NO    
                           AND TRADEQTY = @@LQTY    
                           AND PARTIPANTCODE = @@PARTIPANTCODE    
                                                     
                    SELECT @@PDIFF = 0    
                  END    
                      
              IF @@PDIFF = 0    
                BREAK    
                    
              FETCH NEXT FROM @@LOOP    
              INTO @@LTRADE_NO,    
                   @@LQTY    
            END    
                
          CLOSE @@LOOP    
        END    
            
      FETCH NEXT FROM @@FLAG    
      INTO @@PARTY_CODE,    
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
