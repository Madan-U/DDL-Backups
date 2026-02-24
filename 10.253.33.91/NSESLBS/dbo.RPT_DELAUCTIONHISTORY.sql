-- Object: PROCEDURE dbo.RPT_DELAUCTIONHISTORY
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC RPT_DELAUCTIONHISTORY 
(  
      @STATUSID VARCHAR(15), 
      @STATUSNAME VARCHAR(25), 
      @SETT_NO VARCHAR(7), 
      @SETT_TYPE VARCHAR(2), 
      @FPARTY_CD VARCHAR(10), 
      @TPARTY_CD VARCHAR(10)
) 

AS  

SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

      SELECT C2.PARTY_CODE, 
            C1.LONG_NAME, 
            C1.L_ADDRESS1,
            C1.L_ADDRESS2,
            C1.L_ADDRESS3, 
            C1.L_CITY,
            C1.L_ZIP, 
            C1.L_STATE, 
            C1.BRANCH_CD ,
            C1.SUB_BROKER,
            C2.SERVICE_CHRG,
            BROKERNOTE, 
            TURNOVER_TAX, 
            SEBI_TURN_TAX, 
            C2.OTHER_CHRG, 
            INSURANCE_CHRG
      INTO #CLIENTMASTER 
      FROM MSAJAG.DBO.CLIENT2 C2 WITH(NOLOCK), 
            MSAJAG.DBO.CLIENT1 C1 WITH(NOLOCK) 
      WHERE C1.CL_CODE = C2.CL_CODE 
            AND C2.PARTY_CODE >= @FPARTY_CD 
            AND C2.PARTY_CODE <= @TPARTY_CD 
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


      SELECT 
            S.SETT_NO, 
            S.SETT_TYPE,
            PAYIN=CONVERT(VARCHAR,START_DATE,103), 
            PAYOUT=CONVERT(VARCHAR,END_DATE,103),
            A.PARTY_CODE,
            C2.LONG_NAME,
            C2.L_ADDRESS1,
            C2.L_ADDRESS2,
            C2.L_ADDRESS3,
            L_CITY, 
            L_STATE,
            L_ZIP,
            BILLNO,
            SCRIPNAME=SCRIP_CD,
            QTY=SUM(TRADEQTY), 
            AMOUNT=SUM(TRADEQTY*N_NETRATE)+SUM(
                  CASE 
                        WHEN SERVICE_CHRG = 1 
                        THEN NSERTAX 
                        ELSE 0 
                  END
                  )+SUM(
                  CASE 
                        WHEN AUCTIONPART LIKE 'F%' 
                        THEN A.OTHER_CHRG 
                        ELSE 0 
                  END
                  ), 
            MARKETRATE=ROUND((SUM(TRADEQTY*N_NETRATE)+SUM(
                  CASE 
                        WHEN SERVICE_CHRG = 1 
                        THEN NSERTAX 
                        ELSE 0 
                  END
                  ) +SUM(
                  CASE 
                        WHEN AUCTIONPART LIKE 'F%' 
                        THEN A.OTHER_CHRG 
                        ELSE 0 
                  END
                  ))/SUM(TRADEQTY),4), 
            SELL_BUY,
            SERVICE_TAX=SUM(
                  CASE 
                        WHEN SERVICE_CHRG = 0 
                        THEN NSERTAX 
                        ELSE 0 
                  END
                  ), 
            INS_CHRG = SUM(
                  CASE 
                        WHEN C2.INSURANCE_CHRG = 1 
                        THEN INS_CHRG 
                        ELSE 0 
                  END
                  ), 
            TURN_TAX = SUM(
                  CASE 
                        WHEN TURNOVER_TAX = 1 
                        THEN TURN_TAX 
                        ELSE 0 
                  END
                  ), 
            OTHER_CHRG = SUM(
                  CASE 
                        WHEN C2.OTHER_CHRG = 1 
                        THEN (
                        CASE 
                              WHEN AUCTIONPART NOT LIKE 'F%' 
                              THEN A.OTHER_CHRG 
                              ELSE 0 
                        END
                        ) 
                        ELSE 0 
                  END
                  ), 
            SABI_TAX = SUM(
                  CASE 
                        WHEN SEBI_TURN_TAX = 1 
                        THEN SEBI_TAX 
                        ELSE 0 
                  END
                  ), 
            BROKER_CHRG = 0, 
            SAUDADATE=CONVERT(VARCHAR,START_DATE,103) 
      FROM #CLIENTMASTER C2 WITH(NOLOCK), 
            MSAJAG.DBO.HISTORY A WITH(NOLOCK), 
            MSAJAG.DBO.SETT_MST S WITH(NOLOCK) 
      WHERE S.SETT_NO = A.SETT_NO 
            AND S.SETT_TYPE = A.SETT_TYPE 
            AND C2.PARTY_CODE = A.PARTY_CODE 
            AND MARKETRATE > 0 
            AND TRADEQTY > 0 
            AND A.SETT_NO = @SETT_NO 
            AND A.SETT_TYPE = @SETT_TYPE 
            AND A.PARTY_CODE >= @FPARTY_CD 
            AND A.PARTY_CODE <= @TPARTY_CD 
            AND AUCTIONPART NOT LIKE 'A%' 
      GROUP BY S.SETT_NO, 
            S.SETT_TYPE,
            START_DATE,
            END_DATE,
            A.PARTY_CODE,
            C2.LONG_NAME,
            C2.L_ADDRESS1,
            C2.L_ADDRESS2, 
            C2.L_ADDRESS3,
            L_CITY,
            L_STATE,
            L_ZIP,
            BILLNO,
            SCRIP_CD,
            SELL_BUY 
      ORDER BY S.SETT_NO, 
            S.SETT_TYPE,
            A.PARTY_CODE,
            SCRIP_CD,
            SELL_BUY

GO
