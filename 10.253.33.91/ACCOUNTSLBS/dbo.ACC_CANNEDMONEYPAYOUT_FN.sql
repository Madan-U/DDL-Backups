-- Object: PROCEDURE dbo.ACC_CANNEDMONEYPAYOUT_FN
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE PROCEDURE [dbo].[ACC_CANNEDMONEYPAYOUT_FN]  
 @SDATE VARCHAR(11),  
 @STATUSNAME VARCHAR(30),  
 @BANKCODE VARCHAR(10),  
 @BOOKTYPE VARCHAR(2),  
 @PAYMODE VARCHAR(1),  
 @LDATE VARCHAR(11),  
 @DISPLAY VARCHAR(1) = 'A',  
 @DISPREC VARCHAR(5) = 'ALL',  
 @FCODE VARCHAR(10) = '0000000000',  
 @TCODE VARCHAR(10) = 'ZZZZZZZZZZ',  
 @FILTER TINYINT = 0,  
 @FORNEXT TINYINT = 0  
AS  
/*  
 EXEC ACC_CANNEDMONEYPAYOUT 'APR  1 2006', 'ARSL', '1111111', '01', '', 'MAR 31 2007', 'A', 'ALL', '0', 'ZZZ', 2  
 EXEC ACC_CANNEDMONEYPAYOUT 'Apr 1 2006', 'ebroking', '1111111', '', '', 'Mar 31 2007', 'A', '100', '0', 'z', 2  
*/  
DECLARE  
 @@LDATE AS VARCHAR(11),  
 @@SQL AS VARCHAR(2000)  
 SET NOCOUNT ON  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

/*===================================================================================================
	START :: PATCH ADDED FOR ENABLING AREA LOGIN REQUEST
===================================================================================================*/
IF UPPER(@STATUSNAME) <> 'BROKER'  
BEGIN  
	SELECT BRANCH_CODE INTO #BRANCH FROM MSAJAG.DBO.BRANCH WHERE 1=2
	
	IF (SELECT COUNT(1) FROM MSAJAG.DBO.BRANCH WHERE BRANCH_CODE = @STATUSNAME) <> 0 
	BEGIN
		INSERT INTO #BRANCH SELECT @STATUSNAME 
	END
	ELSE
	BEGIN
		INSERT INTO #BRANCH SELECT BRANCH_CODE FROM MSAJAG.DBO.AREA WHERE AREACODE = @STATUSNAME
	END
END
/*===================================================================================================
	END :: PATCH ADDED FOR ENABLING AREA LOGIN REQUEST
===================================================================================================*/

