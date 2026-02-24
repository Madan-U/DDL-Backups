-- Object: PROCEDURE dbo.REARRANGETRDFLAG
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[REARRANGETRDFLAG]      
AS      
  DECLARE  @TRADE_NO         VARCHAR(20),      
           @PQTY             NUMERIC(9),      
           @SQTY             NUMERIC(9),      
           @LTRADE_NO        VARCHAR(20),      
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
           @PARTICIPANTCODE  VARCHAR(30),      
           @TMARK            VARCHAR(3),      
           @TPARTY_CODE      VARCHAR(15),      
           @TSCRIP_CD        VARCHAR(20),      
           @TSERIES          VARCHAR(3),      
           @TPARTICIPANTCODE VARCHAR(30),      
           @TSETT_TYPE       VARCHAR(3),      
           @SETT_TYPE        VARCHAR(3),      
           @TTMARK           VARCHAR(3),      
           @SCRIPLOOP        CURSOR,      
           @SAUDA_DATE       VARCHAR(11),      
           @TTMARKETTYPE     VARCHAR(2),      
           @TMARKETTYPE      VARCHAR(2)      
                                    
  SELECT TOP 1 @SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11)      
  FROM   TRADE      
               
  INSERT INTO PROCESS_MONITOR      
  VALUES     ('IMPORT TRADE',      
              'CONFIRMATION',      
              '',      
              'REARRANGETRDFLAG',      
              'START',      
              'UPDATE SETTFLAG=4,5',      
              @SAUDA_DATE,      
              GETDATE())      
        
  UPDATE TRADE      
  SET    SETTFLAG = (CASE       
                       WHEN SELL_BUY = 1 THEN 4      
                       ELSE 5      
                     END)      
  WHERE  AUCTIONPART In ('W','Z')      
                             
  INSERT INTO PROCESS_MONITOR      
  VALUES     ('IMPORT TRADE',      
              'CONFIRMATION',      
              '',      
              'REARRANGETRDFLAG',      
              'DONE-UPDATE SETTFLAG=1 FOR DEL-CLIENTS AND BE-SERIES',      
              'UPDATE SETTFLAG=4,5',      
              @SAUDA_DATE,      
              GETDATE())      
        
	SELECT   PARTY_CODE,      
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
                   TMARK,      
                   MARKETTYPE
				   INTO #FLAG      
          FROM     TRADE      
          WHERE    AUCTIONPART NOT IN ('W','Z')      
          GROUP BY PARTY_CODE,SCRIP_CD,SERIES,PARTIPANTCODE,      
                   TMARK,MARKETTYPE

