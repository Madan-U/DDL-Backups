-- Object: PROCEDURE dbo.PROC_SETTFLAG_SET_bak_dec022019
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROCEDURE [dbo].[PROC_SETTFLAG_SET]      
AS      
  DECLARE  @TRADE_NO         VARCHAR(14),      
           @PQTY             NUMERIC(9),      
           @SQTY             NUMERIC(9),      
           @SRNO          NUMERIC(18, 0),      
           @LQTY             NUMERIC(9),      
           @PDIFF            NUMERIC(9),      
           @FLAG             CURSOR,      
           @LOOP             CURSOR,      
           @TPQTY            NUMERIC(9),      
           @TSQTY            NUMERIC(9),      
           @TSELL_BUY        INT,      
           @PARTY_CODE       VARCHAR(15),      
           @SCRIP_CD         VARCHAR(20),      
           @SERIES           VARCHAR(3),      
           @PARTIPANTCODE  VARCHAR(30),      
           @TMARK            VARCHAR(3),      
           @TPARTY_CODE      VARCHAR(15),      
           @TSCRIP_CD        VARCHAR(20),      
           @TSERIES          VARCHAR(3),      
           @TPARTIPANTCODE VARCHAR(30),      
           @TSETT_TYPE       VARCHAR(3),      
           @SETT_TYPE        VARCHAR(3),      
           @TTMARK           VARCHAR(3),      
           @SCRIPLOOP        CURSOR,      
           @SAUDA_DATE       VARCHAR(11)

  UPDATE COMBINE_SETTLEMENT      
  SET    SETTFLAG = (CASE       
                       WHEN SELL_BUY = 1 THEN 4      
                       ELSE 5      
                     END)      
  WHERE  SETT_TYPE = 'W'      
                         
  UPDATE COMBINE_SETTLEMENT SET TMARK = 'N'  
  
  UPDATE COMBINE_SETTLEMENT      
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
  FROM   COMBINE_SETTLEMENT T,      
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
          FROM     COMBINE_SETTLEMENT      
          WHERE    SETT_TYPE <> 'W'      
          GROUP BY PARTY_CODE,SCRIP_CD,SERIES,PARTIPANTCODE,      
                   TMARK) T1      
  WHERE  T.PARTY_CODE = T1.PARTY_CODE      
         AND T.SCRIP_CD = T1.SCRIP_CD      
         AND T.SERIES = T1.SERIES      
         AND T.PARTIPANTCODE = T1.PARTIPANTCODE      
         AND T.TMARK = T1.TMARK      
      
        
  SET @FLAG = CURSOR FOR      
        
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
                                   
             FROM     COMBINE_SETTLEMENT T      
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
       
  OPEN @FLAG      
        
  FETCH NEXT FROM @FLAG      
  INTO @PARTY_CODE,      
       @PARTIPANTCODE,      
       @SCRIP_CD,      
       @SERIES,      
       @TMARK,      
       @TPQTY,      
       @TSQTY      
             
  SELECT @SQTY = 0      
                        
  SELECT @PQTY = 0      
                        
  SELECT @TPARTY_CODE = @PARTY_CODE      
                               
  SELECT @TPARTIPANTCODE = @PARTIPANTCODE      
                                    
  SELECT @TSCRIP_CD = @SCRIP_CD      
                             
  SELECT @TSERIES = @SERIES      
                           
  SELECT @TTMARK = @TMARK      
                          
  WHILE ((@@FETCH_STATUS = 0))      
    BEGIN      
      IF @TSQTY = 0      
        BEGIN      
          UPDATE COMBINE_SETTLEMENT      
          SET    SETTFLAG = 4      
          WHERE  PARTY_CODE = @TPARTY_CODE      
                 AND SCRIP_CD = @TSCRIP_CD      
                 AND SERIES = @TSERIES      
                 AND SELL_BUY = 1      
                 AND TMARK LIKE @TMARK + '%'      
                 AND PARTIPANTCODE = @TPARTIPANTCODE      
        END      
              
      IF @TPQTY = 0      
        BEGIN      
          UPDATE COMBINE_SETTLEMENT      
          SET    SETTFLAG = 5      
          WHERE  PARTY_CODE = @PARTY_CODE      
                 AND SCRIP_CD = @SCRIP_CD      
                 AND SERIES = @SERIES      
                 AND SELL_BUY = 2      
                 AND TMARK LIKE @TMARK + '%'      
                 AND PARTIPANTCODE = @TPARTIPANTCODE      
        END      
              
      IF ((@TPQTY > @TSQTY)      
          AND (@TSQTY > 0))      
        BEGIN      
          SELECT @PDIFF = @TPQTY - @TSQTY      
                                           
          SET @LOOP = CURSOR FOR SELECT   SRNO,      
                                           TRADEQTY      
                                  FROM     COMBINE_SETTLEMENT      
                                  WHERE    PARTY_CODE = @TPARTY_CODE      
                                           AND SCRIP_CD = @TSCRIP_CD      
                                           AND SERIES = @TSERIES      
                                           AND SELL_BUY = 1      
                                           AND PARTIPANTCODE = @TPARTIPANTCODE      
                                  ORDER BY SAUDA_DATE DESC, ORDER_NO DESC, MARKETRATE DESC, TRADEQTY ASC   
                                                 
          OPEN @LOOP      
                
          FETCH NEXT FROM @LOOP      
          INTO @SRNO,      
               @LQTY      
                     
          WHILE (@@FETCH_STATUS = 0)      
                AND (@PDIFF > 0)      
            BEGIN      
              IF @PDIFF >= @LQTY      
                BEGIN      
                  UPDATE COMBINE_SETTLEMENT      
                  SET    SETTFLAG = 4      
                  WHERE  PARTY_CODE = @TPARTY_CODE      
                         AND SCRIP_CD = @TSCRIP_CD      
                         AND SERIES = @TSERIES      
                         AND SELL_BUY = 1      
                         AND SRNO = @SRNO     
                         AND TRADEQTY = @LQTY      
                         AND PARTIPANTCODE = @TPARTIPANTCODE      
                                                     
                  SELECT @PDIFF = @PDIFF - @LQTY      
                END      
              ELSE      
                IF @PDIFF < @LQTY      
                  BEGIN      
                        
                    INSERT INTO COMBINE_SETTLEMENT      
           SELECT ORGSRNO, CONTRACTNO,BILLNO,TRADE_NO,PARTY_CODE,SCRIP_CD,USER_ID,@PDIFF,AUCTIONPART,    
     MARKETTYPE,SERIES,ORDER_NO,MARKETRATE,SAUDA_DATE,TABLE_NO,LINE_NO,VAL_PERC,NORMAL,DAY_PUC,    
     DAY_SALES,SETT_PURCH,SETT_SALES,SELL_BUY,4,BROKAPPLIED,NETRATE,AMOUNT,
	 INS_CHRG=(INS_CHRG/TRADEQTY)*@PDIFF,
	 TURN_TAX=(TURN_TAX/TRADEQTY)*@PDIFF,    
     OTHER_CHRG=(OTHER_CHRG/TRADEQTY)*@PDIFF,
	 SEBI_TAX=(SEBI_TAX/TRADEQTY)*@PDIFF,
	 BROKER_CHRG=(BROKER_CHRG/TRADEQTY)*@PDIFF,
	 SERVICE_TAX=(SERVICE_TAX/TRADEQTY)*@PDIFF,TRADE_AMOUNT,BILLFLAG,SETT_NO,NBROKAPP,
	 NSERTAX=(NSERTAX/TRADEQTY)*@PDIFF,    
     N_NETRATE,SETT_TYPE,PARTIPANTCODE,STATUS,PRO_CLI,CPID,INSTRUMENT,BOOKTYPE,BRANCH_ID,TMARK,    
     SCHEME,DUMMY1,DUMMY2,EXCHG,ORG_CONTRACTNO,ORG_SETT_NO,ORG_SETT_TYPE,ORG_SCRIP_CD,ORG_SERIES,ISIN  
                    FROM   COMBINE_SETTLEMENT      
                    WHERE      
                          
                           PARTY_CODE = @TPARTY_CODE      
                           AND SCRIP_CD = @TSCRIP_CD      
                           AND SERIES = @TSERIES      
                           AND SELL_BUY = 1      
						   AND SRNO = @SRNO     
                           AND TRADEQTY = @LQTY      
                           AND PARTIPANTCODE = @TPARTIPANTCODE      
                                                       
                    UPDATE COMBINE_SETTLEMENT      
                    SET    SETTFLAG = 2,      
                           TRADEQTY = @LQTY - @PDIFF,
						   INS_CHRG = INS_CHRG-(INS_CHRG/TRADEQTY)*@PDIFF,
						   BROKER_CHRG=BROKER_CHRG-(BROKER_CHRG/TRADEQTY)*@PDIFF ,
						   OTHER_CHRG=OTHER_CHRG-(OTHER_CHRG/TRADEQTY)*@PDIFF ,
						   SEBI_TAX=SEBI_TAX-(SEBI_TAX/TRADEQTY)*@PDIFF ,
						   TURN_TAX=TURN_TAX-(TURN_TAX/TRADEQTY)*@PDIFF ,
						   SERVICE_TAX=SERVICE_TAX-(SERVICE_TAX/TRADEQTY)*@PDIFF  ,
						   NSERTAX=NSERTAX-(NSERTAX/TRADEQTY)*@PDIFF       
                    WHERE  PARTY_CODE = @TPARTY_CODE      
                           AND SCRIP_CD = @TSCRIP_CD      
                           AND SELL_BUY = 1      
                           AND SRNO = @SRNO  
                           AND TRADEQTY = @LQTY      
                           AND PARTIPANTCODE = @PARTIPANTCODE      
                                                       
                    SELECT @PDIFF = 0      
                  END      
                        
              IF @PDIFF = 0      
                BREAK      
                      
              FETCH NEXT FROM @LOOP      
              INTO @SRNO,      
                   @LQTY      
            END      
                  
          CLOSE @LOOP      
        END      
              
      IF ((@TPQTY < @TSQTY)      
          AND (@TPQTY > 0))      
        BEGIN      
          SELECT @PDIFF = @TSQTY - @TPQTY      
                                           
          SET @LOOP = CURSOR FOR SELECT   SRNO,      
                                           TRADEQTY      
                                  FROM     COMBINE_SETTLEMENT      
                                  WHERE    PARTY_CODE = @TPARTY_CODE      
                                           AND SCRIP_CD = @TSCRIP_CD      
                                           AND SERIES = @TSERIES      
                                           AND SELL_BUY = 2      
                                           AND PARTIPANTCODE = @TPARTIPANTCODE      
                                  ORDER BY SAUDA_DATE DESC, ORDER_NO DESC, MARKETRATE DESC, TRADEQTY ASC      
                                                 
          OPEN @LOOP      
                
          FETCH NEXT FROM @LOOP      
          INTO @SRNO,      
               @LQTY      
                     
          WHILE (@@FETCH_STATUS = 0)      
                AND (@PDIFF > 0)      
            BEGIN      
              IF @PDIFF >= @LQTY      
                BEGIN      
                  UPDATE COMBINE_SETTLEMENT      
                  SET    SETTFLAG = 5      
                  WHERE  PARTY_CODE = @TPARTY_CODE      
                         AND SCRIP_CD = @TSCRIP_CD      
                         AND SERIES = @TSERIES      
                         AND SELL_BUY = 2      
                         AND SRNO = @SRNO  
                         AND TRADEQTY = @LQTY      
                         AND PARTIPANTCODE = @TPARTIPANTCODE      
                                                     
                  SELECT @PDIFF = @PDIFF - @LQTY      
                END      
              ELSE      
                IF @PDIFF < @LQTY      
                  BEGIN      
                        
                    INSERT INTO COMBINE_SETTLEMENT      
                    SELECT ORGSRNO, CONTRACTNO,BILLNO,TRADE_NO,PARTY_CODE,SCRIP_CD,USER_ID,@PDIFF,AUCTIONPART,    
     MARKETTYPE,SERIES,ORDER_NO,MARKETRATE,SAUDA_DATE,TABLE_NO,LINE_NO,VAL_PERC,NORMAL,DAY_PUC,    
     DAY_SALES,SETT_PURCH,SETT_SALES,SELL_BUY,5,BROKAPPLIED,NETRATE,AMOUNT,
	 INS_CHRG=(INS_CHRG/TRADEQTY)*@PDIFF,
	 TURN_TAX=(TURN_TAX/TRADEQTY)*@PDIFF,    
     OTHER_CHRG=(OTHER_CHRG/TRADEQTY)*@PDIFF,
	 SEBI_TAX=(SEBI_TAX/TRADEQTY)*@PDIFF,
	 BROKER_CHRG=(BROKER_CHRG/TRADEQTY)*@PDIFF,
	 SERVICE_TAX=(SERVICE_TAX/TRADEQTY)*@PDIFF,TRADE_AMOUNT,BILLFLAG,SETT_NO,NBROKAPP,
	 NSERTAX=(NSERTAX/TRADEQTY)*@PDIFF,   
     N_NETRATE,SETT_TYPE,PARTIPANTCODE,STATUS,PRO_CLI,CPID,INSTRUMENT,BOOKTYPE,BRANCH_ID,TMARK,    
     SCHEME,DUMMY1,DUMMY2,EXCHG,ORG_CONTRACTNO,ORG_SETT_NO,ORG_SETT_TYPE,ORG_SCRIP_CD,ORG_SERIES,ISIN  
                    FROM   COMBINE_SETTLEMENT      
                    WHERE  PARTY_CODE = @TPARTY_CODE      
                    AND SCRIP_CD = @TSCRIP_CD      
                           AND SERIES = @TSERIES      
                           AND SELL_BUY = 2      
                           AND SRNO = @SRNO   
                           AND TRADEQTY = @LQTY      
                           AND PARTIPANTCODE = @TPARTIPANTCODE      
                                                       
                    UPDATE COMBINE_SETTLEMENT      
                    SET    SETTFLAG = 3,      
                           TRADEQTY = @LQTY - @PDIFF,
						   INS_CHRG = INS_CHRG-(INS_CHRG/TRADEQTY)*@PDIFF,
						   BROKER_CHRG=BROKER_CHRG-(BROKER_CHRG/TRADEQTY)*@PDIFF ,
						   OTHER_CHRG=OTHER_CHRG-(OTHER_CHRG/TRADEQTY)*@PDIFF ,
						   SEBI_TAX=SEBI_TAX-(SEBI_TAX/TRADEQTY)*@PDIFF ,
						   TURN_TAX=TURN_TAX-(TURN_TAX/TRADEQTY)*@PDIFF ,
						   SERVICE_TAX=SERVICE_TAX-(SERVICE_TAX/TRADEQTY)*@PDIFF  ,
						   NSERTAX=NSERTAX-(NSERTAX/TRADEQTY)*@PDIFF        
                    WHERE  PARTY_CODE = @TPARTY_CODE      
                           AND SCRIP_CD = @TSCRIP_CD      
                           AND SELL_BUY = 2      
                           AND SRNO = @SRNO  
                           AND TRADEQTY = @LQTY      
                           AND PARTIPANTCODE = @PARTIPANTCODE      
                                                       
                    SELECT @PDIFF = 0      
                  END      
                        
              IF @PDIFF = 0      
                BREAK      
                      
              FETCH NEXT FROM @LOOP      
              INTO @SRNO,      
                   @LQTY      
            END      
                  
          CLOSE @LOOP      
        END      
              
      FETCH NEXT FROM @FLAG      
      INTO @PARTY_CODE,      
           @PARTIPANTCODE,      
           @SCRIP_CD,      
           @SERIES,      
           @TMARK,      
           @TPQTY,      
           @TSQTY      
                 
      SELECT @TPARTY_CODE = @PARTY_CODE      
                                   
      SELECT @TPARTIPANTCODE = @PARTIPANTCODE      
                                        
      SELECT @TSCRIP_CD = @SCRIP_CD      
                                 
      SELECT @TSERIES = @SERIES      
                               
      SELECT @TTMARK = @TMARK      
                              
    END      
          
  CLOSE @FLAG      
        
  DEALLOCATE @FLAG 
  
  UPDATE COMBINE_SETTLEMENT SET BILLFLAG = SETTFLAG

GO
