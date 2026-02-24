-- Object: PROCEDURE dbo.TRD_CLIENTMASTER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE [dbo].[TRD_CLIENTMASTER]  
  
AS  
  
  DECLARE  @SAUDA_DATE VARCHAR(11)  
                         
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED  
    
  TRUNCATE TABLE TRD_CLIENT  
    
  TRUNCATE TABLE TRD_BROKTABLE  
    
  TRUNCATE TABLE TRD_SETT_MST  
    
  TRUNCATE TABLE TRD_CLIENTBROK_SCHEME  
    
  TRUNCATE TABLE TRD_CLIENTTAXES_NEW  
    
  -----------------------------------------------------------------------------------------------------  
  SELECT TOP 1 @SAUDA_DATE = LEFT(SAUDA_DATE,11)  
  FROM   TRADE  
           
  SELECT DISTINCT PARTY_CODE  
  INTO   #TRADE  
  FROM   TRADE  
           
  INSERT INTO TRD_CLIENT  
  SELECT C2.CL_CODE,  
         C2.PARTY_CODE,  
         C1.SHORT_NAME,  
         C1.CL_TYPE,  
         C1.OFF_PHONE1,  
         C2.SERVICE_CHRG,  
         C2.SERTAXMETHOD,  
         C2.TRAN_CAT,  
         C2.INSCONT,  
         INACTIVEFROM = ISNULL(INACTIVEFROM,'JAN  1 1900')  
  FROM   CLIENT1 C1,  
         CLIENT2 C2  
         LEFT OUTER JOIN CLIENT5  
           ON C2.CL_CODE = CLIENT5.CL_CODE  
                             
  WHERE  C1.CL_CODE = C2.CL_CODE  
         AND C2.PARTY_CODE IN (SELECT PARTY_CODE  
                               FROM   #TRADE)  
                                
  -----------------------------------------------------------------------------------------------------  
  UPDATE TRADE  
  SET    PRO_CLI = (CASE   
                      WHEN CL_TYPE = 'pro' THEN 2  
                      WHEN CL_TYPE = 'NRI' THEN 3  
                      ELSE 1  
                    END),  
         PARTIPANTCODE = (CASE   
                            WHEN CL_TYPE = 'ins' THEN 'dvp'  
                            ELSE PARTIPANTCODE  
                          END)  
  FROM   TRADE,  
         TRD_CLIENT CLIENT,  
         OWNER  
  WHERE  TRADE.PARTY_CODE = CLIENT.PARTY_CODE  
         AND TRADE.PARTIPANTCODE = MEMBERCODE  
                                     
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED  
    
  -----------------------------------------------------------------------------------------------------  
  INSERT INTO TRD_CLIENTBROK_SCHEME  
  SELECT C2.*  
  FROM   CLIENTBROK_SCHEME C2  
  WHERE  C2.PARTY_CODE IN (SELECT PARTY_CODE  
                           FROM   TRD_CLIENT)  
         AND @SAUDA_DATE BETWEEN FROM_DATE  
                                 AND TO_DATE  
         AND SCHEME_TYPE = 'TRD'  
         AND SCRIP_CD = 'ALL'  
                          
  INSERT INTO TRD_BROKTABLE  
  SELECT TABLE_NO,  
         LINE_NO,  
         VAL_PERC,  
         UPPER_LIM,  
         DAY_PUC,  
         DAY_SALES,  
         SETT_PURCH,  
         ROUND_TO,  
         TABLE_NAME,  
         SETT_SALES,  
         NORMAL,  
         TRD_DEL,  
         LOWER_LIM,  
         DEF_TABLE,  
         ROFIG,  
         ERRNUM,  
         NOZERO,  
         BRANCH_CODE = ''  
  FROM   BROKTABLE  
  WHERE  TABLE_NO IN (SELECT DISTINCT TABLE_NO  
                      FROM   TRD_CLIENTBROK_SCHEME)  
                       
  INSERT INTO TRD_CLIENTTAXES_NEW  
  SELECT C2.*  
  FROM   CLIENTTAXES_NEW C2  
  WHERE  C2.PARTY_CODE IN (SELECT PARTY_CODE  
                           FROM   TRD_CLIENT)  
         AND @SAUDA_DATE BETWEEN FROMDATE  
                                 AND TODATE  
         AND TRANS_CAT = 'TRD'  
                           
  INSERT INTO TRD_SETT_MST  
  SELECT *  
  FROM   SETT_MST  
  WHERE  @SAUDA_DATE BETWEEN START_DATE  
                             AND END_DATE  
                                   
  -----------------------------------------------------------------------------------------------------  
  UPDATE TRADE  
  SET    BOOKTYPE = (CASE   
                       WHEN C.BROKSCHEME = 0 THEN 'T'  
                       ELSE (CASE   
                               WHEN C.PQTY <> C.SQTY  
                                    AND SELL_BUY = 1 THEN (CASE   
                                                             WHEN C.PQTY > C.SQTY THEN 'F'  
                                                             ELSE 'S'  
                                                END)  
                               WHEN C.PQTY <> C.SQTY  
                                    AND SELL_BUY = 2 THEN (CASE   
                                                             WHEN C.PQTY > C.SQTY THEN 'S'  
                                                             ELSE 'F'  
                                                           END)  
                               WHEN C.PQTY = C.SQTY  
                                    AND C.BROKSCHEME = 1 THEN (CASE   
                                                                 WHEN SELL_BUY = 1 THEN 'F'  
                                                                 ELSE 'S'  
                                                               END)  
                               WHEN C.PQTY = C.SQTY  
                                    AND C.BROKSCHEME = 3 THEN (CASE   
                                                                 WHEN SELL_BUY = 2 THEN 'F'  
                                                                 ELSE 'S'  
                                                               END)  
                               WHEN C.PQTY = C.SQTY  
                                    AND C.BROKSCHEME = 2 THEN (CASE   
                                                                 WHEN C.PRATE >= C.SRATE THEN (CASE   
                                                                                                 WHEN SELL_BUY = 1 THEN 'F'  
                                                                                                 ELSE 'S'  
                                                                                               END)  
                                                                 ELSE (CASE   
                                                                         WHEN SELL_BUY = 2 THEN 'F'  
                                                                         ELSE 'S'  
                                                                       END)  
                                                               END)  
                             END)  
                     END)  
  FROM   (SELECT   TRADE.PARTY_CODE,  
                   TRADE.SCRIP_CD,  
                   SERIES,  
                   PQTY = SUM(CASE   
                                WHEN SELL_BUY = 1 THEN TRADEQTY  
                                ELSE 0  
                              END),  
                   SQTY = SUM(CASE   
                                WHEN SELL_BUY = 2 THEN TRADEQTY  
                                ELSE 0  
                              END),  
                   PRATE = (CASE   
                              WHEN SUM(CASE   
                                         WHEN SELL_BUY = 1 THEN TRADEQTY  
                                         ELSE 0  
                                       END) > 0 THEN SUM(CASE   
                                                           WHEN SELL_BUY = 1 THEN TRADEQTY * MARKETRATE  
                                                           ELSE 0  
                                                         END) / SUM(CASE   
                                                                      WHEN SELL_BUY = 1 THEN TRADEQTY  
                                                                      ELSE 0  
                                                                    END)  
                              ELSE 0  
                            END),  
                   SRATE = (CASE   
                              WHEN SUM(CASE   
                                         WHEN SELL_BUY = 2 THEN TRADEQTY  
                                         ELSE 0  
                                       END) > 0 THEN SUM(CASE   
                                                           WHEN SELL_BUY = 2 THEN TRADEQTY * MARKETRATE  
                                                           ELSE 0  
                                                         END) / SUM(CASE   
                                      WHEN SELL_BUY = 2 THEN TRADEQTY  
                                                                      ELSE 0  
                                                                    END)  
                              ELSE 0  
                            END),  
                   PARTIPANTCODE,  
                   TMARK,  
                   T.BROKSCHEME  
          FROM     TRADE,  
                   TRD_CLIENTBROK_SCHEME T,  
                   OWNER  
          WHERE    TRADE.PARTY_CODE = T.PARTY_CODE  
                   AND T.TRADE_TYPE = (CASE   
                                         WHEN TRADE.PARTIPANTCODE = MEMBERCODE THEN 'NRM'  
                                         ELSE 'INS'  
                                       END)  
          GROUP BY TRADE.PARTY_CODE,TRADE.SCRIP_CD,SERIES,PARTIPANTCODE,  
                   TMARK,T.BROKSCHEME) C  
  WHERE  TRADE.PARTY_CODE = C.PARTY_CODE  
         AND TRADE.SCRIP_CD = C.SCRIP_CD  
         AND TRADE.SERIES = C.SERIES  
         AND TRADE.TMARK = C.TMARK  
         AND TRADE.PARTIPANTCODE = C.PARTIPANTCODE  
                                     
  UPDATE TRADE  
  SET    AUCTIONPART = 'L'

GO
