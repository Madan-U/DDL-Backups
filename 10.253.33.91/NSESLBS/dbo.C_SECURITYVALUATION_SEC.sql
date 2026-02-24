-- Object: PROCEDURE dbo.C_SECURITYVALUATION_SEC
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROC C_SECURITYVALUATION_SEC(
           @EXCHANGE VARCHAR(3),
           @SEGMENT  VARCHAR(7),
           @SHAREDB  VARCHAR(20),
           @VALDATE  VARCHAR(11))
AS

  DELETE FROM C_VALUATION
  WHERE       SYSDATE LIKE @VALDATE + '%'
              AND EXCHANGE = @EXCHANGE
              AND SEGMENT = @SEGMENT
                            
/*=============================================================================
GET LATEST CLOSING
=============================================================================*/
  SELECT EXCHANGE = 2,
         *
  INTO   #TEMPCLOSING
  FROM   (SELECT I.ISIN,
                 C1.SCRIP_CD,
                 C1.SERIES,
                 CL_RATE = ISNULL(C1.CL_RATE,0),
                 C1.SYSDATE
          FROM   BSEDB.DBO.CLOSING C1 WITH (nolock),
                 BSEDB.DBO.MULTIISIN I WITH (nolock)
          WHERE  SYSDATE = (SELECT MAX(SYSDATE)
                            FROM   BSEDB.DBO.CLOSING C2 WITH (nolock)
                            WHERE  SYSDATE <= @VALDATE + ' 23:59:59'
                                   AND C1.SCRIP_CD = C2.SCRIP_CD
                                   AND C1.SERIES = C2.SERIES)
                 AND C1.SCRIP_CD = I.SCRIP_CD
                 AND C1.SERIES = I.SERIES) V
         
  INSERT INTO #TEMPCLOSING
  SELECT EXCHANGE = 1,
         *
  FROM   (SELECT I.ISIN,
                 C1.SCRIP_CD,
                 C1.SERIES,
                 CL_RATE = ISNULL(C1.CL_RATE,0),
                 C1.SYSDATE
          FROM   MSAJAG.DBO.CLOSING C1 WITH (nolock),
                 MSAJAG.DBO.MULTIISIN I WITH (nolock)
          WHERE  SYSDATE = (SELECT MAX(SYSDATE)
                            FROM   MSAJAG.DBO.CLOSING C2 WITH (nolock)
                            WHERE  SYSDATE <= @VALDATE + ' 23:59:59'
                                   AND C1.SCRIP_CD = C2.SCRIP_CD
                                   AND C1.SERIES = C2.SERIES)
                 AND C1.SCRIP_CD = I.SCRIP_CD
                 AND C1.SERIES = I.SERIES) V
         
  SELECT   F.ISIN,
           CL_RATE = MIN(F.CL_RATE),
           SYSDATE = LEFT(F.SYSDATE,11)
  INTO     #LATESTCLOSING
  FROM     #TEMPCLOSING F,
           (SELECT   EXCHANGE = MIN(EXCHANGE),
                     ISIN,
                     SYSDATE
            FROM     #TEMPCLOSING C
            WHERE    SYSDATE = (SELECT MAX(SYSDATE)
                                FROM   #TEMPCLOSING C1
                                WHERE  C.ISIN = C1.ISIN)
            GROUP BY ISIN,SYSDATE) F1
  WHERE    F.EXCHANGE = F1.EXCHANGE
           AND F.SYSDATE = F1.SYSDATE
           AND F.ISIN = F1.ISIN
  GROUP BY F.ISIN,LEFT(F.SYSDATE,11)
/*=============================================================================
GET LATEST CLOSING
=============================================================================*/

  SELECT PARTY_CODE,
         SCRIP_CD,
         SERIES,
         CRQTY = SUM(CASE 
                       WHEN DRCR = 'C' THEN QTY
                       ELSE -QTY
                     END),
         S.ISIN,
         CL_RATE = ISNULL(C.CL_RATE,0),
         FLAG = (CASE 
                   WHEN ISNULL(C.SYSDATE,'JAN  1 1900') = @VALDATE THEN 1
                   ELSE 0
                 END)
  INTO     #SECMST
  FROM     C_SECURITIESMST S
           LEFT OUTER JOIN #LATESTCLOSING C
             ON (S.ISIN = C.ISIN)
  WHERE    PARTY_CODE <> 'BROKER'
           AND EFFDATE <= @VALDATE + ' 23:59:59'
           AND EXCHANGE = @EXCHANGE
           AND SEGMENT = @SEGMENT
  GROUP BY PARTY_CODE,SCRIP_CD,SERIES,S.ISIN,
           ISNULL(C.CL_RATE,0),ISNULL(C.SYSDATE,'JAN  1 1900')
  HAVING   SUM(CASE 
                 WHEN DRCR = 'C' THEN QTY
                 ELSE -QTY
               END) <> 0

  INSERT INTO C_VALUATION
             (EXCHANGE,
              SEGMENT,
              MARKET,
              SHAREDB,
              SCRIP_CD,
              SERIES,
              CL_RATE,
              SYSDATE)
  SELECT DISTINCT @EXCHANGE,
                  @SEGMENT,
                  'NORMAL',
                  @SHAREDB,
                  SCRIP_CD,
                  SERIES,
                  CL_RATE,
                  @VALDATE
  FROM   #SECMST
  WHERE  FLAG = 1
                
  SELECT   DISTINCT SCRIP_CD,
                    SERIES,
                    CL_RATE
  FROM     #SECMST
  WHERE    FLAG = 0
  ORDER BY SCRIP_CD,
           SERIES

GO