IF UPPER(@STATUSNAME) = 'BROKER'  
 BEGIN  
  IF CONVERT(DATETIME,@LDATE + ' 23:59:59' ) >= GETDATE()  
   BEGIN  
    SELECT @@SQL = "DELETE FROM HOPAYOUT WHERE SPID = @@SPID "  
    SELECT @@SQL = @@SQL + "INSERT INTO HOPAYOUT "  
    SELECT @@SQL = @@SQL + "SELECT    "  
    IF @DISPREC <> 'ALL'  
     BEGIN  
      SELECT @@SQL = @@SQL + " TOP " + @DISPREC + " "  
     END  
    SELECT @@SQL = @@SQL + " L.CLTCODE,    "  
    SELECT @@SQL = @@SQL + " ACNAME = (A.LONGNAME),    "  
    SELECT @@SQL = @@SQL + " CHEQUENAME =A.LONGNAME,    "  
    SELECT @@SQL = @@SQL + " A.BRANCHCODE,    "  
    SELECT @@SQL = @@SQL + " A.ACCAT,    "  
    SELECT @@SQL = @@SQL + " A.BTOBPAYMENT,    "  
    SELECT @@SQL = @@SQL + " EFFECTIVEBALANCE = SUM(CASE WHEN EDT <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59'  AND    "  
    SELECT @@SQL = @@SQL + "       EDT >='" + @SDATE  + "' THEN  (CASE WHEN L.VTYP = 18 THEN BALAMT ELSE CASE WHEN DRCR = 'D' THEN VAMT ELSE - VAMT END END) ELSE 0 END ),    "  
    SELECT @@SQL = @@SQL + " LEDGERBALANCE = SUM(CASE WHEN DRCR = 'D' THEN VAMT ELSE - VAMT END),    "  
    SELECT @@SQL = @@SQL + " BILLAMT = SUM(CASE WHEN (EDT LIKE LEFT(CONVERT(VARCHAR,GETDATE(),109),11) +'%'  AND L.VTYP='15') THEN    "  
    SELECT @@SQL = @@SQL + "    (CASE WHEN DRCR = 'D' THEN 0 ELSE - VAMT END) ELSE 0 END ),    "  
    SELECT @@SQL = @@SQL + " FUTUREPAYOUT =0,    "  
    SELECT @@SQL = @@SQL + " SHORTAGE=0,    "  
    SELECT @@SQL = @@SQL + " AMOUNTTOBEPAID = ISNULL(AMOUNTTOBEPAID,0), "  
    SELECT @@SQL = @@SQL + " SNO = ISNULL(P.SNO, 0),  "  
    SELECT @@SQL = @@SQL + " PAYMODE = ISNULL(A.PAYMODE, ''),  "  
    SELECT @@SQL = @@SQL + " EXPAY = 0, "  
    SELECT @@SQL = @@SQL + " SPID = @@SPID  "  
    SELECT @@SQL = @@SQL + "FROM    "  
    SELECT @@SQL = @@SQL + " PAYMENTMARKING P WITH(INDEX(MONEYPAYOUTIDX)),    "  
    SELECT @@SQL = @@SQL + " LEDGER L (NOLOCK) ,ACMAST A (NOLOCK)    "  
    SELECT @@SQL = @@SQL + "WHERE    "  
    SELECT @@SQL = @@SQL + " A.CLTCODE = P.CLTCODE    "  
    SELECT @@SQL = @@SQL + " AND P.CLTCODE = L.CLTCODE    "  
    SELECT @@SQL = @@SQL + "  AND P.CLTCODE BETWEEN '" + @FCODE + "' AND '" + @TCODE + "' "  
    SELECT @@SQL = @@SQL + " AND HOAPPROVAL = '0'    "  
    SELECT @@SQL = @@SQL + " AND VDT >= '" + @SDATE + "'    "  
    SELECT @@SQL = @@SQL + " AND VDT <= LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + ' 23:59'    "  
    SELECT @@SQL = @@SQL + " AND A.PAYMODE LIKE '" + @PAYMODE + "%'    "  
    SELECT @@SQL = @@SQL + " AND A.POBANKCODE = '" + @BANKCODE + "'    "  
    SELECT @@SQL = @@SQL + " AND PAYMENTDATE LIKE LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + '%'    "  
    IF @DISPLAY = 'B'  
     BEGIN  
      SELECT @@SQL = @@SQL + " AND A.BTOBPAYMENT = '1'    "  
     END  
    ELSE IF @DISPLAY = 'N'  
     BEGIN  
      SELECT @@SQL = @@SQL + " AND A.BTOBPAYMENT <> '1'    "  
     END  
    SELECT @@SQL = @@SQL + "GROUP BY    "  
    SELECT @@SQL = @@SQL + " L.CLTCODE,    "  
    SELECT @@SQL = @@SQL + "A.LONGNAME,    "  
    SELECT @@SQL = @@SQL + " A.LONGNAME,    "  
    SELECT @@SQL = @@SQL + " A.BRANCHCODE,    "  
    SELECT @@SQL = @@SQL + " A.ACCAT,    "  
    SELECT @@SQL = @@SQL + " A.BTOBPAYMENT,    "  
    SELECT @@SQL = @@SQL + " ISNULL(AMOUNTTOBEPAID,0), "  
    SELECT @@SQL = @@SQL + " ISNULL(P.SNO, 0), "  
    SELECT @@SQL = @@SQL + " ISNULL(A.PAYMODE, '')  "  
   END  
  ELSE  
   BEGIN  
    SELECT @@SQL = "DELETE FROM HOPAYOUT WHERE SPID = @@SPID  "  
    SELECT @@SQL = @@SQL + "INSERT INTO HOPAYOUT "  
    SELECT @@SQL = @@SQL + "SELECT     "  
    IF @DISPREC <> 'ALL'  
     BEGIN  
      SELECT @@SQL = @@SQL + " TOP " + @DISPREC + " "  
     END  
    SELECT @@SQL = @@SQL + " L.CLTCODE,     "  
    SELECT @@SQL = @@SQL + " ACNAME = (A.LONGNAME),     "  
    SELECT @@SQL = @@SQL + " CHEQUENAME = A.LONGNAME,     "  
    SELECT @@SQL = @@SQL + " A.BRANCHCODE,     "  
    SELECT @@SQL = @@SQL + " A.ACCAT,     "  
    SELECT @@SQL = @@SQL + " A.BTOBPAYMENT,     "  
    SELECT @@SQL = @@SQL + " EFFECTIVEBALANCE = SUM(CASE WHEN EDT <= '" + @LDATE + "' + ' 23:59'  AND     "  
    SELECT @@SQL = @@SQL + "       EDT >= '" + @SDATE + "'  THEN  (CASE WHEN L.VTYP = 18 THEN BALAMT ELSE CASE WHEN DRCR = 'D' THEN VAMT ELSE - VAMT END END) ELSE 0 END ),     "  
    SELECT @@SQL = @@SQL + " LEDGERBALANCE = SUM(CASE WHEN DRCR = 'D' THEN VAMT ELSE - VAMT END),     "  
    SELECT @@SQL = @@SQL + " BILLAMT = SUM(CASE WHEN (EDT LIKE '" + @LDATE + "%'  AND L.VTYP='15') THEN     "  
    SELECT @@SQL = @@SQL + "    (CASE WHEN DRCR = 'D' THEN 0 ELSE - VAMT END) ELSE 0 END),     "  
    SELECT @@SQL = @@SQL + " FUTUREPAYOUT = 0,     "  
    SELECT @@SQL = @@SQL + " SHORTAGE = 0,     "  
    SELECT @@SQL = @@SQL + " AMOUNTTOBEPAID = ISNULL(AMOUNTTOBEPAID,0),     "  
    SELECT @@SQL = @@SQL + " PAYMODE = ISNULL(A.PAYMODE, ''),  "  
    SELECT @@SQL = @@SQL + " EXPAY = 0 "  
    SELECT @@SQL = @@SQL + "FROM     "  
    SELECT @@SQL = @@SQL + " PAYMENTMARKING P WITH(INDEX(MONEYPAYOUTIDX)),     "  
    SELECT @@SQL = @@SQL + " LEDGER L (NOLOCK),     "  
    SELECT @@SQL = @@SQL + " ACMAST A  (NOLOCK)     "  
    SELECT @@SQL = @@SQL + "WHERE     "  
    SELECT @@SQL = @@SQL + " A.CLTCODE = P.CLTCODE     "  
    SELECT @@SQL = @@SQL + " AND P.CLTCODE = L.CLTCODE     "  
    SELECT @@SQL = @@SQL + "  AND P.CLTCODE BETWEEN '" + @FCODE + "' AND '" + @TCODE + "' "  
    SELECT @@SQL = @@SQL + " AND HOAPPROVAL = '0'     "  
    SELECT @@SQL = @@SQL + " AND VDT >='" + @SDATE + "'     "  
    SELECT @@SQL = @@SQL + " AND VDT <='" + @LDATE + " 23:59'     "  
    SELECT @@SQL = @@SQL + " AND A.PAYMODE LIKE '" + @PAYMODE + "%'     "  
    SELECT @@SQL = @@SQL + " AND A.POBANKCODE = '" + @BANKCODE + "'     "  
    SELECT @@SQL = @@SQL + " AND PAYMENTDATE LIKE '" + @LDATE + "%'     "  
    IF @DISPLAY = 'B'  
     BEGIN  
      SELECT @@SQL = @@SQL + " AND A.BTOBPAYMENT = '1'    "  
     END  
    ELSE IF @DISPLAY = 'N'  
     BEGIN  
      SELECT @@SQL = @@SQL + " AND A.BTOBPAYMENT <> '1'    "  
     END  
    SELECT @@SQL = @@SQL + "GROUP BY     "  
    SELECT @@SQL = @@SQL + " L.CLTCODE,     "  
    SELECT @@SQL = @@SQL + " L.LONGNAME,     "  
    SELECT @@SQL = @@SQL + " A.LONGNAME,     "  
    SELECT @@SQL = @@SQL + " A.BRANCHCODE,     "  
    SELECT @@SQL = @@SQL + " A.ACCAT,     "  
    SELECT @@SQL = @@SQL + " A.BTOBPAYMENT,     "  
    SELECT @@SQL = @@SQL + " ISNULL(AMOUNTTOBEPAID,0),     "  
    SELECT @@SQL = @@SQL + " ISNULL(A.PAYMODE, '')  "  
   END  
