-- Object: PROCEDURE dbo.RearrangeTrdflag_sett
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

  /****** Object:  Stored Procedure dbo.RearrangeTrdflag_sett    Script Date: 01/14/2005 16:43:28 ******/    
CREATE PROCEDURE [dbo].[RearrangeTrdflag_sett]    
AS    
  DECLARE  @@trade_no         VARCHAR(14),    
           @@Pqty             NUMERIC(9),    
           @@Sqty             NUMERIC(9),    
           @@Ltrade_no        VARCHAR(14),    
           @@Lqty             NUMERIC(9),    
           @@Pdiff            NUMERIC(9),    
           @@Flag             CURSOR,    
           @@loop             CURSOR,    
           @@TPqty            NUMERIC(9),    
           @@TSqty            NUMERIC(9),    
           @@TSell_Buy        INT,    
           @@Party_code       VARCHAR(15),    
           @@Scrip_cd         VARCHAR(20),    
           @@Series           VARCHAR(3),    
           @@PARTIPANTCODE  VARCHAR(30),    
           @@TMark            VARCHAR(3),    
           @@Tparty_code      VARCHAR(15),    
           @@Tscrip_cd        VARCHAR(20),    
           @@Tseries          VARCHAR(3),    
           @@TPARTIPANTCODE VARCHAR(30),    
           @@Tsett_type       VARCHAR(3),    
           @@Sett_type        VARCHAR(3),    
           @@TTmark           VARCHAR(3),    
           @@Scriploop        CURSOR,    
           @@sauda_date       VARCHAR(11)    
                                  
  UPDATE bbgsettlement    
  SET    SETTFLAG = (CASE     
                       WHEN SELL_BUY = 1 THEN 4    
                       ELSE 5    
                     END)    
  WHERE  sett_type = 'W'    
                       
  UPDATE bbgsettlement set TMark = 'N'

  UPDATE bbgsettlement    
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
  FROM   bbgsettlement T,    
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
          FROM     bbgsettlement    
          WHERE    sett_type <> 'W'    
          GROUP BY PARTY_CODE,SCRIP_CD,SERIES,PARTIPANTCODE,    
                   TMARK) T1    
  WHERE  T.PARTY_CODE = T1.PARTY_CODE    
         AND T.SCRIP_CD = T1.SCRIP_CD    
         AND T.SERIES = T1.SERIES    
         AND T.PARTIPANTCODE = T1.PARTIPANTCODE    
         AND T.TMARK = T1.TMARK    
    
      
  SET @@Flag = CURSOR FOR    
      
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
                                 
             FROM     bbgsettlement T    
             WHERE    sett_type <> 'W'    
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
     
  OPEN @@Flag    
      
  FETCH NEXT FROM @@Flag    
  INTO @@Party_code,    
       @@PARTIPANTCODE,    
       @@Scrip_cd,    
       @@Series,    
       @@TMark,    
       @@TPQty,    
       @@TSQty    
           
  SELECT @@Sqty = 0    
                      
  SELECT @@PQty = 0    
                      
  SELECT @@Tparty_code = @@Party_code    
                             
  SELECT @@TPARTIPANTCODE = @@PARTIPANTCODE    
                                  
  SELECT @@TScrip_cd = @@Scrip_cd    
                           
  SELECT @@Tseries = @@Series    
                         
  SELECT @@TTmark = @@Tmark    
                        
  WHILE ((@@FETCH_STATUS = 0))    
    BEGIN    
      IF @@TSqty = 0    
        BEGIN    
          UPDATE bbgsettlement    
          SET    SETTFLAG = 4    
          WHERE  PARTY_CODE = @@TParty_code    
                 AND SCRIP_CD = @@Tscrip_cd    
                 AND SERIES = @@TSeries    
                 AND SELL_BUY = 1    
                 AND TMARK LIKE @@TMark + '%'    
                 AND PARTIPANTCODE = @@TPARTIPANTCODE    
        END    
            
      IF @@TPqty = 0    
        BEGIN    
          UPDATE bbgsettlement    
          SET    SETTFLAG = 5    
          WHERE  PARTY_CODE = @@Party_Code    
                 AND SCRIP_CD = @@Scrip_Cd    
                 AND SERIES = @@Series    
                 AND SELL_BUY = 2    
                 AND TMARK LIKE @@TMark + '%'    
                 AND PARTIPANTCODE = @@TPARTIPANTCODE    
        END    
            
      IF ((@@TPqty > @@TSqty)    
          AND (@@TSqty > 0))    
        BEGIN    
          SELECT @@Pdiff = @@TPqty - @@TSqty    
                                         
          SET @@Loop = CURSOR FOR SELECT   TRADE_NO,    
                                           TRADEQTY    
                                  FROM     bbgsettlement    
                                  WHERE    PARTY_CODE = @@TParty_code    
                                           AND SCRIP_CD = @@TScrip_cd    
                                           AND SERIES = @@TSeries    
                                           AND SELL_BUY = 1    
                                           AND PARTIPANTCODE = @@TPARTIPANTCODE    
                                  ORDER BY MARKETRATE DESC    
                                               
          OPEN @@Loop    
              
          FETCH NEXT FROM @@Loop    
          INTO @@Ltrade_no,    
               @@Lqty    
                   
          WHILE (@@FETCH_STATUS = 0)    
                AND (@@Pdiff > 0)    
            BEGIN    
              IF @@Pdiff >= @@Lqty    
                BEGIN    
                  UPDATE bbgsettlement    
                  SET    SETTFLAG = 4    
                  WHERE  PARTY_CODE = @@TParty_code    
                         AND SCRIP_CD = @@TScrip_cd    
                         AND SERIES = @@TSeries    
                         AND SELL_BUY = 1    
                         AND TRADE_NO = @@ltrade_no    
                         AND TRADEQTY = @@lqty    
                         AND PARTIPANTCODE = @@TPARTIPANTCODE    
                                                   
                  SELECT @@Pdiff = @@Pdiff - @@Lqty    
                END    
              ELSE    
                IF @@Pdiff < @@Lqty    
                  BEGIN    
                      
                    INSERT INTO bbgsettlement    
                    SELECT Contractno,Billno,'A' + Trade_No,Party_Code,Scrip_Cd,User_Id,@@pdiff,Auctionpart,  
     Markettype,Series,Order_No,Marketrate,Sauda_Date,Table_No,Line_No,Val_Perc,Normal,Day_Puc,  
     Day_Sales,Sett_Purch,Sett_Sales,Sell_Buy,4,Brokapplied,Netrate,Amount,Ins_Chrg,Turn_Tax,  
     Other_Chrg,Sebi_Tax,Broker_Chrg,Service_Tax,Trade_Amount,Billflag,Sett_No,Nbrokapp,Nsertax,  
     N_Netrate,Sett_Type,PARTIPANTCODE,Status,Pro_Cli,Cpid,Instrument,Booktype,Branch_Id,Tmark,  
     Scheme,Dummy1,Dummy2  
                    FROM   bbgsettlement    
                    WHERE    
                        
                           PARTY_CODE = @@TParty_code    
                           AND SCRIP_CD = @@TScrip_cd    
                           AND SERIES = @@Tseries    
                           AND SELL_BUY = 1    
         AND TRADE_NO = @@ltrade_no    
                           AND TRADEQTY = @@lqty    
                           AND PARTIPANTCODE = @@TPARTIPANTCODE    
                                                     
                    UPDATE bbgsettlement    
                    SET    SETTFLAG = 2,    
                           TRADEQTY = @@Lqty - @@pdiff    
                    WHERE  PARTY_CODE = @@TParty_Code    
                           AND SCRIP_CD = @@TScrip_cd    
                           AND SELL_BUY = 1    
                           AND TRADE_NO = @@ltrade_no    
                           AND TRADEQTY = @@lqty    
                           AND PARTIPANTCODE = @@PARTIPANTCODE    
                                                     
                    SELECT @@Pdiff = 0    
                  END    
                      
              IF @@pdiff = 0    
                BREAK    
                    
              FETCH NEXT FROM @@Loop    
              INTO @@Ltrade_no,    
                   @@Lqty    
            END    
                
          CLOSE @@Loop    
        END    
            
      IF ((@@TPqty < @@TSqty)    
          AND (@@TPqty > 0))    
        BEGIN    
          SELECT @@Pdiff = @@TSqty - @@TPqty    
                                         
          SET @@Loop = CURSOR FOR SELECT   TRADE_NO,    
                                           TRADEQTY    
                                  FROM     bbgsettlement    
                                  WHERE    PARTY_CODE = @@TParty_code    
                                           AND SCRIP_CD = @@TScrip_cd    
                                           AND SERIES = @@TSeries    
                                           AND SELL_BUY = 2    
                                           AND PARTIPANTCODE = @@TPARTIPANTCODE    
                                  ORDER BY MARKETRATE DESC    
                                               
          OPEN @@Loop    
              
          FETCH NEXT FROM @@Loop    
          INTO @@Ltrade_no,    
               @@Lqty    
                   
          WHILE (@@FETCH_STATUS = 0)    
                AND (@@Pdiff > 0)    
            BEGIN    
              IF @@Pdiff >= @@Lqty    
                BEGIN    
                  UPDATE bbgsettlement    
                  SET    SETTFLAG = 5    
                  WHERE  PARTY_CODE = @@TParty_code    
                         AND SCRIP_CD = @@TScrip_cd    
                         AND SERIES = @@TSeries    
                         AND SELL_BUY = 2    
                         AND TRADE_NO = @@ltrade_no    
                         AND TRADEQTY = @@lqty    
                         AND PARTIPANTCODE = @@TPARTIPANTCODE    
                                                   
                  SELECT @@Pdiff = @@Pdiff - @@Lqty    
                END    
              ELSE    
                IF @@Pdiff < @@Lqty    
                  BEGIN    
                      
                    INSERT INTO bbgsettlement    
                    SELECT Contractno,Billno,'A' + Trade_No,Party_Code,Scrip_Cd,User_Id,@@pdiff,Auctionpart,  
     Markettype,Series,Order_No,Marketrate,Sauda_Date,Table_No,Line_No,Val_Perc,Normal,Day_Puc,  
     Day_Sales,Sett_Purch,Sett_Sales,Sell_Buy,5,Brokapplied,Netrate,Amount,Ins_Chrg,Turn_Tax,  
     Other_Chrg,Sebi_Tax,Broker_Chrg,Service_Tax,Trade_Amount,Billflag,Sett_No,Nbrokapp,Nsertax,  
     N_Netrate,Sett_Type,PARTIPANTCODE,Status,Pro_Cli,Cpid,Instrument,Booktype,Branch_Id,Tmark,  
     Scheme,Dummy1,Dummy2  
                    FROM   bbgsettlement    
                    WHERE  PARTY_CODE = @@TParty_code    
                    AND SCRIP_CD = @@TScrip_cd    
                           AND SERIES = @@Tseries    
                           AND SELL_BUY = 2    
                           AND TRADE_NO = @@ltrade_no    
                           AND TRADEQTY = @@lqty    
                           AND PARTIPANTCODE = @@TPARTIPANTCODE    
                                                     
                    UPDATE bbgsettlement    
                    SET    SETTFLAG = 3,    
                           TRADEQTY = @@Lqty - @@pdiff    
                    WHERE  PARTY_CODE = @@TParty_Code    
                           AND SCRIP_CD = @@TScrip_cd    
                           AND SELL_BUY = 2    
                           AND TRADE_NO = @@ltrade_no    
                           AND TRADEQTY = @@lqty    
                           AND PARTIPANTCODE = @@PARTIPANTCODE    
                                                     
                    SELECT @@Pdiff = 0    
                  END    
                      
              IF @@pdiff = 0    
                BREAK    
                    
              FETCH NEXT FROM @@Loop    
              INTO @@Ltrade_no,    
                   @@Lqty    
            END    
                
          CLOSE @@Loop    
        END    
            
      FETCH NEXT FROM @@Flag    
      INTO @@Party_code,    
           @@PARTIPANTCODE,    
           @@Scrip_cd,    
           @@Series,    
           @@TMark,    
           @@TPQty,    
           @@TSQty    
               
      SELECT @@Tparty_code = @@Party_code    
                                 
      SELECT @@TPARTIPANTCODE = @@PARTIPANTCODE    
                                      
      SELECT @@TScrip_cd = @@Scrip_cd    
                               
      SELECT @@Tseries = @@Series    
                             
      SELECT @@TTmark = @@Tmark    
                            
    END    
        
  CLOSE @@Flag    
      
  DEALLOCATE @@Flag

GO