CREATE CLUSTERED INDEX IDXFLG ON #FLAG
(
	PARTY_CODE,
	SCRIP_CD,
	SERIES,
	PARTIPANTCODE,
	TMARK,
	MARKETTYPE
)

  UPDATE TRADE      
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
  FROM   TRADE T,      
         #FLAG T1      
  WHERE  T.PARTY_CODE = T1.PARTY_CODE      
         AND T.SCRIP_CD = T1.SCRIP_CD      
         AND T.SERIES = T1.SERIES      
         AND T.PARTIPANTCODE = T1.PARTIPANTCODE      
         AND T.TMARK = T1.TMARK      
         AND T.MARKETTYPE = T1.MARKETTYPE      
        
  INSERT INTO PROCESS_MONITOR      
  VALUES     ('IMPORT TRADE',      
              'CONFIRMATION',      
              '',      
              'REARRANGETRDFLAG',      
              'DONE-UPDATE SETTFLAG=4,5',      
              'UPDATE WHERE SETTFLAG=2,3 FOR EQ-SERIES',      
              @SAUDA_DATE,      
              GETDATE())      
      
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
                                       END),0),      
                     MARKETTYPE      
                           
            FROM     TRADE T      
            WHERE    AUCTIONPART NOT In ('W','Z')      
            GROUP BY T.PARTY_CODE,PARTIPANTCODE,SCRIP_CD,SERIES,      
                     TMARK,MARKETTYPE) T      
                 
  WHERE    PQTY > 0      
           AND SQTY > 0      
           AND PQTY <> SQTY      
                             
  ORDER BY T.PARTY_CODE,      
           SCRIP_CD,      
           SERIES,      
           PARTIPANTCODE,      
           TMARK,      
           MARKETTYPE      
                 
  OPEN @FLAG      
        
  FETCH NEXT FROM @FLAG      
  INTO @PARTY_CODE,      
       @PARTICIPANTCODE,      
       @SCRIP_CD,      
       @SERIES,      
       @TMARK,      
       @TPQTY,      
       @TSQTY,      
       @TMARKETTYPE      
             
  SELECT @SQTY = 0      
        
  SELECT @PQTY = 0      
                        
  SELECT @TPARTY_CODE = @PARTY_CODE      
        
  SELECT @TPARTICIPANTCODE = @PARTICIPANTCODE      
        
  SELECT @TSCRIP_CD = @SCRIP_CD      
        
  SELECT @TSERIES = @SERIES      
        
  SELECT @TTMARK = @TMARK      
        
  SELECT @TTMARKETTYPE = @TMARKETTYPE      
                                
  WHILE ((@@FETCH_STATUS = 0))      
    BEGIN      
      IF @TSQTY = 0      
        BEGIN      
          UPDATE TRADE      
          SET    SETTFLAG = 4      
          WHERE  PARTY_CODE = @TPARTY_CODE      
                 AND SCRIP_CD = @TSCRIP_CD      
                 AND SERIES = @TSERIES      
                 AND SELL_BUY = 1      
                 AND TMARK LIKE @TMARK + '%'      
                 AND PARTIPANTCODE = @TPARTICIPANTCODE      
                 AND MARKETTYPE = @TMARKETTYPE      
        END      
            
      IF @TPQTY = 0      
        BEGIN      
          UPDATE TRADE      
          SET    SETTFLAG = 5      
          WHERE  PARTY_CODE = @PARTY_CODE      
                 AND SCRIP_CD = @SCRIP_CD      
                 AND SERIES = @SERIES      
                 AND SELL_BUY = 2      
                 AND TMARK LIKE @TMARK + '%'      
                 AND PARTIPANTCODE = @TPARTICIPANTCODE      
                 AND MARKETTYPE = @TMARKETTYPE      
        END      
              
      IF ((@TPQTY > @TSQTY)      
          AND (@TSQTY > 0))      
        BEGIN      
          SELECT @PDIFF = @TPQTY - @TSQTY      
                                           
          SET @LOOP = CURSOR FOR SELECT   TRADE_NO,      
                                           TRADEQTY      
                                  FROM     TRADE      
                                  WHERE    PARTY_CODE = @TPARTY_CODE      
                                           AND SCRIP_CD = @TSCRIP_CD      
                                           AND SERIES = @TSERIES      
                                           AND SELL_BUY = 1      
                                           AND PARTIPANTCODE = @TPARTICIPANTCODE      
                                           AND MARKETTYPE = @TMARKETTYPE      
                 ORDER BY SAUDA_DATE DESC    
                
          OPEN @LOOP      
                
          FETCH NEXT FROM @LOOP      
          INTO @LTRADE_NO,      
               @LQTY      
                
          WHILE (@@FETCH_STATUS = 0)      
                AND (@PDIFF > 0)      
            BEGIN      
              IF @PDIFF >= @LQTY      
                BEGIN      
                  UPDATE TRADE      
                  SET    SETTFLAG = 4      
                  WHERE  PARTY_CODE = @TPARTY_CODE      
                         AND SCRIP_CD = @TSCRIP_CD      
                         AND SERIES = @TSERIES      
                         AND SELL_BUY = 1      
                         AND TRADE_NO = @LTRADE_NO      
                         AND TRADEQTY = @LQTY      
                         AND PARTIPANTCODE = @TPARTICIPANTCODE      
                         AND MARKETTYPE = @TMARKETTYPE      
                        
                  SELECT @PDIFF = @PDIFF - @LQTY      
                END      
              ELSE      
                IF @PDIFF < @LQTY      
                  BEGIN      
                    INSERT INTO TRADE      
                    SELECT 'A' + TRADE_NO,      
                           ORDER_NO,      
                           STATUS,      
                           SCRIP_CD,      
                           SERIES,      
                           SCRIPNAME,      
                           INSTRUMENT,      
                           BOOKTYPE,      
                           MARKETTYPE,      
                           USER_ID,      
                           PARTIPANTCODE,      
                           BRANCH_ID,      
                           SELL_BUY,      
                           @PDIFF,      
                           MARKETRATE,      
                           PRO_CLI,      
                           PARTY_CODE,      
                           AUCTIONPART,      
                           AUCTIONNO,      
                           SETTNO,      
                           SAUDA_DATE,      
                           TRADEMODIFIED,      
                           CPID,      
                           4,      
                           TMARK,      
                           SCHEME,      
                           DUMMY1,      
                           DUMMY2      
                    FROM   TRADE      
                    WHERE  PARTY_CODE = @TPARTY_CODE      
                           AND SCRIP_CD = @TSCRIP_CD      
                           AND SERIES = @TSERIES      
                           AND SELL_BUY = 1      
                           AND TRADE_NO = @LTRADE_NO      
                           AND TRADEQTY = @LQTY      
                           AND PARTIPANTCODE = @TPARTICIPANTCODE      
                           AND MARKETTYPE = @TMARKETTYPE      
                          
                    UPDATE TRADE      
                    SET    SETTFLAG = 2,      
                           TRADEQTY = @LQTY - @PDIFF      
                    WHERE  PARTY_CODE = @TPARTY_CODE      
                           AND SCRIP_CD = @TSCRIP_CD      
                           AND SELL_BUY = 1      
                           AND TRADE_NO = @LTRADE_NO      
                           AND TRADEQTY = @LQTY      
                           AND PARTIPANTCODE = @PARTICIPANTCODE      
                           AND MARKETTYPE = @TMARKETTYPE      
                          
                    SELECT @PDIFF = 0      
                  END      
                    
              IF @PDIFF = 0      
                BREAK      
                    
              FETCH NEXT FROM @LOOP      
              INTO @LTRADE_NO,      
                   @LQTY      
            END      
                
          CLOSE @LOOP      
        END      
              
      IF ((@TPQTY < @TSQTY)      
          AND (@TPQTY > 0))      
        BEGIN      
          SELECT @PDIFF = @TSQTY - @TPQTY      
                
          SET @LOOP = CURSOR FOR SELECT   TRADE_NO,      
                                        TRADEQTY      
                                  FROM     TRADE      
                                  WHERE    PARTY_CODE = @TPARTY_CODE      
                                           AND SCRIP_CD = @TSCRIP_CD      
                                           AND SERIES = @TSERIES      
                                           AND SELL_BUY = 2      
                                           AND PARTIPANTCODE = @TPARTICIPANTCODE      
                                           AND MARKETTYPE = @TMARKETTYPE      
                                  ORDER BY SAUDA_DATE  DESC    
                
