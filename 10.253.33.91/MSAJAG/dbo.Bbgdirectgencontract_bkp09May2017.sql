-- Object: PROCEDURE dbo.Bbgdirectgencontract_bkp09May2017
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




CREATE PROCEDURE [dbo].[Bbgdirectgencontract_bkp09May2017]        

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

         DUMMY2,  

   PARTY_CODE        

  FROM   CONFIRMVIEW       

  UPDATE BBGSETTLEMENT SET PARENTCODE = T.PARENTCODE  

  FROM TRD_CLIENT T  

  WHERE BBGSETTLEMENT.PARTY_CODE = T.PARTY_CODE  

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

  SELECT Contractno,Billno,Trade_No,Party_Code,Scrip_Cd,User_Id,Tradeqty,Auctionpart,Markettype,Series,      

  Order_No,Marketrate,Sauda_Date,Table_No,Line_No,Val_Perc,Normal,Day_Puc,Day_Sales,Sett_Purch,Sett_Sales,      

  Sell_Buy,Settflag,Brokapplied,Netrate,Amount,Ins_Chrg,Turn_Tax,Other_Chrg,Sebi_Tax,Broker_Chrg,Service_Tax,      

  Trade_Amount,Billflag,Sett_No,Nbrokapp,Nsertax,N_Netrate,Sett_Type,Partipantcode,Status,Pro_Cli,Cpid,      

  Instrument,Booktype,Branch_Id,Tmark,Scheme,Dummy1,Dummy2        

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

                  C.PARENTCODE,        

                  CONTRACTNO        

  INTO   #SETT        

  FROM   SETTLEMENT S,        

         TRD_CLIENT C        

  WHERE  SAUDA_DATE LIKE @@sauda_date + '%'        

         AND C.PARTY_CODE = S.PARTY_CODE        

         AND TRADE_NO NOT LIKE '%C%'        

         AND C.CL_TYPE NOT IN ('PRO','NRI')        

                                      

  UPDATE BBGSETTLEMENT        

  SET    CONTRACTNO = S.CONTRACTNO        

  FROM   BBGSETTLEMENT WITH (index (partysett )),        

         #SETT S        

  WHERE  BBGSETTLEMENT.PARENTCODE = S.PARENTCODE        

         AND BBGSETTLEMENT.SETT_TYPE = S.SETT_TYPE        

                                               

  SELECT DISTINCT SETT_TYPE,        

                  C.PARENTCODE,        

                  CONTRACTNO,        

                  SCRIP_CD='',        

                  SERIES='',        

                  SELL_BUY        

  INTO   #SETT_NRI        

  FROM   SETTLEMENT S,        

         TRD_CLIENT C        

  WHERE  SAUDA_DATE LIKE @@sauda_date + '%'        

         AND C.PARTY_CODE = S.PARTY_CODE        

         AND TRADE_NO NOT LIKE '%C%'        

         AND C.CL_TYPE = 'NRI'        

                                 

  UPDATE BBGSETTLEMENT        

  SET    CONTRACTNO = S.CONTRACTNO        

  FROM   BBGSETTLEMENT WITH (index (partysett )),        

         #SETT_NRI S        

  WHERE  BBGSETTLEMENT.PARENTCODE = S.PARENTCODE        

         AND BBGSETTLEMENT.SETT_TYPE = S.SETT_TYPE        

         --AND BBGSETTLEMENT.SCRIP_CD = S.SCRIP_CD        

         --AND BBGSETTLEMENT.SERIES = S.SERIES        

         AND BBGSETTLEMENT.SELL_BUY = S.SELL_BUY        

                                              

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

                    PARENTCODE,        

                    SCRIP_CD = '',        

                    ORDER_NO = '',        

                    SERIES = '',        

                    SELL_BUY = ''        

  FROM     BBGSETTLEMENT        

  WHERE    PRO_CLI = 1        

           AND CONVERT(INT,CONTRACTNO) = 0        

  ORDER BY SETT_TYPE,        

           PARENTCODE        

                   

  INSERT INTO TRD_CONTRACTNO        

  SELECT   DISTINCT SETT_TYPE,        

                    PARENTCODE,        

                    SCRIP_CD='',        

                    ORDER_NO = '',        

                    SERIES='',        

                    SELL_BUY        

  FROM     BBGSETTLEMENT        

  WHERE    PRO_CLI = 3        

           AND CONVERT(INT,CONTRACTNO) = 0        

  ORDER BY SETT_TYPE,        

           PARENTCODE,          

           SELL_BUY        

                   

  UPDATE BBGSETTLEMENT        

  SET    CONTRACTNO = STUFF('0000000',8 - LEN(@@maxcontnos + SNO),LEN(@@maxcontnos + SNO),        

                            @@maxcontnos + SNO)        

  FROM   BBGSETTLEMENT B WITH (index (partysett )),        

         TRD_CONTRACTNO T        

  WHERE  B.SETT_TYPE = T.SETT_TYPE        

         AND B.PARENTCODE = T.PARTY_CODE        

         AND PRO_CLI = 1        

         AND CONVERT(INT,CONTRACTNO) = 0        

                                               

  UPDATE BBGSETTLEMENT        

  SET    CONTRACTNO = STUFF('0000000',8 - LEN(@@maxcontnos + SNO),LEN(@@maxcontnos + SNO),        

                            @@maxcontnos + SNO)        

  FROM   BBGSETTLEMENT B WITH (index (partysett )),        

         TRD_CONTRACTNO T        

  WHERE  B.SETT_TYPE = T.SETT_TYPE        

         AND B.PARENTCODE = T.PARTY_CODE        

         --AND B.SCRIP_CD = T.SCRIP_CD        

         --AND B.SERIES = T.SERIES        

         AND B.SELL_BUY = T.SELL_BUY        

         AND PRO_CLI = 3        

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

                                                 INSCONT,        

                                                 SELL_BUY        

                               FROM     ISETTLEMENT I,        

              CLIENT2 C2        

                               WHERE    I.SAUDA_DATE LIKE @@sauda_date + '%'        

                                        AND I.PARTY_CODE = C2.PARTY_CODE        

                                        AND TRADEQTY > 0        

                                        AND I.DUMMY2 <> '1'        

                               ORDER BY I.SETT_TYPE,        

                                        I.PARTY_CODE,        

                                        I.SCRIP_CD,        

                                        I.ORDER_NO,        

                                        I.CONTRACTNO        

                                                

  OPEN @@partycont        

          

  FETCH NEXT FROM @@partycont        

  INTO @@party,        

       @@sett_type,        

       @@contno,        

       @@order_no,        

       @@scrip_cd,        

       @@inscont,        

       @@Sell_Buy        

               

  WHILE @@FETCH_STATUS = 0        

    BEGIN        

      IF @@inscont = 'n'        

        BEGIN        

          UPDATE BBGISETTLEMENT        

          SET    CONTRACTNO = @@contno        

          WHERE  SETT_TYPE = @@sett_type        

                 AND PARTY_CODE = @@party        

        END        

                

      IF @@inscont = 'o'        

        BEGIN        

          UPDATE BBGISETTLEMENT        

          SET    CONTRACTNO = @@contno        

          WHERE  SETT_TYPE = @@sett_type        

                 AND PARTY_CODE = @@party        

                 AND ORDER_NO = @@order_no        

        END        

                

      IF @@inscont = 's'        

        BEGIN        

          UPDATE BBGISETTLEMENT        

          SET    CONTRACTNO = @@contno        

          WHERE  SETT_TYPE = @@sett_type        

                 AND PARTY_CODE = @@party        

                 AND SCRIP_CD = @@scrip_cd        

                 AND SELL_BUY = @@Sell_Buy        

        END        

                

      FETCH NEXT FROM @@partycont        

      INTO @@party,        

           @@sett_type,        

           @@contno,        

           @@order_no,        

           @@scrip_cd,        

           @@inscont,        

           @@Sell_Buy        

    END        

            

  CLOSE @@partycont        

          

  SELECT @@sett_type = ''        

          

  SELECT @@PARTIPANTCODE = ''        

          

  SELECT @@party = ''        

                           

  SET @@partycont = CURSOR FOR SELECT   DISTINCT SETT_TYPE,        

                                                 BBGISETTLEMENT.PARTY_CODE        

                               FROM     BBGISETTLEMENT,        

                                        CLIENT2        

                               WHERE    PRO_CLI <> 2        

                   AND CONVERT(INT,CONTRACTNO) = 0        

                                        AND BBGISETTLEMENT.PARTY_CODE = CLIENT2.PARTY_CODE        

                                        AND INSCONT = 'n'        

                               ORDER BY SETT_TYPE,        

                                        BBGISETTLEMENT.PARTY_CODE        

                                                

  OPEN @@partycont        

          

  FETCH NEXT FROM @@partycont        

  INTO @@sett_type,        

       @@party        

          

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

                                     

      FETCH NEXT FROM @@partycont        

      INTO @@sett_type,        

           @@party        

    END        

            

  CLOSE @@partycont        

          

  SELECT @@sett_type = ''        

          

  SELECT @@PARTIPANTCODE = ''        

          

  SELECT @@party = ''        

                           

  /* Now Order Wise    */        

  SET @@partycont = CURSOR FOR SELECT   DISTINCT SETT_TYPE,        

                                                 BBGISETTLEMENT.PARTY_CODE,        

                                                 ORDER_NO        

                               FROM     BBGISETTLEMENT,        

                                        CLIENT2        

                               WHERE    PRO_CLI <> 2        

                                        AND CONVERT(INT,CONTRACTNO) = 0        

                                        AND BBGISETTLEMENT.PARTY_CODE = CLIENT2.PARTY_CODE        

                                        AND INSCONT = 'o'        

                               ORDER BY SETT_TYPE,        

                                        BBGISETTLEMENT.PARTY_CODE,        

                                        ORDER_NO        

                                                

  OPEN @@partycont        

          

  FETCH NEXT FROM @@partycont        

  INTO @@sett_type,        

       @@party,        

       @@order_no        

          

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

                                    

      FETCH NEXT FROM @@partycont        

      INTO @@sett_type,        

           @@party,        

           @@order_no        

    END        

          

  CLOSE @@partycont        

          

  SELECT @@sett_type = ''        

          

  SELECT @@PARTIPANTCODE = ''        

          

  SELECT @@party = ''                             

  /* Now Scrip_wise   */        

  SET @@partycont = CURSOR FOR SELECT   DISTINCT SETT_TYPE,        

                                                 BBGISETTLEMENT.PARTY_CODE,        

                                                 SCRIP_CD,        

                                                 SELL_BUY        

                               FROM     BBGISETTLEMENT,        

                                        CLIENT2        

                               WHERE    PRO_CLI <> 2        

                                        AND CONVERT(INT,CONTRACTNO) = 0        

                                        AND BBGISETTLEMENT.PARTY_CODE = CLIENT2.PARTY_CODE        

                                        AND INSCONT = 's'        

                               ORDER BY SETT_TYPE,        

                                        BBGISETTLEMENT.PARTY_CODE,        

                                        SCRIP_CD        

                                                

  OPEN @@partycont        

          

  FETCH NEXT FROM @@partycont        

  INTO @@sett_type,        

       @@party,        

       @@scrip_cd,        

       @@Sell_Buy        

               

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

             AND SELL_BUY = @@Sell_Buy        

              

      FETCH NEXT FROM @@partycont        

      INTO @@sett_type,        

           @@party,        

           @@scrip_cd,        

           @@Sell_Buy        

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



