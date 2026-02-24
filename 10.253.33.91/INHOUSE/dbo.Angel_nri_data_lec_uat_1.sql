-- Object: PROCEDURE dbo.Angel_nri_data_lec_uat_1
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

      

--exec Angel_nri_data_lec_uat '01/03/2013','1','0','NSE'      

CREATE PROC Angel_nri_data_lec_uat_1 (@SDATE  AS VARCHAR(11),        

                                   @TYPE   AS VARCHAR(2),        

                                   @BANKID AS INT,        

                                   @SEG    AS VARCHAR(5))        

AS        

  BEGIN        

      SET NOCOUNT ON        

      --DECLARE @SDATE AS VARCHAR(11),@TYPE AS VARCHAR(2),@BANKID AS INT,@SEG AS VARCHAR(5)                            

      --SET @SDATE ='16/08/2011' SET @TYPE ='1' SET @BANKID =9 SET @SEG='BSE'                            

      SET @SDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @SDATE, 103))        

        

      DECLARE @SELL_BUY        AS CHAR(1),        

              @TRANS_AMOUNT    AS DECIMAL(18, 2),        

              @CALCULATION     AS DECIMAL(18, 2),        

              @HEADER_TOTALAMT AS DECIMAL(18, 2),        

              @BSE             AS INT,        

              @NSE             AS INT,        

              @DIFFAMT         AS DECIMAL(18, 2);        

        

      SELECT @SELL_BUY = CASE        

                           WHEN @TYPE = 1 THEN 'P'        

                           WHEN @TYPE = 2 THEN 'S'        

                         END        

        

      CREATE TABLE #TEMP1        

        (        

           FLDCOL VARCHAR(1000)        

        )        

        

      SELECT @BSE = Count(*)        

      FROM   MSAJAG.DBO.NRIBSE with(nolock)       

      WHERE  CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

        

      SELECT @NSE = Count(*)        

      FROM   MSAJAG.DBO.NRINSE with(nolock)          

      WHERE  CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

        

      IF @BSE = 0        

          OR @NSE = 0        

        BEGIN        

            SELECT DISTINCT FLD_CLIENTCODE        

            INTO   #ZRCLI        

            FROM   INTRANET.RISK.DBO.TBL_NRICLIENTMASTER B WITH (NOLOCK)        

        

            SELECT DISTINCT PARTY_CODE        

            INTO   #NRI_CLI        

            FROM   MSAJAG.DBO.CMBILLVALAN X WITH (NOLOCK)        

                   INNER JOIN #ZRCLI B WITH (NOLOCK)        

                     ON X.PARTY_CODE = B.FLD_CLIENTCODE        

            WHERE  SAUDA_DATE = CONVERT(DATETIME, @SDATE, 103) --AND PARTY_CODE LIKE 'ZR%'                            

            UNION        

            SELECT DISTINCT PARTY_CODE        

            FROM   ANAND.BSEDB_AB.DBO.CMBILLVALAN X WITH (NOLOCK)        

                   INNER JOIN #ZRCLI B WITH (NOLOCK)        

                     ON X.PARTY_CODE = B.FLD_CLIENTCODE        

            WHERE  SAUDA_DATE = CONVERT(DATETIME, @SDATE, 103) --AND PARTY_CODE LIKE 'ZR%'                          

            IF @SEG = 'BSE'        

              BEGIN        

                  DELETE FROM MSAJAG.DBO.NRIBSE        

                  WHERE  CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

        

                  INSERT INTO MSAJAG.DBO.NRIBSE        

                  SELECT CONTRACTNO,        

                         PARTY_CODE,        

                         SCRIP_CD,        

                         TRADEQTY,        

                         SAUDA_DATE,        

                         SELL_BUY,        

                         NBROKAPP,        

                         INS_CHRG,        

                         TURN_TAX,        

                         OTHER_CHRG,        

                         SEBI_TAX,        

                         BROKER_CHRG,        

                         TRADE_AMOUNT,        

                         MARKETRATE,        

                         NSERTAX,        

                         N_NETRATE        

                  FROM   ANAND.BSEDB_AB.DBO.SETTLEMENT WITH (NOLOCK)        

                  WHERE  PARTY_CODE IN (SELECT PARTY_CODE        

                                        FROM   #NRI_CLI)        

                         AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

        

                  INSERT INTO MSAJAG.DBO.NRIBSE        

                  SELECT CONTRACTNO,        

                         PARTY_CODE,        

                         SCRIP_CD,        

                         TRADEQTY,        

                         SAUDA_DATE,        

                         SELL_BUY,        

                         NBROKAPP,        

                         INS_CHRG,        

                         TURN_TAX,        

                         OTHER_CHRG,        

                         SEBI_TAX,        

                         BROKER_CHRG,        

                         TRADE_AMOUNT,        

                         MARKETRATE,        

                  NSERTAX,        

                         N_NETRATE        

                  FROM   ANAND.BSEDB_AB.DBO.HISTORY WITH (NOLOCK)        

                  WHERE  PARTY_CODE IN (SELECT PARTY_CODE        

                                        FROM   #NRI_CLI)        

                         AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

              END        

        

            IF @SEG = 'NSE'        

              BEGIN        

                  DELETE FROM MSAJAG.DBO.NRINSE        

                  WHERE  CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

        

                  INSERT INTO MSAJAG.DBO.NRINSE        

                  SELECT CONTRACTNO,        

                         PARTY_CODE,        

                         SCRIP_CD,        

                         TRADEQTY,        

                         SAUDA_DATE,        

                         SELL_BUY,        

                         NBROKAPP,        

                         INS_CHRG,        

                         TURN_TAX,        

                         OTHER_CHRG,        

                         SEBI_TAX,        

                         BROKER_CHRG,        

                         TRADE_AMOUNT,        

                         MARKETRATE,        

                         NSERTAX,        

                         N_NETRATE        

                  FROM   MSAJAG.DBO.SETTLEMENT(NOLOCK)        

                  WHERE  PARTY_CODE IN (SELECT PARTY_CODE        

                                        FROM   #NRI_CLI)        

                         AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

        

                  INSERT INTO MSAJAG.DBO.NRINSE        

                  SELECT CONTRACTNO,        

                         PARTY_CODE,        

                         SCRIP_CD,        

                         TRADEQTY,        

                         SAUDA_DATE,        

                         SELL_BUY,        

                         NBROKAPP,        

                         INS_CHRG,        

                         TURN_TAX,        

                         OTHER_CHRG,        

                         SEBI_TAX,        

                         BROKER_CHRG,        

                         TRADE_AMOUNT,        

                         MARKETRATE,        

                         NSERTAX,        

                         N_NETRATE        

                  FROM   MSAJAG.DBO.HISTORY(NOLOCK)        

                  WHERE  PARTY_CODE IN (SELECT PARTY_CODE        

                                        FROM   #NRI_CLI)        

                         AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

              END        

        END        

        

      IF  @SEG = 'NSE'         

        BEGIN        

            CREATE TABLE #NSE_HEADER        

              (        

                 EXCHANGE           VARCHAR(50),        

                 PARTY_CODE         VARCHAR(50),        

                 SAUDA_DATE         DATETIME,        

                 SELL_BUY           INT,        

                 CONTRACTNO         VARCHAR(50),        

                 SERVICE_TAX        DECIMAL(18, 4),        

                 EDUCESS            INT,        

                 EXCHAGE_LEVIES     DECIMAL(18, 4),        

                 STT                DECIMAL(18, 4),        

                 STAMPDUTY          DECIMAL(18, 4),        

                 MINBROKERAGE       DECIMAL(18, 4),        

                 OTHER_CHARGES      DECIMAL(18, 4),        

                 NO_OF_TRANSACTIONS INT,        

                 TOTALAMT           DECIMAL(18, 2)        

              ); -- drop table #NSE_HEADER          

            INSERT INTO #NSE_HEADER        

            EXEC MSAJAG.dbo.Nsenriheader        

              @SDATE,        

              @TYPE        

        END        

      ELSE        

      BEGIN        

        CREATE TABLE #BSE_HEADER        

          (        

             EXCHANGE           VARCHAR(50),        

             PARTY_CODE         VARCHAR(50),        

             SAUDA_DATE         DATETIME,        

             SELL_BUY           INT,        

             CONTRACTNO         VARCHAR(50),        

             SERVICE_TAX        DECIMAL(18, 4),        

             EDUCESS            INT,        

             EXCHAGE_LEVIES     DECIMAL(18, 4),        

             STT                DECIMAL(18, 4),        

             STAMPDUTY          DECIMAL(18, 4),        

             MINBROKERAGE       DECIMAL(18, 4),        

             OTHER_CHARGES      DECIMAL(18, 4),        

             NO_OF_TRANSACTIONS INT,        

             TOTALAMT           DECIMAL(18, 2)        

          ); -- drop table #BSE_HEADER          

      INSERT INTO #BSE_HEADER        

      EXEC Anand.BSEDB_AB.DBO.Bsenriheader        

        @SDATE,        

        @TYPE        

     END        

        

SELECT DISTINCT PARTY_CODE        

INTO   #CLIENTS        

FROM   MSAJAG.DBO.NRIBSE WITH (NOLOCK)        

WHERE  CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

       AND SELL_BUY = @TYPE        

UNION        

SELECT DISTINCT PARTY_CODE        

FROM   MSAJAG.DBO.NRINSE WITH (NOLOCK)        

WHERE  CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

       AND SELL_BUY = @TYPE        

        

IF @BANKID <> 0        

  BEGIN        

      SELECT #CLIENTS.PARTY_CODE,        

             B.FLD_BANKID        

      INTO   #T        

      FROM   #CLIENTS,        

             INTRANET.RISK.DBO.TBL_NRICLIENTMASTER B WITH (NOLOCK)        

      WHERE  #CLIENTS.PARTY_CODE = B.FLD_CLIENTCODE        

        

      DELETE FROM #CLIENTS        

      WHERE  PARTY_CODE IN (SELECT PARTY_CODE        

                            FROM   #T        

                            WHERE  FLD_BANKID <> @BANKID)        

  END        

        

CREATE TABLE #TT        

  (        

     CNT        INT IDENTITY (1, 1),        

     PARTY_CODE VARCHAR(20)        

  )        

        

INSERT INTO #TT        

SELECT *        

FROM   #CLIENTS        

        

DECLARE @CNT INT        

        

SELECT @CNT = Count(*)        

FROM   #CLIENTS        

        

WHILE @CNT > 0        

  BEGIN        

      DECLARE @TRANCNT   AS INT,        

              @PARTYCODE AS VARCHAR(20)        

        

      SELECT @PARTYCODE = Ltrim(Rtrim(PARTY_CODE))        

      FROM   #TT        

      WHERE  @CNT = CNT        

        

      IF @SEG = 'BSE'        

        BEGIN        

            /* SELECT @TRANCNT = Count(CONTRACTNO)        

                   FROM   MSAJAG.DBO.NRIBSE        

                   WHERE  PARTY_CODE = @PARTYCODE        

                          AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

                          AND SELL_BUY = @TYPE        

                   GROUP  BY PARTY_CODE,        

                             Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', ''),        

                             CONTRACTNO        

                    

                   INSERT INTO #TEMP1        

                   SELECT 'H' + '|' + Ltrim(Rtrim(PARTY_CODE)) + '|' + Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', '') + '|' + CONVERT(VARCHAR, CONTRACTNO) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(SERVICE_TAX, 0)))) + '|' + '0.0


  

    

      

0' + '|' +        

                          --EXSERVICE_TAX=SUM(ISNULL(EXSERVICE_TAX,0))+'|'+                            

                          CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(TURN_TAX, 0)))) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(INS_CHRG, 0)))) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(BROKER_CHRG, 0)))) + '|' 


  

    

      

+ CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(SEBI_TAX, 0)))) + '|' + CONVERT(VARCHAR, @TRANCNT) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), CASE        

                                                                                                                                                                                                

      

                                                                                                                                                            WHEN @TYPE = '1' THEN ( -1 ) * ( Sum(Isnull(PAMT, 0)) )        

                                                                                        

                                                                                                                                                            ELSE Sum(Isnull(SAMT, 0))        

                                                                       END))        

                   FROM   ANAND.BSEDB_AB.DBO.CMBILLVALAN WITH (NOLOCK)        

                   WHERE  SAUDA_DATE = @SDATE        

                          AND PARTY_CODE = @PARTYCODE        

                          AND ( ( @TYPE = '1'        

                                  AND PAMT <> 0 )        

                                 OR ( @TYPE = '2'        

                                      AND SAMT <> 0 ) )        

                   GROUP  BY PARTY_CODE,        

                             CONTRACTNO,        

                             Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', '')        

                    

                   INSERT INTO #TEMP1        

                   SELECT 'T' + '|' + Ltrim(Rtrim(PARTY_CODE)) + '|' + Ltrim(Rtrim(CONTRACTNO)) + '|' + CASE        

                                                                                                          WHEN @TYPE = 1 THEN 'P'        

                                                                                                          WHEN @TYPE = 2 THEN 'S'        

                                                                                                        END + '|' + Ltrim(Rtrim(Isnull(Y.ISIN, ''))) + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, TRADEQTY))) + '|' + Ltrim(Rtrim(MARKETRATE)) + '|' + Ltrim(Rtrim(CONV


  

    

      

ERT(VARCHAR, CONVERT(DEC(10, 2), NBROKAPP)))) + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, CASE        

                                                                                                                                                                                                                                                               


  

    

      

                                                                                     WHEN @TYPE = 1 THEN ( -1 ) * ( CONVERT(INT, TRADEQTY) * ( MARKETRATE + NBROKAPP ) )        

                     

  

    

      

                                                                                     WHEN @TYPE = 2 THEN CONVERT(INT, TRADEQTY) * ( MARKETRATE - NBROKAPP )        

                                                                                                                                                                                                                                                               


  

    

      

                                                                                   END)))        

                   FROM   MSAJAG.DBO.NRIBSE X        

                          LEFT OUTER JOIN (SELECT *        

                                           FROM   ANGELDEMAT.MSAJAG.DBO.V_ISIN_BSENSE WITH (NOLOCK)        

                                           WHERE  SERIES = 'BSE')Y        

                            ON X.SCRIP_CD = Y.SCRIP_CD COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS        

                   WHERE  X.PARTY_CODE = @PARTYCODE        

                          AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

                          AND SELL_BUY = @TYPE        

                          */        

 SELECT @TRANCNT = Count(CONTRACTNO),        

                   @TRANS_AMOUNT = Sum(CONVERT(DECIMAL(14, 2), TRANACTIONAMT))        

            FROM   Anand.BSEDB_AB.DBO.BSENRIDETAIL        

            WHERE  PARTY_CODE = @PARTYCODE        

                   AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

                   AND TRANSACTION_TYPE = @SELL_BUY        

            GROUP  BY PARTY_CODE,        

                      Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', ''),        

                 CONTRACTNO        

        

            -- as per formula add header's service tax + Education Cess + Exchange Levy + STT + Stamp Duty+ Others          

            SELECT @CALCULATION =     

            CONVERT(DECIMAL(14, 2), @TRANS_AMOUNT) + CONVERT(DECIMAL(14, 2), SERVICE_TAX) + 

            CONVERT(DECIMAL(14, 2), EDUCESS) + CONVERT(DECIMAL(14, 2), EXCHAGE_LEVIES) + 

            CONVERT(DECIMAL(14, 2), STT) + CONVERT(DECIMAL(14, 2), STAMPDUTY) 

            + CONVERT(DECIMAL(14, 2), MINBROKERAGE) + CONVERT(DECIMAL(14, 2), OTHER_CHARGES)        

            FROM   #BSE_HEADER WITH (NOLOCK)        

            WHERE  PARTY_CODE = @PARTYCODE        

                   AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

                   AND SELL_BUY = @TYPE        

        

            SELECT @HEADER_TOTALAMT = Sum(CONVERT(DECIMAL(14, 2), TOTALAMT))        

            FROM   #BSE_HEADER        

            WHERE  PARTY_CODE = @PARTYCODE        

                   AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

                   AND SELL_BUY = @TYPE        

            GROUP  BY PARTY_CODE        

        

            SELECT @diffamt = Round(@HEADER_TOTALAMT, 2) - Round(@calculation, 2)        

        

            INSERT INTO #TEMP1        

            SELECT 'H' + '|' + Ltrim(Rtrim(PARTY_CODE)) + '|' + Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', '') + '|' + CONVERT(VARCHAR, CONTRACTNO) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(SERVICE_TAX, 0)))) + '|'       

            + '0.00' + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(EXCHAGE_LEVIES, 0)))) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(STT, 0)))) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2),   

            Sum(Isnull(STAMPDUTY, 0)))) + '|'     

            + CASE WHEN @diffamt BETWEEN -0.03 AND 0.03 THEN CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), ( Sum(CONVERT(DECIMAL(14, 2), Isnull(MINBROKERAGE, 0)) + CONVERT(DECIMAL(14, 2), Isnull(OTHER_CHARGES, 0))) + @diffamt )))        

             ELSE CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), ( Sum(Isnull(MINBROKERAGE, 0) + Isnull(OTHER_CHARGES, 0)) )))        

             END + '|' + CONVERT(VARCHAR, @TRANCNT) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), ( Sum(TOTALAMT) )))        

            FROM   #BSE_HEADER WITH (NOLOCK)        

            WHERE  SAUDA_DATE = @SDATE        

                   AND PARTY_CODE = @PARTYCODE        

                   AND SELL_BUY = @TYPE        

            GROUP  BY PARTY_CODE,        

                      CONTRACTNO,        

                      Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', '')        

        

            INSERT INTO #TEMP1        

            SELECT 'T' + '|' + Ltrim(Rtrim(PARTY_CODE)) + '|' + Ltrim(Rtrim(CONTRACTNO)) + '|' + CASE        

                                                                                                   WHEN @TYPE = 1 THEN 'P'     

                                                                                                   WHEN @TYPE = 2 THEN 'S'        

                                                                                                 END 

                 +'|' + Ltrim(Rtrim(Isnull(ISIN, ''))) 

                 + '|'  + Ltrim(Rtrim(CONVERT(VARCHAR, QTY))) 

                 + '|'  + Ltrim(Rtrim(CONVERT(VARCHAR, CONVERT(DEC(15, 2), RATE)))) 

                 + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, CONVERT(DEC(10, 2), BROK_PERSCRIP)))) 

                 + '|' + Ltrim(Rtrim(CONVERT(DEC(10, 2), TRANACTIONAMT)))        

            FROM   Anand.BSEDB_AB.DBO.BSENRIDETAIL X  WITH (NOLOCK)          

            WHERE  X.PARTY_CODE = @PARTYCODE        

          AND SAUDA_DATE = @SDATE        

                   AND Transaction_type = @SELL_BUY        

        END        

        

      ---- NSE                            

      IF @SEG = 'NSE'        

        BEGIN        

            /* SELECT @TRANCNT = Count(CONTRACTNO)        

             FROM   MSAJAG.DBO.NRINSE        

             WHERE  PARTY_CODE = @PARTYCODE        

                    AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

                    AND SELL_BUY = @TYPE        

             GROUP  BY PARTY_CODE,        

                       Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', ''),        

                       CONTRACTNO        

                    

             INSERT INTO #TEMP1        

             SELECT 'H' + '|' + Ltrim(Rtrim(PARTY_CODE)) + '|' + Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', '') + '|' + CONVERT(VARCHAR, CONTRACTNO) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(SERVICE_TAX, 0)))) + '|' + '0.00' + 
'

  

    

      

|' +        

                    --EXSERVICE_TAX=SUM(ISNULL(EXSERVICE_TAX,0))+'|'+                              

                    CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(TURN_TAX, 0)))) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(INS_CHRG, 0)))) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(BROKER_CHRG, 0)))) + '|' + CONV


  

    

      

ERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(SEBI_TAX, 0)))) + '|' + CONVERT(VARCHAR, @TRANCNT) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), CASE        

                                                                                                                                                                                                                                                               


  

    

      

                                                                                                                                                      WHEN @TYPE = '1' THEN ( -1 ) * ( Sum(Isnull(PAMT, 0)) )        

                                                                                                                                                                                                                                                               


  

    

      

                                                                                                                            ELSE Sum(Isnull(SAMT, 0))        

                                                                                                                                                                                                                                                               


  

    

      

                                                                                                                                                    END))        

             FROM   MSAJAG.DBO.CMBILLVALAN WITH (NOLOCK)        

             --FROM MSAJAG.DBO.CONTRACT_DATA WITH (NOLOCK)           

             WHERE  SAUDA_DATE = @SDATE        

                    AND PARTY_CODE = @PARTYCODE        

                    AND ( ( @TYPE = '1'        

                            AND PAMT <> 0 )        

                           OR ( @TYPE = '2'        

                          AND SAMT <> 0 ) )        

             GROUP  BY PARTY_CODE,        

                       CONTRACTNO,        

                       Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', '')        

                    

             INSERT INTO #TEMP1        

             SELECT 'T' + '|' + Ltrim(Rtrim(PARTY_CODE)) + '|' + Ltrim(Rtrim(CONTRACTNO)) + '|' + CASE        

                                                                                                    WHEN @TYPE = 1 THEN 'P'        

                                                                                                    WHEN @TYPE = 2 THEN 'S'        

                                       END + '|' + Ltrim(Rtrim(Isnull(Y.ISIN, ''))) + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, TRADEQTY))) + '|' + Ltrim(Rtrim(MARKETRATE)) + '|' + Ltrim(Rtrim(CONVERT(VA      

RCHAR, CONVERT(DEC(10, 2), NBROKAPP)))) + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, CASE        

                                                                                  WHEN @TYPE = 1 THEN ( -1 ) * ( CONVERT(INT, TRADEQTY) * ( MARKETRATE + NBROKAPP ) )        

                                                                                                                                                                                                                                                               


  

    

      

                                                                               WHEN @TYPE = 2 THEN CONVERT(INT, TRADEQTY) * ( MARKETRATE - NBROKAPP )        

                                                                                                                                                                                                                                                               


  

    

      

                                                                             END)))        

             FROM   MSAJAG.DBO.NRINSE X        

                    LEFT OUTER JOIN (SELECT *        

                                     FROM   ANGELDEMAT.MSAJAG.DBO.V_ISIN_BSENSE WITH (NOLOCK)        

                                     WHERE  SERIES = 'EQ')Y        

                      ON X.SCRIP_CD = Y.SCRIP_CD COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS        

             WHERE  X.PARTY_CODE = @PARTYCODE        

                    AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

                    AND SELL_BUY = @TYPE */        

            SELECT @TRANCNT = Count(CONTRACTNO),        

                   @TRANS_AMOUNT = Sum(CONVERT(DECIMAL(14, 2), TRANACTIONAMT))        

            FROM   MSAJAG.DBO.NSENRIDETAIL        

            WHERE  PARTY_CODE = @PARTYCODE        

                   AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

                   AND TRANSACTION_TYPE = @SELL_BUY        

            GROUP  BY PARTY_CODE,        

                      Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', ''),        

                      CONTRACTNO        

        

            SELECT @CALCULATION = CONVERT(DECIMAL(14, 2), @TRANS_AMOUNT) + CONVERT(DECIMAL(14, 2), SERVICE_TAX) + CONVERT(DECIMAL(14, 2), EDUCESS) + CONVERT(DECIMAL(14, 2), EXCHAGE_LEVIES) + CONVERT(DECIMAL(14, 2), STT) +     

            CONVERT(DECIMAL(14, 2), STAMPDUTY) + CONVERT(DECIMAL(14, 2), MINBROKERAGE) + CONVERT(DECIMAL(14, 2), OTHER_CHARGES)        

            FROM   #NSE_HEADER WITH (NOLOCK)        

            WHERE  PARTY_CODE = @PARTYCODE        

                   AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

                   AND SELL_BUY = @TYPE        

        

            SELECT @HEADER_TOTALAMT = Sum(CONVERT(DECIMAL(14, 2), TOTALAMT))        

            FROM   #NSE_HEADER        

            WHERE  PARTY_CODE = @PARTYCODE        

                   AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

                   AND SELL_BUY = @TYPE        

            GROUP  BY PARTY_CODE        

        

 SELECT @diffamt = Round(@HEADER_TOTALAMT, 2) - Round(@calculation, 2)        

        

            INSERT INTO #TEMP1    

                 SELECT 'H' + '|' + Ltrim(Rtrim(PARTY_CODE)) + '|' + Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', '') + '|' + CONVERT(VARCHAR, CONTRACTNO) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(SERVICE_TAX, 0)))) + '|'    

                 + '0.00' + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(EXCHAGE_LEVIES, 0)))) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(STT, 0)))) + '|' +     

                 CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(STAMPDUTY, 0)))) + '|'    

      +  CASE   WHEN @diffamt BETWEEN -0.03 AND 0.03 THEN CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), ( Sum(CONVERT(DECIMAL(14, 2), Isnull(MINBROKERAGE, 0)) + CONVERT(DECIMAL(14, 2), Isnull(OTHER_CHARGES, 0))) + @diffamt )))    

          ELSE CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), ( Sum(Isnull(MINBROKERAGE, 0) + Isnull(OTHER_CHARGES, 0)) )))    

          END + '|' + CONVERT(VARCHAR, @TRANCNT) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), ( Sum(TOTALAMT) )))    

            FROM   #NSE_HEADER WITH (NOLOCK)        

            WHERE  SAUDA_DATE = @SDATE        

                   AND PARTY_CODE = @PARTYCODE        

                   AND SELL_BUY = @TYPE        

            GROUP  BY PARTY_CODE,        

                      CONTRACTNO,        

                      Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', '')        

        

            INSERT INTO #TEMP1        

            SELECT 'T' + '|' + Ltrim(Rtrim(PARTY_CODE)) + '|' + Ltrim(Rtrim(CONTRACTNO)) + '|' + CASE        

                                                                                                   WHEN @TYPE = 1 THEN 'P'        

                                                                                                   WHEN @TYPE = 2 THEN 'S'        

                                                                                                 END + '|' + Ltrim(Rtrim(Isnull(ISIN, ''))) + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, QTY))) + '|'

 + Ltrim(Rtrim(CONVERT(VARCHAR, CONVERT(DEC(15, 2), RATE)))) 

 + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, CONVERT(DEC(10, 2), BROK_PERSCRIP)))) + '|' + Ltrim(Rtrim(CONVERT(DEC(10, 2), TRANACTIONAMT)))        

            FROM   MSAJAG.DBO.NSENRIDETAIL X WITH (NOLOCK)           

            WHERE  X.PARTY_CODE = @PARTYCODE        

                   AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE        

                   AND Transaction_type = @SELL_BUY        

        END        

        

      SET @CNT=@CNT - 1        

  END        

        

SELECT *        

FROM   #TEMP1        

        

SET NOCOUNT OFF        

          

  END

GO
