-- Object: PROCEDURE dbo.CONTCUMBILL_SECTION_NSECM_HISTORY_COMMON
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





CREATE   PROC CONTCUMBILL_SECTION_NSECM_HISTORY_COMMON 
(
      @STATUSID VARCHAR(15), 
      @STATUSNAME VARCHAR(25), 
      @SAUDA_DATE VARCHAR(11), 
      @SETT_NO VARCHAR(7), 
      @SETT_TYPE VARCHAR(2), 
      @FROMPARTY_CODE VARCHAR(10), 
      @TOPARTY_CODE VARCHAR(10), 
      @BRANCH VARCHAR(10), 
      @SUB_BROKER VARCHAR(10),
      @CONTFLAG VARCHAR(10)
)

AS

SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

/*=========================================================================
      /*FOR THE HISTORY*/ 
=========================================================================*/
      SELECT C2.PARTY_CODE, 
            C1.LONG_NAME, 
            C1.L_ADDRESS1, 
            C1.L_ADDRESS2, 
            C1.L_ADDRESS3, 
            C1.L_CITY, 
            C1.L_ZIP, 
            C1.BRANCH_CD , 
            C1.SUB_BROKER, 
            C1.TRADER, 
            C1.PAN_GIR_NO, 
            C1.OFF_PHONE1, 
            C1.OFF_PHONE2, 
            PRINTF, 
            MAPIDID, 
            C2.SERVICE_CHRG, 
            BROKERNOTE, 
            TURNOVER_TAX, 
            SEBI_TURN_TAX, 
            C2.OTHER_CHRG, 
            INSURANCE_CHRG 
      INTO #CLIENTMASTER 
      FROM CLIENT1 C1 WITH(NOLOCK), 
            CLIENT2 C2 WITH(NOLOCK) 
            LEFT OUTER JOIN 
            UCC_CLIENT UC WITH(NOLOCK) 
            ON C2.PARTY_CODE = UC.PARTY_CODE 
      WHERE C2.CL_CODE = C1.CL_CODE 
            AND C2.PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE 
             AND @STATUSNAME = 
                  (CASE 
                        WHEN @STATUSID = 'BRANCH' THEN C1.BRANCH_CD
                        WHEN @STATUSID = 'SUBBROKER' THEN C1.SUB_BROKER
                        WHEN @STATUSID = 'TRADER' THEN C1.TRADER
                        WHEN @STATUSID = 'FAMILY' THEN C1.FAMILY
                        WHEN @STATUSID = 'AREA' THEN C1.AREA
                        WHEN @STATUSID = 'REGION' THEN C1.REGION
                        WHEN @STATUSID = 'CLIENT' THEN C2.PARTY_CODE
                  ELSE 
                        'BROKER'
                  END)
            AND BRANCH_CD LIKE @BRANCH 
            AND SUB_BROKER LIKE @SUB_BROKER 



      SELECT 
            CONTRACTNO, 
            S.PARTY_CODE, 
            ORDER_NO,
            ORDER_TIME=' ', 
            TM=CONVERT(VARCHAR,SAUDA_DATE,108), 
            TRADE_NO, 
            SAUDA_DATE, 
            S.SCRIP_CD, 
            S.SERIES, 
            SCRIPNAME =  (
                  CASE 
                        WHEN LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11) = @SAUDA_DATE 
                        THEN ' ' 
                        ELSE 'BF-' 
                  END
                  ) + S1.SHORT_NAME , 
            SDT = CONVERT(VARCHAR,SAUDA_DATE,103), 
            SELL_BUY, 
            S.MARKETTYPE, 
            BROKER_CHRG =(
                  CASE 
                        WHEN BROKERNOTE = 1 
                        THEN BROKER_CHRG 
                        ELSE 0 
                  END 
                  ), 
            TURN_TAX =(
                  CASE 
                        WHEN TURNOVER_TAX = 1 
                        THEN TURN_TAX 
                        ELSE 0 
                  END
                  ), 
            SEBI_TAX =(
                  CASE 
                        WHEN SEBI_TURN_TAX = 1 
                        THEN SEBI_TAX 
                        ELSE 0 
                  END
                  ), 
            OTHER_CHRG =(
                  CASE 
                        WHEN C1.OTHER_CHRG = 1 
                        THEN S.OTHER_CHRG 
                        ELSE 0 
                  END
                  ) , 
            INS_CHRG = (
                  CASE 
                        WHEN INSURANCE_CHRG = 1 
                        THEN INS_CHRG 
                        ELSE 0 
                  END 
                  ), 
            SERVICE_TAX = (
                  CASE 
                        WHEN SERVICE_CHRG = 0 
                        THEN NSERTAX 
                        ELSE 0 
                  END 
                  ), 
            NSERTAX = (
                  CASE 
                        WHEN SERVICE_CHRG = 0 
                        THEN NSERTAX 
                        ELSE 0 
                  END 
                  ), 
            SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11), 
            PQTY = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN TRADEQTY 
                        ELSE 0 
                  END
                  ), 
            SQTY = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN TRADEQTY 
                        ELSE 0 
                  END
                  ), 
            PRATE = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN MARKETRATE 
                        ELSE 0 
                  END
                  ), 
            SRATE = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN MARKETRATE 
                        ELSE 0 
                  END
                  ), 
            PBROK = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN NBROKAPP + (
                        CASE 
                              WHEN SERVICE_CHRG = 1 
                              THEN NSERTAX/TRADEQTY 
                              ELSE 0 
                        END
                        ) 
                        ELSE 0 
                  END
                  ), 
            SBROK = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN NBROKAPP + (
                        CASE 
                              WHEN SERVICE_CHRG = 1 
                              THEN NSERTAX/TRADEQTY 
                              ELSE 0 
                        END
                        ) 
                        ELSE 0 
                  END
                  ), 
            PNETRATE = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN N_NETRATE + (
                        CASE 
                              WHEN SERVICE_CHRG = 1 
                              THEN NSERTAX/TRADEQTY 
                              ELSE 0 
                        END
                        ) 
                        ELSE 0 
                  END
                  ), 
            SNETRATE = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN N_NETRATE - (
                        CASE 
                              WHEN SERVICE_CHRG = 1 
                              THEN NSERTAX/TRADEQTY 
                              ELSE 0 
                        END
                        ) 
                        ELSE 0 
                  END
                  ), 
            PAMT = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN TRADEQTY*(N_NETRATE + (
                        CASE 
                              WHEN SERVICE_CHRG = 1 
                              THEN NSERTAX/TRADEQTY 
                              ELSE 0 
                        END
                        )) 
                        ELSE 0 
                  END
                  ), 
            SAMT = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN TRADEQTY*(N_NETRATE - (
                        CASE 
                              WHEN SERVICE_CHRG = 1 
                              THEN NSERTAX/TRADEQTY 
                              ELSE 0 
                        END
                        )) 
                        ELSE 0 
                  END
                  ), 
            BROKERAGE = TRADEQTY*NBROKAPP+(
                  CASE 
                        WHEN SERVICE_CHRG = 1 
                        THEN NSERTAX 
                        ELSE 0 
                  END
                  ), 
            S.SETT_NO, 
            S.SETT_TYPE, 
            TRADETYPE = '  ', 
            TMARK = 
                  CASE 
                        WHEN BILLFLAG = 1 
                        OR BILLFLAG = 4 
                        OR BILLFLAG = 5 
                        THEN 'D' 
                        ELSE '' 
                  END 
                  , 
            /*TO DISPLAY THE HEADER PART*/ 
            PARTYNAME = C1.LONG_NAME, 
            C1.L_ADDRESS1,
            C1.L_ADDRESS2,
            C1.L_ADDRESS3, 
            C1.L_CITY,
            C1.L_ZIP, 
            C1.SERVICE_CHRG,
            C1.BRANCH_CD ,
            C1.SUB_BROKER,
            C1.TRADER, 
            C1.PAN_GIR_NO, 
            C1.OFF_PHONE1,
            C1.OFF_PHONE2,
            PRINTF,
            MAPIDID, 
            ORDERFLAG = 0, 
            SCRIPNAME1 = S1.SHORT_NAME 
      INTO #CONTSETT 
      FROM HISTORY S WITH(NOLOCK), 
            #CLIENTMASTER C1 WITH(NOLOCK),  
            SETT_MST M WITH(NOLOCK), 
            SCRIP1 S1 WITH(NOLOCK), 
            SCRIP2 S2 WITH(NOLOCK) 
      WHERE SAUDA_DATE <= @SAUDA_DATE + ' 23:59' 
            AND S.PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE 
            AND S.SETT_NO = @SETT_NO 
            AND S.SETT_TYPE = @SETT_TYPE 
            AND S.SETT_NO = M.SETT_NO 
            AND S.SETT_TYPE = M.SETT_TYPE 
            AND M.END_DATE LIKE @SAUDA_DATE + '%' 
            AND S1.CO_CODE = S2.CO_CODE 
            AND S2.SERIES = S1.SERIES 
            AND S2.SCRIP_CD = S.SCRIP_CD 
            AND S2.SERIES = S.SERIES 
            AND S.PARTY_CODE = C1.PARTY_CODE 
            AND S.TRADEQTY > 0 