Update BBGSettlement Set           

Brokapplied = (CASE WHEN T.VAL_PERC = 'V' THEN BROKERAGE ELSE ROUND(MARKETRATE * BROKERAGE / 100,2) END),  

NBrokapp = (CASE WHEN T.VAL_PERC = 'V' THEN BROKERAGE ELSE ROUND(MARKETRATE * BROKERAGE / 100,2) END),          

NetRate = MarketRate + (Case When Sell_Buy = 1   

        Then (CASE WHEN T.VAL_PERC = 'V'   

          THEN BROKERAGE   

          ELSE ROUND(MARKETRATE * BROKERAGE / 100,2)   

           END)  

        Else -(CASE WHEN T.VAL_PERC = 'V'   

          THEN BROKERAGE   

          ELSE ROUND(MARKETRATE * BROKERAGE / 100,2)   

           END)  

         End),          

N_NetRate = MarketRate + (Case When Sell_Buy = 1   

        Then (CASE WHEN T.VAL_PERC = 'V'   

          THEN BROKERAGE   

          ELSE ROUND(MARKETRATE * BROKERAGE / 100,2)   

           END)  

        Else -(CASE WHEN T.VAL_PERC = 'V'   

          THEN BROKERAGE   

          ELSE ROUND(MARKETRATE * BROKERAGE / 100,2)   

           END)  

         End),    

