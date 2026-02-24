-- Object: PROCEDURE dbo.InsDelPayIn
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC INSDELPAYIN 
(
      @STATUSID VARCHAR(25), 
      @STATUSNAME VARCHAR(25), 
      @SETT_NO VARCHAR(11), 
      @SETT_TYPE VARCHAR(11), 
      @FPARTY_CD VARCHAR(10), 
      @TPARTY_CD VARCHAR(10)
) 

AS

SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

      SELECT 
            PARTY_CODE,
            LONG_NAME
      INTO #CLIENTMASTER 
      FROM CLIENT2 C2 WITH(NOLOCK), 
            CLIENT1 C1 WITH(NOLOCK) 
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
            D.SETT_NO,
            D.SETT_TYPE,
            D.PARTY_CODE,
            LONG_NAME,
            ISIN=CERTNO,
            SCRIP_CD,
            QTY=SUM(QTY), 
            CLTDPID = CLTDPID,
            DPID = D.DPID,
            ISETT_NO,
            ISETT_TYPE, 
            TRANSDATE=LEFT(CONVERT(VARCHAR,TRANSDATE,109),11),
            EXCHG='NSE', 
            REMARK=(
                  CASE 
                        WHEN TRTYPE = 907 
                        THEN 'INTER SETTLEMENT FROM ' + CLTDPID 
                        ELSE 'RECEIVED' 
                  END
                  ) 
      FROM DELTRANS D WITH(NOLOCK), 
            #CLIENTMASTER C2 WITH(NOLOCK) 
      WHERE D.SETT_NO = @SETT_NO 
            AND D.SETT_TYPE = @SETT_TYPE 
            AND DRCR = 'C' 
            AND FILLER2 = 1 
            AND D.PARTY_CODE >= @FPARTY_CD 
            AND D.PARTY_CODE <= @TPARTY_CD 
            AND SHARETYPE <> 'AUCTION' 
            AND C2.PARTY_CODE = D.PARTY_CODE 
      GROUP BY D.SETT_NO,
            D.SETT_TYPE,
            D.PARTY_CODE,
            LONG_NAME,
            CERTNO,
            SCRIP_CD,
            CLTDPID,
            D.DPID,
            ISETT_NO,
            ISETT_TYPE, 
            D.SETT_NO,
            TRANSDATE,
            DELIVERED,
            TRTYPE 

      UNION ALL 

      SELECT 
            D.SETT_NO,
            D.SETT_TYPE,
            D.PARTY_CODE,
            C2.LONG_NAME,
            ISIN=' ',
            D.SCRIP_CD,
            QTY=D.QTY-SUM((
                  CASE 
                        WHEN DRCR = 'C' 
                        THEN ISNULL(DE.QTY,0) 
                        ELSE -ISNULL(DE.QTY,0) 
                  END
                  )), 
            CLTDPID=' ', 
            DPID = ' ', 
            ISETT_NO=' ',
            ISETT_TYPE=' ',
            TRANSDATE=LEFT(CONVERT(VARCHAR,SEC_PAYIN,109),11),
            EXCHG='NSE', 
            REMARK='PAYIN SHORTAGE' 
      FROM SETT_MST S WITH(NOLOCK),
            #CLIENTMASTER C2 WITH(NOLOCK),
            DELIVERYCLT D WITH(NOLOCK) 
            LEFT OUTER JOIN 
            DELTRANS DE WITH(NOLOCK) 
            ON 
            ( 
                  DE.SETT_NO = D.SETT_NO 
                  AND DE.SETT_TYPE = D.SETT_TYPE 
                  AND DE.SCRIP_CD = D.SCRIP_CD 
                  AND DE.SERIES = D.SERIES 
                  AND DE.PARTY_CODE = D.PARTY_CODE 
                  AND FILLER2 = 1 
                  AND SHARETYPE <> 'AUCTION'
            ) 
      WHERE D.INOUT = 'I' 
            AND D.QTY > 0 
            AND D.PARTY_CODE = C2.PARTY_CODE 
            AND D.SETT_NO = S.SETT_NO 
            AND D.SETT_TYPE = S.SETT_TYPE 
            AND D.SETT_NO = @SETT_NO 
            AND D.SETT_TYPE = @SETT_TYPE 
            AND D.PARTY_CODE >= @FPARTY_CD 
            AND D.PARTY_CODE <= @TPARTY_CD 
      GROUP BY D.SETT_NO,
            D.SETT_TYPE,
            D.PARTY_CODE,
            C2.LONG_NAME,
            D.SCRIP_CD,
            D.SERIES,
            D.QTY,
            SEC_PAYIN 
      HAVING D.QTY <> SUM((
            CASE 
                  WHEN DRCR = 'C' 
                  THEN ISNULL(DE.QTY,0) 
                  ELSE -ISNULL(DE.QTY,0) 
            END
            )) 
      ORDER BY D.PARTY_CODE,
            EXCHG,
            CERTNO,
            D.SETT_NO,
            D.SETT_TYPE,
            LEFT(CONVERT(VARCHAR,TRANSDATE,109),11)

GO