/*=========================================================================
      /*FOR OTHER DAY EXCEPT THE LAST DAY OF THE HISTORY FOR NOT ONE DAY HISTORY RECORD */ 
=========================================================================*/
      INSERT 
      INTO #CONTSETT 
      SELECT 
            CONTRACTNO, 
            S.PARTY_CODE, 
            ORDER_NO,
	    ORDER_TIME=' ', 
            TM=CONVERT(VARCHAR,SAUDA_DATE,108), 
            TRADE_NO, 
            SAUDA_DATE, 
            S.SCRIP_CD, 
            S.SERIES, 
            SCRIPNAME = S1.SHORT_NAME + ' ', 
            SDT = CONVERT(VARCHAR,SAUDA_DATE,103), 
            SELL_BUY, 
            S.MARKETTYPE, 
            BROKER_CHRG =(
                  CASE 
                        WHEN BROKERNOTE = 1 
                        THEN BROKER_CHRG 
                        ELSE 0 
                  END 
                  ), 
            TURN_TAX =(
                  CASE 
                        WHEN TURNOVER_TAX = 1 
                        THEN TURN_TAX 
                        ELSE 0 
                  END
                  ), 
            SEBI_TAX =(
                  CASE 
                        WHEN SEBI_TURN_TAX = 1 
                        THEN SEBI_TAX 
                        ELSE 0 
                  END
                  ), 
            OTHER_CHRG =(
                  CASE 
                        WHEN C1.OTHER_CHRG = 1 
                        THEN S.OTHER_CHRG 
                        ELSE 0 
                  END
                  ) , 
            INS_CHRG = (
                  CASE 
                        WHEN INSURANCE_CHRG = 1 
                        THEN INS_CHRG 
                        ELSE 0 
                  END 
                  ), 
            SERVICE_TAX = (
                  CASE 
                        WHEN SERVICE_CHRG = 0 
                        THEN NSERTAX 
                        ELSE 0 
                  END 
                  ), 
            NSERTAX = (
                  CASE 
                        WHEN SERVICE_CHRG = 0 
                        THEN SERVICE_TAX 
                        ELSE 0 
                  END 
                  ), 
            SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11), 
            PQTY = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN TRADEQTY 
                        ELSE 0 
                  END
                  ), 
            SQTY = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN TRADEQTY 
                        ELSE 0 
                  END
                  ), 
            PRATE = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN MARKETRATE 
                        ELSE 0 
                  END
                  ), 
            SRATE = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN MARKETRATE 
                        ELSE 0 
                  END
                  ), 
            PBROK = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN BROKAPPLIED + (
                        CASE 
                              WHEN SERVICE_CHRG = 1 
                              THEN SERVICE_TAX/TRADEQTY 
                              ELSE 0 
                        END
                        ) 
                        ELSE 0 
                  END
                  ), 
            SBROK = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN BROKAPPLIED + (
                        CASE 
                              WHEN SERVICE_CHRG = 1 
                              THEN SERVICE_TAX/TRADEQTY 
                              ELSE 0 
                        END
                        ) 
                        ELSE 0 
                  END
                  ), 
            PNETRATE = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN NETRATE + (
                        CASE 
                              WHEN SERVICE_CHRG = 1 
                              THEN SERVICE_TAX/TRADEQTY 
                              ELSE 0 
                        END
                        ) 
                        ELSE 0 
                  END
                  ), 
            SNETRATE = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN NETRATE - (
                        CASE 
                              WHEN SERVICE_CHRG = 1 
                              THEN SERVICE_TAX/TRADEQTY 
                              ELSE 0 
                        END
                        ) 
                        ELSE 0 
                  END
                  ), 
            PAMT = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN TRADEQTY*(NETRATE + (
                        CASE 
                              WHEN SERVICE_CHRG = 1 
                              THEN SERVICE_TAX/TRADEQTY 
                              ELSE 0 
                        END
                        )) 
                        ELSE 0 
                  END
                  ), 
            SAMT = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN TRADEQTY*(NETRATE - (
                        CASE 
                              WHEN SERVICE_CHRG = 1 
                              THEN SERVICE_TAX/TRADEQTY 
                              ELSE 0 
                        END
                        )) 
                        ELSE 0 
                  END
                  ), 
            BROKERAGE = TRADEQTY*BROKAPPLIED+(
                  CASE 
                        WHEN SERVICE_CHRG = 1 
                        THEN SERVICE_TAX 
                        ELSE 0 
                  END
                  ), 
            S.SETT_NO, 
            S.SETT_TYPE, 
            TRADETYPE = '  ', 
            TMARK = 
                  CASE 
                        WHEN BILLFLAG = 1 
                        OR BILLFLAG = 4 
                        OR BILLFLAG = 5 
                        THEN 'D' 
                        ELSE '' 
                  END 
            , 
            /*TO DISPLAY THE HEADER PART*/ 
            PARTYNAME = C1.LONG_NAME, 
            C1.L_ADDRESS1,
            C1.L_ADDRESS2,
            C1.L_ADDRESS3, 
            C1.L_CITY,
            C1.L_ZIP, 
            C1.SERVICE_CHRG,
            C1.BRANCH_CD ,
            C1.SUB_BROKER,
            C1.TRADER, 
            C1.PAN_GIR_NO, 
            C1.OFF_PHONE1,
            C1.OFF_PHONE2 ,
            PRINTF,
            MAPIDID, 
            ORDERFLAG = 0, 
            SCRIPNAME1 = S1.SHORT_NAME 
      FROM HISTORY S WITH(NOLOCK), 
            #CLIENTMASTER C1 WITH(NOLOCK), 
            SETT_MST M WITH(NOLOCK), 
            SCRIP1 S1 WITH(NOLOCK), 
            SCRIP2 S2 WITH(NOLOCK) 
      WHERE SAUDA_DATE <= @SAUDA_DATE + ' 23:59' 
            AND S.PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE 
            AND S.SETT_NO = @SETT_NO 
            AND S.SETT_TYPE = @SETT_TYPE 
            AND S.SETT_NO = M.SETT_NO 
            AND S.SETT_TYPE = M.SETT_TYPE 
            AND M.END_DATE NOT LIKE @SAUDA_DATE + '%' 
            AND S1.CO_CODE = S2.CO_CODE 
            AND S2.SERIES = S1.SERIES 
            AND S2.SCRIP_CD = S.SCRIP_CD 
            AND S2.SERIES = S.SERIES 
            AND S.PARTY_CODE = C1.PARTY_CODE 
            AND S.TRADEQTY > 0 