Service_Tax = Round(TradeQty*(CASE WHEN T.VAL_PERC = 'V'   

          THEN BROKERAGE   

          ELSE ROUND(MARKETRATE * BROKERAGE / 100,2)   

           END)*g.service_tax/100,4),        

NSerTax = Round(TradeQty*(CASE WHEN T.VAL_PERC = 'V'   

          THEN BROKERAGE   

          ELSE ROUND(MARKETRATE * BROKERAGE / 100,2)   

           END)*g.service_tax/100,4),        

Status = 'E',           

Ins_chrg = 0,          

Turn_Tax   = ((Floor((((Ct.Turnover_Tax  * BBGSettlement.Marketrate * BBGSettlement.Tradeqty)/100 )         

                       * Power(10, Ct.Round_To) + Ct.Rofig + Ct.Errnum ) /

                         (Ct.Rofig + Ct.Nozero )) * (Ct.Rofig +Ct.Nozero )) /        

                         Power(10, Ct.Round_To)),         

Other_Chrg = ((Floor((((Ct.Other_Chrg    * BBGSettlement.Marketrate * BBGSettlement.Tradeqty)/100 )         

                       * Power(10, Ct.Round_To) + Ct.Rofig + Ct.Errnum ) /         

                         (Ct.Rofig + Ct.Nozero )) * (Ct.Rofig +Ct.Nozero )) /        

                         Power(10, Ct.Round_To)),         

