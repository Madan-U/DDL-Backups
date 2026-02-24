-- Object: PROCEDURE dbo.V2_TRD_CLIENTMASTER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE
      PROCEDURE V2_TRD_CLIENTMASTER 

AS 

      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
--      TRUNCATE TABLE TRD_CLIENT1 
--      TRUNCATE TABLE TRD_CLIENT2 
      TRUNCATE TABLE V2_TRD_BROKTABLE 
      TRUNCATE TABLE V2_TRD_SETT_MST 
--      TRUNCATE TABLE TRD_CLIENTBROK_SCHEME 
--      TRUNCATE TABLE TRD_CLIENTTAXES_NEW 
      TRUNCATE TABLE V2_TRD_CONAVGRATEQTYSUM 
      TRUNCATE TABLE V2_TRD_CLIENT_BROK_TAXES
      TRUNCATE TABLE V2_TRD_SCRIPMASTER
      TRUNCATE TABLE V2_TRD_CLIENTMASTER_NEW
-----------------------------------------------------------------------------------------------------

      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
      SELECT DISTINCT 
            PARTY_CODE, 
            LEFT(SAUDA_DATE,11) AS SAUDA_DATE 
      INTO #TRADE 
      FROM TRADE 
      WITH(NOLOCK) 

-----------------------------------------------------------------------------------------------------

/*
      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
      INSERT 
      INTO TRD_CLIENT2 
      SELECT 
            C2.* 
      FROM CLIENT2 C2 
      WITH(NOLOCK),
      #TRADE T (NOLOCK) 
      WHERE C2.PARTY_CODE = T.PARTY_CODE
*/

-----------------------------------------------------------------------------------------------------

/*
      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
      INSERT 
      INTO TRD_CLIENT1 
      SELECT 
            C1.*
      FROM CLIENT1 C1 
      WITH(NOLOCK),
      TRD_CLIENT2 C2 (NOLOCK) 
      WHERE C1.CL_CODE = C2.CL_CODE
 */

-----------------------------------------------------------------------------------------------------

/*
      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
      INSERT 
      INTO TRD_CLIENTBROK_SCHEME 
      SELECT 
            C2.* 
      FROM CLIENTBROK_SCHEME C2 
      WITH(NOLOCK),
      #TRADE T (NOLOCK)
      WHERE C2.PARTY_CODE = T.PARTY_CODE
      AND T.SAUDA_DATE BETWEEN C2.FROM_DATE AND C2.TO_DATE
*/

-----------------------------------------------------------------------------------------------------

/*
      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
      INSERT 
      INTO V2_TRD_BROKTABLE 
      SELECT 
            * 
      FROM BROKTABLE 
      WITH(NOLOCK) 
      WHERE TABLE_NO IN 
            (
            SELECT DISTINCT 
                  TABLE_NO 
            FROM TRD_CLIENTBROK_SCHEME 
            WITH(NOLOCK)
            ) 
*/

-----------------------------------------------------------------------------------------------------

/*
      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
      INSERT 
      INTO TRD_CLIENTTAXES_NEW 
      SELECT DISTINCT 
            C2.* 
      FROM CLIENTTAXES_NEW C2 
      WITH(NOLOCK),
      #TRADE T (NOLOCK)
      WHERE C2.PARTY_CODE = T.PARTY_CODE
      AND T.SAUDA_DATE BETWEEN C2.FROMDATE AND C2.TODATE
*/

-----------------------------------------------------------------------------------------------------

      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
      INSERT 
      INTO V2_TRD_SETT_MST 
      SELECT 
            S.* 
      FROM SETT_MST S 
      WITH(NOLOCK), 
            (
            SELECT 
                  TOP 1 SAUDA_DATE 
            FROM #TRADE 
            WITH(NOLOCK) 
            ) T 
      WHERE SAUDA_DATE BETWEEN S.START_DATE AND S.END_DATE 