/*=========================================================================
      /* ND RECORD BROUGHT FORWARD FOR SAME DAY OR PREVIOUS DAYS */ 
=========================================================================*/
      INSERT 
      INTO #CONTSETT 
      SELECT 
            CONTRACTNO, 
            S.PARTY_CODE, 
            ORDER_NO, 
            ORDER_TIME=' ',
            TM=CONVERT(VARCHAR,SAUDA_DATE,108), 
            TRADE_NO, 
            SAUDA_DATE, 
            S.SCRIP_CD, 
            S.SERIES, 
            SCRIPNAME = (
                  CASE 
                        WHEN LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11) = @SAUDA_DATE 
                        THEN 'ND-' 
                        ELSE 'BF-' 
                  END
                  ) + S1.SHORT_NAME, 
            SDT = CONVERT(VARCHAR,SAUDA_DATE,103), 
            SELL_BUY, 
            S.MARKETTYPE, 
            BROKER_CHRG =0, 
            TURN_TAX=0,
            SEBI_TAX=0,
            S.OTHER_CHRG,
            INS_CHRG =0,
            SERVICE_TAX = 0,
            NSERTAX=0, 
            SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11), 
            PQTY = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN TRADEQTY 
                        ELSE 0 
                  END
                  ), 
            SQTY = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN TRADEQTY 
                        ELSE 0 
                  END
                  ), 
            PRATE = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN MARKETRATE 
                        ELSE 0 
                  END
                  ), 
            SRATE = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN MARKETRATE 
                        ELSE 0 
                  END
                  ), 
            PBROK = 0, 
            SBROK = 0, 
            PNETRATE = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN MARKETRATE 
                        ELSE 0 
                  END
                  ), 
            SNETRATE = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN MARKETRATE 
                        ELSE 0 
                  END
                  ), 
            PAMT = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN TRADEQTY*MARKETRATE 
                        ELSE 0 
                  END
                  ), 
            SAMT = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN TRADEQTY*MARKETRATE 
                        ELSE 0 
                  END
                  ), 
            BROKERAGE = 0, 
            S.SETT_NO, 
            S.SETT_TYPE, 
            TRADETYPE = 'BF', 
            TMARK = 
                  CASE 
                        WHEN BILLFLAG = 1 
                        OR BILLFLAG = 4 
                        OR BILLFLAG = 5 
                        THEN '' 
                        ELSE '' 
                  END 
                  , 
            /*TO DISPLAY THE HEADER PART*/ 
            PARTYNAME = C1.LONG_NAME, 
            C1.L_ADDRESS1,
            C1.L_ADDRESS2,
            C1.L_ADDRESS3, 
            C1.L_CITY,
            C1.L_ZIP, 
            C1.SERVICE_CHRG,
            C1.BRANCH_CD ,
            C1.SUB_BROKER,
            C1.TRADER, 
            C1.PAN_GIR_NO, 
            C1.OFF_PHONE1,
            C1.OFF_PHONE2 ,
            PRINTF,
            MAPIDID,
            ORDERFLAG = 0, 
            SCRIPNAME1 = S1.SHORT_NAME 
      FROM HISTORY S WITH(NOLOCK), 
            #CLIENTMASTER C1 WITH(NOLOCK), 
            SETT_MST M WITH(NOLOCK), 
            SCRIP1 S1 WITH(NOLOCK), 
            SCRIP2 S2 WITH(NOLOCK)
      WHERE SAUDA_DATE <= @SAUDA_DATE + ' 23:59' 
            AND S.PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE 
            AND M.END_DATE > @SAUDA_DATE + ' 23:59:59' 
            AND S.SETT_TYPE = @SETT_TYPE 
            --AND S.SETT_NO > @SETT_NO AND S.SETT_TYPE = @SETT_TYPE 
            AND S.SETT_NO = M.SETT_NO 
            AND S.SETT_TYPE = M.SETT_TYPE 
            AND M.END_DATE NOT LIKE @SAUDA_DATE + '%' 
            AND S1.CO_CODE = S2.CO_CODE 
            AND S2.SERIES = S1.SERIES 
            AND S2.SCRIP_CD = S.SCRIP_CD 
            AND S2.SERIES = S.SERIES 
            AND S.PARTY_CODE = C1.PARTY_CODE 
            AND S.TRADEQTY > 0 


