-- Object: PROCEDURE dbo.Bbgdirectgencontract
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE  PROCEDURE [dbo].[Bbgdirectgencontract]      
AS      
  DECLARE  @@party           VARCHAR(12),      
           @@sett_type       VARCHAR(2),      
           @@contno          VARCHAR(7),      
           @@contnopartipant VARCHAR(7),      
           @@PARTIPANTCODE VARCHAR(15),      
           @@membercode      VARCHAR(15),      
           @@sauda_date      VARCHAR(11),      
           @@order_no        VARCHAR(16),      
           @@scrip_cd        VARCHAR(12),      
           @@series          VARCHAR(2),      
           @@sell_buy        INT,      
           @@style           INT,      
           @@startdate       VARCHAR(11),      
           @@enddate         VARCHAR(11),      
           @@flag            INT,      
           @@cont            CURSOR,      
           @@partycont       CURSOR,      
           @@cursetttype     VARCHAR(2),      
           @@inscontno       VARCHAR(7),      
           @@sett_no         VARCHAR(10),      
           @@maxcontnos      INT,      
           @@maxconnoi       INT,      
           @@bbgcontcur      CURSOR,      
           @@getmaxcontno    CURSOR,      
           @@inscont         VARCHAR(4),      
           @@tempcontractno  INT,      
           @@MARKETRATE   numeric(18,4),      
           @@rcount          VARCHAR(20)      
                                   
  SELECT TOP 1 @@sauda_date = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11)      
  FROM   TRADE      
               
  SELECT @@membercode = MEMBERCODE,      
         @@style = ISNULL(STYLE,0)      
  FROM   OWNER      
               
  INSERT INTO PROCESS_MONITOR      
  VALUES     ('import Trade',      
              'contract',      
              '',      
              'bbgdirectgencontract',      
              'start',      
              'update Pro_cli, Participant Code In Trade',      
              @@sauda_date,      
              GETDATE())      
        
  --select @@rcount = @@rowcount      
  INSERT INTO PROCESS_MONITOR      
  VALUES     ('import Trade',      
              'contract',      
              '',      
              'bbgdirectgencontract',      
              'done-update Pro_cli, Participant Code In Trade',      
              'insert In Bbgsettlement From Confirmview',      
              @@sauda_date,      
              GETDATE())      
        
  TRUNCATE TABLE BBGSETTLEMENT      
        
  TRUNCATE TABLE BBGISETTLEMENT      
        
  INSERT INTO BBGSETTLEMENT      
  SELECT '0000000',      
         '0',      
         TRADE_NO,      
         PARTY_CODE,      
         SCRIP_CD,      
         USER_ID,      
         TRADEQTY,      
         AUCTIONPART = 'N',      
         MARKETTYPE,      
         SERIES,      
         ORDER_NO,      
         MARKETRATE,      
         SAUDA_DATE,      
         TABLE_NO,      
         LINE_NO,      
         VAL_PERC,      
         NORMAL,      
         DAY_PUC,      
         DAY_SALES,      
         SETT_PURCH,      
         SETT_SALES,      
         SELL_BUY,      
         SETTFLAG,      
         BROKAPPLIED,      
         NETRATE,      
         AMOUNT,      
         INS_CHRG,      
         TURN_TAX,      
         OTHER_CHRG,      
         SEBI_TAX,      
         BROKER_CHRG,      
         SERVICE_TAX,      
         TRADE_AMOUNT,      
         1,      
         SETT_NO,      
         BROKAPPLIED,      
         SERVICE_TAX,      
         NETRATE,      
         SETT_TYPE,      
         PARTIPANTCODE,      
         STATUS,      
         PRO_CLI,      
         CPID,      
         INSTRUMENT,      
         BOOKTYPE,      
         BRANCH_ID,      
         TMARK,      
         SCHEME,      
         DUMMY1,      
         DUMMY2      
  FROM   CONFIRMVIEW      
               
  INSERT INTO PROCESS_MONITOR      
  VALUES     ('import Trade',      
              'contract',      
              '',      
              'bbgdirectgencontract',      
              'done-insert In Bbgsettlement From Confirmview',      
              'insert In Bbgisettlement From Bbgsettlement And Delete From Bbgsettlement',   
              @@sauda_date,      
              GETDATE())      
        
  INSERT INTO BBGISETTLEMENT      
  SELECT *      
  FROM   BBGSETTLEMENT      
  WHERE  PARTIPANTCODE NOT IN (SELECT DISTINCT CLTCODE      
                               FROM   MULTIBROKER)      
         AND (PARTIPANTCODE LIKE 'fi%'      
               OR PARTIPANTCODE <> @@membercode)      
                   
  DELETE BBGSETTLEMENT      
  WHERE  PARTIPANTCODE NOT IN (SELECT DISTINCT CLTCODE      
                               FROM   MULTIBROKER)      
         AND (PARTIPANTCODE LIKE 'fi%'      
 OR PARTIPANTCODE <> @@membercode)      
                   
  INSERT INTO PROCESS_MONITOR      
  VALUES     ('import Trade',      
              'contract',      
              '',      
              'bbgdirectgencontract',      
              'done-insert In Bbgisettlement From Bbgsettlement And Delete From Bbgsettlement',      
              'update Contractnumber From Settlement',      
              @@sauda_date,      
              GETDATE())      
        
  SELECT DISTINCT SETT_TYPE,      
                  S.PARTY_CODE,      
                  CONTRACTNO,    
                  SERIES      
  INTO   #SETT      
  FROM   SETTLEMENT S,      
         TRD_CLIENT C      
  WHERE  SAUDA_DATE LIKE @@sauda_date + '%'      
         AND C.PARTY_CODE = S.PARTY_CODE      
         AND TRADE_NO NOT LIKE '%C%'    
                                    
  UPDATE BBGSETTLEMENT      
  SET    CONTRACTNO = S.CONTRACTNO      
  FROM   BBGSETTLEMENT WITH (index (partysett )),      
         #SETT S      
  WHERE  BBGSETTLEMENT.PARTY_CODE = S.PARTY_CODE      
         AND BBGSETTLEMENT.SETT_TYPE = S.SETT_TYPE    
         AND BBGSETTLEMENT.SERIES = S.SERIES    
                                             
  INSERT INTO PROCESS_MONITOR      
  VALUES     ('import Trade',      
              'contract',      
              '',      
              'bbgdirectgencontract',      
              'done-update Contno From Settlement For Existing Clients',      
              'generate Contno For New Clients',      
              @@sauda_date,      
              GETDATE())      
        
  IF @@style = 0      
    BEGIN      
      SET @@bbgcontcur = CURSOR FOR SELECT ISNULL(MAX(CONVERT(INT,CONTRACTNO)),0)      
                                    FROM   SETTLEMENT      
                                    WHERE  SAUDA_DATE LIKE @@sauda_date + '%'      
                                                                                
      OPEN @@bbgcontcur      
            
      FETCH NEXT FROM @@bbgcontcur      
      INTO @@maxcontnos      
            
      CLOSE @@bbgcontcur      
            
      SET @@bbgcontcur = CURSOR FOR SELECT ISNULL(MAX(CONVERT(INT,CONTRACTNO)),0)      
                                    FROM   ISETTLEMENT      
                                    WHERE  SAUDA_DATE LIKE @@sauda_date + '%'      
                                                                                
      OPEN @@bbgcontcur      
            
      FETCH NEXT FROM @@bbgcontcur      
      INTO @@tempcontractno      
            
      CLOSE @@bbgcontcur      
            
      IF @@tempcontractno > @@maxcontnos      
        BEGIN      
          SET @@maxcontnos = @@tempcontractno      
        END      
    END      
          
  IF @@style = 1      
    BEGIN      
      SET @@bbgcontcur = CURSOR FOR SELECT ISNULL(CONVERT(INT,CONTRACTNO),0)      
                                    FROM   CONTGEN      
                                    WHERE  @@sauda_date BETWEEN START_DATE      
                AND END_DATE      
                                                                          
      OPEN @@bbgcontcur      
            
      FETCH NEXT FROM @@bbgcontcur      
      INTO @@maxcontnos      
            
      CLOSE @@bbgcontcur      
    END      
          
  TRUNCATE TABLE TRD_CONTRACTNO      
        
  INSERT INTO TRD_CONTRACTNO      
  SELECT   DISTINCT SETT_TYPE,      
                    PARTY_CODE,      
                    SCRIP_CD = '',      
                    ORDER_NO = '',      
                    SERIES,      
                    SELL_BUY = ''      
  FROM     BBGSETTLEMENT      
  WHERE    CONVERT(INT,CONTRACTNO) = 0      
  ORDER BY SETT_TYPE,      
           PARTY_CODE      
                 
  UPDATE BBGSETTLEMENT      
  SET    CONTRACTNO = STUFF('0000000',8 - LEN(@@maxcontnos + SNO),LEN(@@maxcontnos + SNO),      
                            @@maxcontnos + SNO)      
  FROM   BBGSETTLEMENT B WITH (index (partysett )),      
         TRD_CONTRACTNO T      
  WHERE  B.SETT_TYPE = T.SETT_TYPE      
         AND B.PARTY_CODE = T.PARTY_CODE     
         AND B.SERIES = T.SERIES     
         AND CONVERT(INT,CONTRACTNO) = 0      
    
  SELECT @@maxcontnos = @@maxcontnos + ISNULL(MAX(SNO),0)      
  FROM   TRD_CONTRACTNO      
               
  IF @@style = 1      
    UPDATE CONTGEN      
    SET    CONTRACTNO = @@maxcontnos      
    WHERE  @@sauda_date BETWEEN START_DATE      
                                AND END_DATE      
                                          
  /* Changes Needs To Done In The Above Patch */      
  INSERT INTO PROCESS_MONITOR      
  VALUES     ('import Trade',      
              'contract',      
              '',      
              'bbgdirectgencontract',      
              'done-generate Contno For New Clients',      
              'generate Contno For Inst Clients',      
              @@sauda_date,      
              GETDATE())      
        
  SET @@partycont = CURSOR FOR SELECT   DISTINCT I.PARTY_CODE,      
                                                 I.SETT_TYPE,      
                                                 I.CONTRACTNO,      
                                                 I.ORDER_NO,      
                                                 I.SCRIP_CD,    
                                                 I.SERIES,      
                                                 INSCONT,      
                                                 SELL_BUY,  
             MARKETRATE      
                               FROM     ISETTLEMENT I,      
                                        CLIENT2 C2      
                               WHERE    I.SAUDA_DATE LIKE @@sauda_date + '%'      
                                        AND I.PARTY_CODE = C2.PARTY_CODE      
                                        AND TRADEQTY > 0 AND MARKETRATE > 0     
                                        AND I.DUMMY2 <> '1'      
                               ORDER BY I.SETT_TYPE,      
                                        I.PARTY_CODE,      
                                        I.SCRIP_CD,    
                                        I.SERIES,      
                                        I.ORDER_NO,      
                                        I.CONTRACTNO,  
          MARKETRATE     
                                              
  OPEN @@partycont      
        
  FETCH NEXT FROM @@partycont      
  INTO @@party,      
       @@sett_type,      
       @@contno,      
       @@order_no,      
       @@scrip_cd,    
       @@SERIES,      
       @@inscont,      
       @@Sell_Buy,  
    @@MARKETRATE      
             
  WHILE @@FETCH_STATUS = 0      
    BEGIN      
      IF @@inscont = 'n'      
        BEGIN      
          UPDATE BBGISETTLEMENT      
          SET    CONTRACTNO = @@contno      
          WHERE  SETT_TYPE = @@sett_type      
     AND PARTY_CODE = @@party    
                 AND SERIES = @@SERIES  
     AND MARKETRATE = @@MARKETRATE      
        END      
              
      IF @@inscont = 'o'      
        BEGIN      
          UPDATE BBGISETTLEMENT      
          SET    CONTRACTNO = @@contno      
          WHERE  SETT_TYPE = @@sett_type      
                 AND PARTY_CODE = @@party      
                 AND ORDER_NO = @@order_no    
                 AND SERIES = @@SERIES  
     AND MARKETRATE = @@MARKETRATE     
        END      
              
      IF @@inscont = 's'      
        BEGIN      
          UPDATE BBGISETTLEMENT      
          SET    CONTRACTNO = @@contno      
          WHERE  SETT_TYPE = @@sett_type      
                 AND PARTY_CODE = @@party      
                 AND SCRIP_CD = @@scrip_cd    
                 AND SERIES = @@SERIES      
                 AND SELL_BUY = @@Sell_Buy   
     AND MARKETRATE = @@MARKETRATE      
        END      
              
      FETCH NEXT FROM @@partycont      
      INTO @@party,      
           @@sett_type,      
           @@contno,      
           @@order_no,      
           @@scrip_cd,      
           @@SERIES,    
           @@inscont,      
           @@Sell_Buy,  
     @@MARKETRATE       
    END      
          
  CLOSE @@partycont      
        
  SELECT @@sett_type = ''      
        
  SELECT @@PARTIPANTCODE = ''      
        
  SELECT @@party = ''      
                         
  SET @@partycont = CURSOR FOR SELECT   DISTINCT SETT_TYPE,      
                                                 BBGISETTLEMENT.PARTY_CODE,    
                                      SERIES,MARKETRATE        
                               FROM     BBGISETTLEMENT,      
                                        CLIENT2      
                               WHERE    PRO_CLI <> 2      
                                        AND CONVERT(INT,CONTRACTNO) = 0      
                                        AND BBGISETTLEMENT.PARTY_CODE = CLIENT2.PARTY_CODE      
                                        AND INSCONT = 'n' AND MARKETRATE > 0      
                               ORDER BY SETT_TYPE,      
                                        BBGISETTLEMENT.PARTY_CODE,MARKETRATE  
                                              
  OPEN @@partycont      
        
  FETCH NEXT FROM @@partycont      
  INTO @@sett_type,      
       @@party,    
       @@SERIES,  
    @@MARKETRATE       
        
  WHILE @@FETCH_STATUS = 0      
    BEGIN      
      SELECT @@cursetttype = @@sett_type      
            
      SELECT @@contno = @@maxcontnos + 1      
            
      SELECT @@maxcontnos = @@maxcontnos + 1      
                                                 
      UPDATE BBGISETTLEMENT      
      SET    CONTRACTNO = STUFF('0000000',8 - LEN(@@contno),LEN(@@contno),      
                                @@contno)      
      WHERE  PARTY_CODE = @@party      
             AND SETT_TYPE = @@sett_type    
             AND SERIES = @@SERIES      
             AND MARKETRATE = @@MARKETRATE   
                          
      FETCH NEXT FROM @@partycont      
      INTO @@sett_type,      
           @@party,    
           @@SERIES,  
     @@MARKETRATE      
    END      
          
  CLOSE @@partycont      
        
  SELECT @@sett_type = ''      
        
  SELECT @@PARTIPANTCODE = ''      
        
  SELECT @@party = ''      
                         
  /* Now Order Wise    */      
  SET @@partycont = CURSOR FOR SELECT   DISTINCT SETT_TYPE,      
                                                 BBGISETTLEMENT.PARTY_CODE,      
                                                 ORDER_NO,    
                                                 SERIES,  
             MARKETRATE  
                               FROM     BBGISETTLEMENT,      
                                        CLIENT2      
             WHERE    PRO_CLI <> 2      
                                        AND CONVERT(INT,CONTRACTNO) = 0      
                                        AND BBGISETTLEMENT.PARTY_CODE = CLIENT2.PARTY_CODE      
                                        AND INSCONT = 'o' AND MARKETRATE > 0     
                               ORDER BY SETT_TYPE,      
                                        BBGISETTLEMENT.PARTY_CODE,      
                                        ORDER_NO, SERIES, MARKETRATE  
                                              
  OPEN @@partycont      
        
  FETCH NEXT FROM @@partycont      
  INTO @@sett_type,      
       @@party,      
       @@order_no,  
       @@SERIES,  
    @@MARKETRATE       
        
  WHILE @@FETCH_STATUS = 0      
    BEGIN      
      SELECT @@cursetttype = @@sett_type      
            
      SELECT @@contno = 0      
            
      SELECT @@contno = @@maxcontnos + 1      
            
      SELECT @@maxcontnos = @@maxcontnos + 1      
                                                 
      UPDATE BBGISETTLEMENT      
      SET    CONTRACTNO = STUFF('0000000',8 - LEN(@@contno),LEN(@@contno),      
                                @@contno)      
      WHERE  PARTY_CODE = @@party      
             AND SETT_TYPE = @@sett_type      
             AND ORDER_NO = @@order_no    
             AND SERIES = @@SERIES  
    AND MARKETRATE = @@MARKETRATE       
                                  
      FETCH NEXT FROM @@partycont      
      INTO @@sett_type,      
           @@party,      
           @@order_no,    
           @@SERIES,  
     @@MARKETRATE       
    END      
        
  CLOSE @@partycont      
        
  SELECT @@sett_type = ''      
        
  SELECT @@PARTIPANTCODE = ''      
        
  SELECT @@party = ''                           
  /* Now Scrip_wise   */      
  SET @@partycont = CURSOR FOR SELECT   DISTINCT SETT_TYPE,      
                                                 BBGISETTLEMENT.PARTY_CODE,      
                                                 SCRIP_CD,    
                                                 SERIES,      
                                                 SELL_BUY,  
             MARKETRATE       
                               FROM     BBGISETTLEMENT,      
                                        CLIENT2      
                               WHERE    PRO_CLI <> 2      
                                        AND CONVERT(INT,CONTRACTNO) = 0      
                                        AND BBGISETTLEMENT.PARTY_CODE = CLIENT2.PARTY_CODE      
                                        AND INSCONT = 's' AND MARKETRATE > 0  
                               ORDER BY SETT_TYPE,      
                                        BBGISETTLEMENT.PARTY_CODE,      
                                        SCRIP_CD,    
                                        SERIES, MARKETRATE      
                                              
  OPEN @@partycont      
        
  FETCH NEXT FROM @@partycont      
  INTO @@sett_type,      
       @@party,      
       @@scrip_cd,    
       @@SERIES,      
       @@Sell_Buy,  
    @@MARKETRATE       
             
  WHILE @@FETCH_STATUS = 0      
    BEGIN      
      SELECT @@cursetttype = @@sett_type      
            
      SELECT @@contno = 0      
            
      SELECT @@contno = @@maxcontnos + 1      
            
      SELECT @@maxcontnos = @@maxcontnos + 1      
                                                 
      UPDATE BBGISETTLEMENT      
      SET    CONTRACTNO = STUFF('0000000',8 - LEN(@@contno),LEN(@@contno),      
                                @@contno)      
      WHERE  PARTY_CODE = @@party      
             AND SETT_TYPE = @@sett_type      
             AND SCRIP_CD = @@scrip_cd    
             AND SERIES = @@SERIES      
             AND SELL_BUY = @@Sell_Buy      
    AND MARKETRATE = @@MARKETRATE   
        
      FETCH NEXT FROM @@partycont      
      INTO @@sett_type,      
           @@party,      
           @@scrip_cd,    
           @@SERIES,      
           @@Sell_Buy,  
     @@MARKETRATE       
    END      
          
  CLOSE @@partycont      
        
  IF CONVERT(INT,@@contno) >= 0      
    BEGIN      
      SELECT @@contno = @@contno      
    END      
  ELSE      
    BEGIN      
      SELECT @@contno = '0000000'      
    END      
          
  IF @@style = 1      
    BEGIN      
      IF @@contno > 0      
        UPDATE CONTGEN      
        SET    CONTRACTNO = @@maxcontnos      
        WHERE  @@sauda_date BETWEEN START_DATE      
                                    AND END_DATE      
    END      
          
  TRUNCATE TABLE TRADE      
        
  INSERT INTO PROCESS_MONITOR      
  VALUES     ('import Trade',      
              'contract',      
              '',      
              'bbgdirectgencontract',      
              'done-generate Contnp For Inst Clients (trade Table Truncated)',      
              'update Nodel Sett_no In Bbgsettlement',      
              @@sauda_date,      
              GETDATE())      
        
  UPDATE BBGSETTLEMENT      
  SET    SETT_NO = SETTLED_IN      
  FROM   BBGSETTLEMENT S,      
         NODEL N      
  WHERE  S.SCRIP_CD = N.SCRIP_CD      
         AND S.SERIES = N.SERIES      
         AND S.SAUDA_DATE BETWEEN N.START_DATE      
                                  AND N.END_DATE      
         AND S.SETT_TYPE = N.SETT_TYPE      
         AND S.SAUDA_DATE >= @@sauda_date      
                                   
  UPDATE BBGISETTLEMENT      
  SET    SETT_NO = SETTLED_IN      
  FROM   BBGISETTLEMENT S,      
         NODEL N      
  WHERE  S.SCRIP_CD = N.SCRIP_CD      
         AND S.SERIES = N.SERIES      
         AND S.SAUDA_DATE BETWEEN N.START_DATE      
                                  AND N.END_DATE      
         AND S.SETT_TYPE = N.SETT_TYPE      
         AND S.SAUDA_DATE >= @@sauda_date      
                                   
  INSERT INTO PROCESS_MONITOR      
  VALUES     ('import Trade',      
              'contract',      
              '',      
              'bbgdirectgencontract',      
              'done-update Nodel Sett_no In Bbgsettlement',      
              'settflag Regen-populate Cursor From Settlement And Bbgsettlement',      
              @@sauda_date,      
              GETDATE())      
        
                                            
  INSERT INTO SETTLEMENT      
  SELECT *      
  FROM   BBGSETTLEMENT      
               
  INSERT INTO PROCESS_MONITOR      
  VALUES     ('import Trade',      
              'contract',      
              '',      
              'bbgdirectgencontract',      
              'done-insert Into Settlement From Bbgsettlement',      
              'settflag Regen-populate Cursor From Isettlement And Bbgisettlement',      
              @@sauda_date,      
              GETDATE())      
        
         
  INSERT INTO ISETTLEMENT      
  SELECT *      
  FROM   BBGISETTLEMENT      
               
  INSERT INTO PROCESS_MONITOR      
  VALUES     ('import Trade',      
              'contract',      
              '',      
              'bbgdirectgencontract',      
              'done-insert Into Isettlement From Bbgisettlement',      
              'insert Into Details From Bbgsettlement',      
              @@sauda_date,      
              GETDATE())      
        
  INSERT INTO DETAILS      
  SELECT DISTINCT LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),      
                  SETT_NO,      
                  SETT_TYPE,      
                  PARTY_CODE,      
                  's'      
  FROM   BBGSETTLEMENT      
               
  INSERT INTO DETAILS      
  SELECT DISTINCT LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),      
                  SETT_NO,      
        SETT_TYPE,      
                  PARTY_CODE,      
                  'is'      
  FROM   BBGISETTLEMENT      
               
  INSERT INTO PROCESS_MONITOR      
  VALUES     ('import Trade',      
              'contract',      
              '',      
              'bbgdirectgencontract',      
              'done-insert Into Details From Bbgsettlement',      
              'end-process Completed',      
              @@sauda_date,      
              GETDATE())

GO