Sebi_Tax   = ((Floor((((Ct.Sebiturn_Tax  * BBGSettlement.Marketrate * BBGSettlement.Tradeqty)/100)         

                       * Power(10, Ct.Round_To) + Ct.Rofig + Ct.Errnum ) /         

                         (Ct.Rofig + Ct.Nozero )) * (Ct.Rofig +Ct.Nozero )) /        

                         Power(10, Ct.Round_To)),        

Broker_Chrg =  ((Floor((((Ct.Broker_Note * BBGSettlement.Marketrate * BBGSettlement.Tradeqty)/100)         

                       * Power(10, Ct.Round_To) + Ct.Rofig + Ct.Errnum ) /         

                         (Ct.Rofig + Ct.Nozero )) * (Ct.Rofig +Ct.Nozero )) /        

                         Power(10, Ct.Round_To))        

From Globals G, Client1 C1, Client2 C2, ClientTaxes_New CT, TBL_EXCEPTION_SCRIP T        

Where C1.Cl_Code = C2.Cl_Code        

And C2.Party_Code = BBGSettlement.Party_Code        

And C2.Party_Code = CT.Party_Code        

And BBGsettlement.Sauda_Date Between CT.Fromdate And CT.Todate        

And CT.Trans_Cat = 'DEL'        

And BBGsettlement.Scrip_CD = T.SCRIP_CD        

And BBGsettlement.SERIES = T.SERIES      