-----------------------------------------------------------------------------------------------------
-- Added by Uppili Krishnan
-----------------------------------------------------------------------------------------------------

      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
      INSERT 
      INTO V2_TRD_SCRIPMASTER
      SELECT DISTINCT 
            S1.CO_CODE,
            S1.SHORT_NAME,
            S1.MARKET_LOT,
            S1.DEMAT_DATE,
            S2.SCRIP_CD,
            S2.SERIES,
            S2.SCRIP_CAT
      FROM SCRIP1 S1 WITH(NOLOCK),
      SCRIP2  S2 WITH(NOLOCK),
      TRADE T WITH(NOLOCK)
      WHERE S2.CO_CODE = S1.CO_CODE
      AND S2.SCRIP_CD = T.SCRIP_CD
      AND S2.SERIES = T.SERIES

-----------------------------------------------------------------------------------------------------

      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
      INSERT INTO V2_TRD_CLIENTMASTER_NEW
      SELECT DISTINCT 
            C1.CL_CODE,
            C1.SHORT_NAME,
            C1.OFF_PHONE1,
            C1.CL_TYPE,
            C2.PARTY_CODE,
            C2.SERVICE_CHRG,
            C2.SERTAXMETHOD,
            C2.TRAN_CAT
      FROM CLIENT1 C1 WITH(NOLOCK),
      CLIENT2 C2 WITH(NOLOCK),
      #TRADE T WITH(NOLOCK)
      WHERE C1.CL_CODE = C2.CL_CODE
      AND C2.PARTY_CODE = T.PARTY_CODE

-----------------------------------------------------------------------------------------------------

      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
      INSERT INTO V2_TRD_CLIENT_BROK_TAXES
      SELECT DISTINCT
            T.PARTY_CODE,
            A.SCHEME_TYPE,
            A.BROKSCHEME,
            A.TABLE_NO,
            A.TRADE_TYPE,
            A.SCRIP_CD,
            A.FROM_DATE,
            A.TO_DATE,
            B.SCIDENTITY,
            B.CL_TYPE,
            B.TRANS_CAT,
            B.INSURANCE_CHRG,
            B.TURNOVER_TAX,
            B.OTHER_CHRG,
            B.SEBITURN_TAX,
            B.BROKER_NOTE,
            B.DEMAT_INSURE,
            B.SERVICE_TAX, 
            B.TAX1,
            B.TAX2,
            B.TAX3,
            B.TAX4,            
            B.TAX5,
            B.TAX6,
            B.TAX7,      
            B.TAX8,
            B.TAX9,
            B.TAX10,
            B.LATEST,
            B.STATE,
            B.ROUND_TO,
            B.ROFIG,
            B.ERRNUM,
            B.NOZERO,
            B.FROMDATE,
            B.TODATE
      FROM
            (
                  SELECT
                        BS.PARTY_CODE,
                        BS.SCHEME_TYPE,
                        BS.BROKSCHEME,
                        BS.TABLE_NO,
                        BS.TRADE_TYPE,
                        BS.SCRIP_CD,
                        BS.FROM_DATE,
                        BS.TO_DATE
                  FROM
                        CLIENTBROK_SCHEME BS WITH(NOLOCK),
                        #TRADE T WITH(NOLOCK)
                  WHERE
                        BS.PARTY_CODE = T.PARTY_CODE
                        AND T.SAUDA_DATE BETWEEN BS.FROM_DATE AND BS.TO_DATE
            
            ) A,
            (
                  SELECT
                        CT.SCIDENTITY,
                        CT.PARTY_CODE,
                        CT.CL_TYPE,
                        CT.TRANS_CAT,
                        CT.INSURANCE_CHRG,
                        CT.TURNOVER_TAX,
                        CT.OTHER_CHRG,
                        CT.SEBITURN_TAX,
                        CT.BROKER_NOTE,
                        CT.DEMAT_INSURE,
                        CT.SERVICE_TAX, 
                        CT.TAX1,
                        CT.TAX2,
                        CT.TAX3,
                        CT.TAX4,            
                        CT.TAX5,
                        CT.TAX6,
                        CT.TAX7,      
                        CT.TAX8,
                        CT.TAX9,
                        CT.TAX10,
                        CT.LATEST,
                        CT.STATE,
                        CT.ROUND_TO,
                        CT.ROFIG,
                        CT.ERRNUM,
                        CT.NOZERO,
                        CT.FROMDATE,
                        CT.TODATE
                  FROM
                        CLIENTTAXES_NEW CT WITH(NOLOCK),
                        #TRADE T WITH(NOLOCK)
                  WHERE
                        CT.PARTY_CODE = T.PARTY_CODE
                        AND T.SAUDA_DATE BETWEEN CT.FROMDATE AND CT.TODATE
            ) B,
            #TRADE T WITH(NOLOCK)
            WHERE 
                  T.PARTY_CODE = A.PARTY_CODE
                  AND T.PARTY_CODE = B.PARTY_CODE