--  PRINT @@SQL  
  EXEC (@@SQL)  
  SELECT  
   L.CLTCODE,  
   EFFECTIVEREV = SUM(CASE WHEN L.DRCR = 'D' THEN -L.VAMT ELSE L.VAMT END)  
  INTO  
   #HOPAYOUT  
  FROM  
   HOPAYOUT H,  
   LEDGER L  
  WHERE  
   H.CLTCODE = L.CLTCODE  
   AND L.VDT < @SDATE  
   AND L.EDT >= @SDATE  
   AND L.EDT <= @LDATE + ' 23:59'  
   AND H.SPID = @@SPID  
  GROUP BY  
   L.CLTCODE  
  
  UPDATE H SET EFFECTIVEBALANCE = EFFECTIVEBALANCE - HH.EFFECTIVEREV FROM HOPAYOUT H, #HOPAYOUT HH WHERE H.CLTCODE = HH.CLTCODE AND H.SPID = @@SPID  
  
  SELECT @@SQL = "UPDATE HOPAYOUT SET EXPAY = 1 WHERE AMOUNTTOBEPAID > ABS(EFFECTIVEBALANCE) AND AMOUNTTOBEPAID > ABS(LEDGERBALANCE) AND AMOUNTTOBEPAID > ABS(BILLAMT) AND SPID = @@SPID "  
  EXEC (@@SQL)  
  SELECT @@SQL = "SELECT * FROM HOPAYOUT WHERE SPID = @@SPID ORDER BY EXPAY, CLTCODE, BRANCHCODE"  
  EXEC (@@SQL)  
  SELECT @@SQL = "DELETE FROM HOPAYOUT WHERE SPID = @@SPID "  
  EXEC (@@SQL)  
 END  