/*=========================================================================
      /* ND RECORD CARRY FORWARD FOR SAME DAY OR PREVIOUS DAYS */ 
=========================================================================*/
      INSERT 
      INTO #CONTSETT 
      SELECT 
            CONTRACTNO, 
            S.PARTY_CODE, 
            ORDER_NO, 
            ORDER_TIME=' ',
            TM=CONVERT(VARCHAR,SAUDA_DATE,108), 
            TRADE_NO, 
            SAUDA_DATE, 
            S.SCRIP_CD, 
            S.SERIES, 
            SCRIPNAME = 'CF-' + S1.SHORT_NAME, 
            SDT = CONVERT(VARCHAR,SAUDA_DATE,103), 
            SELL_BUY=(
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN 2 
                        ELSE 1 
                  END
                  ), 
            S.MARKETTYPE, 
            BROKER_CHRG =0, 
            TURN_TAX=0,
            SEBI_TAX=0,
            S.OTHER_CHRG,
            INS_CHRG = 0,
            SERVICE_TAX = 0,
            NSERTAX=0, 
            SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11), 
            PQTY = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN TRADEQTY 
                        ELSE 0 
                  END
                  ), 
            SQTY = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN TRADEQTY 
                        ELSE 0 
                  END
                  ), 
            PRATE = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN MARKETRATE 
                        ELSE 0 
                  END
                  ), 
            SRATE = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN MARKETRATE 
                        ELSE 0 
                  END
                  ), 
            PBROK = 0, 
            SBROK = 0, 
            PNETRATE = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN MARKETRATE 
                        ELSE 0 
                  END
                  ), 
            SNETRATE = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN MARKETRATE 
                        ELSE 0 
                  END
                  ), 
            PAMT = (
                  CASE 
                        WHEN SELL_BUY = 2 
                        THEN TRADEQTY*MARKETRATE 
                        ELSE 0 
                  END
                  ), 
            SAMT = (
                  CASE 
                        WHEN SELL_BUY = 1 
                        THEN TRADEQTY*MARKETRATE 
                        ELSE 0 
                  END
                  ), 
            BROKERAGE = 0, 
            S.SETT_NO, 
            S.SETT_TYPE, 
            TRADETYPE = 'CF', 
            TMARK = 
                  CASE 
                        WHEN BILLFLAG = 1 
                        OR BILLFLAG = 4 
                        OR BILLFLAG = 5 
                        THEN '' 
                        ELSE '' 
                  END 
                  , 
            /*TO DISPLAY THE HEADER PART*/ 
            PARTYNAME = C1.LONG_NAME, 
            C1.L_ADDRESS1,
            C1.L_ADDRESS2,
            C1.L_ADDRESS3, 
            C1.L_CITY,
            C1.L_ZIP, 
            C1.SERVICE_CHRG,
            C1.BRANCH_CD ,
            C1.SUB_BROKER,
            C1.TRADER, 
            C1.PAN_GIR_NO, 
            C1.OFF_PHONE1,
            C1.OFF_PHONE2 ,
            PRINTF,
            MAPIDID,
            ORDERFLAG = 1, 
            SCRIPNAME1 = S1.SHORT_NAME 
      FROM HISTORY S WITH(NOLOCK), 
            #CLIENTMASTER C1 WITH(NOLOCK), 
            SETT_MST M WITH(NOLOCK), 
            SCRIP1 S1 WITH(NOLOCK), 
            SCRIP2 S2 WITH(NOLOCK)
      WHERE SAUDA_DATE <= @SAUDA_DATE + ' 23:59' 
            AND S.PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE 
            AND M.END_DATE > @SAUDA_DATE + ' 23:59:59' 
            AND S.SETT_TYPE = @SETT_TYPE 
            --AND S.SETT_NO > @SETT_NO AND S.SETT_TYPE = @SETT_TYPE 
            AND S.SETT_NO = M.SETT_NO 
            AND S.SETT_TYPE = M.SETT_TYPE 
            AND M.END_DATE NOT LIKE @SAUDA_DATE + '%' 
            AND S1.CO_CODE = S2.CO_CODE 
            AND S2.SERIES = S1.SERIES 
            AND S2.SCRIP_CD = S.SCRIP_CD 
            AND S2.SERIES = S.SERIES 
            AND S.PARTY_CODE = C1.PARTY_CODE 
            AND S.TRADEQTY > 0 



      SELECT 
            CONTRACTNO,
            PARTY_CODE,
            ORDER_NO='0000000000000000',
 	    ORDER_TIME=' ',
            TM='        ',
            TRADE_NO='00000000000', 
            SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),
            SCRIP_CD,
            SERIES,
            SCRIPNAME,
            SDT, 
            SELL_BUY,
            MARKETTYPE,
            BROKER_CHRG=SUM(BROKER_CHRG),
            TURN_TAX=SUM(TURN_TAX),
            SEBI_TAX=SUM(SEBI_TAX), 
            OTHER_CHRG=SUM(OTHER_CHRG),
            INS_CHRG = SUM(INS_CHRG),
            SERVICE_TAX = SUM(SERVICE_TAX),
            NSERTAX=SUM(NSERTAX),
            SAUDA_DATE1, 
            PQTY=SUM(PQTY),
            SQTY=SUM(SQTY), 
            PRATE=(
                  CASE 
                        WHEN SUM(PQTY) > 0 
                        THEN SUM(PRATE*PQTY)/SUM(PQTY) 
                        ELSE 0 
                  END
                  ), 
            SRATE=(
                  CASE 
                        WHEN SUM(SQTY) > 0 
                        THEN SUM(SRATE*SQTY)/SUM(SQTY) 
                        ELSE 0 
                  END
                  ), 
            PBROK=(
                  CASE 
                        WHEN SUM(PQTY) > 0 
                        THEN SUM(PBROK*PQTY)/SUM(PQTY) 
                        ELSE 0 
                  END
                  ), 
            SBROK=(
                  CASE 
                        WHEN SUM(SQTY) > 0 
                        THEN SUM(SBROK*SQTY)/SUM(SQTY) 
                        ELSE 0 
                  END
                  ), 
            PNETRATE=(
                  CASE 
                        WHEN SUM(PQTY) > 0 
                        THEN SUM(PNETRATE*PQTY)/SUM(PQTY) 
                        ELSE 0 
                  END
                  ), 
            SNETRATE=(
                  CASE 
                        WHEN SUM(SQTY) > 0 
                        THEN SUM(SNETRATE*SQTY)/SUM(SQTY) 
                        ELSE 0 
                  END
                  ), 
            PAMT=SUM(PAMT),
            SAMT=SUM(SAMT),
            BROKERAGE=SUM(BROKERAGE),
            SETT_NO,
            SETT_TYPE,
            TRADETYPE,
            TMARK,
            PARTYNAME, 
            L_ADDRESS1,
            L_ADDRESS2,
            L_ADDRESS3,
            L_CITY,
            L_ZIP,
            SERVICE_CHRG,
            BRANCH_CD,
            SUB_BROKER,
            TRADER, 
            PAN_GIR_NO,
            OFF_PHONE1,
            OFF_PHONE2,
            PRINTF,
            MAPIDID,
            ORDERFLAG, 
            SCRIPNAME1 
      INTO #CONTSETTNEW 
      FROM #CONTSETT WITH(NOLOCK) 
      WHERE PRINTF = '3' 
      GROUP BY CONTRACTNO,
            PARTY_CODE,
            LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),
            SCRIP_CD,
            SERIES,
            SCRIPNAME,
            SDT, 
            SELL_BUY,
            MARKETTYPE,
            SETT_NO,
            SETT_TYPE,
            SAUDA_DATE1,
            TRADETYPE,
            TMARK,
            PARTYNAME,
            L_ADDRESS1,
            L_ADDRESS2,
            L_ADDRESS3, 
            L_CITY,
            L_ZIP,
            SERVICE_CHRG,
            BRANCH_CD,
            SUB_BROKER,
            TRADER, 
            PAN_GIR_NO,
            OFF_PHONE1,
            OFF_PHONE2,
            PRINTF,
            MAPIDID, 
            ORDERFLAG,
            SCRIPNAME1 


      INSERT 
      INTO #CONTSETTNEW 
      SELECT 
            * 
      FROM #CONTSETT WITH(NOLOCK) 
      WHERE PRINTF <> '3' 


      UPDATE 
            #CONTSETTNEW 
            SET ORDER_NO = S.ORDER_NO, 
            TM = CONVERT(VARCHAR,S.SAUDA_DATE,108), 
            TRADE_NO = S.TRADE_NO 
      FROM #CONTSETT S WITH(NOLOCK) 
      WHERE S.PRINTF = #CONTSETTNEW.PRINTF 
            AND S.PRINTF = '3' 
            AND S.SAUDA_DATE LIKE @SAUDA_DATE + '%' 
            AND S.SCRIP_CD = #CONTSETTNEW.SCRIP_CD 
            AND S.SERIES = #CONTSETTNEW.SERIES 
            AND S.PARTY_CODE = #CONTSETTNEW.PARTY_CODE 
            AND S.CONTRACTNO = #CONTSETTNEW.CONTRACTNO 
            AND S.SELL_BUY = #CONTSETTNEW.SELL_BUY 
            AND S.SAUDA_DATE = 
                  (
                        SELECT 
                              MIN(SAUDA_DATE) 
                        FROM #CONTSETT ISETT WITH(NOLOCK) 
                        WHERE PRINTF = '3' 
                              AND ISETT.SAUDA_DATE LIKE @SAUDA_DATE + '%' 
                              AND S.SCRIP_CD = ISETT.SCRIP_CD 
                              AND S.SERIES = ISETT.SERIES 
                              AND S.PARTY_CODE = ISETT.PARTY_CODE 
                              AND S.CONTRACTNO = ISETT.CONTRACTNO 
                              AND S.SELL_BUY = ISETT.SELL_BUY 
                  ) 


IF (@CONTFLAG = 'CONTRACT')
	BEGIN
	      SELECT 
	            * 
	      FROM #CONTSETTNEW WITH(NOLOCK) 
	      WHERE PRINTF <> 1
	      ORDER BY
			BRANCH_CD,
			SUB_BROKER,
			TRADER,
			PARTY_CODE,
			PARTYNAME,
			SCRIPNAME1,
			ORDERFLAG,
			SETT_NO, 
			SETT_TYPE, 
			ORDER_NO, 
			TRADE_NO 
	END		
ELSE
	BEGIN
	      SELECT 
	            * 
	      FROM #CONTSETTNEW WITH(NOLOCK) 
	      ORDER BY
			BRANCH_CD,
			SUB_BROKER,
			TRADER,
			PARTY_CODE,
			PARTYNAME,
			SCRIPNAME1,
			ORDERFLAG,
			SETT_NO, 
			SETT_TYPE, 
			ORDER_NO, 
			TRADE_NO 
	END

GO