-----------------------------------------------------------------------------------------------------

      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
      INSERT 
      INTO V2_TRD_BROKTABLE 
      SELECT 
            * 
      FROM BROKTABLE 
      WITH(NOLOCK) 
      WHERE TABLE_NO IN 
            (
            SELECT DISTINCT 
                  TABLE_NO 
            FROM V2_TRD_CLIENT_BROK_TAXES 
            WITH(NOLOCK)
            ) 


--SELECT * FROM V2_TRD_CLIENT_BROK_TAXES
--SELECT * FROM V2_TRD_SCRIPMASTER
--SELECT * FROM V2_TRD_CLIENTMASTER_NEW
--RETURN

-----------------------------------------------------------------------------------------------------
-- Addition by Uppili Krishnan Ends
-----------------------------------------------------------------------------------------------------


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
INSERT 
INTO V2_TRD_CONAVGRATEQTYSUM 
SELECT 
      PARTY_CODE,
      SCRIP_CD,
      SERIES,
      MARKETTYPE, 
      PRATE=(
      CASE 
            WHEN SUM(
            CASE 
                  WHEN SELL_BUY = 1 
                  THEN TRADEQTY 
                  ELSE 0 
            END
            ) > 0 
            THEN SUM(
            CASE 
                  WHEN SELL_BUY = 1 
                  THEN MARKETRATE*TRADEQTY 
                  ELSE 0 
            END
            ) / SUM(
            CASE 
                  WHEN SELL_BUY = 1 
                  THEN TRADEQTY 
                  ELSE 0 
            END
            ) 
            ELSE 0 
      END
      ), 
      PQTY=SUM(
      CASE 
            WHEN SELL_BUY = 1 
            THEN TRADEQTY 
            ELSE 0 
      END
      ), 
      SRATE=(
      CASE 
            WHEN SUM(
            CASE 
                  WHEN SELL_BUY = 2 
                  THEN TRADEQTY 
                  ELSE 0 
            END
            ) > 0 
            THEN SUM(
            CASE 
                  WHEN SELL_BUY = 2 
                  THEN MARKETRATE*TRADEQTY 
                  ELSE 0 
            END
            ) / SUM(
            CASE 
                  WHEN SELL_BUY = 2 
                  THEN TRADEQTY 
                  ELSE 0 
            END
            ) 
            ELSE 0 
      END
      ), 
      SQTY=SUM(
      CASE 
            WHEN SELL_BUY = 2 
            THEN TRADEQTY 
            ELSE 0 
      END
      ), 
      PARTIPANTCODE,
      TMARK 
FROM TRADE (NOLOCK)
GROUP BY PARTY_CODE,
      SCRIP_CD,
      SERIES,
      MARKETTYPE,
      PARTIPANTCODE,
      TMARK

GO
