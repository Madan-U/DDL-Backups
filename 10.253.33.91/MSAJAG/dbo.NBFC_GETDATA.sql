-- Object: PROCEDURE dbo.NBFC_GETDATA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[NBFC_GETDATA] (@SAUDA_DATE VARCHAR(11))
AS
  
IF EXISTS (SELECT TOP 1 1 
           FROM   SETTLEMENT S
           WHERE  SAUDA_DATE LIKE @SAUDA_DATE + '%'
                  AND BILLFLAG > 3       
                  AND TRADEQTY > 0      
                  AND MARKETRATE > 0    
                  AND SERIES IN ('EQ','BE')    
                  AND NOT EXISTS (SELECT N.SCRIP_CD       
                                  FROM   NODEL N      
                                  WHERE  S.SCRIP_CD = N.SCRIP_CD      
                                         AND S.SERIES = N.SERIES      
                                         AND S.SAUDA_DATE BETWEEN N.START_DATE AND N.END_DATE      
                                         AND S.SETT_TYPE = N.SETT_TYPE)) 
BEGIN 
  SELECT CONTRACTNO,      
         BILLNO,      
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
         BILLFLAG,      
         SETT_NO,      
         NBROKAPP,      
         NSERTAX,      
         N_NETRATE,      
         SETT_TYPE,      
         PARTIPANTCODE,      
         STATUS = 'N',      
         PRO_CLI,      
         CPID,      
         INSTRUMENT,      
         BOOKTYPE,      
         BRANCH_ID,      
         TMARK,      
         SCHEME,      
         DUMMY1,      
         FUNDING_DATE = CONVERT(VARCHAR,SAUDA_DATE,112)      
  FROM   SETTLEMENT S WITH(NOLOCK)      
  WHERE  SAUDA_DATE LIKE @SAUDA_DATE + '%'      
         AND BILLFLAG > 3       
         AND TRADEQTY > 0      
         AND MARKETRATE > 0    
         AND SERIES IN ('EQ','BE')    
         AND NOT EXISTS (SELECT N.SCRIP_CD       
                         FROM   NODEL N      
                         WHERE  S.SCRIP_CD = N.SCRIP_CD      
                                AND S.SERIES = N.SERIES      
                                AND S.SAUDA_DATE BETWEEN N.START_DATE AND N.END_DATE      
                                AND S.SETT_TYPE = N.SETT_TYPE)
END
ELSE
BEGIN 
  SELECT CONTRACTNO,      
         BILLNO,      
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
         BILLFLAG,      
         SETT_NO,      
         NBROKAPP,      
         NSERTAX,      
         N_NETRATE,      
         SETT_TYPE,      
         PARTIPANTCODE,      
         STATUS = 'N',      
         PRO_CLI,      
         CPID,      
         INSTRUMENT,      
         BOOKTYPE,      
         BRANCH_ID,      
         TMARK,      
         SCHEME,      
         DUMMY1,      
         FUNDING_DATE = CONVERT(VARCHAR,SAUDA_DATE,112)      
  FROM   HISTORY S WITH(NOLOCK)      
  WHERE  SAUDA_DATE LIKE @SAUDA_DATE + '%'      
         AND BILLFLAG > 3       
         AND TRADEQTY > 0      
         AND MARKETRATE > 0    
         AND SERIES IN ('EQ','BE')    
         AND NOT EXISTS (SELECT N.SCRIP_CD       
                         FROM   NODEL N      
                         WHERE  S.SCRIP_CD = N.SCRIP_CD      
                                AND S.SERIES = N.SERIES      
                                AND S.SAUDA_DATE BETWEEN N.START_DATE AND N.END_DATE      
                                AND S.SETT_TYPE = N.SETT_TYPE)
END

GO