And BBGsettlement.Sauda_Date Between T.Fromdate And T.Todate        

And BBGsettlement.Sauda_Date Between year_start_dt And year_end_dt

          

  INSERT INTO PROCESS_MONITOR        

  VALUES     ('import Trade',        

              'contract',        

              '',        

              'bbgdirectgencontract',        

              'done-generate Contnp For Inst Clients (trade Table Truncated)',        

              'update Nodel Sett_no In Bbgsettlement',        

              @@sauda_date,        

              GETDATE())        

  

  

Update BBGSettlement Set         

Brokapplied = BROKERAGE,        

NBrokapp = BROKERAGE,        

NetRate = MarketRate+(Case When Sell_Buy = 1 Then BROKERAGE Else -BROKERAGE End),        

N_NetRate = MarketRate+(Case When Sell_Buy = 1 Then BROKERAGE Else -BROKERAGE End),        

Service_Tax = Round(TradeQty*BROKERAGE*g.service_tax/100,4),      

NSerTax = Round(TradeQty*BROKERAGE*g.service_tax/100,4),      

Status = 'E',       

Turn_Tax   = ((Floor((((Ct.Turnover_Tax  * BBGSettlement.Marketrate * BBGSettlement.Tradeqty)/100 )       

                       * Power(10, Ct.Round_To) + Ct.Rofig + Ct.Errnum ) /      

                         (Ct.Rofig + Ct.Nozero )) * (Ct.Rofig +Ct.Nozero )) /      

                         Power(10, Ct.Round_To)),       

Other_Chrg = ((Floor((((Ct.Other_Chrg    * BBGSettlement.Marketrate * BBGSettlement.Tradeqty)/100 )       

                       * Power(10, Ct.Round_To) + Ct.Rofig + Ct.Errnum ) /       

                         (Ct.Rofig + Ct.Nozero )) * (Ct.Rofig +Ct.Nozero )) /      

                         Power(10, Ct.Round_To)),       

Sebi_Tax   = ((Floor((((Ct.Sebiturn_Tax  * BBGSettlement.Marketrate * BBGSettlement.Tradeqty)/100)       

                       * Power(10, Ct.Round_To) + Ct.Rofig + Ct.Errnum ) /       

                         (Ct.Rofig + Ct.Nozero )) * (Ct.Rofig +Ct.Nozero )) /      

                         Power(10, Ct.Round_To)),      

Broker_Chrg =  ((Floor((((Ct.Broker_Note * BBGSettlement.Marketrate * BBGSettlement.Tradeqty)/100)       

                       * Power(10, Ct.Round_To) + Ct.Rofig + Ct.Errnum ) /       

                         (Ct.Rofig + Ct.Nozero )) * (Ct.Rofig +Ct.Nozero )) /      

                         Power(10, Ct.Round_To))      

From Globals G, Client1 C1, Client2 C2, ClientTaxes_New CT, TBL_EXCEPTION_SCRIP T      

Where C1.Cl_Code = C2.Cl_Code      

And C2.Party_Code = BBGSettlement.Party_Code      

And C2.Party_Code = CT.Party_Code      

And BBGsettlement.Sauda_Date Between CT.Fromdate And CT.Todate      

And CT.Trans_Cat = 'DEL'      

And BBGsettlement.Scrip_CD = T.SCRIP_CD      

And BBGsettlement.SERIES = T.SERIES    

And BBGsettlement.Sauda_Date Between T.Fromdate And T.Todate      