OPEN @LOOP      
                
          FETCH NEXT FROM @LOOP      
          INTO @LTRADE_NO,      
               @LQTY      
                
          WHILE (@@FETCH_STATUS = 0)      
                AND (@PDIFF > 0)      
            BEGIN      
              IF @PDIFF >= @LQTY      
                BEGIN      
                  UPDATE TRADE      
                  SET    SETTFLAG = 5      
                  WHERE  PARTY_CODE = @TPARTY_CODE      
                         AND SCRIP_CD = @TSCRIP_CD      
                         AND SERIES = @TSERIES      
                         AND SELL_BUY = 2      
                         AND TRADE_NO = @LTRADE_NO      
                         AND TRADEQTY = @LQTY      
                         AND PARTIPANTCODE = @TPARTICIPANTCODE      
                         AND MARKETTYPE = @TMARKETTYPE      
                        
                  SELECT @PDIFF = @PDIFF - @LQTY      
                END      
              ELSE      
                IF @PDIFF < @LQTY      
                  BEGIN      
                    INSERT INTO TRADE      
                    SELECT 'A' + TRADE_NO,      
                           ORDER_NO,      
                           STATUS,      
                           SCRIP_CD,      
                           SERIES,      
                           SCRIPNAME,      
                           INSTRUMENT,      
                           BOOKTYPE,      
                           MARKETTYPE,      
                           USER_ID,      
                           PARTIPANTCODE,      
                           BRANCH_ID,      
                           SELL_BUY,      
                           @PDIFF,      
                           MARKETRATE,      
                           PRO_CLI,      
                           PARTY_CODE,      
                           AUCTIONPART,      
                           AUCTIONNO,      
                           SETTNO,      
                           SAUDA_DATE,      
                           TRADEMODIFIED,      
                           CPID,      
                           5,      
                           TMARK,      
                           SCHEME,      
                           DUMMY1,      
                           DUMMY2      
                    FROM   TRADE      
                    WHERE  PARTY_CODE = @TPARTY_CODE      
                           AND SCRIP_CD = @TSCRIP_CD      
                           AND SERIES = @TSERIES      
                           AND SELL_BUY = 2      
                           AND TRADE_NO = @LTRADE_NO      
                           AND TRADEQTY = @LQTY      
                           AND PARTIPANTCODE = @TPARTICIPANTCODE      
                           AND MARKETTYPE = @TMARKETTYPE      
                                                  
                    UPDATE TRADE      
                    SET    SETTFLAG = 3,      
                           TRADEQTY = @LQTY - @PDIFF      
                    WHERE  PARTY_CODE = @TPARTY_CODE      
                           AND SCRIP_CD = @TSCRIP_CD      
                           AND SELL_BUY = 2      
                           AND TRADE_NO = @LTRADE_NO      
                           AND TRADEQTY = @LQTY      
                           AND PARTIPANTCODE = @PARTICIPANTCODE      
                           AND MARKETTYPE = @TMARKETTYPE      
      
                    SELECT @PDIFF = 0      
                  END      
                    
              IF @PDIFF = 0      
                BREAK      
                    
              FETCH NEXT FROM @LOOP      
              INTO @LTRADE_NO,      
                   @LQTY      
            END      
                
          CLOSE @LOOP      
        END      
            
      FETCH NEXT FROM @FLAG      
      INTO @PARTY_CODE,      
           @PARTICIPANTCODE,      
           @SCRIP_CD,      
           @SERIES,      
           @TMARK,      
           @TPQTY,      
           @TSQTY,      
           @TMARKETTYPE      
            
      SELECT @TPARTY_CODE = @PARTY_CODE      
            
      SELECT @TPARTICIPANTCODE = @PARTICIPANTCODE      
            
      SELECT @TSCRIP_CD = @SCRIP_CD      
            
      SELECT @TSERIES = @SERIES      
            
      SELECT @TTMARK = @TMARK      
            
      SELECT @TTMARKETTYPE = @TMARKETTYPE      
    END      
        
  CLOSE @FLAG      
        
  DEALLOCATE @FLAG      
        
  INSERT INTO PROCESS_MONITOR      
  VALUES     ('IMPORT TRADE',      
              'CONFIRMATION',      
              '',      
              'REARRANGETRDFLAG',      
              'DONE-UPDATE WHERE SETTFLAG=2,3 FOR EQ-SERIES',      
              'END-PROCESS COMPLETED',      
              @SAUDA_DATE,      
              GETDATE())

GO