ELSE  
 BEGIN  
  IF CONVERT(DATETIME,@LDATE + ' 23:59:59' ) >= GETDATE()  
   BEGIN  
    SELECT @@LDATE = CONVERT(VARCHAR(11), GETDATE(), 109)  
   END  
  ELSE  
   BEGIN  
    SELECT @@LDATE = @LDATE  
   END  
  SELECT @@SQL = "SELECT "  
  IF @DISPREC <> 'ALL'  
   BEGIN  
    SELECT @@SQL = @@SQL + " TOP " + @DISPREC + " "  
   END  
   SELECT @@SQL = @@SQL + "  F.CLTCODE,    "  
   SELECT @@SQL = @@SQL + "  F.ACNAME,    "  
   SELECT @@SQL = @@SQL + "  F.CHEQUENAME,    "  
   SELECT @@SQL = @@SQL + "  F.BRANCHCODE,    "  
   SELECT @@SQL = @@SQL + "  F.ACCAT,    "  
   SELECT @@SQL = @@SQL + "  F.BTOBPAYMENT,    "  
   SELECT @@SQL = @@SQL + "  EFFECTIVEBALANCE = ROUND(F.EFFECTIVEBALANCE, 2),    "  
   SELECT @@SQL = @@SQL + "  LEDGERBALANCE = ROUND(F.LEDGERBALANCE, 2),    "  
   SELECT @@SQL = @@SQL + "  F.BILLAMT,    "  
   SELECT @@SQL = @@SQL + "  F.FUTUREPAYOUT,    "  
   SELECT @@SQL = @@SQL + "  F.SHORTAGE,    "  
   SELECT @@SQL = @@SQL + "  AMOUNTTOBEPAID = ISNULL(P.AMOUNTTOBEPAID, 0), "  
   SELECT @@SQL = @@SQL + "  SNO = ISNULL(P.SNO, 0), "  
   SELECT @@SQL = @@SQL + "  EXPAY = 0 "  
   SELECT @@SQL = @@SQL + " FROM    "  
   SELECT @@SQL = @@SQL + "  FILLED_MONEYPAYOUT F LEFT OUTER JOIN PAYMENTMARKING P WITH(INDEX(MONEYPAYOUTIDX))    "  
   SELECT @@SQL = @@SQL + "  ON ( F.CLTCODE = P.CLTCODE    "  
   SELECT @@SQL = @@SQL + "  AND P.HOAPPROVAL = '0' "  
   SELECT @@SQL = @@SQL + "  AND CONVERT(VARCHAR(11), P.PAYMENTDATE, 109) = '" + @@LDATE + "') "  