And BBGsettlement.Sauda_Date Between year_start_dt And year_end_dt   

  
SELECT N.SCRIP_CD,N.SERIES,N.SETT_NO,N.SETT_TYPE,N.START_DATE,N.END_DATE,N.SETTLED_IN  INTO #NODEL FROM NODEL N ,SETT_MST M
WHERE N.SETT_NO=M.SETT_NO
AND N.SETT_TYPE=M.SETT_TYPE
AND M.SETT_NO= @@sett_no
          

  UPDATE BBGSETTLEMENT        

  SET    SETT_NO = SETTLED_IN        

  FROM   BBGSETTLEMENT S,        

         #NODEL N        

  WHERE  S.SCRIP_CD = N.SCRIP_CD        

         AND S.SERIES = N.SERIES        

         AND S.SAUDA_DATE BETWEEN N.START_DATE        

                                  AND N.END_DATE        

         AND S.SETT_TYPE = N.SETT_TYPE        

  AND S.SAUDA_DATE >= @@sauda_date        

                                     

  UPDATE BBGISETTLEMENT        

  SET    SETT_NO = SETTLED_IN        

  FROM   BBGISETTLEMENT S,        

         #NODEL N        

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

          

  SELECT DISTINCT B.PARTY_CODE,        

                  B.SCRIP_CD,        

                  B.SERIES,        

                  B.PARTIPANTCODE,        

                  B.SETT_TYPE,        

                  B.SETT_NO        

  INTO   #SETT1        

  FROM   SETTLEMENT B        

  WHERE  SAUDA_DATE LIKE @@sauda_date + '%'        

      AND SETT_TYPE = 'N'      

   AND EXISTS (SELECT PARTY_CODE FROM BBGSETTLEMENT S                

   WHERE B.SCRIP_CD = S.SCRIP_CD                

               AND B.SERIES = S.SERIES                

               AND B.PARTIPANTCODE = S.PARTIPANTCODE                

               AND B.SETT_TYPE = S.SETT_TYPE                

               AND B.SETT_NO = S.SETT_NO                

               AND B.PARTY_CODE = S.PARTY_CODE)       

                                              

  INSERT INTO SETTLEMENT        

  SELECT Contractno,Billno,Trade_No,Party_Code,Scrip_Cd,User_Id,Tradeqty,Auctionpart,Markettype,Series,      

  Order_No,Marketrate,Sauda_Date,Table_No,Line_No,Val_Perc,Normal,Day_Puc,Day_Sales,Sett_Purch,Sett_Sales,      

  Sell_Buy,Settflag,Brokapplied,Netrate,Amount,Ins_Chrg,Turn_Tax,Other_Chrg,Sebi_Tax,Broker_Chrg,Service_Tax,      

  Trade_Amount,Billflag,Sett_No,Nbrokapp,Nsertax,N_Netrate,Sett_Type,Partipantcode,Status,Pro_Cli,Cpid,  

  Instrument,Booktype,Branch_Id,Tmark,Scheme,Dummy1,Dummy2        

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

  SELECT Contractno,Billno,Trade_No,Party_Code,Scrip_Cd,User_Id,Tradeqty,Auctionpart,Markettype,Series,      

  Order_No,Marketrate,Sauda_Date,Table_No,Line_No,Val_Perc,Normal,Day_Puc,Day_Sales,Sett_Purch,Sett_Sales,      

  Sell_Buy,Settflag,Brokapplied,Netrate,Amount,Ins_Chrg,Turn_Tax,Other_Chrg,Sebi_Tax,Broker_Chrg,Service_Tax,      

  Trade_Amount,Billflag,Sett_No,Nbrokapp,Nsertax,N_Netrate,Sett_Type,Partipantcode,Status,Pro_Cli,Cpid,      

  Instrument,Booktype,Branch_Id,Tmark,Scheme,Dummy1,Dummy2  

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


  INSERT INTO MSAJAG.DBO.DETAILS        

  SELECT DISTINCT LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),        

                  SETT_NO,        

                  SETT_TYPE,        

                  PARTY_CODE,        

                  's'        

  FROM   BBGSETTLEMENT        

                 

  INSERT INTO MSAJAG.DBO.DETAILS        

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

        

   SELECT S.*           

   INTO #SETT_NEW       

 FROM   SETTLEMENT S,                

         TRD_CLIENT C                

   WHERE  SAUDA_DATE LIKE @@sauda_date + '%'                

         AND S.PARTY_CODE = C.PARTY_CODE                

         AND TRADE_NO NOT LIKE '%C%'       

  AND SETT_TYPE = 'N'                                             

   AND EXISTS (SELECT PARTY_CODE FROM #SETT1 B                

   WHERE    B.SCRIP_CD = S.SCRIP_CD                

            AND B.SERIES = S.SERIES                

            AND B.PARTIPANTCODE = S.PARTIPANTCODE                

            AND B.SETT_TYPE = S.SETT_TYPE                

            AND B.SETT_NO = S.SETT_NO                

            AND B.PARTY_CODE = S.PARTY_CODE      

   AND B.SETT_TYPE = 'N')      

      

IF (SELECT ISNULL(COUNT(1),0) FROM #SETT_NEW ) > 0          

BEGIN          

  

 TRUNCATE TABLE BBGSETTLEMENT      

  

 DELETE SETTLEMENT FROM TRD_CLIENT C          

 WHERE  SAUDA_DATE LIKE @@sauda_date + '%'                

         AND SETTLEMENT.PARTY_CODE = C.PARTY_CODE                

         AND TRADE_NO NOT LIKE '%C%'       

   AND SETT_TYPE = 'N'                                             

   AND EXISTS (SELECT PARTY_CODE FROM #SETT1 B                

   WHERE    B.SCRIP_CD = SETTLEMENT.SCRIP_CD                

            AND B.SERIES = SETTLEMENT.SERIES                

            AND B.PARTIPANTCODE = SETTLEMENT.PARTIPANTCODE                

            AND B.SETT_TYPE = SETTLEMENT.SETT_TYPE                

            AND B.SETT_NO = SETTLEMENT.SETT_NO                

            AND B.PARTY_CODE = SETTLEMENT.PARTY_CODE      

   AND B.SETT_TYPE = 'N')          

          

  INSERT INTO BBGSETTLEMENT          

  SELECT Contractno,Billno,Trade_No,Party_Code,Scrip_Cd,User_Id,Tradeqty,Auctionpart,Markettype,Series,      

  Order_No,Marketrate,Sauda_Date,Table_No,Line_No,Val_Perc,Normal,Day_Puc,Day_Sales,Sett_Purch,Sett_Sales,      

  Sell_Buy,Settflag,Brokapplied,Netrate,Amount,Ins_Chrg,Turn_Tax,Other_Chrg,Sebi_Tax,Broker_Chrg,Service_Tax,      

  Trade_Amount,Billflag,Sett_No,Nbrokapp,Nsertax,N_Netrate,Sett_Type,Partipantcode,Status,Pro_Cli,Cpid,      

  Instrument,Booktype,Branch_Id,Tmark,Scheme,Dummy1,Dummy2, PARTY_CODE               

  FROM #SETT_NEW          

  

  UPDATE BBGSETTLEMENT SET PARENTCODE = T.PARENTCODE  

  FROM TRD_CLIENT T  

  WHERE BBGSETTLEMENT.PARTY_CODE = T.PARTY_CODE  

          

  exec RearrangeTrdflag_sett          

  exec BBGSettBrokUpdateNew_temp          

           

  INSERT INTO SETTLEMENT                

  SELECT Contractno,Billno,Trade_No,Party_Code,Scrip_Cd,User_Id,Tradeqty,Auctionpart,Markettype,Series,      

  Order_No,Marketrate,Sauda_Date,Table_No,Line_No,Val_Perc,Normal,Day_Puc,Day_Sales,Sett_Purch,Sett_Sales,      

  Sell_Buy,Settflag,Brokapplied,Netrate,Amount,Ins_Chrg,Turn_Tax,Other_Chrg,Sebi_Tax,Broker_Chrg,Service_Tax,      

  Trade_Amount,Billflag,Sett_No,Nbrokapp,Nsertax,N_Netrate,Sett_Type,Partipantcode,Status,Pro_Cli,Cpid,      

  Instrument,Booktype,Branch_Id,Tmark,Scheme,Dummy1,Dummy2               

  FROM   BBGSETTLEMENT          

      

END

GO