/*===================================================================================================
	START :: CHANGES MADE FOR ENABLING AREA LOGIN REQUEST
===================================================================================================*/

   SELECT @@SQL = @@SQL + "  , #BRANCH B "  
   SELECT @@SQL = @@SQL + " WHERE    "  
--   SELECT @@SQL = @@SQL + "  F.BRANCHCODE = '" + @STATUSNAME    + "' "  
   SELECT @@SQL = @@SQL + "  F.BRANCHCODE = B.BRANCH_CODE "  

/*===================================================================================================
	START :: CHANGES MADE FOR ENABLING AREA LOGIN REQUEST
===================================================================================================*/

   SELECT @@SQL = @@SQL + "  AND CONVERT(VARCHAR(11), PROC_DATE, 109) = '" + @@LDATE    + "' "  
   SELECT @@SQL = @@SQL + "  AND F.LEDGERBALANCE <> 0    "  
   IF @FORNEXT = 0  
    BEGIN  
     SELECT @@SQL = @@SQL + "  AND F.CLTCODE BETWEEN '" + @FCODE + "' AND '" + @TCODE + "' "  
    END  
   ELSE  
    BEGIN  
     SELECT @@SQL = @@SQL + "  AND F.CLTCODE > '" + @FCODE + "' AND F.CLTCODE <= '" + @TCODE + "' "  
    END  
   IF @FILTER = 1  
    BEGIN  
     SELECT @@SQL = @@SQL + "  AND ISNULL(P.AMOUNTTOBEPAID, 0) = 0 "  
    END  
   ELSE IF @FILTER = 2  
    BEGIN  
     SELECT @@SQL = @@SQL + "  AND ISNULL(P.AMOUNTTOBEPAID, 0) > 0 "  
    END  
   SELECT @@SQL = @@SQL + "  ORDER BY    "  
   SELECT @@SQL = @@SQL + "   F.CLTCODE,    "  
   SELECT @@SQL = @@SQL + "   F.BRANCHCODE    "  
   --PRINT (@@SQL)  
   EXEC (@@SQL)  
 END

GO
